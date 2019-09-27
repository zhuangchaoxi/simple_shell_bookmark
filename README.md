# simple_shell_bookmark
简易shell目录书签，支持apple和linux。

# 部署
将Makefile和bookmark.sh放到任意有权限的目录下执行make install

# 使用说明(任意有权限的目录下执行以下指令)：
- 查看书签列表：b
- 增加新书签：a
- 跳转到指定书签目录：t <书签id> ,例: t 3
- 删除指定目录书签(可删除多个)：r <书签id> ... ,例: r 4 3 7
- 清空所有书签：c
