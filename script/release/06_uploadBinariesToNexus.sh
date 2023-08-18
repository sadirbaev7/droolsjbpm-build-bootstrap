#!/bin/bash -e

# the created binaries are uploaded from the locally deploy dir [$WORKSPACE/community-deploy-dir ] to Nexus
# the binaries are only uploaded when the build was for a community release
# BACKUP for prod:
#    stagingRep=15c3321d12936e
#    deployDir=$WORKSPACE/prod-deploy-dir

# fetch the <version.org.kie> from kie-parent-metadata pom.xml and set it on parameter KIE_VERSION
kieVersion=$(sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' -n -e 's/<version.org.kie>\(.*\)<\/version.org.kie>/\1/p' droolsjbpm-build-bootstrap/pom.xml)

# staging repository on Nexus
stagingRep=15c58a1abc895b
# local directoy where artifacts are stored
deployDir=$WORKSPACE/community-deploy-dir


cd $deployDir
# upload the content to remote staging repo on Nexus
mvn -B -e -s $SETTINGS_XML_FILE -Dkie.maven.settings.custom=$SETTINGS_XML_FILE org.sonatype.plugins:nexus-staging-maven-plugin:1.6.5:deploy-staged-repository -DnexusUrl=https://repository.jboss.org/nexus -DserverId=jboss-releases-repository -DrepositoryDirectory=$deployDir -DstagingProfileId=$stagingRep -DstagingDescription="kie-$kieVersion" -DkeepStagingRepositoryOnCloseRuleFailure=true -DkeepStagingRepositoryOnFailure=true -DstagingProgressTimeoutMinutes=120
