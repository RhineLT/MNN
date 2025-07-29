# iOS应用自动构建说明

这个GitHub Action工作流用于自动构建MNN iOS应用，生成可以在iPad上安装的IPA文件。

## 功能特性

- ✅ 自动构建MNN框架
- ✅ 编译iOS应用
- ✅ 生成IPA安装包
- ✅ 支持代码签名（可选）
- ✅ 自动发布到GitHub Releases
- ✅ 工件上传和下载

## 触发条件

- 推送到 `master` 分支或 `feature/**` 分支
- 修改iOS应用相关文件时自动触发
- 支持手动触发（workflow_dispatch）
- 创建tag时自动发布Release

## 配置说明

### 必需的GitHub Secrets（用于代码签名）

如果您需要生成可直接安装的IPA文件，需要在GitHub仓库设置中添加以下Secrets：

1. **APPLE_TEAM_ID** - 您的Apple开发者团队ID
   - 在Apple Developer账户中可以找到
   - 格式如：`1234567890`

2. **IOS_CERTIFICATE_P12_BASE64** - iOS开发证书的Base64编码
   ```bash
   # 将.p12证书文件转换为Base64
   base64 -i YourCertificate.p12 | pbcopy
   ```

3. **CERTIFICATE_PASSWORD** - P12证书的密码

4. **KEYCHAIN_PASSWORD** - 临时keychain的密码（可以是任意强密码）

5. **IOS_PROVISIONING_PROFILE_BASE64**（可选）- Provisioning Profile的Base64编码
   ```bash
   # 将.mobileprovision文件转换为Base64
   base64 -i YourProfile.mobileprovision | pbcopy
   ```

### 不使用代码签名（测试构建）

如果您只需要测试构建而不需要生成可安装的IPA，可以不配置上述Secrets。工作流会执行无签名构建用于验证代码编译正确性。

## 使用方法

### 1. 推送代码触发自动构建
```bash
git add .
git commit -m "Update iOS app"
git push origin master
```

### 2. 手动触发构建
在GitHub仓库页面：
1. 点击 "Actions" 标签
2. 选择 "iOS App Build and Release" 工作流
3. 点击 "Run workflow" 按钮

### 3. 创建Release版本
```bash
# 创建并推送tag
git tag v1.0.0
git push origin v1.0.0
```

## 构建产物

工作流完成后会生成以下文件：

### Artifacts（每次构建）
- **MNNLLMiOS.ipa** - 可安装的iOS应用包
- **MNNLLMiOS.xcarchive.zip** - Xcode归档文件
- **build-info.txt** - 构建信息

### GitHub Release（仅tag触发）
当推送tag时，会自动创建GitHub Release并上传IPA文件。

## 在iPad上安装应用

### 方法1：使用Xcode（推荐）
1. 下载 `MNNLLMiOS.ipa` 文件
2. 在Mac上打开Xcode
3. 连接iPad到Mac
4. 在Xcode中选择 "Window" → "Devices and Simulators"
5. 选择您的iPad，点击"+"按钮，选择IPA文件安装

### 方法2：使用TestFlight
1. 需要将应用上传到App Store Connect
2. 添加测试用户
3. 通过TestFlight分发

### 方法3：使用第三方工具
- **AltStore**：支持侧载IPA文件
- **Sideloadly**：Windows/Mac上的侧载工具
- **3uTools**：iOS设备管理工具

## 故障排除

### 常见问题

1. **MNN.framework未找到**
   - 检查MNN框架构建是否成功
   - 确认framework复制路径正确

2. **代码签名失败**
   - 检查Apple Team ID是否正确
   - 确认证书和密码配置正确
   - 验证Provisioning Profile有效性

3. **构建超时**
   - 大型项目可能需要较长构建时间
   - 可以调整工作流中的超时设置

4. **内存不足**
   - 确保使用较小的模型（推荐7B参数以下）
   - 在iOS设备上关闭其他应用

### 查看构建日志
1. 进入GitHub仓库的"Actions"页面
2. 点击失败的构建
3. 查看详细日志输出

## 自定义配置

您可以修改工作流文件 `.github/workflows/ios-app-build.yml` 来自定义：

- Xcode版本
- iOS部署目标版本
- MNN编译选项
- 构建配置
- artifact保留时间

## 注意事项

1. **证书管理**：保管好您的开发者证书和私钥
2. **Bundle ID**：确保Bundle ID在您的开发者账户中已注册
3. **设备兼容性**：测试不同iOS版本和设备型号
4. **模型大小**：考虑iOS设备内存限制，选择合适的模型大小
5. **网络访问**：首次运行可能需要下载依赖，确保网络稳定

## 安全建议

- 定期更新开发者证书
- 使用强密码保护P12证书
- 限制GitHub Secrets的访问权限
- 定期检查和轮换敏感信息
