# 实验2-1 - 了解 Git Flow 和 GitHub Flow 分支协作模式

| #    | Author                 | Revision       | Date     |
| ---- | ---------------------- | -------------- | -------- |
| 1    | yuesheng@microsoft.com | Initialization | 2022-6-15 |
| 2    |                        |                |          |


## 实验概述

- 了解 Git Flow 和 GitHub Flow

## 前提条件

- GitHub account


## 实验一

### GitHub Flow
Git Flow 流程主要是围绕"发布"而设计的。而 GitHub 没有这种"发布"，而是每天都部署到生产环境，通常每天部署几次，因而使用更简单的 Git 工作流。

那么，什么是GitHub Flow？

- master/main 分支中的内容都是可部署的
- 要增加新内容时，从master/main分支中创建一个具有描述性命名的分支
- 在本地提交(commit)到该分支，并定期将工作推送到服务器上的同一命名分支
- 当您需要反馈或帮助，或者您认为分支已准备好合并时，提交合并请求(Pull Request)
- 在其他人审阅并签署该功能后，您可以将其合并到 master/main 中
- 一旦它被合并并推送到“master”，你可以且应该立即部署

![GitHub Flow](./.image/21lab/github-flow.jpg)*Figure 1 - GitHub Flow*

使用Git Flow的前提包括：团队规模最好控制在15-20人之内，且部署作业完全自动化，以满足高频部署。

对于每天都在发布生产，不断测试和部署的团队可以选择 GitHub Flow 简单的流程。对于必须以较长时间的时间间隔（如几周到几个月）进行正式发布，并且能够进行热修复和维护分支等可以选择Git Flow。

### Git Flow

在 Git Flow 中，有两个分支会贯彻整个流程始终，绝对不会被删除。

- master/main 分支
  
  该分支时常保持着可以正常运行的状态，不允许开发者直接对 master/main 分支的代码进行修改和提交。其他分支的开发工作进展到可以发布的程度后，将会与master分支进行合并，并且这一合并只在发布成品时进行。发布时将会附加版本编号的Git标签。

- develop 分支
  
  该分支是开发过程中的中心分支。与 master/main 分支一样，不允许开发者直接进行修改和提交。开发人员要以 develop 分支为起点新建 feature 分支，在 feature 分支中进行新功能的开发或者代码的修正。develop 分支保持开发过程中的最新代码，以便创建feature分支进行自己的工作。

与2个主要分支不同，以下这些分支的生命周期总是有限的，用于帮助团队成员之间的并行开发，简化功能跟踪，为生产版本做准备，并协助快速修复实时生产问题。

- Feature 分支
  
  用于为即将发布或将来的版本开发新功能。从 develop 创建，且必须合并回 develop。
- Release 分支
  
  用于支持新生产版本的准备。从 develop 分支创建，必须合并回 develop 和 master/main。运用分支命名约定例如：release-*
- Hotfix 分支
  
  用于必须立即解决生产版本中的关键错误。从 master/main 分支创建，必须合并回 develop 和 master/main。运用分支命名约定例如：hotfix-*


![Git Flow](./.image/21lab/git-flow.png)*Figure 2 - Git Flow*


## 参考资料

[[1]. GitHub flow - GitHub Docs](https://docs.github.com/en/get-started/quickstart/github-flow)

[[2]. GitHub flow Image credit](https://www.nicoespeon.com/en/2013/08/which-git-workflow-for-my-project/#the-github-flow)

[[3]. Git flow Image credit](https://nvie.com/posts/a-successful-git-branching-model)


