#!/bin/bash

if [ -z "$1" ]; then
  echo "Pass HANA-HA project ID to this script"
  exit 1
fi

PROJECT=$1

echo "Deleting forwarding-rules"
for i in $(gcloud compute forwarding-rules list --project $PROJECT --format='csv[no-heading](name,region)'); do
  # i is in the format name,region
  # split string on ','
  vars=(`echo $i | tr ',' ' '`)
  gcloud --project $PROJECT --quiet compute forwarding-rules delete --region "${vars[1]}" "${vars[0]}" &
done

wait

echo "Deleting backend-services"
for i in $(gcloud compute backend-services list --project $PROJECT --format='csv[no-heading](name,region.scope())'); do
  # i is in the format name,region
  # split string on ','
  vars=(`echo $i | tr ',' ' '`)
  gcloud --project $PROJECT --quiet compute backend-services  delete --region "${vars[1]}" "${vars[0]}" &
done

wait

echo "Deleting health-checks"
for i in $(gcloud compute health-checks list --project $PROJECT --format='value(name)'); do
  gcloud --project $PROJECT --quiet compute health-checks  delete --global $i &
done

wait

echo "Deleting managed instance groups"
for i in $(gcloud --project $PROJECT compute instance-groups unmanaged  list --format='csv[no-heading](name,zone.scope())'); do
  # i is in the format name,region
  # split string on ','
  vars=(`echo $i | tr ',' ' '`)
  gcloud --project $PROJECT --quiet compute instance-groups unmanaged  delete --zone "${vars[1]}" "${vars[0]}" &
done

wait

echo "Deleting instances"
for i in $(gcloud --project $PROJECT compute instances list --format='csv[no-heading](name,zone.scope())'); do
  # i is in the format name,region
  # split string on ','
  vars=(`echo $i | tr ',' ' '`)
  gcloud --project $PROJECT --quiet compute instances delete --zone "${vars[1]}" "${vars[0]}" &
done

wait

echo "Deleting compute addresses"
for i in $(gcloud --project $PROJECT compute addresses  list --filter='addressType=INTERNAL' --format='csv[no-heading](name,region.scope())'); do
  # i is in the format name,region
  # split string on ','
  vars=(`echo $i | tr ',' ' '`)
  gcloud --project $PROJECT --quiet compute addresses  delete --region "${vars[1]}" "${vars[0]}" &
done

wait

echo "Deleting instance-templates"
for i in $(gcloud --project $PROJECT compute instance-templates list --format='csv[no-heading](name)'); do
  gcloud --project $PROJECT --quiet compute instance-templates delete $i &
done

wait

echo "Deleting attached disks"
for i in $(gcloud --project $PROJECT compute  disks list --format='csv[no-heading](name,zone.scope())'); do
  # i is in the format name,zone
  # split string on ','
  vars=(`echo $i | tr ',' ' '`)
  gcloud --project $PROJECT --quiet compute disks delete --zone "${vars[1]}" "${vars[0]}" &
done

wait

echo "Deleting firewall rules"
for i in $(gcloud --project $PROJECT compute firewall-rules list --filter='NOT name ~ ^sap-iap$ AND NOT name ~ ^sap-allow-all$' --format='csv[no-heading](name)'); do
  gcloud --project $PROJECT --quiet compute firewall-rules delete $i &
done

wait

echo "Deleting bastion service accounts"
for i in $(gcloud --project $PROJECT iam service-accounts list --filter='email ~ ^ssh-bastion' --format='csv[no-heading](email)'); do
  gcloud --project $PROJECT --quiet iam service-accounts delete $i &
done

wait

echo "Deleting filestores"
for i in $(gcloud --project $PROJECT  filestore instances list --format='value(name.scope())'); do
  gcloud --project $PROJECT --quiet filestore instances delete $i &
done

wait

echo "Deleting stale state files"
for i in $(gsutil ls gs://$PROJECT-tf-state/); do
  gsutil rm -r $i
done
