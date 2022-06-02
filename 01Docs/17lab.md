# 实验1-7 - 清理资源

| #    | Author                 | Revision       | Date     |
| ---- | ---------------------- | -------------- | -------- |
| 1    | HarveyHu@microsoft.com | Initialization | 2022-6-2 |
| 2    |                        |                |          |



[TOC]





## 1. 实验概述

- 了解如何通过Az CLI 和Bicep配合清理 Azure 资源



## 2. 前提条件

- Azure账号及订阅
- VS Code
- AZ CLI
  - 下载及安装 [How to install the Azure CLI | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)



## 3. 实验一

> 目标：
>
> ​       清理前面实验所产生的Azure资源， 避免继续产生费用

### a.  进入根目录C:\Code\DataOpsStarter\

​	      使用**VS Code**打开根目录"C:\Code\DataOpsStarter\ ; 

### b. 准备清理资源的Bicep

​		 创建目录**\17lab\\** , 新建文件 **\17lab\clean.bicep**

~~~json
// here is NOTHING
// use --mode complete in the deployment command
~~~



### c.  使用AZ-CLI登录

~~~cmd
az bicep install && az bicep upgrade        # 确保安装了bicep 模块

az login					# 登录。 使用AdminUser账号

az account set --subscription {your subscription ID}  # 选择订阅

az configure --defaults group=rg-dataops-starter  # 设置默认资源组； 如果不设默认， 则后面每个命令需要单独指定一次。
~~~



### d. 运行Bicep, 创建Synapse资源

~~~cmd
# 进入工作区目录
cd C:\Code\DataOpsStarter\17lab
# 部署Bicep 文件
az deployment group create --template-file clean.bicep --Mode Complete
~~~



默认az deployment的mode是增量模式， 所以会在现有的资源上做添加或者更新。 

如果指定的Mode是完整模式（Complete） ，则如果Bicep中没有出现的资源就会被删除。



## 4. 参考资料

[[1]. Deployment modes - Azure Resource Manager | Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes)
