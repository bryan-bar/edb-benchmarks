#!/bin/bash -eux

echo "PGBENCH_SCALE_FACTOR: $PGBENCH_SCALE_FACTOR"

if (( $(echo "$PGBENCH_SCALE_FACTOR < 100" | bc -l) )); then
   echo "PGBENCH_SCALE_FACTOR: $PGBENCH_SCALE_FACTOR";
   echo "PGBench Scale Factor, cannot be lower than 100!"
   exit 1
fi
