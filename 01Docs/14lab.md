# 实验1-4 - 了解ADF数据流水线

| #    | Author                 | Revision       | Date     |
| ---- | ---------------------- | -------------- | -------- |
| 1    | HarveyHu@microsoft.com | Initialization | 2022-6-2 |
| 2    |                        |                |          |





[TOC]



## 1. 实验概述

- 创建2个环境ADF资源，第一个配置Git repo; 配置ADF访问存储账号和数据的权限
- 创建ADF数据流水线, 实现将Blob数据复制到数据库
- 通过publish->CI->artifacts->CD的过程， 将ADF发布到下一环境



## 2. 前提条件

- Azure账号及订阅
- VS Code & 插件 Bicep 
- AZ CLI
  - 下载及安装 [How to install the Azure CLI | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)



## 3. 实验一

> 目标：
>
> ​      创建2个环境的ADF资源， 一个dev, 一个sit
>
> ​      在dev设计一个Pipeline， 然后Publish; CICD发布到sit环境
>
> ​      观察ADF绑定的git repo 分支的内容， 包括main 和 adf_publish 分支

### a.  进入根目录C:\Code\DataOpsStarter\

​	      使用**VS Code**打开根目录"C:\Code\DataOpsStarter\ ; 

### b. 准备创建ADF资源的Bicep

​		 创建目录**\14lab\\** , 新建文件 **\14lab\adf.bicep**

~~~json
param familyName string = 'hh101'
param env string='dev'
param location string= resourceGroup().location
param name string = 'adf-${familyName}-${env}'

// github repo
param repo_accountName string ='HarveyHuBJ'              // replace
param repo_repositoryName string ='MsDataOpsStarter'	 // replace
param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'	 // replace
  project: 'dataops-starter-lab'
}

// only bind git repo on 'dev' environment
var repoConfiguration= {
  type: 'FactoryGitHubConfiguration'
  accountName: repo_accountName
  repositoryName: repo_repositoryName
  collaborationBranch: 'main'
  rootFolder: '/14lab/ADF'
}

resource datafactories_resource 'Microsoft.DataFactory/factories@2018-06-01' =   {
  name: name
  location: location
  tags:tags
  properties: {
    publicNetworkAccess: 'Enabled'
    repoConfiguration: repoConfiguration:  // comment this line when not 'dev' environment
  }
  identity:{
    type: 'SystemAssigned'
  }

}

resource adf_vnet_resource 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' =   {
  parent: datafactories_resource
  name: 'default'
  properties: {}
}

resource adf_integration_runtimes 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' =  {
  parent: datafactories_resource
  name: 'AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    managedVirtualNetwork: {
      referenceName: 'default'
      type: 'ManagedVirtualNetworkReference'
    }
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
  dependsOn: [
    adf_vnet
  ]
}

~~~

​		ADF的内容将会与 '**/14lab/ADF**' 保持同步 , ADF的发布分支默认是adf_publish branch。

| #    | 资源                     | 说明                   |
| ---- | ------------------------ | ---------------------- |
| 1    | datafactories_resource   | 数据工厂实例资源       |
| 2    | adf_vnet_resource        | 数据工厂的默认网络实例 |
| 3    | adf_integration_runtimes | 数据工厂的IR实例       |



### b.  使用AZ-CLI登录

~~~cmd
az bicep install && az bicep upgrade        # 确保安装了bicep 模块

az login					# 登录。 使用AdminUser账号

az account set --subscription {your subscription ID}  # 选择订阅

az configure --defaults group=rg-dataops-starter  # 设置默认资源组； 如果不设默认， 则后面每个命令需要单独指定一次。
~~~



### c. 运行Bicep, 创建dev环境的ADF, 并绑定github repo

~~~cmd
# 进入工作区目录
cd C:\Code\DataOpsStarter\14lab
# 部署Bicep 文件
az deployment group create --template-file adf.bicep --parameters env=dev
~~~



### d. 运行Bicep, 创建SIT环境的ADF, 该环境不绑定任何git repo

​	需要把adf.bicep中的一行注释掉： `// repoConfiguration:repoConfiguration`

~~~cmd
# 进入工作区目录
cd C:\Code\DataOpsStarter\14lab
# 部署Bicep 文件
az deployment group create --template-file adf.bicep --parameters env=sit
~~~



### * e. 打开ADF（dev)，按提示完成git repo的账号验证。 

​		然后将main分支内容同步到ADF。 

​        新建一个Pipeline， 并保存提交。 

​        相关代码会提交到github的代码repo中。

​        创建Pipeline的过程，可以参考：

[Use the Azure portal to create a data factory pipeline - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-copy-data-portal#create-a-pipeline)

 

 ### f.  本地同步ADF代码， 并查看新建Pipeline的代码

 ~~~cmd
 cd C:\Code\DataOpsStarter\14lab\ADF
 
 git pull
 ~~~

​        可以看到新建的pipeline是一个JSON格式的文件。

### g. 打开ADF(dev), 点击publish

​        **publish** 操作会将ADF的内容build成一个ARM template， 并同步到adf_publish 分支中； **并且这个分支与main分支内容无关**。 

​        我们可以打开这个分支看看内容：

~~~cmd

cd C:\Code\
# 新Clone 分支adf_publish到目录 DataOpsStarterADF
git clone -b adf_publish https://github.com/{yourOrg}/{yourRepo}.git MsDataOpsStarterADF
~~~

可以观察里面的内容包括：

~~~cmd
adf-hh101-dev\
 ARMTemplateForFactory.json
 ARMTemplateParametersForFactory.json
 globalParameters       <dir>
 linkedTemplates        <dir>
~~~

其中包括ARM的模板文件和参数文件。 



## 4. 实验二

> 目标： 
>
> ​      使用git workflow 将dev环境的ADF发布到SIT环境

### a.  进入根目录C:\Code\DataOpsStarterADF\

​	      使用**VS Code**打开根目录**C:\Code\DataOpsStarterADF\ ;** 

~~~cmd
cd C:\Code\MsDataOpsStarterADF

md .github\workflows
cd .github\workflows
~~~

​       注意， 这是在**adf_publish** 分支下的代码目录。

### b. 新建CI workflow

​		在\\.github\workflow目录下，新建文件lab14-CI-ADF.yml, 内容如下：

~~~yaml
name: 14lab-CI-ADF

on:
  push:
    branches:
      - "adf_publish"
  workflow_dispatch:
  workflow_call:

env:
  ARTIFACT_NAME: adf_arm_template
  ADF_FOLDER: adf-hh101-dev    ## Your ADF instance name

jobs:
  build-adf:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          ref: adf_publish

#### Copy to Artifact Folder, and add readme.txt
      - name: Copy to Artifact Folder
        run: |
          mkdir -p ./artifacts/ci-run/${{github.RUN_NUMBER}}/ 
          cp -r ./${{ADF_FOLDER}}/* ./artifacts/
          echo 'ci-run:${{github.RUN_NUMBER}}'> ./artifacts/readme.txt

#### Upload Artifact
      - name: Upload Artifact
        uses: actions/upload-artifact@v3
        with:
          name: ${{env.ARTIFACT_NAME}}
          path: ./artifacts/


~~~

​        上述CI的过程， 是将ADF的ARM JSON 相关内容上传到Artifact中。

​        使用到的Actions 包括:

| #    | Action                     | 说明                                                         |
| ---- | -------------------------- | ------------------------------------------------------------ |
| 1    | actions/checkout@v3        | 从git repo的**分支adf_publish**签出代码                      |
| 2    | Bash                       | 复制准备artifacts文件， 并就run_number保存到readme.txt文件中 |
| 3    | actions/upload-artifact@v3 | 上传artifact                                                 |



### c. 新建CD workflow

​      在\\.github\workflow目录下，新建文件lab14-CD-ADF.yml, 内容如下：

~~~yaml
name: 14lab-CD-ADF

on:
  # workflow_run:
  #   workflows: [CI-02-ADF]
  #   types:
  #     - completed

  workflow_dispatch:
  workflow_call:
  # push:
  #   branches:
  #     - "main"
env:
  FAMILY_NAME: hh101 
  ENV_NAME: sit 
  ARTIFACT_NAME: adf_arm_template
  RESOURCE_GROUP_NAME: rg-dataops-starter
  DATA_FACTORY_NAME: adf-hh101-sit
  ARM_FILE_NAME: ARMTemplateForFactory.json
  ARM_PARAMETER_FILE_NAME: ARMTemplateParametersForFactory.json
 
jobs:
  publish-adf:
    runs-on: ubuntu-latest

    steps:
#### Download Artifact
      - name: Download artifact from CI
        uses: aochmann/actions-download-artifact@1.0.4
        with:
          repo: HarveyHuBJ/MsDataOpsStarter
          github_token: ${{ secrets.GITHUB_TOKEN }}
          name: ${{ env.ARTIFACT_NAME }}
          path: .

#### Azure login 
      - uses: azure/login@v1                            # Azure login required to add a temporary firewall rule
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
          enable-AzPSSession: true                      # or error: Run Connect-AzAccount to login
 #### Deploy Data Factory         
      - name: Deploy Data Factory
        uses: Azure/data-factory-deploy-action@v1.2.0
        with:
          resourceGroupName: ${{ env.RESOURCE_GROUP_NAME }}
          dataFactoryName: ${{ env.DATA_FACTORY_NAME }}
          armTemplateFile: ./ArmTemplateOutput/${{ env.ARM_FILE_NAME }}
          armTemplateParametersFile: ./ArmTemplateOutput/${{ env.ARM_PARAMETER_FILE_NAME }}
          


~~~

​                使用到的Actions 包括:

| #    | Action                                   | 说明                                                         |
| ---- | ---------------------------------------- | ------------------------------------------------------------ |
| 1    | aochmann/actions-download-artifact@1.0.4 | 从git repo的**分支adf_publish**签出代码                      |
| 2    | azure/login@v1                           | 使用SPN登录Azure， 务必enable-AzPSSession: true              |
| 3    | Azure/data-factory-deploy-action@v1.2.0  | 发布ADF 的ARMTemplate. <br />该Action 默认包含了prepost的行为，包括事前关闭triggers， 事后重新启动triggers |

### d. 运行 CI CD workflows 并观察结果

分别运行CI 和CD workflows。

CI 运行完成后， 在Summary页会有Artifact： adf_arm_template

CD 完成后， SIT的ADF中会出现与DEV相同的内容。



## 4. 参考资料

[[1]. Continuous integration and delivery - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery)

[[2]. Automated publishing for continuous integration and delivery - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery-improvements)

[[3]. Use the Azure portal to create a data factory pipeline - Azure Data Factory | Microsoft Docs](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-copy-data-portal#create-a-pipeline)

