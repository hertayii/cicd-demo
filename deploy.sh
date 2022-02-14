#!/bin/bash

# this will force script to exit if any command fails
set -ex

export AWS_DEFAULT_REGION=us-east-1

# set right variable value based on the branch
if [[ $BRANCH_NAME == feature-* ]]
then
    stage=dev
elif [[ $BRANCH_NAME == master ]]
then
    stage=staging
elif [[ $BRANCH_NAME == production/deploy ]]
then
    stage=prod
fi

# if stage is not prod, then also build/push image
if [[ $stage != prod ]]
then
    cd api/
    make build stage=$stage
    make push stage=$stage
    cd ..
    cd web/
    make build stage=$stage
    make push stage=$stage
    cd ..
fi

# there is no if here, so the deploy will happen regardless of the stage
cd api/
make deploy stage=$stage
cd ..
cd web/
make deploy stage=$stage
cd ..
