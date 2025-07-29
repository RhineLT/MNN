# 🚀 快速构建iOS应用

## 一键构建（无需证书）

如果您只想测试编译，无需配置任何证书：

1. Fork这个仓库到您的GitHub账户
2. 进入 Actions → iOS App Build and Release → Run workflow
3. 等待构建完成，下载artifacts中的文件

## 生成可安装IPA（需要证书）

### 步骤1：获取Apple开发者证书
1. 登录 [Apple Developer](https://developer.apple.com)
2. 创建iOS开发证书并下载 `.p12` 文件
3. 记录您的Team ID（10位字符）

### 步骤2：配置GitHub Secrets
在您的GitHub仓库中：`Settings` → `Secrets and variables` → `Actions`

添加以下Secrets：
```
APPLE_TEAM_ID = 您的10位Team ID
CERTIFICATE_PASSWORD = P12证书密码
KEYCHAIN_PASSWORD = 任意强密码
IOS_CERTIFICATE_P12_BASE64 = P12证书的Base64编码
```

获取Base64编码：
```bash
base64 -i YourCertificate.p12 | pbcopy
```

### 步骤3：运行构建
1. 推送代码或手动触发工作流
2. 等待构建完成
3. 下载生成的 `MNNLLMiOS.ipa` 文件

### 步骤4：安装到iPad
使用Xcode的设备管理器将IPA安装到iPad：
1. 连接iPad到Mac
2. 打开Xcode → Window → Devices and Simulators
3. 选择iPad → 点击"+" → 选择IPA文件

## 🎯 发布Release版本

创建并推送tag即可自动发布：
```bash
git tag v1.0.0
git push origin v1.0.0
```

## 📱 系统要求
- iOS 14.0+
- 推荐7B参数以下的模型（避免内存问题）

## ❓ 遇到问题？
查看完整文档：[iOS应用自动构建说明](./ios-app-build-guide.md)
