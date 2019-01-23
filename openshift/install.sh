#!/bin/sh
set -o nounset -o errexit
cd `dirname $0`

# Builds and installs Jenkins on your current OpenShift project

GIT_BRANCH=${1:-master}

# Show current OpenShift project
oc project

# Github SSH Key
SSH_KEY=$(cat ~/.ssh/id_rsa)
oc create secret generic github-secret --from-literal=ssh-privatekey="${SSH_KEY}" --dry-run -o yaml | oc apply -f -

# Newrelic API Key
oc create secret generic newrelic-api-secret \
    --from-literal=newrelic-key="newrelic-key" \
    --dry-run -o yaml | oc apply -f -

# Slack Token
oc create secret generic slack-token-secret \
    --from-literal=slack-token="slack-token" \
    --dry-run -o yaml | oc apply -f -

# Apply and execute the OpenShift template
oc apply -f openshift-template.yml
oc process jenkins GIT_BRANCH=${GIT_BRANCH} | oc apply -f -
oc start-build jenkins
