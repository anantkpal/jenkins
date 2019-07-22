FROM jenkinsci/blueocean

ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV ENV_NAME dev
ENV REPO_LIST_GIT_URI sample

ENV TERRAFORM_VERSION 0.11.14

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

COPY ssh_config /usr/share/jenkins/ref/.ssh/config

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN echo 2 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    echo 2 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

COPY init /usr/share/jenkins/ref/init.groovy.d/

COPY load-jobs/load-jobs.jobdsl /usr/share/jenkins/ref/jobdsl/load-jobs.jobdsl

COPY load-jobs/download-jobdsl.sh /usr/local/bin/download-jobdsl.sh

USER root

RUN apk --no-cache add su-exec docker groff python py-pip gettext procps jq && \
    apk --no-cache add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev python3-dev make && \
    pip install pip==18.0 && \
    pip install awscli s3cmd && \
    apk del --purge build

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin
