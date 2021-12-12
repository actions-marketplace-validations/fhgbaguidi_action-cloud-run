#!/bin/sh

set -e

echo "image ====> ${INPUT_IMAGE}}"
echo "registry ====> ${INPUT_REGISTRY}}"
echo "tag ====> ${INPUT_TAG}}"
echo "service ====> ${INPUT_SERVICE}}"
echo "project ====> ${INPUT_PROJECT}}"
echo "region ====> ${INPUT_REGION}}"
echo "key ====> ${INPUT_KEY}}"
echo "envfile ====> ${INPUT_ENVFILE}}"
echo "serviceyamlfile ====> ${INPUT_SERVICEYAMLFILE}}"

echo "${INPUT_KEY}" | base64 --decode > "$HOME"/gcloud.json

if [ "${INPUT_ENVFILE}" ]
then
  sed '/^#/ d' < ${INPUT_ENVFILE} > outputWithoutComment.txt
  sed 's/\n /,/g' < outputWithoutComment.txt > env.final
  ENVS=$(cat env.final | xargs | sed 's/\"/\\"/g')
fi

if [ "${ENVS}" ]
then
    ENV_FLAG="--set-env-vars ${ENVS}"
else
    ENV_FLAG="--clear-env-vars"
fi

ADDITIONAL_ARGS="${ENV_FLAG}"

gcloud auth activate-service-account --key-file="$HOME"/gcloud.json --project "${INPUT_PROJECT}"
gcloud auth configure-docker

IMAGE="${INPUT_REGISTRY}/${INPUT_IMAGE}:${INPUT_TAG}"

if [ "${INPUT_SERVICEYAMLFILE}" ]
then
  echo "cating ${INPUT_SERVICEYAMLFILE}}"
  cat ${INPUT_SERVICEYAMLFILE}
  gcloud beta run services replace "${INPUT_SERVICEYAMLFILE}" \
    --region "${INPUT_REGION}" \
    --platform managed

else
  gcloud run deploy "${INPUT_SERVICE}" \
    --image "${IMAGE}" \
    --region "${INPUT_REGION}" \
    --platform managed \
    --allow-unauthenticated \
    ${ADDITIONAL_ARGS}
fi