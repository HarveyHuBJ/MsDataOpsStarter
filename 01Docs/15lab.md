# # 1-5 - 了解Databricks

## 1. 实验概述

- 创建2个环境Databricks资源， 第一个配置Git repo
- 第二个配置Databricks token
- 通过CI->artifacts->CD的过程， 将Notebooks发布到下一环境



## 2. 前提条件

- Azure账号及订阅
- VS Code & 插件 Bicep 
- AZ CLI
  - 下载及安装 [How to install the Azure CLI | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)



## 3. 实验一

> 目标：
>
> ​         创建2个Azure Databricks资源（一个dev, 一个sit)； dev 绑定git repo
>
> ​         在sit 的Databricks 获取token， 并保存到KeyVault中

### a.  进入根目录C:\Code\DataOpsStarter\

​	      使用**VS Code**打开根目录"C:\Code\DataOpsStarter\ ; 



### 4. 实验二

> 目标：
>
> ​         通过CICD的方式， 将dev Azure Databricks的git repo中的代码发布到sit的Azure Databricks中

## 5. 参考资料

