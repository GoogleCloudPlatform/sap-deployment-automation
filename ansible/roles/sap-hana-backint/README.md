# sap-hana-backint -- install Backint tool so Hana can stream backups to a GCS bucket

## Setup and Use Backint

Resource: Cloud Storage Backint agent for SAP HANA installation guide https://cloud.google.com/solutions/sap/docs/sap-hana-backint-guide

1) create bucket to store backups

2) grant Hana's default IAM service account write access to bucket

3) TODO: In AWX, select "Install Backint" Job Template.

4) connect HANA with Backint agent -- see Guide above.

5) test: run HANA backup with Backint agent. Verify data appears in bucket.

Example of Steps 1-2 above:

    # create bucket
    BUCKET=jm-backint-bucket
    gsutil mb gs://${BUCKET}
    
    # grant access to bucket from HANA default user
    SA=186808757774-compute@developer.gserviceaccount.com
    gsutil iam ch serviceAccount:${SA}:roles/storage.objectAdmin gs://${BUCKET}


## Manual Backups

1) ssh into the HANA instance

2) sudo to `rh1adm` user

3) verify that raw SQL queries execute correctly:

    hdbsql -n localhost -i 00 -u SYSTEM -p mypassword "select version from
    sys.m_database"
    
   VERSION
   "2.00.047.00.1586595995"

4) run a full backup, using Backint plugin, with a custom prefix:

   hdbsql -n localhost -i 00 -u SYSTEM -p mypassword "backup data incremental
   using backint ('$(date +'%Y_%m_%d:%H:%M')_BACKUP_FILE')"
   

## HANA Studio Configuration and Logs

![configuration]
(images/backint hana configuration.png)

![set destination to Backint]
(images/backint destination backint.png)

![backup logs are available]
(images/backint logs.png)

![settings]
(images/backint settings.png)
