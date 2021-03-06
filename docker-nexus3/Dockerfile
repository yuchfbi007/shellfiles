# Copyright (c) 2016-present Sonatype, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#FROM centos:centos7
FROM openjdk:8-jre-alpine

MAINTAINER Sonatype <yuchfbi007@163.com>

LABEL vendor=Sonatype \
      com.sonatype.license="Apache License, Version 2.0" \
      com.sonatype.name="Nexus Repository Manager base image"

ARG NEXUS_VERSION=3.7.1-02
ARG NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz
ARG NEXUS_DOWNLOAD_SHA256_HASH=d6605064eae2d6a0679054e3afb039c8b071862644632894e04558e1d067cbfb

#configure nexus runtime
ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME=${SONATYPE_DIR}/nexus \
    NEXUS_DATA=/nexus-data \
    NEXUS_CONTEXT='' \
    SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work \
    DOCKER_TYPE='docker'

ARG NEXUS_REPOSITORY_MANAGER_COOKBOOK_VERSION="release-0.5.20180105-135811.666c150"
ARG NEXUS_REPOSITORY_MANAGER_COOKBOOK_URL="https://github.com/sonatype/chef-nexus-repository-manager/releases/download/${NEXUS_REPOSITORY_MANAGER_COOKBOOK_VERSION}/chef-nexus-repository-manager.tar.gz"

#ADD spec/solo.json.erb /var/chef/solo.json.erb
#ADD spec/install.sh  /var/chef/install.sh 


# Install using chef-solo
#RUN chmod +x /var/chef/install.sh 
#RUN /var/chef/install.sh  \
#    && /opt/chef/embedded/bin/erb /var/chef/solo.json.erb > /var/chef/solo.json \
#    && chef-solo \
#       --recipe-url ${NEXUS_REPOSITORY_MANAGER_COOKBOOK_URL} \
#       --json-attributes /var/chef/solo.json \
#    && rpm -qa *chef* | xargs rpm -e \
#    && rpm --rebuilddb \
#    && rm -rf /etc/chef \
#    && rm -rf /opt/chefdk \
#    && rm -rf /var/cache/yum \
#    && rm -rf /var/chef

VOLUME ${NEXUS_DATA}

EXPOSE 8081
USER nexus

ENV INSTALL4J_ADD_VM_PARAMS="-Xms1200m -Xmx1200m -XX:MaxDirectMemorySize=2g -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs"

CMD ["sh", "-c", "${SONATYPE_DIR}/start-nexus-repository-manager.sh"]
