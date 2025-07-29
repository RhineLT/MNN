# iOS 构建工作流更新说明

## 🎯 更新目标

将 MNN iOS 构建工作流从仅构建框架库扩展为生成可直接安装的 iOS 应用程序包（IPA 文件）。

## 📋 主要更改

### 1. 工作流文件更新 (.github/workflows/ios.yml)

#### 新增构建步骤：
- **build-demo-app**: 构建 demo 演示应用程序
- **build-playground-app**: 构建 Playground 测试应用程序
- **show-generated-apps**: 显示构建产物
- **upload-ios-apps**: 上传所有iOS应用和框架到 GitHub Artifacts
- **installation-instructions**: 显示安装说明

#### 技术实现：
- 使用 `xcodebuild build` 命令构建应用
- 禁用代码签名以支持CI环境构建
- 手动创建 IPA 包（Payload 文件夹 + ZIP 压缩）
- 上传构建产物到 GitHub Actions Artifacts

### 2. 新增配置文件

#### ExportOptions.plist
- IPA 导出配置文件
- 配置开发模式导出
- 禁用 Bitcode 和符号上传

#### README-Installation.md
- 详细的安装指南
- 多种安装方法说明
- 代码签名和信任配置说明
- 常见问题解决方案

## 🏗 构建产物

工作流完成后将生成：

1. **MNN.framework** - 原有的框架库
2. **demo.ipa** - 演示应用程序包
3. **Playground.ipa** - 测试应用程序包

## 📱 应用安装方法

### 通过 Xcode 安装
1. 打开 Xcode > Window > Devices and Simulators
2. 选择设备，拖拽 IPA 文件到应用列表

### 通过命令行安装
```bash
npm install -g ios-deploy
ios-deploy --bundle demo.ipa
```

### 通过第三方工具
- 3uTools
- iMazing  
- AltStore（需要开发者账号）

## ⚠️ 重要注意事项

### 代码签名限制
- 应用没有有效代码签名
- 只能在开发设备或越狱设备上安装
- 需要手动信任开发者证书

### 设备要求
- iOS 9.0+（Playground）/ iOS 11.0+（demo）
- 支持 iPhone 和 iPad
- 支持 arm64, armv7, armv7s 架构

## 🔄 工作流程

1. **触发条件**: 
   - 推送到 master 或 feature 分支
   - 修改相关源码路径
   - Pull Request 到 master

2. **构建流程**:
   ```
   源码检出 → 构建框架 → 构建Demo应用 → 构建Playground应用 → 上传产物 → 显示说明
   ```

3. **产物下载**:
   - 在 GitHub Actions 页面下载 `ios-apps` artifact
   - 包含所有 IPA 文件和框架库

## 🚀 使用方式

### 开发者使用
1. 从 GitHub Actions 下载构建产物
2. 根据安装指南安装到设备
3. 在设置中信任开发者证书
4. 启动应用进行测试

### 最终用户使用
1. 获取 IPA 文件
2. 使用推荐的安装工具
3. 按照指南完成安装和信任配置

## 🎉 预期效果

通过这些更改，用户现在可以：
- 直接获得可安装的 iOS 应用程序
- 无需本地编译即可测试 MNN 功能
- 快速在设备上体验 MNN 的机器学习能力
- 使用多种方式安装应用到 iOS 设备

这大大降低了用户体验 MNN iOS 功能的门槛，提高了项目的可用性和推广效果。
