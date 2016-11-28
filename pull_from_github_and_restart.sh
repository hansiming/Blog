echo '从github拿最新的代码';
git pull;
echo '杀死jekyll服务器进程';
pkill -f jekyll;
echo '关闭成功';
echo '重新编译，并重启jekyll';
jekyll serve --detach;
echo '重启成功'
