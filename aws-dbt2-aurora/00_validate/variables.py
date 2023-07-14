from environment import EnvironmentVariable, Arguments
from pathlib import Path
from inspect import getsourcefile
import os

SCRIPT_DIRECTORY = Path(getsourcefile(lambda:0)).resolve().parent
ENVIRONMENT_PREFIX = ''
SAVE_PATH = (SCRIPT_DIRECTORY / '..').resolve()

DBT2_ARGS = [
    EnvironmentVariable(
        name = 'DBT2_DURATION',
        type = int,
        default=None,
        validation_callback=lambda x:  (True, 'valid') if x>=15 else (False, 'is too low, adjust your values'),
        help = 'Terraform instance to use',
    ),
    EnvironmentVariable(
        name = 'DBT2_WAREHOUSE',
        type = int,
        default=None,
        help = 'Terraform instance to use',
        required=True
    ),
    EnvironmentVariable(
        name = 'DBT2_CONNECTIONS',
        type = int,
        default=None,
        help = 'Terraform instance to use',
    ),
]

ANSIBLE_ARGS = [
    EnvironmentVariable(
        name = 'ANSIBLE_VERBOSITY',
        type = int,
        default=0,
        help = 'Default verbosity',
    ),
]

SSH_USER='rocky'
TERRAFORM_ARGS = [
    EnvironmentVariable(
        name = 'INSTANCE_TYPE',
        type = str,
        default=None,
        help = 'Terraform instance to use',
    ),
    EnvironmentVariable(
        name = 'STORAGE_TYPE',
        type = dict,
        default=None,
        help = 'Terraform instance to use',
    ),
    EnvironmentVariable(
        name = 'SSH_USER',
        type = str,
        default = SSH_USER,
        help = 'image\'s default user',
    ),
]

RESULTS_DIRECTORY=(SCRIPT_DIRECTORY / '..' / 'results').resolve()
BENCHMARK_NAME=(SCRIPT_DIRECTORY / '..').resolve().name.upper().replace('-', '_')
BUCKET_NAME='ebac-reports'
BENCHMARK_ARGS = [
    EnvironmentVariable(
        name = 'BENCHMARK_NAME',
        type = str,
        default = BENCHMARK_NAME,
        help = 'Save location for results and related data',
    ),
    EnvironmentVariable(
        name = 'RESULTS_DIRECTORY',
        type = Path,
        default = RESULTS_DIRECTORY,
        cwd = SCRIPT_DIRECTORY,
        help = 'Save location for results and related data',
    ),
    EnvironmentVariable(
        name = 'BUCKET_NAME',
        type = str,
        default = BUCKET_NAME,
        help = 'Default folder name to use for uploading results remotely',
    ),
]

# Flatten lists
VARIABLES = [
    *ANSIBLE_ARGS,
    *TERRAFORM_ARGS,
    *DBT2_ARGS,
    *BENCHMARK_ARGS,
]

if __name__ == '__main__':
    print(os.environ)
    args = Arguments(VARIABLES)
    args.print()
    args.validate()
    args.print()
    args.save(SAVE_PATH)
    args.exit()

    #parser = argparse.ArgumentParser(prefix_chars='$')
    #for arg in Arguments:
    #    parser.add_argument(*(arg.get_argparse_names()), **(arg.get_args()))
    #parser.usage = 'Usage message'
    #print(parser.parse_args())
    #env = parser.parse_known_args()
    #print(env)
    #subparsers = parser.add_subparsers()


#@dataclass
#class EnvironmentVariable:
#    '''
#    Dataclass to represent an environment variable
#    '''
#    name: str # Environment variable name
#    value: typing.Any # Holds final value
#    type: typing.Type # Type of environment variable
#    default: typing.Any = None # Default value to set if not found
#    required: bool = False # Whether to return return as an error if not provided
#    validate_callback: typing.Callable = lambda x: True # validation callback, needs to accept the environment variable
#    valid: bool = False
#    help: str = 'No help message set' # Help message
#
#    def __post_init__(self):
#        self.help = f'{self.name} - {self.help}'
#
#    def validate(self) -> typing.Union['EnvironmentVariable', BaseException]:
#        self.value = os.getenv(self.name, self.default)
#        try:
#            self.value = self.type(self.value)
#        except Exception as e:
#            return e
#        
#        if not self.validate_callback(self.value):
#            return False, Exception(self.help)
#
#        return True, self
#
#    def as_field_type(self) -> Field:
#        '''
#        Return a field for use for use in another dataclass
#        '''
#        return field(default_factory=self.validate)
#
#ANSIBLE_VERBOSITY=EnvironmentVariable(
#    name='ANSIBLE_VERBOSITY',
#    default=0,
#    type=int,
#    required=False,
#    validate_callback=lambda x: 0 <= x and x <= 4,
#    help='Expects values from 0 - 4'
#)
#
#DBT2_WAREHOUSE=EnvironmentVariable(
#    name='DBT2_WAREHOUSE',
#    default=15,
#    type=int,
#    required=False,
#    validate_callback=lambda x: x >= 15,
#    help='Expects values from 0 - 4'
#)
#
#@dataclass
#class BenchmarkEnvironment:
#    ANSIBLE_VERBOSITY: EnvironmentVariable = ANSIBLE_VERBOSITY.as_field_type()
#    DBT2_WAREHOUSE: EnvironmentVariable = DBT2_WAREHOUSE.as_field_type()
#
#    def __post_init__(self):
#        tempdict = self.__dict__.items()
#        self.unset_env = {key: None for key, _ in tempdict if not os.getenv(key)}
#        self.configured_env = {key: os.getenv(key, value) for key, value in tempdict}

#@dataclass
#class BenchmarkEnvironment(
#    AnsibleEnvironment,
#):
#    WORKING_DIRECTORY: Path = WORKING_DIRECTORY
#    RESULTS_DIRECTORY: Path = WORKING_DIRECTORY /  'results'
#    TERRAFORM_PROJECT_PATH: Path = WORKING_DIRECTORY / 'terraform'
#    DBT2_DURATION: int = 15
#    DBT2_WAREHOUSE: int = 15
#    DBT2_CONNECTIONS: int = 15
#    SSH_USER: str = "rocky"
#    BUCKET_NAME: str = "ebac-reports"
#    BENCHMARK_NAME: str = BENCHMARK_NAME
#
#    def __post_init__(self):
#        tempdict = self.__dict__.items()
#        self.unset_env = {key: None for key, _ in tempdict if not os.getenv(key)}
#        self.configured_env = {key: os.getenv(key, value) for key, value in tempdict}

#if __name__ == '__main__':
#    env=BenchmarkEnvironment()
#    print(env)
#    print('---------------')
#    print(env.ANSIBLE_VERBOSITY)
#    print('---------------')
#    print(env.configured_env)
#    print('---------------')
#    print(env.unset_env)
    #print(env.unset_env)
    #print(env.configured_env)
