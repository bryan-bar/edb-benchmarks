#!/bin/bash

CLIENT_START=10
# For Production: 400 - Around 12 hours, Dev: 40 - Around 40 minutes
CLIENT_END=$CLIENT_END_DURATION
echo "CLIENT END: ${CLIENT_END_DURATION}"
CLIENT_STEP=10
# For Production: 1200 - Around 12 hours, Dev: 600 - Around 40 minutes
# For Production: 1200, Dev: 600
MY_BENCHMARK_DURATION=$BENCHMARK_DURATION
echo "BENCHMARK DURATION: ${MY_BENCHMARK_DURATION}"
PGSQL_BIN_PATH=/usr/local/pgsql-${PG_MAX_VERSION}/bin
# Let's make read-write the default mode if no argument is given
PGBENCH_MODE=${1:-read-write}

echo "clients,${PG_VERSION}" > /tmp/pgbench-tps-${PG_VERSION}.csv
echo "0,0" >> /tmp/pgbench-tps-${PG_VERSION}.csv

for ((c=${CLIENT_START}; c<${CLIENT_END}; c=c+${CLIENT_STEP}))
do
    ${PGSQL_BIN_PATH}/psql pgbench -c "CHECKPOINT" > /dev/null
    if [ "${PGBENCH_MODE}" == "read-write" ]; then
       # Execute pgbench in read-write mode
       tps=$(${PGSQL_BIN_PATH}/pgbench -T ${MY_BENCHMARK_DURATION} -c ${c} -j 32 pgbench 2> /dev/null | grep "tps = " | grep -v "including" | sed -E "s/tps = ([0-9\.]+).*/\1/")
    else
       # Execute pgbench in read-only mode
       tps=$(${PGSQL_BIN_PATH}/pgbench -T ${MY_BENCHMARK_DURATION} -S -c ${c} -j 32 pgbench 2> /dev/null | grep "tps = " | grep -v "including" | sed -E "s/tps = ([0-9\.]+).*/\1/")
    fi
    echo "${c},${tps}" >> /tmp/pgbench-tps-${PG_VERSION}.csv
    sleep 5
done
