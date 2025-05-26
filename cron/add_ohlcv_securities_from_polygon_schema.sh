#!/bin/bash
current_date_time=$(date +"%Y-%m-%d %T")
echo "Starting cron add_ohlcv_securities_from_polygon_schema.sh at $current_date_time"
touch /home/ubuntuuser/cronlogs/cron_add_ohlcv_securities_from_polygon_schema.start
source /home/ubuntuuser/miniconda3/etc/profile.d/conda.sh
echo "Activate polygon environment"
conda activate polygon
export PYTHONPATH=${HOME}/karra
echo $PYTHONPATH
cd /home/ubuntuuser/karra/securities_load/
echo $PWD
python /home/ubuntuuser/karra/securities_load/load_polygon/run_add_ohlcv_securities_from_polygon_schema.py
touch /home/ubuntuuser/cronlogs/cron_add_ohlcv_securities_from_polygon_schema.end
current_date_time=$(date +"%Y-%m-%d %T")
echo "Finished cron add_ohlcv_securities_from_polygon_schema.sh at $current_date_time"
