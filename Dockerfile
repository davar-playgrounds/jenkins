FROM openshift/jenkins-2-centos7:v3.9

RUN rm -rf /opt/openshift/configuration/jobs/OpenShift\ Sample

USER root

# jq
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm && \
    yum install -y jq

USER 1001

# Plugin overrides
COPY plugins.txt /opt/openshift/configuration/plugins.txt
RUN /usr/local/bin/install-plugins.sh /opt/openshift/configuration/plugins.txt
