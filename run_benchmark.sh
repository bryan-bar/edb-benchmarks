#!/bin/bash

# Workflow script to run a benchmark based on a directory path
# Assumptions: 
#   * Each benchmark directory has directories with a numberic prefix ordering
#     * Within each directory is a run.sh script to kick off that step
#     * ex: aws-dbt2-aurora/00_validate/run.sh
#   * Each benchmark directory has an environment file to source required variables to run the benchmark
#     * ex: aws-dbt2-aurora/environment
# Examples availble below in usage()

usage () {
    cat << EOF
Usage: $(basename "$0") -b benchmark_directory [-e environment_file] [-s starting_step ] [-x comma_separated_steps] [-u < true | false > ]
    -b  (required) Path to benchmark directory
    -e  Path to environment file, will be copied with user passed values if any values are unset for future re-use
    -s  Benchmark step to start at
    -x  Benchmark steps to skip over
    -u  Skip user input for missing values
Example:
    Run all steps: ./run_benchmark -b aws-dbt2-aurora
    Skip final step: ./run_benchmark -b aws-dbt2-aurora -x -1
    Skip final step: ./run_benchmark -b aws-dbt2-aurora -x 5
    Skip some steps: ./run_benchmark -b aws-dbt2-aurora -x 0,3,unprovision
    Start running from final step: ./run_benchmark -b aws-dbt2-aurora -s -1
    Start from step name: ./run_benchmark -b aws-dbt2-aurora -s unprovision
EOF
}

parse_args() {
    unset OPTIND benchmark_directory env_file

    while getopts b:e:s:x:h:u: flag
    do
        case "${flag}" in
            # use of python3 for the absolute path since realpath and readlink implementations can vary
            b)
                benchmark_directory=$(python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" ${OPTARG});;
            e)
                env_file="${OPTARG}";;
            h)
                usage;
                exit 0;;
            s)
                start_step="${OPTARG}";;
            x)
                IFS=',' read -ra exclude_steps <<< "${OPTARG}";;
            u) 
                user_input="${OPTARG}";;
            *)
                usage;
                exit 1;;
        esac
    done
    if (( $OPTIND == 1 )); then
        usage
        exit 1
    fi
    if [[ ! -d "$benchmark_directory" ]]; then
        echo "Use -b to specify the path to the benchmarks directory" >&2
        echo "Directory doesn't exist: $benchmark_directory" >&2
        usage
        exit 1
    fi
    # Set defaults if no option was passed
    user_input=${user_input:-true}
    start_step=${start_step:-0}
    # each benchmark should contain an number prefix such as 00_provision or 00_validation and
    # within each directory should be run.sh which executes the needed step
    benchmark_steps=()
    while IFS= read -ra directory; do
        prefix=$( basename "$directory" | cut -d '_' -f1 )
        step_name=$( basename "$directory" | cut -d '_' -f 2- )
        if [[ ! $prefix =~ ^[0-9]+$ ]]; then
            echo "Skipping over directory: $step_name"
            continue
        fi
        # convert start_step to a proper index if not a digit and it matches a step name
        if [[ ! $start_step =~ ^[0-9]+$ && $start_step == $step_name ]]; then
            start_step=$prefix
            echo "start updated to $prefix - $step_name"
        fi
        benchmark_steps+=("$directory")
    done < <( find "$benchmark_directory" -mindepth 1 -maxdepth 1 -type d | sort )

    env_file=$(python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" ${env_file:-"${benchmark_directory}/environment"})
    if [[ ! -f "$env_file" ]]; then
        echo "Use -e to specify the path to the environment file" >&2
        echo "Environment variable does not exist: $env_file" >&2
        usage
        exit 1
    fi

    # Convert user values to postive values to mimic python's negative indexing
    temp=$start_step
    if (( $start_step < 0 )); then
        start_step=$(( ${#benchmark_steps[@]} + $start_step ))
    fi
    if (( $start_step < 0)) || (( $start_step >= ${#benchmark_steps[@]} )) || [[ ! $start_step =~ ^[0-9]+$ ]]; then
            echo "Out of bounds start index or invalid step name does not match any step" >&2
            echo "Starting step: $temp" >&2
            echo "Final step used: ${start_step}" >&2
            echo "Steps available: ${!benchmark_steps[@]}" >&2
            usage
            exit 1
    fi
    for step in ${!exclude_steps[@]}
    do
        temp="${exclude_steps[$step]}"
        if (( ${exclude_steps[$step]} < 0 )); then
            exclude_steps[$step]=$(( ${#benchmark_steps[@]} + $temp ))
        fi
        if (( ${exclude_steps[$step]} < 0)) || (( ${exclude_steps[$step]} >= ${#benchmark_steps[@]} )); then
                echo "Out of bounds index in exclude steps list will be ignored" >&2
                echo "step: $temp" >&2
                echo "final step: ${exclude_steps[$step]}" >&2
                echo "Steps available: ${!benchmark_steps[@]}" >&2
                echo "Steps names: ${benchmark_steps[@]}" >&2
        fi
    done

    echo "benchmark_directory: $benchmark_directory"
    echo "env_file: $env_file"
    echo "start_step: $start_step"
    echo "exclude_steps: ${exclude_steps[@]}"
}

source_env_files () {
    # Source environment file for use with each directories run.sh
    env_file_copy="$benchmark_directory/env_$(date +'%Y-%m-%dT%H:%M:%S')"
    # grab variables with '=' as separator
    sourced_variables=($(awk -F = '{print $1}' $env_file))
    paired_values=($( awk -F = '{print $2}' "$env_file" ))
    # unset all variables before sourcing
    for var in "${sourced_variables[@]}"
    do
        unset $var
    done
    # set exports so they are seen by subshells
    set -o allexport
    source "$env_file"
    set +o allexport
    # If all values are defined, we can skip the rest
    if (( ${#sourced_variables[@]} == ${#paired_values[@]} )); then
        return
    fi
    # prompt user input for any missing/empty variables from sourced environment file
    for var in "${sourced_variables[@]}"
    do
        if [[ -z ${!var} ]] && [[ $user_input == true ]]; then
            echo "Please enter a value for the the following: $var"
            read $var
        else
            echo "Override value - $var=${!var}: [y/n]"
            read override_value
            if [[ "$override_value" == "y" ]]; then
                echo "New Value:"
                read $var
            fi
        fi
        echo "$var=${!var}" >> "$env_file_copy"
    done
    echo "A copy of the new source file is available here: $env_file_copy"
    set -o allexport
    source "$env_file_copy"
    set +o allexport
}

set_file_permissions() {
    for step in "${benchmark_steps[@]}"; do
        run_script="$step/run.sh"
        if [[ ! -f "$run_script" ]]; then
            continue
        fi
        # Attempt to handle execute permissions
        # as each directory/step should have a run.sh file
        if [[ ! -x "$run_script" ]] && [[ ! $(chmod u+x "$run_script") ]]; then
            echo "Unable to set execution for $run_script" >&2
            exit 1
        fi
    done
}

run_steps() {
    for (( step_index=0; step_index<${#benchmark_steps[@]}; step_index++ )); do
        step=${benchmark_steps[$step_index]}
        prefix=$( basename "$step" | cut -d '_' -f 1 )
        step_name=$( basename "$step" | cut -d '_' -f 2- )
        run_script="$step/run.sh"

        if [[ "${exclude_steps[@]}" =~ "$step_index" ]] || [[ "${exclude_steps[@]}" =~ "$step_name" ]] || (( $start_step > $step_index )) ; then
            echo "Skipping step: $prefix - $step_name"
            continue
        fi

        echo "-----------------------"
        echo "Time: $(date)"
        echo "Parent process id: $$"
        echo "Watch process: watch -n 10 -d \"ps -o pid,ppid,start,etime,time,command --forest -g \$(ps -i sid= -p $$)\""
        echo "Starting step: $prefix"
        echo "Step name: $step_name"
        echo "Step path: $step"
        cd $step
        ($run_script)
        if (( $? != 0 )); then
            echo $?
            echo "Step failed: $prefix - $step_name" >&2
            exit 1
        fi
        cd "$benchmark_directory"
    done
}

parse_args $@
source_env_files
set_file_permissions
run_steps
echo 'Benchmark has finished: $(basename "$0") $@'
