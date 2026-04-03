#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar extglob nullglob

# 关联数组
declare -A cfg
cfg[log]=1
cfg[debug]=0

# 高精度时间
start="$EPOCHREALTIME"

# 新语法捕获输出
output=${
  echo "start at $start"
  echo "config: ${cfg[log]}, ${cfg[debug]}"
}

# 字符串修饰符
echo "${output@U}"

# 并发 + wait -n
sleep 1 &
sleep 2 &
wait -n

echo "done in $(( EPOCHSECONDS - ${start%.*} ))s"