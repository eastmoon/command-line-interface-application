# Command line interface Application

### 簡介

命令介面應用程式是單一專案的整合介面層，亦是系統整合對單一單元的命令進入點。

CLI ( Command line interface ) application is an integrate script in single project, and also is execute unit entry point in system integrate.

+ 專案的整合操作命令

任何開發，依據開發流程可區分為開發、測試、產品三個主要環節，而每個環節在專案都會有對等的腳本指令需要運作，亦或者每個環節會需要特殊的前處理來確保專案運作；而這所提的前處理往往並非與專案內指令有關，例如動態編譯腳本、自動化版號等功能。

因此，複雜的專案整合操作命令，即是透過 CLI 來達到整合，一來避免繁瑣指令背誦導致執行困擾、二來避免流程因人員產生操作不一致的異常。

+ 系統的整合操作命令

在大型系統專案中，會將專案分為數個獨立單元交由不同團隊製作，在完成後則交由整合單位將各系統透過適當的介面層整合並讓系統達到預期的運作；在理想情況下，使用一套系統、一套語言若能完成所有項目是完美的，但實務情況上，為了效能、可行性，往往會需要不同語言開發不同的軟體。

因此，複合的軟體間會需要系統整合腳本，而系統整合腳本則會呼叫 CLI 來運作該專案，以確保整合腳本不會與獨立的專案單元產生過度相依與專案間的交叉關聯問題。

### 適用情境

+ 管理與整合不同軟體的 CLI 指令，例如 docker、node.js

+ 管理對應專案、軟體需要的檔案搬移，例如 obs 的設定檔建立

+ 管理動應系統的權限指令，例如 chmod 777 等類似設定

### 設計項目

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

### 使用事項

+ ```cli.bat``` 請於 Windows 作業系統環境下測試

+ ```cli.sh```  請於 Linux、Mac 作業系統環境下測試

### 其他相關工具

+ [make script](https://foreachsam.github.io/book-util-make/book/content/example/make-scripts/)
   - [Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm)
