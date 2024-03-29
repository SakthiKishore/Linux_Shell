#! /bin/bash

echo "Specify AWS region(eg: eu-west-1)"
read region
echo "Specify the environment(eg: dev, uat...)"
read environment

# Find all gp2 volumes within the given region along with current state
volume_ids=$(aws ec2 describe-volumes --region "${region}" --filters Name=volume-type,Values=gp2 Name=tag:environment,Values="${environment}" | jq -r '.Volumes[]  | "\(.VolumeId) \(.State)"')
echo -e "List of all gp2 volumes: \n$volume_ids"

function GP3_MOD()
{
# Iterate all gp2 volumes and change its type to gp3
for volume_id in ${volume_ids}; do
    result=$(aws ec2 modify-volume --region "${region}" --volume-type=gp3 --volume-id "${volume_id}" | jq '.VolumeModification.ModificationState' | sed 's/"//g')
    if [ $? -eq 0 ] && [ "${result}" == "modifying" ]; then
        echo "OK: volume ${volume_id} changed to state 'modifying'"
    else
        echo "ERROR: couldn't change volume ${volume_id} type to gp3!"
    fi
done
}

echo "Initiate modification to gp3(y/n)?"
read VAR

if [ $VAR == 'y' ]; then
	GP3_MOD
else
	echo "Mission Aborted! ;)"
fi


