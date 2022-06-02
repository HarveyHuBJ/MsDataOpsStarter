# # 1-6 - 了解Synapse

## 1. 实验概述

- 了解Bicep 以及如何编写、运行



## 2. 前提条件

- Azure账号及订阅
- VS Code & 插件 Bicep 
- Visual Studio 2019+ & SSDT 组件
- AZ CLI
  - 下载及安装 [How to install the Azure CLI | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)



## 3. 实验一

> 目标：
>
> ​         创建1个Azure Synapse资源 
>

### a.  进入根目录C:\Code\DataOpsStarter\

​	      使用**VS Code**打开根目录"C:\Code\DataOpsStarter\ ; 



### b. 准备创建Synapse资源的Bicep

​		 创建目录**\16lab\\** , 新建文件 **\16lab\synapse.bicep**

~~~json
param familyName string = 'hh101'                            // replace
param env string='dev'
param location string= resourceGroup().location
param workspaceName string = 'ws-${familyName}-${env}'

param adls_account_name string = 'storage${familyName}${env}adls'
param adls_file_system_name string = 'raw-data'

param storageKind string = 'StorageV2'

param sqlPoolName string = 'dwh_${familyName}_${env}_pool'
param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param dw_sku string = 'DW200c'
param adminId string='679e0424-4461-4989-807a-a1a94edc55a0'  // replace

param keyvaultName string = 'kv-${familyName}-${env}'
param exp_unix_time int = 1716776048 // 2024-5-17

param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'             // replace
  project: 'dataops-starter-lab'
}

var dw_admin_password = substring('Pwd0!${uniqueString(resourceGroup().id)}',0, 12)
 
resource adls_account_resource 'Microsoft.Storage/storageAccounts@2021-01-01' =   {
  name: adls_account_name
  location: location
  tags:tags
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    minimumTlsVersion: 'TLS1_2'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: storageKind 
  
}

resource adls_file_system_resource 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-01-01' =  {
  name: '${adls_account_name}/default/${adls_file_system_name}'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    adls_account_resource
  ]
}

// var defaultDataLakeStorageAccountUrl2 = adls_account_resource.properties.primaryEndpoints.web
resource synapse_workspace_resource 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaceName
  tags:tags  
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: adls_account_resource.properties.primaryEndpoints.dfs
      filesystem: adls_file_system_name
      resourceId: adls_file_system_resource.id
      createManagedPrivateEndpoint: false
    }
    
    managedVirtualNetwork: ''
    managedResourceGroupName: ''
    azureADOnlyAuthentication: false
    sqlAdministratorLogin: 'dw_admin'
    sqlAdministratorLoginPassword: dw_admin_password
    cspWorkspaceAdminProperties:{
       initialWorkspaceAdminObjectId: adminId
    }
    trustedServiceBypassEnabled:true
  }
}

resource firewall_allowAll 'Microsoft.Synapse/workspaces/firewallrules@2021-06-01' =   {
  parent: synapse_workspace_resource
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

// var sqlPool_name = '${workspaceName}/${sqlPoolName}'
resource sqlPool_resource 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  location: location
  name: sqlPoolName
  tags:tags
  parent: synapse_workspace_resource
  sku: {
    name: dw_sku
  }
  properties: {
    createMode: 'Default'
    collation: collation
    storageAccountType:  'LRS'
  }
  resource synapse_workspace_tde  'transparentDataEncryption' = {
    name: 'current'
    properties:{
      status: 'Enabled'
    }
  }
}

resource sqlpool_metadatasync 'Microsoft.Synapse/workspaces/sqlPools/metadataSync@2021-06-01' = {
  parent: sqlPool_resource
  name: 'config'
  properties: {
    enabled: false
  }
}


// save password in keyvault
resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' existing={
  name: keyvaultName
}

// dedicate pool account password
resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyvault_resource
  name: 'secret-dwadmin-pwd'
  properties: {
    value:  dw_admin_password
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}


// ADLS storage key
resource keyVaultSecret2 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyvault_resource
  name: 'secret-adls-key'
  properties: {
    value:  adls_account_resource.listKeys().keys[0].value
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}

~~~

​        上面定义的资源包括

| #    | 资源定义                   | 说明                                                        |
| ---- | -------------------------- | ----------------------------------------------------------- |
| 1    | adls_account_resource      | ADLS 托管存储                                               |
| 2    | adls_file_system_resource  | ADLS 托管存储中的文件系统（根目录）                         |
| 3    | synapse_workspace_resource | Synapse的Workspace， 自带一个共享SQL pool                   |
| 4    | firewall_allowAll          | Synapse的防火墙设置， 此处全开                              |
| 5    | sqlPool_resource           | 一个Dedicate Pool， 作为数据仓库                            |
| 6    | keyVaultSecret             | dw_admin 账号的密码， 保存到KeyVault中： secret-dwadmin-pwd |
| 7    | keyVaultSecret2            | ADLS的存储账号的Key,  保存到KeyVault中：secret-adls         |

### b.  使用AZ-CLI登录

~~~cmd
az bicep install && az bicep upgrade        # 确保安装了bicep 模块

az login					# 登录。 使用AdminUser账号

az account set --subscription {your subscription ID}  # 选择订阅

az configure --defaults group=rg-dataops-starter  # 设置默认资源组； 如果不设默认， 则后面每个命令需要单独指定一次。
~~~



### c. 运行Bicep, 创建Synapse资源

~~~cmd
# 进入工作区目录
cd C:\Code\DataOpsStarter\16lab
# 部署Bicep 文件
az deployment group create --template-file synapse.bicep  
~~~



### 4. 实验二

> 目标：
>
> ​         本地创建SQL DW 数据库工程， 并上传到git repo

### a.  在目录C:\Code\DataOpsStarter\16Lab下新建数据库工程

​	      使用Visual Studio 新建数据库工程

### 5. 实验三

> 目标：
>
> ​         通过CICD的方式， 将git中的数据库工程发布到Synapse中

## 5. 参考资料

