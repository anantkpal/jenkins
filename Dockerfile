FROM jenkinsci/blueocean

USER jenkins

ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV ENV_NAME dev
ENV REPO_GIT_REPO sample

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

COPY ssh_config /usr/share/jenkins/ref/.ssh/config

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN echo 2 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    echo 2 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

COPY init /usr/share/jenkins/ref/init.groovy.d/

COPY load-jobs/load-jobs.jobdsl /usr/share/jenkins/ref/jobdsl/load-jobs.jobdsl

COPY load-jobs/download-jobdsl.sh /usr/local/bin/download-jobdsl.sh
