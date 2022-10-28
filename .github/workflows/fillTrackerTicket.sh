#!/bin/bash
tag="$RELEASE_TAG"
date_release=$(date +'%d/%m/%Y')
summary="Релиз $tag - $date_release"
description="коммиты, попавшие в релиз: $TAGS_COMMITS"
patch_data="{\"summary\": \"${summary}\", \"description\": \"${description}\", \"tags\":[\"${tag}\"]}"
post_data="{\"text\": \"Собрали образ c тегом ${tag}\"}"

echo $RELEASE_TAG
echo $summary
echo $RELEASE_USER
echo $TAGS_COMMITS
echo $YANDEX_OAUTH_TOKEN
echo $YANDEX_ID_ORGANIZATION
echo $description
echo $patch_data
echo $post_data

X="-X PATCH"
url="--url $TRACKER_HOST/v2/issues/$TRACKER_TASK_ID"
curl \
${X} \
${url} \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H "Authorization: OAuth ${YANDEX_OAUTH_TOKEN}" \
-H "X-Org-ID: ${YANDEX_ID_ORGANIZATION}" \
-d "$patch_data"

if [ 0 -ne $? ]; then
    echo -e "\n error"
    exit 0
fi

X="-X POST"
url="--url $TRACKER_HOST/v2/issues/$TRACKER_TASK_ID/comments"
curl \
${X} \
${url} \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H "Authorization: OAuth ${YANDEX_OAUTH_TOKEN}" \
-H "X-Org-ID: ${YANDEX_ID_ORGANIZATION}" \
-d "$post_data"


if [ 0 -ne $? ]; then
    echo -e "\n error"
    exit 0
fi