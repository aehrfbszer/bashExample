#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# set -e：出错立即停止，不继续执行
# set -u：使用未定义变量直接报错（避免空值灾难）
# set -o pipefail：管道中任意命令失败，整个管道算失败
# IFS=$'\n\t'：只把换行 / 制表符当分隔符，避免空格分割文件 / 路径


# 现代安全写法
echo "Hello ${name}"

# 路径/文件名 必须双引号包裹
file="my report.txt"
cat "${file}"


# 如果变量为空，使用默认值
port="${PORT:-8080}"


# 字符串判断
if [[ "${name}" == "Alice" ]]; then
  echo "Hi"
fi

# 数字判断
if [[ "${age}" -gt 18 ]]; then
  echo "Adult"
fi

# 文件判断
if [[ -f "${file}" ]]; then
  echo "File exists"
fi

# 逻辑与或
if [[ -f "${file}" && "${name}" == "Alice" ]]; then
  echo "OK"
fi

# -f：普通文件存在
# -d：目录存在
# -z：字符串为空
# -n：字符串非空

# 遍历当前目录所有 txt 文件（安全，支持空格文件名）
for file in *.txt; do
  echo "${file}"
done

for ((i=0; i<10; i++)); do
  echo "${i}"
done

# 标准现代函数
greet() {
  local name="${1}"  # local 限定局部变量！
  echo "Hello ${name}"
}

# 调用
greet "Bob"


str="hello-world-123"

# 替换
echo "${str//world/earth}"  # hello-earth-123

# 截取前缀
echo "${str#hello-}"  # world-123

# 截取后缀
echo "${str%-123}"  # hello-world

# 转大写
echo "${str^^}"  # HELLO-WORLD-123

# 转小写
echo "${str,,}"  # hello-world-123


# 定义现代数组
fruits=("apple" "banana" "orange")

# 遍历
for f in "${fruits[@]}"; do
  echo "${f}"
done

# 获取长度
echo "${#fruits[@]}"

# 现代写法
today=$(date +%Y-%m-%d)


# 标准输出
echo "INFO: Running..."

# 错误输出（必须输出到 stderr）
echo "ERROR: File not found" >&2