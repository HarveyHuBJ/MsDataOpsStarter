# 实验1-1 - 了解Github Workflow and Action 

| #    | Author                 | Revision       | Date     |
| ---- | ---------------------- | -------------- | -------- |
| 1    | HarveyHu@microsoft.com | Initialization | 2022-6-2 |
| 2    | yuesheng@microsoft.com |     Review     | 2022-6-6 |




## 实验概述

* 实现在GitHub Action 中输出Hello world
* 了解如何从Github Action Marketplace中查询




## 前提条件

- Github账号



## 实验一

>目标：
>
>​	了解并使用Github workflow， 执行输出`Hello world`；

1. 登录http://github.com；

2. 新建Repo, 名称如 "DataOpsStarter"

3. 在C:\盘根目录下新建文件夹Code, 打开命令行窗口，同步代码仓库到本地

    ~~~cmd
    cd c:\Code

    git clone https://github.com/{YourOrg}/{YourRepo, like DataOpsStarter}
    ~~~

    若未登录，需要加上PAT

    ~~~cmd
    git clone https://{your PAT}@github.com/{YourOrg}/{YourRepo, like DataOpsStarter}
    ~~~

    其中，`your PAT` 获取自GitHub个人账户下， 开发者设置中。相关方法可用参考：[Creating a personal access token - GitHub Docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

4. 打开Action页，选择从空的模板新建（在线编辑）

5. 将下面代码复制到在线文件中，并将代码提交到repo

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



    | #    | action              | 说明                                                         |
    | ---- | ------------------- | ------------------------------------------------------------ |
    | 1    | actions/checkout@v3 | 从main分支（默认）签出代码                                   |
    | 2    | bach : run echo     | 单行 - 向界面打印文字                                        |
    | 3    | bach : run echo     | 多行 - 向界面打印文字； 且输出一些内置变量, 例如$GITHUB_RUN_NUMBER |


7. 打开Action页， 选择刚才的workflow，启动；并观察结果

8. 再次进入Workflow编辑页面，浏览Marketplace， 可以搜索其他的Action进行尝试

## 参考资料

[[1]. Using workflows - GitHub Docs](https://docs.github.com/en/actions/using-workflows)

[[2]. Using starter workflows - GitHub Docs](https://docs.github.com/en/actions/using-workflows/using-starter-workflows)

[[3]. Contexts - GitHub Docs](https://docs.github.com/en/actions/learn-github-actions/contexts)
