#/bin/bash
## Set Variables
REGION=us-east-1
PROFILE=default
ENV=dev
SERVICE=ukulelele
CHANNEL_NAME=$SERVICE-$ENV

## define function
function ivs () {
  aws ivs $* --region $REGION --profile $PROFILE
}

## Get Path
PRJ_ROOT_PATH=$(dirname $(cd $(dirname $0); pwd))
JSON_FILE=channel.json

## Confirm Channel Existence
ARN_REGEXP="arn:aws:ivs:$REGION:[0-9]{12}:channel/[[:alnum:]]{12}"
channel_arn=$(ivs list-channels --filter-by-name $CHANNEL_NAME | egrep --only-matching $ARN_REGEXP)

## Channel does not Exist -> create channel
if [ $? = 1 ];then
  channel_arn=$(ivs create-channel --name $CHANNEL_NAME \
    --latency-mode NORMAL \
    --type BASIC \
    --tags ENV=$ENV,SERVICE=$SERVICE | egrep --only-matching $ARN_REGEXP | head -n 1)
  echo "[INFO] Create channel \"$CHANNEL_NAME\""
fi

## Check the number of ARNs
line_count=$(echo "$channel_arn" | wc -l)
if [ $line_count -gt 1 ];then
  echo "[ERROR] There are multiple channels named \"$CHANNEL_NAME\""
  exit 1
fi

## Get and Save channel info
ivs get-channel --arn $channel_arn > $PRJ_ROOT_PATH/$JSON_FILE
echo "[INFO] Get channel info \"$CHANNEL_NAME\" and Save to $JSON_FILE"
exit 0
