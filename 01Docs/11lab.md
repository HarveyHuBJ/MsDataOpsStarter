# 实验1-1 - 了解Github Workflow and Action 



## 1. 实验概述

* 实现在GitHub Action 中输出Hello world
* 了解如何从Github Action Marketplace中查询




## 2. 前提条件

- Github账号



## 3. 实验一

>目标：
>
>​	使用Github workflow， 执行输出`Hello world`；

### a. 登录http://github.com；

### b. 新建repo, 名称如 "DataOpsStarter"；并同步到本地

​		在C:\盘根目录下新建文件夹Code, 然后打开命令行窗口， 对repo进行clone:

~~~cmd
cd c:\Code

git clone https://github.com/{YourOrg}/{YourRepo, like DataOpsStarter}
~~~

​         也可尝试加上PAT

~~~cmd
git clone https://{your PAT}@github.com/{YourOrg}/{YourRepo, like DataOpsStarter}
~~~

​	 	其中， ’your PAT ‘ 获取自GITHub 个人账户下， 开发者设置中。 相关方法可用参考：

[Creating a personal access token - GitHub Docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

### c. 打开Action页， 选择新建；

### d. 浏览Marketplace， 并尝试search； 不过先不做任何选择；

### e. 选择从空的模板新建（在线编辑）；

###  f. 将下面代码复制到在线文件中，并将代码提交到repo；

~~~yml
# This is a basic workflow to help you get started with Actions

name: blank demo - Hello world

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  # push:
  #  branches: [ main ]
  # pull_request:
  #  branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v3

      # Runs a single command using the runners shell
      - name: Run a one-line script
        run: echo Hello, world! 

      # Runs a set of commands using the runners shell
      - name: Run a multi-line script
        run: |
          echo Add other actions to build,
          echo test, and deploy your project.
          echo CI-GITHUB_RUN_NUMBER= $GITHUB_RUN_NUMBER
          echo GITHUB_RUN_ID=$GITHUB_RUN_ID 
          echo action is: $GITHUB_ACTION

~~~



### g. 打开Action页， 选择刚才的workflow，并观察结果



## 4. 参考资料

### [a. Using workflows - GitHub Docs](https://docs.github.com/en/actions/using-workflows)

### [b. Using starter workflows - GitHub Docs](https://docs.github.com/en/actions/using-workflows/using-starter-workflows)
