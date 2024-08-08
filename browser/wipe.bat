@echo off
set ExePath=%~1
set STARTUP=5
if "%ExePath%"=="" (
  set ExePath=%~dp0chrome.exe
  set UserDataDir1=%~dp0User Data
  set UserDataDir2=%LOCALAPPDATA%\CentBrowser\User Data
) else (
  set UserDataDir1=%~2
  set UserDataDir2=
)
if not exist "%ExePath%" (
  goto :MAIN
)

:CHECKPROC
wmic process get ExecutablePath | find /i "%ExePath%" >nul 2>nul
if "%ERRORLEVEL%"=="0" (
  if %STARTUP%==5 (
    echo Please exit all Cent Browser processes
  )
  set /a STARTUP=%STARTUP%+1
  if %STARTUP% gtr 65 (
    echo.
    echo Wait timed out, exit now
    exit
  )
  echo | set /p="."
  timeout /t 1 >nul 2>nul
  goto CHECKPROC
) else (
  if %STARTUP% gtr 5 (
    echo.
    timeout /t 2 >nul 2>nul
  )
)
goto :MAIN

:DELETEITEM
set TargetPath=%~1
if not exist "%TargetPath%" (
  exit /b 1
)
if exist "%TargetPath%\*" (
  echo | set /p="Removing %TargetPath% ...... "
  rd /s /q "%TargetPath%" >nul 2>nul
) else (
  echo | set /p="Deleting %TargetPath% ...... "
  attrib -r -s -h "%TargetPath%" /s /d >nul 2>nul
  del /f /s /q "%TargetPath%" >nul 2>nul
)
if exist "%TargetPath%" (
  echo FAILED
) else (
  echo OK
)
exit /b 0

:CLEARUSERDATA
set UserDataDir=%~1
if not exist "%UserDataDir%" (
  exit /b 1
)
for %%i in (
  "debug.log"
  "chrome_debug.log"
  "chrome_shutdown_ms.txt"
  "BrowserMetrics-spare.pma"
  "CrashpadMetrics-active.pma"
  "lockfile"
  "Module Info Cache"
  "first_party_sets.db"
  "first_party_sets.db-journal"
  "persisted_first_party_sets.json"
  "Local Traces"
  "Safe Browsing Channel IDs"
  "Safe Browsing Channel IDs-journal"
  "Safe Browsing Cookies"
  "Safe Browsing Cookies-journal"
  "Service State"
  "Variations"
  "Floc"
  "temp"
  "pnacl"
  "Mobile"
  "safemon"
  "Crashpad"
  "Crowd Deny"
  "SafetyTips"
  "MEIPreload"
  "ShaderCache"
  "OriginTrials"
  "FileTypePolicies"
  "SSLErrorAssistant"
  "DesktopSharingHub"
  "UrlParamClassifications"
  "Subresource Filter"
  "Webstore Downloads"
  "FontLookupTableCache"
  "TLSDeprecationConfig"
  "PnaclTranslationCache"
  "CertificateRevocation"
  "CertificateTransparency"
  "InterventionPolicyDatabase"
  "AutofillStates"
  "BrowserMetrics"
  "ClientSidePhishing"
  "component_crx_cache"
  "extensions_crx_cache"
  "FileTypePolicies"
  "FirstPartySetsPreloaded"
  "GraphiteDawnCache"
  "GrShaderCache"
  "hyphen-data"
  "OnDeviceHeadSuggestModel"
  "OptimizationHints"
  "OptimizationGuidePredictionModels"
  "optimization_guide_model_store"
  "PrivacySandboxAttestationsPreloaded"
  "PKIMetadata"
  "RecoveryImproved"
  "Safe Browsing"
  "SafetyTips"
  "Subresource Filter"
  "SwReporter"
  "ThirdPartyModuleList64"
  "TpcdMetadata"
  "TrustTokenKeyCommitments"
  "ZxcvbnData"
) do (
  call :DELETEITEM "%UserDataDir%\%%~i"
)
for %%j in (
  "Default"
  "System Profile"
  "Guest Profile"
  "Profile 1"
  "Profile 2"
  "Profile 3"
  "Profile 4"
  "Profile 5"
  "Profile 6"
  "Profile 7"
  "Profile 8"
  "Profile 9"
  "Profile 10"
) do (
  if exist "%UserDataDir%\%%~j" (
    for %%k in (
      "Affiliation Database"
      "Affiliation Database-journal"
      "BrowsingTopicsSiteData"
      "BrowsingTopicsSiteData-journal"
      "BrowsingTopicsState"
      "heavy_ad_intervention_opt_out.db"
      "heavy_ad_intervention_opt_out.db-journal"
      "History Provider Cache"
      "Media History"
      "Media History-journal"
      "MediaDeviceSalts"
      "MediaDeviceSalts-journal"
      "Last Tabs"
      "Last Session"
      "Current Tabs"
      "Current Session"
      "Reporting and NEL"
      "Reporting and NEL-journal"
      "LOCK"
      "LOG"
      "LOG.old"
      "page_load_capping_opt_out.db"
      "page_load_capping_opt_out.db-journal"
      "trusted_vault.pb"
      "Visited Links"
      "DIPS"
      "DIPS-journal"
      "Cache"
      "CodeCache"
      "GPUCache"
      "GCM Store"
      "databases"
      "Sync Data"
      "Code Cache"
      "Wallpapers"
      "Thumbnails"
      "DailyBackup"
      "Pepper Data"
      "blob_storage"
      "JumpListIcons"
      "Service Worker"
      "BudgetDatabase"
      "Session Storage"
      "shared_proto_db"
      "VideoDecodeStats"
      "Web Applications"
      "Download Service"
      "JumpListIconsOld"
      "Application Cache"
      "Platform Notifications"
      "JumpListIconsMostVisited"
      "JumpListIconsRecentClosed"
      "Feature Engagement Tracker"
      "Site Characteristics Database"
      "AutofillStrikeDatabase"
      "commerce_subscription_db"
      "Conversions"
      "Conversions-journal"
      "coupon_db"
      "DawnCache"
      "discounts_db"
      "DownloadMetadata"
      "feedv2"
      "Network Action Predictor"
      "Network Action Predictor-journal"
      "optimization_guide_hint_cache_store"
      "optimization_guide_model_metadata_store"
      "optimization_guide_prediction_model_downloads"
      "parcel_tracking_db"
      "PersistentOriginTrials"
      "Safe Browsing Network"
      "Search Logos"
      "Segmentation Platform"
      "WebStorage"
      "data_reduction_proxy_leveldb"
      "WebrtcVideoStats"
      "Extension State"
      "Extension Rules"
      "Extension Scripts"
    ) do (
      call :DELETEITEM "%UserDataDir%\%%~j\%%~k"
    )
    if "%ResetExtensionSettings%"=="1" (
      @rem Besides "XXX Extension Settings", some extensions may store data and settings in these directories.
      call :DELETEITEM "%UserDataDir%\%%~j\IndexedDB"
      call :DELETEITEM "%UserDataDir%\%%~j\Local Storage"
      call :DELETEITEM "%UserDataDir%\%%~j\File System"
      call :DELETEITEM "%UserDataDir%\%%~j\Storage\ext"
    ) else (
      for /f "usebackq eol=: delims=" %%l in (`dir /b /a "%UserDataDir%\%%~j\IndexedDB" 2^>nul ^| find /v /i "chrome-extension" 2^>nul`) do (
        call :DELETEITEM "%UserDataDir%\%%~j\IndexedDB\%%~l"
      )
    )
    if "%DeleteMultiloginTabData%"=="1" (
      call :DELETEITEM "%UserDataDir%\%%~j\Storage\multilogin-tabs"
    )
    if "%DeleteNetworkCache%"=="1" (
      call :DELETEITEM "%UserDataDir%\%%~j\Network"
    )
    if "%DeleteHistory%"=="1" (
      call :DELETEITEM "%UserDataDir%\%%~j\History"
      call :DELETEITEM "%UserDataDir%\%%~j\History-journal"
    )
    if "%ResetExtensionSettings%"=="1" if "%DeleteMultiloginTabData%"=="1" if "%DeleteHistory%"=="1" (
      call :DELETEITEM "%UserDataDir%\%%~j\Storage"
    )
  )
)
exit /b 0

:MAIN
set ResetExtensionSettings=%~3
set DeleteMultiloginTabData=%~4
set DeleteNetworkCache=%~5
set DeleteHistory=%~6
echo Start wiping browsing data ...
echo.
if "%UserDataDir1%" neq "" call :CLEARUSERDATA "%UserDataDir1%"
if "%UserDataDir2%" neq "" call :CLEARUSERDATA "%UserDataDir2%"
echo.
echo Finished wiping browsing data
pause & exit