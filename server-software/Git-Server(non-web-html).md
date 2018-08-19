# 搭建Git服务器
#### 1.安装Git
```
apt-get install git
git --version
git version 1.9.1
```
#### 2:创建Git目录、组、用户、所有
```
mkdir -p /git
groupadd git
useradd git -g git -d /git -s /usr/bin/git-shell
chown -R git:git /git/
```
###### 注：git-shell，git用户可以正常通过ssh使用git，但无法登录shell，每次一登录就自动退出。
#### 3.证书文件
```
mkdir -p /git/.ssh/
touch /git/.ssh/authorized_keys
```
###### 注：收集所有需要登录的用户的公钥，把所有公钥记录到/home/git/.ssh/authorized_keys文件里，一行一个。
###### 注：用户的公钥，即用户本地机器用户目录下.ssh目录下的id_rsa.pub文件里的内容。
#### 4.初始化Git仓库
```
cd /git
git init --bare ts.git
Initialized empty Git repository in /git/ts.git/
chown -R git:git /git/
```
###### 创建一个裸仓库，并且服务器上的Git仓库通常都以.git结尾。裸仓库没有工作区，服务器上的Git仓库纯粹是为了共享，这个仓库只保存git历史提交的版本信息，而不允许用户在上面进行修改工作区或各种git操作，如果在服务器操作发生错误（”This operation must be run in a work tree”）。--bare：推荐！
#### 5.克隆远程仓库(本地工作目录执行)  --以下步骤必须
```
git clone git@git.loveshare.studio:/git/ts.git
cd ts
touch README.md
vim README.md
git add -A
git commit -m "First remote git add file and test."

git checkout -b develop
touch test.md
vim test.md
git add -A
git commit -m "first develop branch commit."
git push --set-upstream origin develop 
```
###### ok.


###### 备注:
```
$ ssh-keygen -t rsa -C "youremail@example.com"
```
