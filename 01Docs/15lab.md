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

### b. 准备创建ADF资源的Bicep

​		 创建目录**\15lab\\** , 新建文件 **\15lab\databricks.bicep**

~~~json
param env string='dev'
param familyName string='hh101'
param workspaceName string='dbk-ws-${familyName}-${env}'

param keyvaultName string = 'kv-${familyName}-${env}'
param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'        //replase
  project: 'dataops-starter-lab'
}

@secure()
param databricks_token string=''   // replace with a real one
param exp_unix_time int = 1716776048 // 2024-5-17

@allowed([
  'standard'
  'premium'
])
param pricingTier string = 'standard'

param location string = resourceGroup().location

var managedResourceGroupName = 'databricks-rg-${workspaceName}'

resource databricks_ws_resource 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: workspaceName
  location: location
  tags:tags
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: '${subscription().id}/resourceGroups/${managedResourceGroupName}'
  }
}


resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' existing={
  name: keyvaultName
}

// need update when token generated!!!
resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if (databricks_token != ''){
  parent: keyvault_resource
  name: 'secret-databricks-token'
  properties: {
    value:  databricks_token
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}

~~~

上述文件将创建一个databricks资源， 并将databricks_token保存到key vault的secrets中



| #    | 资源                   | 说明                                                         |
| ---- | ---------------------- | ------------------------------------------------------------ |
| 1    | databricks_ws_resource | 一个Databricks的workspace,  包含一个自托管的资源组。         |
| 2    | keyVaultSecret         | 将databricks_token 保存到Key Vault的Secrets中： secret-databricks-token |

需要注意的是， 这个token 无法预置， 也无法自动生成。 dev环境不需要， SIT环境需要。

需要在Databricks Workspace建好后， 手动在设置页中生成一个， 然后填补到Bicep的变量值位置； 最后再重新运行Bicep， 将其保存到Key Vault中。 

关于Token的生成， 请参考：

[Manage personal access tokens - Azure Databricks | Microsoft Docs](https://docs.microsoft.com/en-us/azure/databricks/administration-guide/access-control/tokens#--enable-or-disable-token-based-authentication-for-the-workspace)

| 请记录: | databricks_token | dapi\*\*\*\*c4a537bfe2ad44e\*\*\*\*925848ef0 |
| ------- | ---------------- | -------------------------------------------- |

### c.  使用AZ-CLI登录

~~~cmd
az bicep install && az bicep upgrade        # 确保安装了bicep 模块

az login					# 登录。 使用AdminUser账号

az account set --subscription {your subscription ID}  # 选择订阅

az configure --defaults group=rg-dataops-starter  # 设置默认资源组； 如果不设默认， 则后面每个命令需要单独指定一次。
~~~



### d. 运行Bicep, 创建dev环境实例

~~~cmd
# 进入工作区目录
cd C:\Code\DataOpsStart\15lab
# 部署Bicep 文件
az deployment group create --template-file databricks.bicep --parameters env=dev
~~~

 

### e. 打开dev环境的Databricks 实例， 设置git Repo。

设置git Repo的过程请参考：

[用于 Git 集成的 Repos - Azure Databricks | Microsoft Docs](https://docs.microsoft.com/zh-cn/azure/databricks/repos/#--configure-your-git-integration-with-azure-databricks)

然后打开Repo, 向其中添加一些notebooks （15lab\notebooks\*）, 并提交到github的代码仓库中。 

### f. 运行Bicep, 创建SIT环境实例

~~~cmd
# 进入工作区目录
cd C:\Code\DataOpsStart\15lab
# 部署Bicep 文件
az deployment group create --template-file databricks.bicep --parameters env=sit
~~~

 参考上面提到的方法， 获取到databricks_token后， 再运行一次部署

~~~cmd
az deployment group create --template-file databricks.bicep --parameters env=sit databricks_token={your token}
~~~



### g. 观察效果

在资源组中， 将出现2个 databricks的实例。

其中dev的databricks实例, 我们向其中添加了一些notebooks, 同时可以在git repo中看到。



### 4. 实验二

> 目标：
>
> ​         通过CICD的方式， 将dev Azure Databricks的git repo中的代码发布到sit的Azure Databricks中



### a.  进入根目录C:\Code\DataOpsStarter\

​	      使用**VS Code**打开根目录"C:\Code\DataOpsStarter\ ; 

### b. 新建CI workflow

​		在\\.github\workflow目录下，新建文件lab15-CI-Databricks.yml, 内容如下：

~~~yaml
name: lab15-CI-Databricks

on:
  # push:
  #   branches:
  #     - "main"
  workflow_dispatch:
  workflow_call:

env:
  ARTIFACT_NAME: az_databricks_artifact
  DATABRICKS_FOLDER: 15lab\notebooks

jobs:
  build-adf:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

#### Copy to Artifact Folder, and add readme.txt
      - name: Copy to Artifact Folder
        run: |
          mkdir -p ./artifacts/ci-run/${{github.RUN_NUMBER}}/ 
          cp -r ./${{env.DATABRICKS_FOLDER}}/* ./artifacts/
          echo 'ci-run:${{github.RUN_NUMBER}}'> ./artifacts/readme.txt

#### Upload Artifact
      - name: Upload Artifact
        uses: actions/upload-artifact@v3
        with:
          name: ${{env.ARTIFACT_NAME}}
          path: ./artifacts/


~~~

上面的过程， 将把notebooks上传到Repo的Artifacts中

| #    | actions                    | 说明                                                         |
| ---- | -------------------------- | ------------------------------------------------------------ |
| 1    | actions/checkout@v3        | 签出代码                                                     |
| 2    | bash : run cp              | 复制文件到artifacts目录， 并记录RUN_NUMBER在readme.txt文件中 |
| 3    | actions/upload-artifact@v3 | 将artifacts 内容上传到Repo的Artifacts中                      |

### c. 新建CD workflow

在\\.github\workflow目录下，新建文件lab15-CD-Databricks.yml, 内容如下：

~~~yaml
name: lab15-CD-Databricks

on:
  workflow_run:
    workflows: [lab15-CI-Databricks]
    types:
      - completed

  workflow_dispatch:
  workflow_call:
  # push:
  #   branches:
  #     - "main"
env:
  FAMILY_NAME: hh101 
  ENV_NAME: sit 
  KEY_VAULT: kv-hh101-dev
  ARTIFACT_NAME: az_databricks_artifact
  RESOURCE_GROUP_NAME: rg-dataops-starter
  DATABRICKS_HOST: https://adb-6136766911067460.0.azuredatabricks.net/
  LOCAL_NOTEBOOKS_PATH: ./dist                                            # used in step databricks-import-directory
  REMOTE_NOTEBOOK_PATH: /Users/adminuser@cpuhackthon.onmicrosoft.com/src  # used in step databricks-import-directory
# Get-AzDataFactoryV2Trigger -ResourceGroupName rg-dataops-starter -DataFactoryName adf-hh101-dev
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
          path: ${{env.LOCAL_NOTEBOOKS_PATH}}

##### install databricks CLI
      - name: install-databricks-cli
        uses: microsoft/install-databricks-cli@main

#### az login to access key vault 
      - name: az login with github_dataops_spn
        uses: azure/login@v1                            # github_dataops_spn
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
#### retrieve databricks token
      - uses: Azure/get-keyvault-secrets@v1
        id: getSecretAction # ID for secrets that you will reference
        name: retrieve databricks token
        with:
          keyvault: ${{env.KEY_VAULT}} # name of key vault in Azure portal
          secrets: 'secret-databricks-token'  # comma separated list of secret keys to fetch from key vault 


# #### databricks-import-directory
      - name: databricks-import-directory
        run: | 
          echo "Uploading notebooks from $LOCAL_NOTEBOOKS_PATH to $REMOTE_NOTEBOOK_PATH in the workspace $DATABRICKS_HOST"
          databricks workspace import_dir --overwrite "${LOCAL_NOTEBOOKS_PATH}" "${REMOTE_NOTEBOOK_PATH}" --debug
        shell: bash
        env:
          DATABRICKS_TOKEN:   ${{steps.getSecretAction.outputs.secret-databricks-token}}  

 


~~~

上述过程， 将把artifacts 中的Notebooks发布到SIT环境Workspace中指定用户的目录下。

| #    | Actions                                  | 说明                                      |
| ---- | ---------------------------------------- | ----------------------------------------- |
| 1    | aochmann/actions-download-artifact@1.0.4 | 获取Repo Artifacts                        |
| 2    | install-databricks-cli                   | 安装Databricks CLI                        |
| 3    | azure/login@v1                           | 使用SPN 登录Azure                         |
| 4    | Azure/get-keyvault-secrets@v1            | 获取KeyVault中保存的Databricks Token      |
| 5    | bash: run databricks CLI                 | 上传Notebooks到Databricks工作区的指定路径 |

### d. 运行CICD Workflows 并观察效果

CI 完成后， 会在Summary页观察到artifact : az_databricks_artifact

CD 完成后， 会在Databricks(sit)实例中的指定目录下（例如/Users/adminuser@cpuhackthon.onmicrosoft.com/src ) 出现我们期望的Notebooks

## 5. 参考资料

[[1]. Manage personal access tokens - Azure Databricks | Microsoft Docs](https://docs.microsoft.com/en-us/azure/databricks/administration-guide/access-control/tokens#--enable-or-disable-token-based-authentication-for-the-workspace)

[[2]. 用于 Git 集成的 Repos - Azure Databricks | Microsoft Docs](https://docs.microsoft.com/zh-cn/azure/databricks/repos/#--configure-your-git-integration-with-azure-databricks)
