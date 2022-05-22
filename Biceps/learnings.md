
# Bicep 入门

## 学习材料
1. [MSDOC learn-bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/learn-bicep)
2. [fundamentals-bicep](https://docs.microsoft.com/en-us/learn/paths/fundamentals-bicep/)
3. [使用 Bicep 和 GitHub Actions 部署 Azure 资源](https://docs.microsoft.com/en-us/learn/paths/bicep-github-actions/)
4. [Examples](https://github.com/Azure/bicep/tree/main/docs/examples)


## 基本认识
### 为什么要使用基础设施即代码

采用基础结构即代码方法可为资源预配提供许多好处。使用基础架构即代码，您可以：

- 提高对部署的信心。
- 管理多个环境。
- 更好地了解您的云资源



### Azure 资源管理

![Diagram showing Azure Resource Manager accepting requests from all Azure clients and libraries.](.\imgs\azure-resource-manager.png)



### 为什么使用 ARM 模板？

使用 ARM 模板（JSON 和 Bicep）进行资源预配有很多好处：

- **可重复的结果**：ARM 模板是幂等的，这意味着您可以重复部署相同的模板并获得相同的结果。模板不会复制资源。
- **业务流程**：将模板部署提交到资源管理器时，将并行部署模板中的资源。此过程允许更快地完成部署。如果一个资源依赖于另一个资源，资源管理器将按正确的顺序协调这些部署。
- **预览**：在 PowerShell 和 Azure CLI 中提供的假设工具允许你在模板部署之前预览对环境所做的更改。此工具将详细介绍模板将进行的任何创建、修改和删除。
- **测试和验证**：您可以使用 Bicep linter 等工具在部署之前检查模板的质量。提交到资源管理器的 ARM 模板在部署过程之前进行验证。此验证会在资源预配之前提醒你注意模板中的任何错误。
- **模块化**：您可以将模板分解为更小的组件，并在部署时将它们链接在一起。
- **CI/CD 集成**：ARM 模板可以集成到多个 CI/CD 工具中，如 Azure DevOps 和 GitHub Actions。可以使用这些工具通过源代码管理和生成发布管道对模板进行版本控制。
- **可扩展性**：使用部署脚本，可以从 ARM 模板中运行 Bash 或 PowerShell 脚本。这些脚本在部署时执行数据平面操作等任务。通过可扩展性，可以使用单个 ARM 模板来部署完整的解决方案。

### JSON 和Bicep模板

目前有两种类型的 ARM 模板可供使用：JSON 模板和二头肌模板。JavaScript Object Notation （JSON） 是一种开放标准的文件格式，多种语言都可以使用。Bicep 是一种新的特定于域的语言，最近开发用于使用更简单的语法创作 ARM 模板。您可以将任一模板格式用于 ARM 模板和资源部署。

Bicep 是一种用于以声明方式部署 Azure 资源的语言。使用 Bicep，可以定义应如何配置和部署 Azure 资源。你将在称为*模板*的 Bicep 文件中定义资源，然后将该模板提交到 Azure 资源管理器。然后，资源管理器负责代表你部署模板中的每个资源。

### Bicep 与 ARM 模板有何关系？

你可能已经熟悉 Azure 资源管理器模板（ARM 模板），它们是表示 Azure 资源的文件。在Bicep 可用之前，ARM模板必须以特殊的JSON格式编写。JSON 模板的一个常见问题是它们很难使用，因为它们具有复杂的语法。开始使用 JSON 编写 ARM 模板可能很困难。

Bicep 通过使用一种更简单的语言来解决这些问题，该语言专门用于帮助你将资源部署到 Azure。

在后台，资源管理器仍基于相同的 JSON 模板运行。将Bicep 模板提交到资源管理器时，Bicep 工具会在称为*转译*的过程中将模板转换为 JSON 格式。这通常不是您需要考虑的事情，但如果需要，可以查看Bicep创建的JSON模板文件。

![Diagram that shows a template author, a Bicep template, an emitted JSON template, and a deployment to Azure.](.\imgs\bicep-to-json.png)

### 示例

~~~js
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'toylaunchstorage'
  location: 'westus3'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
~~~



> Bicep对放置换行符的位置很严格，因此请确保不要将换行符放在与此处列出的位置不同的位置。



### 部署

~~~bash
az bicep install && az bicep upgrade

az login

az account set --subscription {your subscription ID}

az configure --defaults group={your resource group name}

# 将模板部署到 Azure
az deployment group create --template-file main.bicep
~~~

### uniqueString

当您创建资源名称时，该函数会派上用场。使用此函数时，需要提供*种子值*，该值在不同部署中应不同，但在相同资源的所有部署中应保持一致。`uniqueString()`

~~~c#
param storageAccountName string = uniqueString(resourceGroup().id)
~~~



### Bicep Module

Bicep 模块允许您通过创建可组合成模板的较小单元来组织和重用 Bicep 代码。任何Bicep模板都可以由另一个模板用作模块。

~~~
module myModule 'modules/mymodule.bicep' = {
  name: 'MyModule'
  params: {
    location: location
  }
}
~~~



![Diagram that shows a template for solution A referencing three modules - application, database, and networking. The networking module is then reused in another template for solution B.](.\imgs\bicep-templates-modules.png)



就像模板一样，Bicep模块可以定义输出。在模板中将模块链接在一起是很常见的。在这种情况下，一个模块的输出可以是另一个模块的参数。通过同时使用模块和输出，您可以创建功能强大且可重复使用的Bicep文件

### Bicep Modules设计原则

一个好的Bicep 模块遵循几个关键原则：

- **模块应该有明确的目的。**可以使用模块来定义与解决方案的特定部分相关的所有资源。例如，可以创建一个模块，其中包含用于监视应用程序的所有资源。还可以使用模块来定义一组属于一起的资源，如所有数据库服务器和数据库。
- **不要将每个资源都放入其自己的模块中。**不应为部署的每个资源创建单独的模块。如果您的资源具有大量复杂属性，则将该资源放入其自己的模块中可能是有意义的。但一般来说，模块最好组合多个资源。
- **模块应具有有意义的明确参数和输出。**考虑模块的用途。考虑模块是否应操作参数值，或者父模板是否应处理该参数值，然后将单个值传递给模块。同样，考虑模块应返回的输出，并确保它们对将使用该模块的模板有用。
- **模块应尽可能独立。**如果模块需要使用变量来定义模块的一部分，则该变量通常应包含在模块文件中，而不是包含在父模板中。
- **模块不应输出机密。**就像模板一样，不要为连接字符串或键等机密值创建模块输出。

### 创建参数文件

*使用参数文件*，可以轻松地将参数值作为一个集合一起指定。在参数文件中，为 Bicep 文件中的参数提供值。参数文件是使用 JavaScript 对象表示法 （JSON） 语言创建的。

~~~json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServicePlanInstanceCount": {
      "value": 3
    },
    "appServicePlanSku": {
      "value": {
        "name": "P1v3",
        "tier": "PremiumV3"
      }
    },
    "cosmosDBAccountLocations": {
      "value": [
        {
          "locationName": "australiaeast"
        },
        {
          "locationName": "southcentralus"
        },
        {
          "locationName": "westeurope"
        }
      ]
    }
  }
}
~~~

在部署时使用参数文件

~~~bash
az deployment group create \
  --template-file main.bicep \
  --parameters main.parameters.json
~~~

指定参数值的三种方法：默认值(p3)、命令行(p1)和参数文件(p2)

### 保护您的参数

~~~bash
@secure()
param sqlServerAdministratorLogin string

@secure()
param sqlServerAdministratorPassword string
~~~



将密钥放在KeyVault中，然后可以这样用

~~~js
resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: keyVaultName
}

module applicationModule 'application.bicep' = {
  name: 'application-module'
  params: {
    apiKey： keyVault.getSecret（'ApiKey'）
  }
}
~~~

