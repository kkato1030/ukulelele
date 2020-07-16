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
function err_exit () {
  echo "[ERROR] $1"
  exit 1
}

## Get Path
PRJ_ROOT_PATH=$(dirname $(cd $(dirname $0); pwd))
JSON_FILE=channel.json
JSON_FULL_PATH="$PRJ_ROOT_PATH/$JSON_FILE"
## Check JSON File
if [ ! -f $JSON_FULL_PATH ];then
  err_exit "$JSON_FILE can't be found."
fi

## Get channel ARN
ARN_REGEXP="arn:aws:ivs:$REGION:[0-9]{12}:channel/[[:alnum:]]{12}"
channel_arn=$(egrep --only-matching $ARN_REGEXP < $JSON_FULL_PATH)
## Check ARN
if [ $? = 1 ];then
  err_exit "The ARN of \"$CHANNEL_NAME\" can't be found in $JSON_FILE."
fi

## Delete channel
ivs delete-channel --arn $channel_arn
if [ $? = 1 ];then
  err_exit "Cannot delete channel."
fi
echo "[INFO] $CHANNEL_NAME is deleted."

## Delete Json file
rm $JSON_FULL_PATH
if [ $? = 1 ];then
  err_exit "Cannot delete $JSON_FILE."
fi
echo "[INFO] Delete $JSON_FILE"
exit 0
