# Command line interface Application

## 簡介

命令介面應用程式是單一專案的整合介面層，亦是系統整合對單一單元的命令進入點。

CLI ( Command line interface ) application is an integrate script in single project, and also is execute unit entry point in system integrate.

+ 專案的整合操作命令

任何開發，依據開發流程可區分為開發、測試、產品三個主要環節，而每個環節在專案都會有對等的腳本指令需要運作，亦或者每個環節會需要特殊的前處理來確保專案運作；而這所提的前處理往往並非與專案內指令有關，例如動態編譯腳本、自動化版號等功能。

因此，複雜的專案整合操作命令，即是透過 CLI 來達到整合，一來避免繁瑣指令背誦導致執行困擾、二來避免流程因人員產生操作不一致的異常。

+ 系統的整合操作命令

在大型系統專案中，會將專案分為數個獨立單元交由不同團隊製作，在完成後則交由整合單位將各系統透過適當的介面層整合並讓系統達到預期的運作；在理想情況下，使用一套系統、一套語言若能完成所有項目是完美的，但實務情況上，為了效能、可行性，往往會需要不同語言開發不同的軟體。

因此，複合的軟體間會需要系統整合腳本，而系統整合腳本則會呼叫 CLI 來運作該專案，以確保整合腳本不會與獨立的專案單元產生過度相依與專案間的交叉關聯問題。

## 適用情境

+ 管理與整合不同軟體的 CLI 指令，例如 docker、node.js

+ 管理對應專案、軟體需要的檔案搬移，例如 obs 的設定檔建立

+ 管理動應系統的權限指令，例如 chmod 777 等類似設定

## 開發環境

本專案預設於 Windows 環境設計，對於各開發與測試環境參考如下：

+ batch script 請使用 Command prompt 執行，若為 linux 作業系統可使用 ```conf/docker``` 的 wine 環境模擬執行
+ bash script 請使用 ```dev.bat``` 藉此啟動 Dokcer 來產生可編寫 bash 的 linux 環境

需注意，由於 wine 環境中執行會因為 findstr 指令不存在而無法正確執行，對此仍需調查原因

## 使用事項

可執行腳本請參閱目錄 ```app``` 中：

+ ```*.bat``` 請於 Windows 作業系統環境下測試
+ ```*.sh```  請於 Linux、Mac 作業系統環境下測試
> 為方便測試可使用 ```alias cli=${PWD}/cli.sh``` 來簡化執行命令，詳細參考 [alias](https://zh.wikipedia.org/zh-tw/Alias_(%E5%91%BD%E4%BB%A4)) 命令說明

## 命令介面 - 單一檔案

此腳本是將所有要執行的內容整合於單一檔案，並以函數區分用途。

```
cli [system parameter] [command] [command parameter]
```

+ 命令字串解析
+ 巢式命令架構

在本應用程式中，使用 invoke 的方式調用每個命令模組的函數，其中共有三個函數

+ ```[command]```        : 命令本身的腳本
+ ```[command]-args```   : 命令腳本的選項功能處理函數
+ ```[command]-help```   : 命令腳本的說明函數

若命令模組缺少其中一個函數，在執行階段會發生無法正確呼叫函數而導致系統拋出錯誤訊息。

### 測試事項

驗證與測試項目以 Windows 指令為主，Linux 與 Mac 請以 ```./cli.sh``` 執行

+ CLI 腳本執行：```cli```，輸出 cli 的說明文件
+ CLI 共通 Options
    - ```cli --help```，CLI 共通參數 ( 設定於 common-args 中 )；此操作會直接顯示說明文件
    - ```cli --prod```，CLI 主要參數 ( 設定於 cli-args 中 )；此操作會修改環境變數 ( PROJECT_ENV )
+ CLI 命令
    - ```cli up```，執行 up 命令 ( 設定於 cli-up 中 )；此操作會先處理過依據執行 ```common-args```、```cli-args```、```cli-up-args``` 後才執行
    - ```cli --prod up```，設定 CLI 主要參數並執行於 up 命令中；此操作可以看到輸出顯示環境變數 ( PROJECT_ENV ) 的改變
    - ```cli up --help```，設定 CLI 共通參數執行，已顯示 up 說明文件 ( 設定於 cli-up-help 中 )；需注意，共通參數原則等同改變最後呼叫函數，其優先度大過一切設定
+ CLI 命令 Options
    - ```cli up --test```，執行 up 命令並宣告 ```--test``` 選項執行 ( 設定於 cli-up-args 中 )；此操作可以看到輸出 ```VARTEST = 1```
    - ```cli up --var1=123```，執行 up 命令並宣告 ```--var1``` 的內容 ( 設定於 cli-up-args 中 )；此操作可以看到輸出 ```VARNUMBER1 = 123```
    - ```cli up --var1=123 --test --var2=456```，執行 up 命令並宣告任意 Options，對於 Options 的執行順序是有左至右，若設計上有順序需要應加以說明
    - ```cli up --var1="command -e=123"```，針對 Linux 環境可使用字串作為選項的內容
+ CLI 階層命令
    - ```cli```，執行 cli 主命令，但預設主命令並不包括任何行為，僅可設定主要參數
    - ```cli up```，執行 cli 中的 up 命令 ( 設定於 cli-up 中 )
    - ```cli up demo```，執行 cli 中的 up 命令中的 demo 命令 ( 設定於 cli-up-demo 中 )，設計上 up 命令與參數皆不會被執行，僅有 ```common-args```、```cli-args```、```cli-up-demo-args```、```cli-up-demo``` 會被依序執行
+ CLI 錯誤指令
    - ```cli up1234```，執行 cli 中不存在的 up1234 命令
    - 因不存在指令，會改執行 ```cli-help```，顯示說明文件

## 命令介面 - 複數命令檔案

此腳本是命令執行的介面殼，實際要執行的內容分散在目錄 ```shell``` 下，並以函數區分用途。

```
mcli [system parameter] [command] [command parameter]
```

+ 命令字串解析
+ 可執行命令源自腳本目錄 ```shell``` ( 此參數定義於 ini 檔案中，可更改 )

以下說明以 Linux 的 ".sh" 檔為範本，若為 Windows 則改用 ".bat" 檔

### 命令模組

在本應用程式中，使用每個命令模組為單一檔案，其檔名結構如下

+ ```[command].sh```，第一層命令
+ ```[command]-[sub command].sh```，第二層命令，隸屬於第一層命令下的子功能
+ ```[command]-[2-layer command]-...-[N-layer command].sh```，第 N 層命令，隸屬於第 N-1 層命令下的子功能

其中共有四個函數

+ ```action```  : 命令本身的腳本
+ ```args```    : 命令腳本的選項功能處理函數
+ ```short```   : 命令腳本的短說明函數
+ ```help```    : 命令腳本的說明函數

若命令模組缺少其中一個函數，在執行階段會發生無法正確呼叫函數而導致系統拋出錯誤訊息。

### 命令屬性

若命令模組會對流程的變動或提供額外參數，可設定命令屬性來設置或配置參數，參數結構為

+ ```::@[ATTRIBUTE_NAME]=[VALUE]``` for Windows
+ ```#@[ATTRIBUTE_NAME]=[VALUE]``` for Linux

參數會將值宣告為變數，其規則如下：

+ ```::@ATT-NAME``` 會產生變數 ATTR_ATT_NAME 為真
+ ```::@ATT-NAME=``` 會產生變數為 ATTR_ATT_NAME 為空
+ ```::@ATT-NAME=1234``` 會產生變數為 ATTR_ATT_NAME 其值為 1234

例如以下屬性：

+ ```#@STOP-CLI-PARSER```、```::@STOP-CLI-PARSER```  : 會設定 ```ATTR_STOP_CLI_PARSER``` 變數，其功能會停止繼續解析並執行目前腳本，並將未解析命令以參數方式傳入 ```action``` 函數

使用方式參考腳本：

+ exec 使用 ```ATTR_STOP_CLI_PARSER``` 變數和屬性設定變數，[windows](./app/shell/exec.bat)、[linux](./app/shell/exec.sh)
+ up 使用屬性設定預設值並用參數替換，[windows](./app/shell/up.bat)、[linux](./app/shell/up.sh)

設計上，attr 用於宣告此腳本需要的區域變數。

### 共通變數設定

共通變數配置使用 ini 檔案格式，所有相關工作流控制變數設定於 ```mcli.ini``` 檔案中，此檔共用於 ```mcli.bat``` 與 ```mcli.sh```；此配置檔有以下設計要點：

+ 配置檔不檢查區段 ```[]```，所有變數皆為 key-value 儲存
+ 相應 key 的處理設計於 ```common-ini``` 函數

**注意事項**

+ ini 檔案名稱是依據 CLI 檔名決定，因此，若 CLI 改為 ```do.bat```，則會呼叫 ```do.ini```
+ ini 檔案應設定為 LF 檔案格式，依此兼容 windows 與 linux 的使用環境
+ ini 檔案的註解 ```;``` 後的內容會被移除後才處理
+ ini 檔案若不存在則不會有任何宣告

設計上，ini 用於宣告需演算處理的共通變數。

### 執行變數設定

執行變數配置使用 rc 副檔名，所有相關工作流控制變數設定於 ```mcli.rc``` 檔案中，此檔共用於 ```mcli.bat``` 與 ```mcli.sh```；此配置檔有以下設計要點：

+ 註解使用 ```#```
+ 變數皆為 ```key```=```value``` 儲存
+ 變數實際宣告為 ```RC_${key}=${value}```
    - 若在 ```mcli.rc``` 有個變數設置為 ```VALUE=123``` 則執行時變數名稱為 ```RC_VALUE```。
+ 執行變數可以使用 ```--rc=[RC_file_path]``` 擴增或覆蓋變數
    - 若執行時使用 ```mcli --rc=demo.rc```，則會先讀取 ```mcil.rc``` 後讀取 ```demo.rc```，若變數名稱相同則由後覆蓋前。

**注意事項**

+ rc 檔案名稱是依據 CLI 檔名決定，因此，若 CLI 改為 ```do.bat```，則會呼叫 ```do.rc```
+ rc 檔案應設定為 LF 檔案格式，依此兼容 windows 與 linux 的使用環境
+ rc 檔案的註解 ```#``` 後的內容會被移除後才處理
+ rc 檔案若不存在則不會有任何宣告

設計上，rc 用於宣告執行階段的共通變數。

### 測試事項

驗證與測試項目以 Windows 指令為主，Linux 與 Mac 請以 ```./mcli.sh``` 執行

+ CLI 腳本執行：```mcli.sh```
+ 所有測試項目與 ```cli``` 項目相同

### 其他相關工具

+ [make script](https://foreachsam.github.io/book-util-make/book/content/example/make-scripts/)
   - [Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm)
+ [Shell Script Compiler](https://github.com/neurobin/shc)
+ [INI file](https://en.wikipedia.org/wiki/INI_file)
    - [What Is an INI File?](https://www.lifewire.com/how-to-open-edit-ini-files-2622755)
