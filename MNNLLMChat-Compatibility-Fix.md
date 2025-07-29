# MNNLLMChat 兼容性修复指南

## 🔧 Xcode 项目格式兼容性问题

### 问题描述
MNNLLMChat 项目使用了 Xcode 15+ 的新项目格式 (`objectVersion = 77`)，包含以下新特性：
- `PBXFileSystemSynchronizedRootGroup`
- `PBXFileSystemSynchronizedBuildFileExceptionSet`
- 文件系统同步功能

GitHub Actions 中的 Xcode 15.4 不支持这些新特性。

### 🎯 解决方案

#### 方案 1: 降级项目格式（已实施）
- 修改 `objectVersion` 从 77 到 56
- 但需要手动处理文件系统同步配置

#### 方案 2: 手动构建方法
如果自动构建失败，可以使用以下手动方法：

1. **本地构建**
   ```bash
   # 克隆仓库
   git clone https://github.com/RhineLT/MNN.git
   cd MNN
   
   # 构建 MNN 框架
   ./package_scripts/ios/xcodebuildiOS.sh -o ios_build
   
   # 复制框架到 MNNLLMChat
   cp -R ios_build/MNN.framework apps/iOS/MNNLLMChat/
   
   # 在较新的 Xcode 中构建
   cd apps/iOS/MNNLLMChat
   xcodebuild -project MNNLLMiOS.xcodeproj -scheme MNNLLMiOS -sdk iphoneos
   ```

2. **使用预构建二进制文件**
   - 从 Actions artifacts 下载 MNN.framework
   - 在本地 Xcode 中打开 MNNLLMChat 项目
   - 手动链接框架并构建

#### 方案 3: 创建兼容的项目文件
如果需要完全兼容，可以：
1. 移除 `PBXFileSystemSynchronized` 相关配置
2. 手动添加源文件引用
3. 使用传统的 PBXGroup 结构

### 📱 当前状态
- ✅ MNN.framework 构建成功
- ✅ demo.ipa 和 Playground.ipa 可以生成
- ⚠️ MNNLLMChat.ipa 需要项目格式修复

### 🚀 推荐操作
1. 先获取 MNN.framework 和其他应用
2. 如需 MNNLLMChat，使用本地构建方法
3. 或等待项目格式兼容性修复

### 💡 未来改进
- 创建兼容 Xcode 15.4 的项目配置
- 或升级 GitHub Actions 到更新的 Xcode 版本
- 提供预构建的 MNNLLMChat IPA 文件
