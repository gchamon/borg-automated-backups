SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

folders_to_backup=(home etc srv boot opt usr)
ENV_FILE="$SCRIPT_DIR"/env
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

COLOR_RED='\e[31m'
COLOR_NONE='\e[0m'
