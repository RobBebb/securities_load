# Cron Scheduling

## crontab

Edit crontab using:

```bash
crontab -e
```

## cron

To look at the actual cron output use:

```bash
grep CRON /var/log/syslog
```

This can be useful to find errors in the crontab and the shell scripts.

## Scripts

Write a bash script to run our python program. For example load_asx_ohlcv_from_yahoo.sh

```bash
#!/bin/bash
source ~/miniconda3/etc/profile.d/conda.sh
conda activate polygon
```

You must make the script executable:

```bash
chmod +x cron/load_asx_ohlcv_from_yahoo.sh
```

## SQL

Can use PSQL to run SQL.

The password can be stored in the .pgpass file in the users home directory.
Look at load_ohlcv_from_polygon.sh for an example.

## Schedule

### US Market

```cron
30 8 * * 2,3,4,5,6 cron_load_ohlcv_from_polygon
35 8 * * 2,3,4,5,6 cron_add_ohlcv_securities_from_polygon_schema
40 8 * * 2,3,4,5,6 cron_load_option_data_from_yahoo
```

### AUS Market

```cron
30 18 * * 1,2,3,4,5 cron_load_ohlcv_from_yahoo
```

## Monitoring

The cron logs are in ~/cronlogs.

To list all the files, with times use:

```bash
ls -l -a
```

To look at a specific file use:

```bash
cat filename
```
