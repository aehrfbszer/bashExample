#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# 常量定义（大写）
readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly LOG_FILE="${SCRIPT_DIR}/run.log"

# 函数
info() {
  echo "[$(date +%Y-%m-%d\ %H:%M:%S)] INFO: ${*}"
}

error() {
  echo "[$(date +%Y-%m-%d\ %H:%M:%S)] ERROR: ${*}" >&2
  exit 1
}

# 主逻辑
main() {
  info "Script started"
  [[ $# -eq 0 ]] && error "No arguments provided"

  local name="${1}"
  info "Hello ${name}"
}

main "${@}"