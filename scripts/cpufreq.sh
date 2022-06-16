#!/bin/bash
# Display TSC and actual frequency of the CPU every second (average of all cores).
# Requires: perf

which perf >/dev/null 2>/dev/null || sudo yum install -y perf
echo -1 | sudo tee /proc/sys/kernel/perf_event_paranoid > /dev/null
echo "TSC_Freq  Actual_Freq"
numproc=$(grep processor /proc/cpuinfo|wc -l)
perf stat -I 1000 -x' ' -e msr/aperf/,msr/mperf/,msr/tsc/ 2>&1 | awk "/aperf/{aperf=\$2} /mperf/{mperf=\$2} /tsc/{tsc=\$2; print tsc/1e9/$numproc, \"   \", tsc*aperf/mperf/1e9/$numproc}"
