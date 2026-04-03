# 1. 关联数组（Associative Arrays）- Bash 4.0+
# 这是 Bash 迈向“现代编程语言”的一大步，允许你使用字符串作为索引（类似 Python 的字典或 JS 的对象）。
# 语法：必须先用 declare -A 声明。
# 示例：
# bash
# 声明
declare -A user

# 赋值
user[name]="jack"
user[age]="25"
user[city]="beijing"

# 取值
echo "${user[name]}"

# 遍历 key/value
for key in "${!user[@]}"; do
  echo "$key: ${user[$key]}"
done

# 2. 命令替换的新形态（Non-forking Command Substitution）- Bash 5.3+
# 这是 Bash 5.3 最重磅的更新。传统的 $(command) 会创建一个子进程（Subshell），开销较大。 
# The New Stack
# The New Stack
#  +1
# 新语法：${ command; } 或 ${| command; }。
# 优点：它在当前 shell 上下文中执行，不产生子进程。
${ command; }：直接捕获标准输出。
${| command; }：将结果存入预定义的 REPLY 变量中，执行效率极高



# 3. 变量变换（Parameter Transformation）- Bash 4.4+
# 通过 ${var@operator} 语法，你可以快速转换变量格式，不再需要调用 sed 或 awk。
# 常用操作符：
${var@U}：全部转为大写。
${var@L}：全部转为小写。
${var@Q}：将变量内容转义，使其可以安全地作为输入再次使用（防注入）。
${var@P}：将变量作为提示符字符串解析。


# 4. 更加精确的时间戳 - Bash 5.0+
# 以前获取毫秒/微秒级时间需要调用外部命令 date +%N，现在内置了变量：
$EPOCHSECONDS：当前的 Unix 时间戳（秒）。
$EPOCHREALTIME：带微秒精度的浮点数时间戳（如 1672531200.123456）。


# 5. 改进的路径匹配与排序 - Bash 5.2/5.3+
GLOBSORT 变量：在 Bash 5.3 中，你可以通过设置 GLOBSORT 来控制文件名通配符（Glob）匹配结果的排序方式（按大小、按时间等），无需再配合 ls 或 sort 使用。
patsub_replacement：在 Bash 5.2 中，字符串替换 ${var/pattern/replacement} 变得更强大，支持通过 & 引用匹配到的整个字符串。

arr=("apple.js" "banana.js" "test.txt")
# 批量替换后缀
new_arr=("${arr[@]/%.js/.ts}")
# 批量删除前缀
new_arr=("${arr[@]#test-}")

# 6. 安全与调试增强
# wait -n：现在可以等待任意一个后台作业完成并返回其退出码，而不是等待所有作业。
sleep 3 &
sleep 2 &
sleep 5 &
# 等待【最先完成】的那个进程就继续
wait -n
echo "第一个进程完成"

# 更清晰的错误提示：新版本会在复合命令（如 if 缺失 fi）出错时，准确指出起始行号，极大降低了调试难度。
source -p PATH：Bash 5.3 允许 source 命令通过指定的路径查找文件，而不仅限于全局 $PATH。