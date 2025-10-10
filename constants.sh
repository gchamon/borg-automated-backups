SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
COLOR_RED='\e[31m'
COLOR_NONE='\e[0m'

# replaces path delimiter with underscore (/ -> _)
# borg repos, bash scripts and log files must be valid filenames
filename-from-path() {
    echo "${1//\//_}"
}
