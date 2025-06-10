#!/bin/bash

day=$(date +%u)   # 1 = Monday, ..., 7 = Sunday
hour=$(date +%H)  # 24-hour format

echo "[INFO] Day: $day, Hour: $hour"

if [ "$hour" -eq 9 ]; then
    echo "[INFO] Executing run_script1.R"
    gsutil cat gs://gcp-cdsc-multipipelines/campylobacter_analysis/run_script1.R | R --vanilla
elif [ "$hour" -eq 10 ] && [ "$day" -ge 1 ] && [ "$day" -le 3 ]; then
    echo "[INFO] Executing run_script2.R"
    gsutil cat gs://gcp-cdsc-multipipelines/campylobacter_analysis/run_script2.R | R --vanilla
else
    echo "[INFO] No script scheduled at this time."
fi
