# iOS构建本地测试脚本

#!/bin/bash

# 设置错误时退出
set -e

echo "🚀 开始构建MNN iOS应用..."

# 检查是否在MNN根目录
if [ ! -f "CMakeLists.txt" ] || [ ! -d "apps/iOS/MNNLLMChat" ]; then
    echo "❌ 错误：请在MNN根目录运行此脚本"
    exit 1
fi

# 清理之前的构建
echo "🧹 清理之前的构建文件..."
rm -rf MNN-iOS-CPU-GPU
rm -rf ios_build
rm -rf build
rm -f apps/iOS/MNNLLMChat/MNN.framework

# 构建MNN框架
echo "🔨 构建MNN框架..."
sh package_scripts/ios/buildiOS.sh "
-DMNN_ARM82=ON
-DMNN_LOW_MEMORY=ON
-DMNN_SUPPORT_TRANSFORMER_FUSE=ON
-DMNN_BUILD_LLM=ON
-DMNN_CPU_WEIGHT_DEQUANT_GEMM=ON
-DMNN_METAL=ON
-DMNN_BUILD_DIFFUSION=ON
-DMNN_OPENCL=OFF
-DMNN_SEP_BUILD=OFF
-DLLM_SUPPORT_AUDIO=ON
-DMNN_BUILD_AUDIO=ON
-DLLM_SUPPORT_VISION=ON
-DMNN_BUILD_OPENCV=ON
-DMNN_IMGCODECS=ON
"

# 查找并复制MNN框架
echo "📁 复制MNN框架到iOS项目..."
if [ -d "MNN-iOS-CPU-GPU/Static/MNN.framework" ]; then
    cp -R MNN-iOS-CPU-GPU/Static/MNN.framework apps/iOS/MNNLLMChat/
    echo "✅ MNN.framework 复制成功"
elif [ -d "ios_build/MNN.framework" ]; then
    cp -R ios_build/MNN.framework apps/iOS/MNNLLMChat/
    echo "✅ MNN.framework 从 ios_build 复制成功"
else
    echo "❌ 错误：找不到 MNN.framework"
    echo "正在搜索可能的位置..."
    find . -name "MNN.framework" -type d 2>/dev/null | head -5
    exit 1
fi

# 进入iOS项目目录
cd apps/iOS/MNNLLMChat

# 解析Swift包依赖
echo "📦 解析Swift包依赖..."
xcodebuild -resolvePackageDependencies -project MNNLLMiOS.xcodeproj

# 检查是否有代码签名配置
if [ -n "$APPLE_TEAM_ID" ]; then
    echo "🔐 使用代码签名构建..."
    
    # 构建并归档
    xcodebuild archive \
        -project MNNLLMiOS.xcodeproj \
        -scheme MNNLLMiOS \
        -destination "generic/platform=iOS" \
        -archivePath MNNLLMiOS.xcarchive \
        -configuration Release \
        DEVELOPMENT_TEAM="$APPLE_TEAM_ID" \
        CODE_SIGN_STYLE=Automatic \
        -allowProvisioningUpdates
    
    echo "✅ Archive 构建成功"
    
    # 如果有导出选项，尝试导出IPA
    if [ -f "ExportOptions.plist" ]; then
        echo "📱 导出IPA文件..."
        xcodebuild -exportArchive \
            -archivePath MNNLLMiOS.xcarchive \
            -exportPath export \
            -exportOptionsPlist ExportOptions.plist \
            -allowProvisioningUpdates
        
        if [ -f "export/MNNLLMiOS.ipa" ]; then
            echo "✅ IPA文件生成成功: export/MNNLLMiOS.ipa"
        fi
    fi
else
    echo "⚠️  未配置代码签名，执行测试构建..."
    
    # 无签名构建（仅验证编译）
    xcodebuild build \
        -project MNNLLMiOS.xcodeproj \
        -scheme MNNLLMiOS \
        -destination "generic/platform=iOS" \
        -configuration Release \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO
    
    echo "✅ 测试构建成功（无签名）"
fi

echo "🎉 构建完成！"
echo ""
echo "📋 构建结果："
echo "  - MNN框架: ✅"
echo "  - iOS应用: ✅"
if [ -f "export/MNNLLMiOS.ipa" ]; then
    echo "  - IPA文件: ✅ (export/MNNLLMiOS.ipa)"
    echo ""
    echo "📱 安装说明："
    echo "  1. 连接iPad到Mac"
    echo "  2. 打开Xcode → Window → Devices and Simulators"
    echo "  3. 选择iPad → 点击'+' → 选择IPA文件安装"
elif [ -d "MNNLLMiOS.xcarchive" ]; then
    echo "  - Archive: ✅ (MNNLLMiOS.xcarchive)"
    echo ""
    echo "📝 后续步骤："
    echo "  1. 配置代码签名证书"
    echo "  2. 设置环境变量 APPLE_TEAM_ID"
    echo "  3. 重新运行脚本生成IPA"
else
    echo "  - 编译验证: ✅"
    echo ""
    echo "📝 提示："
    echo "  - 当前为测试构建，需要证书才能生成可安装的IPA"
    echo "  - 可以在Xcode中手动构建和安装到设备"
fi
