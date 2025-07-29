# MNN iOS 应用程序安装指南

本文档说明如何安装和使用从 GitHub Actions 构建的 MNN iOS 应用程序。

## 📦 构建产物

构建完成后，您将获得以下文件：

- **MNN.framework** - MNN 框架库，可集成到其他iOS项目中
- **demo.ipa** - MNN 演示应用程序，展示基本的机器学习推理功能
- **Playground.ipa** - MNN 测试应用程序，用于开发和测试

## 🛠 安装方法

### 方法1：通过 Xcode 安装

1. 打开 Xcode
2. 选择菜单 `Window` > `Devices and Simulators`
3. 连接您的 iOS 设备并选择它
4. 将 `.ipa` 文件拖拽到 `Installed Apps` 区域
5. 等待安装完成

### 方法2：通过命令行安装

首先安装 ios-deploy 工具：
```bash
npm install -g ios-deploy
```

然后安装应用：
```bash
ios-deploy --bundle demo.ipa
# 或
ios-deploy --bundle Playground.ipa
```

### 方法3：通过第三方工具

- **3uTools**：将 IPA 文件拖拽到应用列表中
- **iMazing**：使用应用管理功能安装
- **AltStore**：需要开发者账号，支持侧载安装

## ⚠️ 重要注意事项

### 代码签名问题

这些应用程序没有有效的代码签名，因此：

1. **只能在开发设备上安装**：需要设备已注册到开发者账号
2. **越狱设备**：可以绕过代码签名验证
3. **企业分发**：需要企业开发者账号重新签名

### 信任开发者

安装后需要手动信任开发者证书：

1. 打开 `设置` > `通用` > `VPN与设备管理`
2. 找到对应的开发者配置文件
3. 点击 `信任 "开发者名称"`

### 系统兼容性

- **最低系统要求**：iOS 9.0+（Playground）/ iOS 11.0+（demo）
- **设备支持**：iPhone 和 iPad
- **架构支持**：arm64, armv7, armv7s

## 🚀 应用功能

### Demo 应用
- 图像分类演示
- 模型推理性能测试
- 相机实时检测

### Playground 应用
- 基础 MNN 功能测试
- 开发调试工具
- API 使用示例

## 🔧 开发者信息

如果您是开发者，想要修改和重新构建这些应用：

1. 克隆 MNN 仓库
2. 打开 `project/ios/MNN.xcodeproj`
3. 选择对应的 target（demo 或 Playground）
4. 配置您的开发者账号和证书
5. 构建并安装到设备

## 📞 技术支持

如果遇到安装或使用问题：

1. 检查设备系统版本是否满足要求
2. 确认设备已连接到网络
3. 尝试重启设备后重新安装
4. 查看 GitHub Issues 寻找类似问题

---

*本指南基于 MNN 项目的 iOS 构建配置。如有疑问，请参考官方文档或提交 Issue。*
