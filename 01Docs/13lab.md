# # 1-3 - 了解测试数据发布到存储Blob和AzureSQL

## 1. 实验目的

- 实现将数据文件csv提交到git
- 通过CI->artifacts->CD的过程将数据发布到blob
- 创建数据库资源，并在KeyVault中保存连接串
- 实现将建表语句和存储过程
- 通过CI->artifacts->CD的过程， 发布数据库
- 通过CD的过程， 将blob的数据发布到数据库



## 2. 前提条件

- Azure账号及订阅
- Resource Group 及SPN （resource group contributor)
- VS Code
- Visual Studio 2019 +
- AZ CLI
  - 下载及安装 [How to install the Azure CLI | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)



## 3. 实验步骤一

### a.  进入根目录C:\Code\DataOpsStart\

​	      使用**VS Code**打开根目录"C:\Code\DataOpsStarter\ ; 

### b.  新建 13lab\weights_heights.csv

​		  新建目录**13lab\00Data\01csv**， 并将这几个csv文件下载到目录中：

> https://adlssalesdemo.blob.core.windows.net/lab/weights_heights.csv
>
> 

### c. 新建CI workflow

​		在\\.github\workflow目录下，新建文件lab13-CI-Blob.yml, 内容如下：

~~~yml
name: lab13-CI-Blob

on:
  workflow_dispatch:
  # push:
  #   branches:
  #     - "main"
env:
  # Path to the solution file relative to the root of the project.
  SOLUTION_WORKSPACE: 13lab/00Data
  ARTIFACT_NAME: Data

jobs:
  SQL-AdminOps-LoadData:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: browser
      run: tree .
    - name: Copy to Artifact Folder
      run: |
        mkdir -p ./artifacts/ci-run/${{github.RUN_NUMBER}}/ 
        cp -r ${{env.SOLUTION_WORKSPACE}}/ ./artifacts/ci-run/${{github.RUN_NUMBER}}/
    - name: Upload Data Artifact
      uses: actions/upload-artifact@v3
      with:
        name: ${{env.ARTIFACT_NAME}}
        path: ./artifacts/       

~~~

​		上述CI的过程， 是将/13lab/00Data目录下的数据文件提交到Repo的Artifacts中。

​        值得一提的是，每次数据修改后重新提交， 重新通过CI上传的目录都是加了CI Run Number的编号的， 起到了版本化的作用。 

### d. 新建CD workflow

​		在\\.github\workflow目录下，新建文件lab13-CD-Blob.yml, 内容如下：

~~~yml
name: lab13-CD-Blob

on:
  workflow_run:
    workflows: [lab13-CI-Blob]
    types:
      - completed

  workflow_dispatch:
  # push:
  #   branches:
  #     - "main"
env:
  # Path to the solution file relative to the root of the project.
  ARTIFACT_NAME: Data
  STORAGE_ACCOUNT: storagehh101dev   # storage account name
  SRC_DATA: src-data   # same as blob container
  KEY_VAULT: kv-hh101-dev  # key vault name

permissions:
  contents: read

jobs:
  Deploy-SQLDB:
    runs-on: ubuntu-latest

    steps:
#### Download artifact from CI
    - name: Download artifact from CI
      uses: aochmann/actions-download-artifact@1.0.4
    # - uses: actions/download-artifact@v3
      with:
        repo: HarveyHuBJ/MsDataOpsStarter
        github_token: ${{ secrets.GITHUB_TOKEN }}
        name: ${{ env.ARTIFACT_NAME }}
        path: ${{ env.SRC_DATA }}
        
#### Display structure of downloaded files
    - name: Display structure of downloaded files
      run: tree .
      working-directory: ${{ env.SRC_DATA }}

#### az login to access key vault 
    - name: az login with github_dataops_spn
      uses: azure/login@v1                            # github_dataops_spn
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    
#### Retrieve storage key
    - uses: Azure/get-keyvault-secrets@v1
      id: getSecretAction # ID for secrets that you will reference
      name: retrieve storage key
      with:
        keyvault: ${{env.KEY_VAULT}} # name of key vault in Azure portal
        secrets: 'secret-storage-key'  # comma separated list of secret keys to fetch from key vault 

#### upload multi-files to blob
    - name: Azure CLI script - az copy data
      uses: azure/CLI@v1
      with:
        azcliversion: 2.30.0
        inlineScript: |
          az storage blob upload-batch -s ${{ env.SRC_DATA }} -d ${{ env.SRC_DATA }} --account-name  ${{ env.STORAGE_ACCOUNT }} --account-key ${{steps.getSecretAction.outputs.secret-storage-key}}       

~~~

​        上述CD的过程， 是将上一步CI生成的artifacts 文件，复制到Azure 存储账户的BLOB中。 其中需要从KeyVault中获取访问Azure存储账户的密钥， 

### e. 分别运行CI CD

如果CD中配置了workflow_run， 如下所示， 则会自动在CI 完成的时候开始启动

~~~cmd
  workflow_run:
    workflows: [lab13-CI-Blob]
    types:
      - completed
~~~

 

### f. 观察结果

CI 完成后， 会在workflow的Summary页面上显示Artifacts; 可用自行下载到本地，解压缩后观察Artifacts的内容；数据文件应该保存在CI-run/xx/的目录下

![CI-Artifacts](.\13lab\CI-artifacts.png)



CD 完成后， 会在Blob中出现新加的数据文件。





## 5. 参考资料

