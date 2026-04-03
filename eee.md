mapfile /readarray 这两个详细介绍一下
这两个命令其实是同一个命令的两个名字（别名），它们是 Bash 4.0 引入的内置命令，专门用来将文件或标准输入的内容逐行读取到数组中。
相比传统的 for line in $(cat file) 或 while read 循环，它的性能更高，且能完美处理每一行中的空格。
1. 基本语法
bash
mapfile [选项] 数组名 < 文件名
# 或者使用管道（注意：管道在某些 Bash 版本下需要特殊处理，见下文）
cat file | mapfile [选项] 数组名
请谨慎使用此类代码。

2. 常用选项（现代开发的“必选”）
-t (最常用)：移除行尾的换行符。如果不加这个，数组的每个元素末尾都会带一个 \n，这通常不是我们想要的。
-n：限制读取的行数。例如 -n 5 只读前 5 行。
-s：跳过开头的行数。例如 -s 10 从第 11 行开始读。
-u：从指定的文件描述符读取。
-d：指定分隔符（默认是换行符）。Bash 4.4+ 支持。
3. 实战对比：为什么它比传统方法好？
❌ 传统方案：for 循环（有坑）
bash
# 坑：如果文件里有一行叫 "Hello World"，它会被拆成两个数组元素
for line in $(cat file.txt); do 
    echo "$line"
done
请谨慎使用此类代码。

❌ 传统方案：while read（慢）
bash
# 缺点：每一行都要启动一次 read 进程，大文件极其缓慢
lines=()
while IFS= read -r line; do
    lines+=("$line")
done < file.txt
请谨慎使用此类代码。

✅ 现代方案：mapfile（快且稳）
bash
# 优雅：一行搞定，保留空格，去掉换行符
mapfile -t my_array < file.txt

# 访问方式：
echo "${my_array[0]}"      # 第一行
echo "${#my_array[@]}"     # 总行数
请谨慎使用此类代码。

4. 高级技巧：回调处理 (-C 和 -c)
mapfile 可以在读取一定行数后触发一个“回调函数”。
-c 10：每读 10 行执行一次回调。
-C "my_callback"：指定回调函数名。
这在处理海量文件、需要显示进度条或分批处理数据时非常有用。
5. ⚠️ 进阶警告：管道陷阱（Pipe Trap）
在 Bash 中，管道会启动一个子 Shell（Subshell）。如果你这样写：
bash
cat file.txt | mapfile -t my_array
echo "${#my_array[@]}" # 结果可能是 0！
请谨慎使用此类代码。

原因：mapfile 在子 Shell 中运行，运行完数组就随着子 Shell 销毁了。
现代解决方法：
重定向（推荐）：mapfile -t my_array < file.txt
进程替换：mapfile -t my_array < <(grep "keyword" file.txt)
开启 lastpipe（仅限非交互式脚本）：
bash
set +m
shopt -s lastpipe
grep "keyword" file.txt | mapfile -t my_array
请谨慎使用此类代码。

总结
简单场景：mapfile -t arr < file 是读取文件的标配。
核心优势：避开空格/换行符解析的坑，执行速度极快（内置命令）。
你目前处理的文件通常是几百行的配置，还是上万行的日志数据？如果是后者，我可以给你展示如何配合 -C 选项做分块处理。




