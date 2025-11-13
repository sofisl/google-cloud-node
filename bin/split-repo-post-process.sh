#!/bin/bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
 
set -e
 
PACKAGE_NAME=$(basename ${PACKAGE_PATH})
 
echo "Detecting the latest version in ${PACKAGE_PATH}"
LATEST_VERSION=$(cat "${PACKAGE_PATH}/package.json" | jq -r ".version")
echo "Latest version: ${LATEST_VERSION}"
 
echo "Adding release-please config"
# using a temp file because jq doesn't like writing to the input file as it reads
cat release-please-config.json | jq --sort-keys ". * {\"packages\": {\"${PACKAGE_PATH}\": {}}}" > release-please-config2.json
mv release-please-config2.json release-please-config.json
 
echo "Adding release-please manifest version"
# using a temp file because jq doesn't like writing to the input file as it reads
cat .release-please-manifest.json | jq --sort-keys ". * {\"${PACKAGE_PATH}\": \"${LATEST_VERSION}\"}" > .release-please-manifest2.json
mv .release-please-manifest2.json .release-please-manifest.json
 
echo "updating repository object type"
# using a temp file because jq doesn't like writing to the input file as it reads
jq -r ".repository = {\"type\": \"git\", \"directory\": \"packages/${PACKAGE_NAME}\", \"url\": \"https://github.com/googleapis/google-cloud-node.git\"}" ${PACKAGE_PATH}/package.json > ${PACKAGE_PATH}/package2.json
mv ${PACKAGE_PATH}/package2.json ${PACKAGE_PATH}/package.json
 
echo "updating homepage"
# using a temp file because jq doesn't like writing to the input file as it reads
jq -r ".homepage = \"https://github.com/googleapis/google-cloud-node/tree/main/packages/${PACKAGE_NAME}\"" ${PACKAGE_PATH}/package.json > ${PACKAGE_PATH}/package2.json
mv ${PACKAGE_PATH}/package2.json ${PACKAGE_PATH}/package.json
 

