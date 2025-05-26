#!/bin/bash
current_date_time=$(date +"%Y-%m-%d %T")
echo "Starting cron load_ohlcv_from_yahoo.sh at $current_date_time"
touch /home/ubuntuuser/cronlogs/cron_load_ohlcv_from_yahoo.start
source /home/ubuntuuser/miniconda3/etc/profile.d/conda.sh
echo "Activate polygon environment"
conda activate polygon
export PYTHONPATH=${HOME}/karra
echo $PYTHONPATH
cd /home/ubuntuuser/karra/securities_load/
echo $PWD
python /home/ubuntuuser/karra/securities_load/securities/run_load_ohlcv_from_yahoo.py
touch /home/ubuntuuser/cronlogs/cron_load_ohlcv_from_yahoo.end
current_date_time=$(date +"%Y-%m-%d %T")
echo "Finished cron load_ohlcv_from_yahoo.sh at $current_date_time"
