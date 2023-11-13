#!/bin/bash

if [ $# != "1" ];then
    echo "usage $0 repo"
    exit 1
fi

repository=$1

gh api --paginate "/repos/$repository/environments" | jq -r '.environments[] | select(.name | startswith("pull-request-")) | .name' | while read -r envname ;
do
    echo "Deleting environment $envname"
    gh api --method DELETE "/repos/$repository/environments/$envname"
done

gh api --paginate "/repos/$repository/deployments" | --jq '.[] | select(.environment | startswith("pull-request-")) | .id' | while read -r deploymentid ;
do
    echo "Deleting deployment $deploymentid"
    gh api --method DELETE "/repos/$repository/deployments/$deploymentid"
done

