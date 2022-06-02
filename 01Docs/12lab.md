# 1-2 - 了解Bicep, 实现Infrastructure as Code (IaS)

## 1. 实验概述

- 实现使用Bicep创建一个KeyVault 和存储账号StorageAccount，并在KeyVault中保存访问Key
- 了解如何使用VS Code编写Bicep
- 了解Bicep官方文档
- 了解如何从JSON ARM中反向获取Bicep



## 2. 前提条件

- Azure账号及订阅
- Resource Group 及SPN （resource group contributor)
- VS Code & 插件 Bicep 
- AZ CLI
  - 下载及安装 [How to install the Azure CLI | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)



## 3. 实验一

>目标: 
>
>​        使用Bicep部署Azure Storage Account 和Key Vault
>
>​        并且将Storage Account的Key和SAS保存到KeyVault中

### a.  进入根目录C:\Code\DataOpsStarter\

​	      使用**VS Code**打开根目录"C:\Code\DataOpsStarter\ ; 

### b.  新建 12lab\storage-account.bicep

​		  新建子目录**12lab**， 在**12lab**下新建空文本文件**storage-account.bicep**； 并将如下内容拷贝到文件中：

~~~json
param location string = resourceGroup().location
param env string = 'dev'
param familyName string='hh101'                                 // replace: 

param storageAccountName string = 'storage${familyName}${env}'
param containerName string = 'src-data'
param keyvaultName string = 'kv-${familyName}-${env}'
param exp_unix_time int = 1716776048 // 2024-5-17

param tenantId string = 'efa728a8-****-****-9e56-d8ce0bdc90da'  // replace: tenantId
param spn_id  string = '7da72d5b-****-****-b44d-277ff74d5830' // replace: spn object id
param adminId string= '679e0424-****-****-807a-a1a94edc55a0'  // replace: admin user objectId

param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'		// replace: 
  project: 'dataops-starter-lab'
}

 
// keyvault and access policy
resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyvaultName
  location: location
  tags:tags 
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    enableRbacAuthorization: false
    accessPolicies: [
       {
          tenantId: tenantId 
          objectId: spn_id
          permissions:{
            secrets:[
              'get'
              'list'
              'set'
            ]
          }
       }
       {
          tenantId: tenantId
          objectId: adminId
          permissions:{
            secrets:[
              'get'
              'list'
              'set'
              'delete'
            ]
            keys:[
              'get'
              'list'
              'update'
              'create'
              'delete'
            ]
            certificates:[
              'get'
              'list'
              'delete'
              'update'
              'create'
            ]
          }
        }
    ]
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    publicNetworkAccess: 'Enabled'
    enableSoftDelete: false
    softDeleteRetentionInDays: 90
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
      ipRules: []
      virtualNetworkRules: []
  }
  }
  dependsOn: []
}


// storage account for ADLS GEN2
resource storageAccount_resource 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  tags:tags
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }

  // container named src-data
  resource blob_resource 'blobServices' = {
    name: 'default'
    resource blob_container_resource 'containers' = {
      name: containerName
      properties: {
        publicAccess: 'None'
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride:false
        immutableStorageWithVersioning:{
          enabled: false
        }
      }
    }
  }
}
 
 
resource keyVaultSecret1 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyvault_resource
  name: 'secret-storage-key'
  properties: {
    value: storageAccount_resource.listKeys().keys[0].value
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}

resource keyVaultSecret2 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyvault_resource
  name: 'secret-storage-sas'
  properties: {
    value: listAccountSAS(storageAccount_resource.name, '2021-09-01', {
      signedProtocol: 'https'
      signedResourceTypes: 'sco'
      signedPermission: 'rl'
      signedServices: 'b'
      signedExpiry: '2022-12-01T00:00:00Z'
    }).accountSasToken
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}



~~~

​          注意， 需要将相关参数替换成你自己的value。

​      	上述文件将创建一个KeyVault资源， 一个Storage BLob资源（含一个名为**src-data**的container)， 并将StorageAccount的Key, 一个为期约半年的SAS保存到了KeyVault中。

| #    | 资源                    | 说明                                                         |
| ---- | ----------------------- | ------------------------------------------------------------ |
| 1    | keyvault_resource       | Key Vault 资源                                               |
| 2    | storageAccount_resource | Storage Account资源                                          |
| 3    | blob_resource           | Blob 资源， 在Storage Account资源内部                        |
| 4    | keyVaultSecret1         | Blob的访问key, 保存到KeyVault Secret中： **secret-storage-key** |
| 5    | keyVaultSecret2         | Blob的访问SAS, 保存到KeyVault Secret中： **secret-storage-sas** |



### c.  使用AZ-CLI登录

~~~cmd
az bicep install && az bicep upgrade        # 确保安装了bicep 模块

az login					# 登录。 使用AdminUser账号

az account set --subscription {your subscription ID}  # 选择订阅

az configure --defaults group=rg-dataops-starter  # 设置默认资源组； 如果不设默认， 则后面每个命令需要单独指定一次。
~~~



### d. 运行Bicep

~~~cmd
# 进入工作区目录
cd C:\Code\DataOpsStart\12lab
# 部署Bicep 文件
az deployment group create --template-file storage-account.bicep
~~~

你也可用在后面添加指定参数来覆盖文件中默认的参数

~~~cmd
--parameters env=sit familyName=abc100 ......
~~~



### e. 观察结果

通过上面的步骤， 首先我们可以看到在Azure 的Portal中， 资源组**rg-dataops-starter**下新增加了两个资源：

- KeyVault : kv-hh101-dev
- Storage Account : storagehh101dev

并且每个资源都有3个tags：

* env: 'dev'
* owner: 'harveyhu@microsoft.com'	
* project: 'dataops-starter-lab'

打开KeyVault 资源， 可用看到新增加的Secrets

* secret-storage-key
* secret-storage-sas

以及在Access Policy 下adminuser 和 github_cicd_spn的不同访问权限的设置。 

 

## 4. 实验二

>目标: 
>
>​        尝试将ARM模板反向编译成bicep文件
>
>

### a. 导出ARM模板

Portal中打开Storage Account资源， 点击左侧菜单Automation->Export Template

![image-20220601120403490](.\12lab\exportTemplate.png)

将JSON格式的ARM 文件导出到本地**~\12Lab**目录中，并保存名为 storageARM.json

### b. 反向工程Bicep文件

在 **~\12Lab**目录中运行

~~~cmd
az bicep decompile --file storageARM.json
~~~

将会自动产生一个 **storageARM.bicep** 文件。 

不过这个文件建议不要直接拿来用， 需要重构并且做参数化处理。具体过程请参考Bicep文档。



## 5. 参考资料

[[1]. MSDOC learn-bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep)

[[2]. fundamentals-bicep](https://docs.microsoft.com/en-us/learn/paths/fundamentals-bicep/)

[[3]. 使用 Bicep 和 GitHub Actions 部署 Azure 资源](https://docs.microsoft.com/en-us/learn/paths/bicep-github-actions/)

[[4]. Bicep Deployment Examples](https://github.com/Azure/bicep/tree/main/docs/examples)

[[5]. Decompile ARM template JSON to Bicep - Azure Resource Manager | Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/decompile?tabs=azure-cli)

