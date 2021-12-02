# Install Media

Before running the automation, SAP install media needs to be uploaded to the buckets defined in `sap_hana_install_files_bucket` and `sap_nw_install_files_bucket` (these can be the same bucket). The [gsutil](https://cloud.google.com/storage/docs/gsutil) tool can be used to populate the buckets with the media according to the instructions below.

## HANA Install Media

HANA install media needs to be uploaded to the buckets defined in `sap_hana_install_files_bucket`.

### HANA Version 20SPS03

All files should be uploaded `sap_hana_install_files_bucket` with the prefix `HANA/20SPS03`

HANA 2.0 SPS03 installs from EXE/RAR files. The RAR file version may differ, depending on your patch level.

`HANA/20SPS03/51053061_part1.exe`

`HANA/20SPS03/51053061_part2.rar`

`HANA/20SPS03/51053061_part3.rar`

`HANA/20SPS03/51053061_part4.rar`

The SAPCAR command for linux x86_64 must be uploaded:

`HANA/20SPS03/SAPCAR_1320-80000935.EXE`

The SAP host agent RPM must be uploaded:

`HANA/20SPS03/saphostagentrpm_44-20009394.rpm`

Optionally, a SAR file containing an upgrade may be uploaded. If it is present, the upgrade will be run, otherwise it is skipped.

`HANA/20SPS03/IMDB_SERVER20_037_1-80002031.SAR`

### HANA Version 20SPS04 and later

All files should be uploaded into `sap_hana_install_files_bucket` with the prefix `HANA/20SPS04`

HANA 2.0 SPS04 and later install from ZIP files. The ZIP file version may differ according to version and patch level. The value of `<version>` may be `20SPS04` or `20SPS05`, for example.

`HANA/<version>/51053787.ZIP`

The SAPCAR command for linux x86_64 must be uploaded:

`HANA/<version>/SAPCAR_1320-80000935.EXE`

The SAP host agent RPM must be uploaded:

`HANA/<version>/saphostagentrpm_44-20009394.rpm`

Optionally, a SAR file containing an upgrade may be uploaded. If it is present, the upgrade will be run, otherwise it is skipped.

`HANA/<version>/IMDB_SERVER20_048_2-80002031.SAR`

## Application Install Media

### NetWeaver

The NetWeaver 7.50 install media must be placed into `sap_nw_install_files_bucket` with the following directory structure:

`NetWeaver/750/HANA_CLIENT` - The HANA client should be extracted and placed under this prefix. The `LABEL.ASC`, `DATA_UNITS`, and other files will be in this directory.

`NetWeaver/750/Kernel_Files` - All of the required kernel files should be placed under this prefix. The contents of the directory should look similar to the following, though versions may differ depending on the patch level:

```
NetWeaver/750/Kernel_Files/51050826_3.ZIP
NetWeaver/750/Kernel_Files/SAPEXEDB_200-80002572.SAR
NetWeaver/750/Kernel_Files/SAPEXEDB_200-80002603.SAR
NetWeaver/750/Kernel_Files/SAPEXE_200-80002573.SAR
NetWeaver/750/Kernel_Files/SAPHOSTAGENT36_36-20009394.SAR
NetWeaver/750/Kernel_Files/igsexe_4-80003187.sar
NetWeaver/750/Kernel_Files/igshelper_17-10010245.sar
```

`NetWeaver/750/NW75` - The export files should be extracted and placed under this prefix. The `LABEL.ASC`, `DATA_UNITS`, and other files will be in this directory.

`NetWeaver/750/SWPM1.0` - The SWPM 1.0 SAR file should be extracted and placed under this prefix. The `LABEL.ASC` and other files will be in this directory.

### S4HANA

The S4HANA install media must be placed into `sap_nw_install_files_bucket` with the following directory structure. The value of `<version>` may be `1809`, `1909`, or `2020`, for example.

`S4HANA/<version>/Kernel_Files` - The HANA client, kernel files, and exports will be placed under this prefix. The contents of the directory should look similar to the following:

```
S4HANA/<version>/Kernel_Files/IMDB_CLIENT20_004_142-80002082.SAR
S4HANA/<version>/Kernel_Files/S4CORE104_INST_EXPORT_1.zip
... more export files omitted ...
S4HANA/<version>/Kernel_Files/S4CORE104_INST_EXPORT_19.zip
S4HANA/<version>/Kernel_Files/SAPEXEDB_400-80004392.SAR
S4HANA/<version>/Kernel_Files/SAPEXE_400-80004393.SAR
S4HANA/<version>/Kernel_Files/SAPHOSTAGENT36_36-20009394.SAR
S4HANA/<version>/Kernel_Files/igsexe_4-80003187.sar
S4HANA/<version>/Kernel_Files/igshelper_17-10010245.sar
```

`S4HANA/<version>/SWPM2.0` - The SWPM 2.0 SAR file should be extracted and placed under this prefix. The `LABEL.ASC` and other files will be in this directory.

### BW4HANA

The BW4HANA 2.0 install media must be placed into `sap_nw_install_files_bucket` with the following directory structure:

`BW4HANA/20/Kernel_Files` - The HANA client, kernel files, and exports will be placed under this prefix. The contents of the directory should look similar to the following:

```
BW4HANA/20/Kernel_Files/51052939_EXP_part1
BW4HANA/20/Kernel_Files/51052939_EXP_part1.exe
BW4HANA/20/Kernel_Files/51052939_EXP_part2.rar
BW4HANA/20/Kernel_Files/51053761
BW4HANA/20/Kernel_Files/51053761.ZIP
BW4HANA/20/Kernel_Files/51053791
BW4HANA/20/Kernel_Files/51053791.ZIP
BW4HANA/20/Kernel_Files/51053942
BW4HANA/20/Kernel_Files/51053942.ZIP
BW4HANA/20/Kernel_Files/BW4HANA200_INST_EXPORT_1
BW4HANA/20/Kernel_Files/BW4HANA200_INST_EXPORT_1.zip
... more export files omitted ...
BW4HANA/20/Kernel_Files/BW4HANA200_INST_EXPORT_7
BW4HANA/20/Kernel_Files/BW4HANA200_INST_EXPORT_7.zip
BW4HANA/20/Kernel_Files/BW4HANA200_NW_LANG_AR
BW4HANA/20/Kernel_Files/BW4HANA200_NW_LANG_AR.SAR
... more export files omitted ...
BW4HANA/20/Kernel_Files/BW4HANA200_NW_LANG_ZH
BW4HANA/20/Kernel_Files/BW4HANA200_NW_LANG_ZH.SAR
BW4HANA/20/Kernel_Files/IMDB_CLIENT20_004_151-80002082.SAR
BW4HANA/20/Kernel_Files/SAPEXEDB_300-80003385.SAR
BW4HANA/20/Kernel_Files/SAPEXE_300-80003386.SAR
BW4HANA/20/Kernel_Files/SAPHOSTAGENT36_36-20009394.SAR
BW4HANA/20/Kernel_Files/igsexe_4-80003187.sar
BW4HANA/20/Kernel_Files/igshelper_17-10010245.sar
```

`BW4HANA/20/SWPM2.0` - The SWPM 2.0 SAR file should be extracted and placed under this prefix. The `LABEL.ASC` and other files will be in this directory.
