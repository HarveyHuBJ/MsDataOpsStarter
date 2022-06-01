# DataOps-Starter Overview

## 背景

TODO



## 目标

通过一系列的动手实验， 帮助学员掌握在项目中实施DataOps的路径， 包括相关产品和技术手段。 

但不包括： 

* 产品深度介绍， 例如GitHub, Synapse等
* 数据分析深度介绍
* 安全措施深度介绍



## 提前准备

* Azure 账号及一个可用的订阅

* 一个ResourceGroup（name : rg-dataops-starter)

* 一个AAD User (name : adminuser@yourdomain.com)， 作为  subscription 的Owner

* 一个SPN （name: github-cicd-spn) , 作为  rg-dataops-starter 的contributor

  

  记录如下信息：

| 信息：             | 示例：                               | 说明：                                                       |
| ------------------ | ------------------------------------ | ------------------------------------------------------------ |
| **TenantID**       | efa728a8-8af1-45bd-9e56-d8ce0bdc90da | 在**AAD Overview**页面可用看到                               |
| **SubscriptionID** | f79d0fce-39b1-4498-9c2e-18a27eaa8054 | 从任意资源的url中可用看到                                    |
| **SPN ObjectID**   | 7da72d5b-2ba3-45aa-b44d-277ff74d5830 | 在**AAD Enterprise Applications** 下可用找到SPN的objectID。<br />(注意不是ApplicationID) |
| **AdminID**        | 679e0424-4461-4989-807a-a1a94edc55a0 | 在AAD User Profile 页面可用看到（ Object ID)                 |
| **ResourceGroup**  | rg-dataops-starter                   | 实验过程中的所有资源都放在这个ResourceGroup 中               |



安装**Azure CLI** 后可用参考下面命令行：

~~~cmd
az login					# 登录

az account set --subscription $subscriptionID  # 选择订阅

az group create -l eastasia -n $resourceGroup  # 创建资源组

az ad sp create-for-rbac --name $servicePrincipalName --role $roleName --scopes /subscriptions/$subscriptionID/resourceGroups/$resourceGroup --sdk-auth # 创建SPN并给指定资源组设RBAC （按需替换）

-------------------------------------
# 将如下输出保存到GitHub Repo的secrets中作为 secrets.AZURE_CREDENTIALS
/*
{
    "clientId": "<GUID>",
    "clientSecret": "<GUID>",
    "subscriptionId": "<GUID>",
    "tenantId": "<GUID>",
    (...)
  }
*/
~~~



参考：

[Quickstart - Use Azure Key Vault secrets in GitHub Actions workflows | Microsoft Docs](https://docs.microsoft.com/en-us/azure/developer/github/github-key-vault#define-a-service-principal)



## 整体架构



## 步骤：

### == Level 100 ==

#### [实验1-1 - 了解Github Workflow and Action](11lab.md) 

* 实现在GitHub Action 中输出Hello world
* 了解如何从Github Action Marketplace中查询
* 了解如何使用VS Code 编写workflow

#### [实验1-2 - 了解Bicep, 实现Infrastructure as Code (IaS)](12lab.md)

* 实现使用Bicep创建一个KeyVault 和存储账号StorageAccount，并在KeyVault中保存访问Key
* 了解如何使用VS Code编写Bicep
* 了解Bicep官方文档
* 了解如何从JSON ARM中反向获取Bicep

#### [实验1-3 - 了解测试数据发布到存储Blob和AzureSQL](13lab.md)

* 实现将数据文件csv提交到git
* 通过CI->artifacts->CD的过程将数据发布到blob
* 创建数据库资源，并在KeyVault中保存连接串
* 实现将建表语句和存储过程
* 通过CI->artifacts->CD的过程， 发布数据库
* 通过CD的过程， 将blob的数据发布到数据库

#### [实验1-4 - 了解ADF数据流水线](14lab.md)

* 创建2个环境ADF资源，第一个配置Git repo; 配置ADF访问存储账号和数据的权限
* 创建ADF数据流水线, 实现将Blob数据复制到数据库
* 通过publish->CI->artifacts->CD的过程， 将ADF发布到下一环境

#### [实验1-5 - 了解Databricks](15lab.md)

* 创建2个环境Databricks资源， 第一个配置Git repo
* 第二个配置Databricks token
* 通过CI->artifacts->CD的过程， 将Notebooks发布到下一环境

#### [实验1-6 - 了解Synapse](16lab.md)

* 创建Synapse资源， 并在KeyVault中保存连接串和ADLS key
* 通过CI->artifacts->CD的过程， 发布数据仓库

#### [实验1-7 - 清理资源](17lab.md)

* 通过AZ CLI Deployment 清理资源
* 了解增量模式和完整模式

### == Level 200 ==

#### [实验2-1 - 了解GIT FLow 和 GITHub Flow 分支协作模式](21lab.md) 

* 了解Git flow和Github flow
* 了解Pull request 和分支策略(policy)
* 了解代码合并和解决冲突

#### [实验2-2 - 深入了解GitHub的Workflow](22lab.md)

* 定义action
* 了解常用的触发机制
* 了解自定义Action
* 了解组合Workflow
* 了解环境变量和secrets
* 了解“守门员” （Approver）

#### [实验2-3 - Bicep进阶](23lab.md)

* 了解模块引用机制
* 了解依赖和引用已有资源
* 了解循环和条件判断

#### [实验2-4 - ADF 进阶](24lab.md) 	

* 参数化LinkService, DataSet, Pipleline
* FlagFeature Pipeline
* Metadata driven
* Copy活动的并行优化
* Pipeline组合调用

#### [实验2-5 - SoTa测试框架应用](25lab.md)

*  部署ADF + Synapse + DB， 包括schema
*  上传测试用例
*  执行测试用例
*  查看测试结果

#### [实验2-6 - 持续质量Continuous Quality ](26lab.md)

* 了解Unit Test 框架之一 （pytest, nunit, vstest)
* 了解GreatExpection
* 了解[PR-CI] + [QA-CI] + [Fast-CI]

#### [实验2-7 - Synapse进阶 ](27lab.md) 

* 了解单库拆分
* 了解Synapse的Polybase (External Table， Copy into)
* 了解Distribution和Index
* 了解SKEW检查
* 了解性能查询手段

#### [实验2-8 - Databricks 进阶](28lab.md)

* 发布Libs
* ...

#### [实验2-9 - 混合云部署数据平台](29lab.md)

* 了解混合云部署架构
* .....

### == Level 300 ==

#### [实验3-1 - 持续监控和反馈](31lab.md)

* 了解ELK监控体系
* 了解Azure Monitor体系

#### [实验3-2 - Synapse的数据血缘分析](32lab.md)

* 了解DacFx 和 antlr， 了解抽象语法树（AST)
* 了解图数据库，了解Neo4j
* 了解血缘结果展示

#### [实验3-3 - 数据治理进阶](33lab.md)

* 部署Purview
* 了解数据资产， 管理数据资产
* 上传数据血缘关系
* 了解数据分类 + 自定义规则
* 了解数据洞察

#### [实验3-4 - 数据反哺流水线](34lab.md)

* 了解数据脱敏
* 了解数据反哺流水线过程

#### [实验3-5 - ML数据及版本管理](35lab.md)

* 了解Databricks的ML flow
* ...
