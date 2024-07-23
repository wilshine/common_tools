## Features

Flutter非UI工具库


## 待办清单

- [ ] 弹窗工具的具体实现
- [ ] 下载工具的具体实现
- [x] 主项目中的抽象
- [x] common仓库进行再次抽象，common_tools的native侧依赖common，主项目的native侧也依赖，提供原生侧基础工具能力
- [x] 主项目


> 基础非UI工具组件

支持的功能如下：

- 权限管理
    - Android: com.tbruyelle.rxpermissions2
    - Flutter: permission_handler
- 文件上传下载
    - 下载
        - 断点下载
        - 支持通知栏显示下载进度
        - 支持多线程下载
- 弹窗管理器
- 颜色工具
- 日期工具
- 设备工具
- 加解密工具
- 列表工具
- 字典工具
- MD5工具
- 设备屏幕工具
- 字符串工具
- 防重复点击工具
- 表单校验工具
- 数据存储工具
- url工具
    - 打开某个url链接
- 国际化工具
- 扩展函数
    - context扩展
    - iterable扩展
    - string扩展
- 日志存储(独立仓库)
- 埋点上报
- 原生侧基础工具
    - 设备工具
    - json工具
    - md5工具
    - 线程工具
- 数据库封装

## color_util

## date_util

## device_util

## encrypt_util

## file_util

## list_util

## map_util

## md5_util

## screen_tool

## string_util

## throttle_util

## validator_util

## xp_tool_platform_interface


### 通过mmkv实现简单数据存储

这里不按照官方的方式接入，有点麻烦。下载mmkv源码，修改pubspec.yaml中的name名字为mmkvflutter，xp_tool本地依赖此库

- 使用XpToolPlatform封装好的API






## 权限库permission_handler

### 接入方法


#### Android

#### iOS

- 在Podfile中添加以下内容

```

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    # Start of the permission_handler configuration
    target.build_configurations.each do |config|

      # You can enable the permissions needed here. For example to enable camera
      # permission, just remove the `#` character in front so it looks like this:
      #
      # ## dart: PermissionGroup.camera
      # 'PERMISSION_CAMERA=1'
      #
      #  Preprocessor definitions can be found in: https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

      # 需要使用的权限则去掉注释
        ## dart: PermissionGroup.calendar
        'PERMISSION_EVENTS=1',

        ## dart: PermissionGroup.reminders
        # 'PERMISSION_REMINDERS=1',

        ## dart: PermissionGroup.contacts
        # 'PERMISSION_CONTACTS=1',

        ## dart: PermissionGroup.camera
        'PERMISSION_CAMERA=1',

        ## dart: PermissionGroup.microphone
        'PERMISSION_MICROPHONE=1',

        ## dart: PermissionGroup.speech
        # 'PERMISSION_SPEECH_RECOGNIZER=1',

        ## dart: PermissionGroup.photos
        'PERMISSION_PHOTOS=1',

        ## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
        # 'PERMISSION_LOCATION=1',

        ## dart: PermissionGroup.notification
        # 'PERMISSION_NOTIFICATIONS=1',

        ## dart: PermissionGroup.mediaLibrary
        # 'PERMISSION_MEDIA_LIBRARY=1',

        ## dart: PermissionGroup.sensors
        # 'PERMISSION_SENSORS=1',

        ## dart: PermissionGroup.bluetooth
        # 'PERMISSION_BLUETOOTH=1',

        ## dart: PermissionGroup.appTrackingTransparency
        # 'PERMISSION_APP_TRACKING_TRANSPARENCY=1',

        ## dart: PermissionGroup.criticalAlerts
        # 'PERMISSION_CRITICAL_ALERTS=1'
      ]
      end
  end
end

```

- Info.plist文件中添加权限声明

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>Xp Tool</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>xp_tool_example</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>

<!-- 以下内容为权限声明 -->

	<!-- Permission options for the `location` group -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Need location when in use</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Always and when in use!</string>
    <key>NSLocationUsageDescription</key>
    <string>Older devices need location.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Can I have location always?</string>

    <!-- Permission options for the `mediaLibrary` group -->
    <key>NSAppleMusicUsageDescription</key>
    <string>Music!</string>
    <key>kTCCServiceMediaLibrary</key>
    <string>media</string>

    <!-- Permission options for the `calendar` group -->
    <key>NSCalendarsUsageDescription</key>
    <string>Calendars</string>

    <!-- Permission options for the `camera` group -->
    <key>NSCameraUsageDescription</key>
    <string>camera</string>

    <!-- Permission options for the `contacts` group -->
    <key>NSContactsUsageDescription</key>
    <string>contacts</string>

    <!-- Permission options for the `microphone` group -->
    <key>NSMicrophoneUsageDescription</key>
    <string>microphone</string>

    <!-- Permission options for the `speech` group -->
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>speech</string>

    <!-- Permission options for the `sensors` group -->
    <key>NSMotionUsageDescription</key>
    <string>motion</string>

    <!-- Permission options for the `photos` group -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>photos</string>

    <!-- Permission options for the `reminder` group -->
    <key>NSRemindersUsageDescription</key>
    <string>reminders</string>

    <!-- Permission options for the `bluetooth` -->
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>bluetooth</string>
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>bluetooth</string>

    <!-- Permission options for the `appTrackingTransparency` -->
    <key>NSUserTrackingUsageDescription</key>
    <string>appTrackingTransparency</string>

<!-- 以上内容为权限声明 -->

	<key>CADisableMinimumFrameDurationOnPhone</key>
	<true/>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>


</dict>
</plist>


```

- 使用PermissionManager封装好的API