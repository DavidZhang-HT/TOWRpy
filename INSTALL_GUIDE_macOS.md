# TOWRpy MacBook 安装指南

## 📋 概述
本指南将引导您在macOS系统上从零开始安装TOWRpy（TOWR轨迹优化的Python接口）。TOWRpy是一个复杂的机器人学软件，需要多个C++依赖库。

## 🖥️ 系统要求

### 必需环境
- **操作系统**: macOS 10.15+ (推荐 macOS 11+)
- **CPU架构**: Intel x86_64 或 Apple Silicon (M1/M2/M3)
- **内存**: 至少 4GB RAM
- **存储**: 至少 2GB 可用空间

### 预安装软件
确保以下软件已安装：

#### 1. Homebrew
```bash
# 安装Homebrew（如果未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 2. 基础开发工具
```bash
# 安装Xcode命令行工具
xcode-select --install

# 安装基础工具
brew install cmake git python@3.13
```

#### 3. 验证安装
```bash
# 检查版本
cmake --version    # 应该显示 3.5+
python3 --version  # 应该显示 3.13+
git --version      # 应该显示 git 信息
```

## 🚀 第一阶段：安装基础依赖

### 1. 安装数学库依赖
```bash
# 安装Eigen3线性代数库
brew install eigen

# 安装IPOPT优化库
brew install ipopt
```

### 2. 验证基础依赖
```bash
# 检查Eigen3
brew list | grep eigen

# 检查IPOPT
brew list | grep ipopt
```

## 🔧 第二阶段：编译安装C++库依赖

### 1. 创建依赖安装目录
```bash
cd /path/to/your/workspace  # 替换为您的工作目录
mkdir -p deps
cd deps
```

### 2. 安装ifopt优化库

#### 下载源码
```bash
git clone https://github.com/ethz-adrl/ifopt.git
cd ifopt
```

#### 编译安装
```bash
mkdir build && cd build

# 配置构建（处理CMake版本兼容性）
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5

# 编译（使用多核心加速）
make -j4

# 安装到系统
sudo make install
```

#### 验证安装
```bash
# 检查ifopt库文件
ls -la /usr/local/lib/*ifopt*
ls -la /usr/local/include/ifopt/
```

### 3. 安装TOWR轨迹优化库

#### 返回依赖目录
```bash
cd ../../  # 回到deps目录
```

#### 下载源码
```bash
git clone https://github.com/ethz-adrl/towr.git
cd towr/towr  # 注意：进入子目录towr
```

#### 编译安装
```bash
mkdir build && cd build

# 配置构建
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5

# 编译
make -j4

# 安装到系统
sudo make install
```

#### 验证安装
```bash
# 检查TOWR库文件
ls -la /usr/local/lib/*towr*
ls -la /usr/local/include/towr/
```

## 🐍 第三阶段：配置Python环境

### 1. 进入TOWRpy项目目录
```bash
cd /path/to/TOWRpy  # 替换为TOWRpy项目的实际路径
```

### 2. 设置Python虚拟环境（如果不存在）
```bash
# 创建虚拟环境
python3 -m venv .venv

# 激活虚拟环境
source .venv/bin/activate

# 安装Python依赖
pip install numpy pybullet
```

### 3. 验证Python环境
```bash
python3 -c "import pybullet; print('PyBullet OK')"
python3 -c "import numpy; print('NumPy OK')"
```

## 🛠️ 第四阶段：编译TOWRpy项目

### 1. 修复CMakeLists.txt
由于原项目包含不必要的raisimOgre依赖，需要修改配置文件：

```bash
# 编辑CMakeLists.txt
nano CMakeLists.txt  # 或使用您喜欢的编辑器
```

**修改内容**（注释掉raisimOgre相关行）：
```cmake
# 在第6行左右，注释掉：
# find_package(raisimOgre CONFIG REQUIRED)

# 在第21行左右，注释掉：
# target_link_libraries(${lib_name} PUBLIC raisim::raisimOgre)
```

### 2. 清理并重新构建
```bash
# 清理旧的构建文件
rm -rf build
mkdir build
cd build
```

### 3. 配置和编译项目
```bash
# CMake配置
cmake ..

# 编译（应该看到成功消息）
make -j4
```

### 4. 验证编译结果
```bash
# 检查生成的动态库
ls -la *.dylib
# 应该看到：libtowr_anymal_dll.dylib
```

## 🧪 第五阶段：环境配置和测试

### 1. 设置环境变量
```bash
# 设置动态库路径（每次使用前需要）
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH
```

### 2. 测试库加载
```bash
cd ..  # 回到TOWRpy根目录

# 测试动态库加载
python3 -c "
import ctypes
import os
os.environ['DYLD_LIBRARY_PATH'] = '/usr/local/lib:' + os.environ.get('DYLD_LIBRARY_PATH', '')
lib = ctypes.CDLL('./build/libtowr_anymal_dll.dylib')
print('✓ TOWR library loaded successfully!')
"
```

### 3. 运行完整系统测试
```bash
# 如果存在测试脚本，运行：
python3 test_towr.py
```

## 🎯 第六阶段：创建便利脚本

### 1. 创建环境设置脚本
创建 `setup_env.sh`：
```bash
cat > setup_env.sh << 'EOF'
#!/bin/bash
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH
if [ -d ".venv" ]; then
    source .venv/bin/activate
    echo "✓ Environment ready for TOWRpy"
else
    echo "⚠ Virtual environment not found"
fi
EOF

chmod +x setup_env.sh
```

### 2. 测试完整安装
```bash
# 使用设置脚本
./setup_env.sh

# 运行快速测试
python3 -c "
import os
os.environ['DYLD_LIBRARY_PATH'] = '/usr/local/lib:' + os.environ.get('DYLD_LIBRARY_PATH', '')
from towr_position_control import run_towr_tracking_position_control
print('✓ Ready to run TOWR simulations!')
"
```

## 🚨 常见问题和解决方案

### 问题1：CMake版本兼容性错误
**错误**：`Compatibility with CMake < 3.5 has been removed`
**解决**：
```bash
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5
```

### 问题2：库文件找不到
**错误**：`Library not loaded: @rpath/libifopt_ipopt.dylib`
**解决**：
```bash
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH
```

### 问题3：Python导入错误
**错误**：`ModuleNotFoundError: No module named 'pybullet'`
**解决**：
```bash
source .venv/bin/activate
pip install pybullet numpy
```

### 问题4：raisimOgre依赖错误
**错误**：`Could not find a package configuration file provided by "raisimOgre"`
**解决**：注释掉CMakeLists.txt中的raisimOgre相关行

### 问题5：权限错误
**错误**：`Permission denied`
**解决**：
```bash
sudo make install  # 安装依赖时
chmod +x setup_env.sh  # 脚本权限
```

## 🎉 验证完整安装

运行以下命令验证安装成功：

```bash
# 1. 环境设置
./setup_env.sh

# 2. 系统测试
python3 test_towr.py

# 3. 快速演示（可选，会打开GUI）
python3 quick_test.py
```

如果所有测试通过，恭喜您成功安装了TOWRpy！

## 📝 安装时间估算

- **总时间**: 30-60分钟
- **下载时间**: 5-10分钟（取决于网络）
- **编译时间**: 15-30分钟（取决于机器性能）
- **配置时间**: 5-10分钟

## 💡 后续使用提示

1. **每次使用前**：运行 `./setup_env.sh`
2. **永久设置**：将环境变量添加到 `~/.bashrc` 或 `~/.zshrc`
3. **更新项目**：重新编译时清理build目录

## 📚 相关资源

- [TOWR官方文档](https://github.com/ethz-adrl/towr)
- [PyBullet文档](https://pybullet.org/)
- [ifopt文档](https://github.com/ethz-adrl/ifopt)

---

**安装完成后，您就可以开始探索四足机器人的轨迹优化世界了！** 🤖✨ 