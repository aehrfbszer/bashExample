现代 Bash 5.x 开发规范（2026 正式版）
适用版本：Bash 5.0+（推荐 5.1 / 5.2）目标：安全、高性能、可维护、工程化
0. 文档说明
本文档针对老旧 Bash 教程未覆盖的现代语法、高级特性、工程实践编写，包含你提到的全部特性：
关联数组
${ command; } / ${| command; }
${var@U} 系列修饰符
$EPOCHSECONDS / $EPOCHREALTIME
patsub_replacement 模式替换
wait -n 并发等待
命名引用、协程、扩展通配等现代特性
1. 脚本头部：严格模式（必写）
bash
运行
#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar extglob nullglob
IFS=$'\n\t'
set -e：命令失败立即退出
set -u：未定义变量直接报错
set -o pipefail：管道任意阶段失败则整体失败
globstar：启用 ** 递归匹配
extglob：扩展模式匹配 !() *() +() ?() @()
nullglob：无匹配文件时返回空，而非原字符串
IFS=$'\n\t'：仅换行、制表符为分隔符，避免空格拆分文件名
2. 现代变量与扩展
2.1 内置时间变量（Bash 5.0+）
bash
运行
echo "$EPOCHSECONDS"      # 秒级时间戳
echo "$EPOCHREALTIME"     # 微秒级高精度时间戳
echo "$SECONDS"           # 脚本已运行秒数
2.2 字符串修饰符 ${var@*}（Bash 4.4+）
bash
运行
str="Hello Bash"

echo "${str@U}"   # 全大写
echo "${str@L}"   # 全小写
echo "${str@u}"   # 首字母大写
echo "${str@l}"   # 首字母小写
echo "${str@Q}"   # 安全转义，适合拼接命令
echo "${str@E}"   # 解析转义字符
echo "${str@P}"   # 按 PS1 风格展开
2.3 模式替换（patsub_replacement）
bash
运行
# 后缀替换
file="image.jpg"
echo "${file%.jpg}"    # image
echo "${file//jpg/png}"# image.png

# 数组批量替换
arr=("a.js" "b.js" "c.txt")
ts_arr=("${arr[@]/%.js/.ts}")
2.4 参数默认值与安全展开
bash
运行
port="${PORT:-8080}"          # 有值用值，无值用默认
port="${PORT:=8080}"          # 无值则赋值并使用
port="${PORT:?PORT 未设置}"   # 无值直接报错退出
3. 数组与关联数组（Bash 4+）
3.1 普通数组
bash
运行
files=("a.txt" "b file.txt" "c.md")
for f in "${files[@]}"; do
  echo "$f"
done
3.2 关联数组（字典）
bash
运行
declare -A config=(
  [debug]=1
  [port]=3000
  [host]="127.0.0.1"
)

echo "${config[port]}"

# 遍历键
for k in "${!config[@]}"; do
  echo "$k → ${config[$k]}"
done
4. 现代命令捕获语法（Bash 5.0+）
4.1 多行命令组捕获 ${ ...; }
bash
运行
out=${
  echo "start: $EPOCHSECONDS"
  echo "working..."
  echo "done"
}

echo "$out"
4.2 内联管道捕获 ${| ...; }（Bash 5.1+）
bash
运行
err_count=${|
  cat app.log
  grep ERROR
  wc -l
}
等价于：
bash
运行
err_count=$(cat app.log | grep ERROR | wc -l)
5. 并发与进程控制
5.1 wait -n（等待任一子进程完成，Bash 4.3+）
bash
运行
sleep 2 &
sleep 3 &
sleep 5 &

wait -n   # 等待最快结束的任务
echo "第一个进程已完成"
wait      # 等待剩余所有进程
5.2 coproc 协程（双向异步通信）
bash
运行
coproc MY_SERVER {
  while read -r line; do
    echo "recv: $line"
  done
}

echo "test" >&${MY_SERVER[1]}
read -r res <&${MY_SERVER[0]}
echo "$res"
6. 函数与现代特性
6.1 命名引用（类似指针，Bash 4.3+）
bash
运行
set_val() {
  local -n ref="$1"
  ref="$2"
}

my_var=""
set_val my_var "hello"
echo "$my_var"  # hello
6.2 函数规范
bash
运行
log() {
  printf "[%s] %s\n" "$(date +%FT%T)" "$*" >&2
}

die() {
  log "错误：$*"
  exit 1
}
7. 现代正则与匹配
bash
运行
line="user_123"
if [[ "$line" =~ ^([a-z]+)_([0-9]+)$ ]]; then
  name="${BASH_REMATCH[1]}"
  id="${BASH_REMATCH[2]}"
fi
8. 完整现代 Bash 模板（可直接用于生产）
bash
运行
#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar extglob nullglob
IFS=$'\n\t'

readonly SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
declare -A cfg=(
  [debug]=1
  [log_level]="info"
)

log() {
  printf "[%s] %s\n" "$EPOCHSECONDS" "$*"
}

main() {
  log "启动脚本"
  local files=("$@")

  local report=${
    echo "文件数量：${#files[@]}"
    echo "运行时间：$EPOCHSECONDS"
    echo "配置：${cfg[debug]}"
  }

  log "${report@U}"
}

main "$@"

9. 现代 Bash 禁止写法（2026 黑名单）
禁止使用 [ ]，统一使用 [[ ]]
禁止使用反引号 `...`，统一使用 $(...)
禁止不打引号：$var → 必须写 "${var}"
禁止函数内不使用 local
禁止 for file in $(ls *.txt)
禁止滥用 echo，复杂输出优先 printf
禁止硬编码密钥、密码、令牌
10. 现代工具链
shellcheck：静态语法检查
shfmt：自动格式化
bats-core：单元测试
bash 5.2：最新稳定版本

