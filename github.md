
<style>
p {
  color: black;
  font-family: "Microsoft YaHei";
}
</style>
# 如何使用github

## 一、配置本地的ssh
+ **1、生成新的ssh**
  
    ```c
        ssh-keygen -t ed25519 -C "your_email@example.com"
        ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
+ **2. 启动 SSH 代理并添加 SSH 密钥**
  
    ``` python
        1、gitbash中使用，启动代理服务器
            输入：eval "$(ssh-agent -s)"
            输出：Agent pid 1234
        2、添加(根据密码类型选择添加)
            ssh-add ~/.ssh/id_ed25519
            ssh-add ~/.ssh/id_rsa    
    ```
+ **3.配置公钥到服务器**
    ```python 
        本地复制公钥：
            cat ~/.ssh/id_ed25519.pub
            cat ~/.ssh/id_rsa.pub
        GitHub
            登录到 GitHub。
            进入 Settings。
            在左侧菜单中选择 SSH and GPG keys。
            点击 New SSH key。
            将复制的公钥内容粘贴到 Key 字段，并给它取一个描述性的标题。
            点击 Add SSH key。
    ```
+ **4.测试SSH**
    ```bash 
        输入：ssh -T git@github.com
        输出：Hi your-username! You've successfully authenticated, but GitHub does not provide shell access.
        成功


    ```
## 二、开始第一个项目
### 2.1：  小白git
>*小白git不用考虑很复杂的问题，就是上传，下拉，以下为一般步骤。*
+ **1、克隆远程仓库**
  ```bash
    git clone git@github.com:your-username/your-repo.git
  ```
+ **2、添加和提交更改**
  
    ```bash
        git add .
        git commit -m "Your commit message"
    ```
+ **3、推送更改到远程仓库**
    ```bash
        git push origin main
    ```
### 2.2： 老手git
>*小白进化为老手，只需要注意以下几点。*
+ **1、拉取远程仓库的最新更改(修改之前先更新)**
  ```bash
    git fetch origin
    git pull origin main
    ```

+ **2、对origin的操作**
  + *2.1. 克隆新的仓库时设置 origin*
    ```bash
        git clone git@github.com:your-username/your-repo.git
    ```
  + *2.2. 查看当前的 origin*
    ```bash
        git remote -v
    ```
  + *2.3. 添加或更改 origin*
    ```bash
    添加： git remote add origin git@github.com:your-username/your-repo.git

    更改： git remote set-url origin git@github.com:your-username/your-repo.git
    ```
  + *2.4. 删除 origin*
    ```bash
    git remote remove origin
    ```
  + 2.5*验证更新*
  ```bash
      git fetch origin
      git log origin/main
  ```
+ **3、对branch的操作**
    + *3.1、查看所有本地分支*
    ```bash
        git branch
    ```
    + *3.2、查看所有远程分支*
    ```bash
        git branch -r
    ```
    + *3.3、查看所有远程分支和本地*
    ```bash
        git branch -a
    ```
    
    + *3.4、创建和切换分支*
    ```bash
        创建： git checkout -b new-branch
        切换： git checkout branch-name
    ```
    + *3.5、删除本地分支*
    ```bash
        普通： git branch -d branch-name
        强制(对于未合并)： git branch -D branch-name
    ```
    + *3.6、删除远程分支*
    ```bash
        git push origin --delete branch-name
    ```

    + *3.7、合并分支*
    ```bash
        (将new-branch合并到当前分支)  git merge new-branch
    ```


    + *3.8、重命名分支*
    ```bash
        (在分支上)  git branch -m new-branch-name
        (不在分支上)  git branch -m old-branch-name new-branch-name

    ```
    + *3.9、推送分支到远程仓库*
    ```bash
        git push origin new-branch
     ```
    

## 常见问题
+ **明明服务器已经把分支删除了，本地获取分支还是有**
  > git fetch -p     (*获取最新的远程信息并清理*)
+ 
