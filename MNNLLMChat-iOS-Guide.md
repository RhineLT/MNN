# MNNLLMChat iOS 应用构建指南

## 🤖 应用介绍

**MNNLLMChat** 是基于 MNN 引擎开发的本地大语言模型聊天应用，提供完全本地化的 AI 对话体验。

### ✨ 核心特性

1. **🔒 完全本地运行**
   - 所有推理计算在本地完成
   - 保护用户隐私，数据不上传
   - 无网络连接也可使用

2. **🎯 多模态对话支持**
   - 📝 文本到文本对话
   - 🎤 语音到文本输入
   - 📸 图片理解和描述
   - 📱 支持拍照和图库选择

3. **📚 智能模型管理**
   - 模型市场浏览和搜索
   - 自动下载和管理模型
   - 支持多种下载源切换
   - 模型置顶和自定义排序

4. **⚡ 性能监控**
   - 实时性能基准测试
   - Prefill/Decode 速度监控
   - 内存使用量统计
   - 配置优化建议

5. **💾 完整历史记录**
   - 对话历史管理
   - 会话恢复功能
   - 搜索历史对话

## 🏗️ 构建流程

### 自动构建（推荐）
通过 GitHub Actions 自动构建：
1. 首先构建 MNN.framework
2. 复制框架到 MNNLLMChat 项目
3. 编译 MNNLLMChat 应用
4. 生成 `MNNLLMChat.ipa` 安装包

### 手动构建
```bash
# 1. 构建 MNN 框架
cd project/ios
xcodebuild build -project MNN.xcodeproj -scheme MNN -sdk iphoneos

# 2. 构建 MNNLLMChat
cd ../../apps/iOS/MNNLLMChat
cp ../../../project/ios/build/Release-iphoneos/MNN.framework ./
xcodebuild build -project MNNLLMiOS.xcodeproj -scheme MNNLLMiOS -sdk iphoneos

# 3. 创建 IPA
mkdir Payload
cp -R build/Release-iphoneos/MNNLLMiOS.app Payload/
zip -r MNNLLMChat.ipa Payload/
```

## 📱 安装和使用

### 安装方式
1. **Xcode 安装**（推荐）
   - 打开 Xcode > Window > Devices and Simulators
   - 连接 iOS 设备
   - 拖拽 `MNNLLMChat.ipa` 到设备应用列表

2. **命令行安装**
   ```bash
   npm install -g ios-deploy
   ios-deploy --bundle MNNLLMChat.ipa
   ```

3. **第三方工具**
   - 3uTools、iMazing 等工具
   - AltStore（需要开发者账号）

### 首次使用
1. **信任开发者证书**
   - 设置 > 通用 > VPN与设备管理
   - 找到开发者证书并点击信任

2. **下载模型**
   - 打开应用后进入"模型市场"
   - 选择合适的模型进行下载
   - 推荐模型：Qwen2.5、ChatGLM、Llama 等

3. **开始对话**
   - 模型下载完成后即可开始对话
   - 支持文本、语音、图片多种输入方式

## 🔧 配置选项

### 模型配置
- **mmap**: 内存映射优化
- **采样策略**: 控制生成文本的随机性
- **扩散设置**: 图像生成相关配置

### 性能优化
- **并行线程数**: 根据设备调整
- **内存限制**: 防止应用崩溃
- **缓存策略**: 提升响应速度

## 🛠️ 故障排除

### 常见问题
1. **应用无法启动**
   - 检查是否信任开发者证书
   - 确认设备支持 iOS 12.0 以上

2. **模型下载失败**
   - 检查网络连接
   - 尝试切换下载源
   - 确认存储空间充足

3. **对话响应慢**
   - 调整采样策略
   - 选择较小的模型
   - 关闭其他占用资源的应用

4. **内存不足**
   - 选择量化版本模型
   - 调整 mmap 设置
   - 重启应用释放内存

## 📖 更多资源

- [MNN 官方文档](https://mnn-docs.readthedocs.io/)
- [MNNLLMChat 源码](./apps/iOS/MNNLLMChat/)
- [模型转换工具](https://github.com/alibaba/MNN/tree/master/tools/converter)
- [性能优化指南](./docs/)

---

**享受本地 AI 对话的乐趣！🚀**
