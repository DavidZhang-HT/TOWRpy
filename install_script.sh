#!/bin/bash

# TOWRpy 自动安装脚本 for macOS
# 这个脚本将自动安装TOWRpy所需的所有依赖

set -e  # 遇到错误立即退出

echo "========================================"
echo "TOWRpy Auto-Installer for macOS"
echo "========================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}✗ $1 is not installed${NC}"
        return 1
    else
        echo -e "${GREEN}✓ $1 is available${NC}"
        return 0
    fi
}

# 检查系统要求
echo "Checking system requirements..."
echo "--------------------------------"

# 检查Homebrew
if ! check_command brew; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 检查基础工具
if ! check_command cmake; then
    echo -e "${YELLOW}Installing CMake...${NC}"
    brew install cmake
fi

if ! check_command python3; then
    echo -e "${YELLOW}Installing Python3...${NC}"
    brew install python@3.13
fi

if ! check_command git; then
    echo -e "${YELLOW}Installing Git...${NC}"
    brew install git
fi

echo ""
echo "Installing base dependencies..."
echo "-------------------------------"

# 安装基础依赖
echo -e "${YELLOW}Installing Eigen3 and IPOPT...${NC}"
brew install eigen ipopt

echo ""
echo "Installing C++ library dependencies..."
echo "--------------------------------------"

# 创建临时目录
TEMP_DIR="/tmp/towr_deps_$$"
mkdir -p $TEMP_DIR
cd $TEMP_DIR

echo -e "${YELLOW}Installing ifopt...${NC}"
git clone https://github.com/ethz-adrl/ifopt.git
cd ifopt
mkdir build && cd build
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5
make -j4
echo -e "${YELLOW}Installing ifopt (requires sudo)...${NC}"
sudo make install
echo -e "${GREEN}✓ ifopt installed${NC}"

cd $TEMP_DIR
echo -e "${YELLOW}Installing TOWR...${NC}"
git clone https://github.com/ethz-adrl/towr.git
cd towr/towr
mkdir build && cd build
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5
make -j4
echo -e "${YELLOW}Installing TOWR (requires sudo)...${NC}"
sudo make install
echo -e "${GREEN}✓ TOWR installed${NC}"

# 清理临时文件
cd /
rm -rf $TEMP_DIR

echo ""
echo "Setting up Python environment..."
echo "--------------------------------"

# 返回项目目录（假设脚本在TOWRpy目录中运行）
cd "$(dirname "$0")"

# 创建虚拟环境（如果不存在）
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}Creating Python virtual environment...${NC}"
    python3 -m venv .venv
fi

# 激活虚拟环境并安装依赖
echo -e "${YELLOW}Installing Python dependencies...${NC}"
source .venv/bin/activate
pip install --upgrade pip
pip install numpy pybullet

echo ""
echo "Configuring TOWRpy project..."
echo "-----------------------------"

# 检查并修复CMakeLists.txt
if grep -q "find_package(raisimOgre CONFIG REQUIRED)" CMakeLists.txt; then
    echo -e "${YELLOW}Fixing CMakeLists.txt...${NC}"
    sed -i.bak 's/find_package(raisimOgre CONFIG REQUIRED)/# find_package(raisimOgre CONFIG REQUIRED)/' CMakeLists.txt
    sed -i.bak 's/target_link_libraries(\${lib_name} PUBLIC raisim::raisimOgre)/# target_link_libraries(\${lib_name} PUBLIC raisim::raisimOgre)/' CMakeLists.txt
    echo -e "${GREEN}✓ CMakeLists.txt fixed${NC}"
fi

# 构建项目
echo -e "${YELLOW}Building TOWRpy...${NC}"
rm -rf build
mkdir build
cd build
cmake ..
make -j4

if [ -f "libtowr_anymal_dll.dylib" ]; then
    echo -e "${GREEN}✓ TOWRpy compiled successfully${NC}"
else
    echo -e "${RED}✗ TOWRpy compilation failed${NC}"
    exit 1
fi

cd ..

# 运行测试
echo ""
echo "Running installation test..."
echo "----------------------------"

# 设置环境并测试
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH
source .venv/bin/activate

python3 -c "
import ctypes
import os
os.environ['DYLD_LIBRARY_PATH'] = '/usr/local/lib:' + os.environ.get('DYLD_LIBRARY_PATH', '')
try:
    lib = ctypes.CDLL('./build/libtowr_anymal_dll.dylib')
    print('✓ TOWR library loads successfully')
except Exception as e:
    print(f'✗ Library loading failed: {e}')
    exit(1)
"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================"
    echo -e "🎉 Installation completed successfully!"
    echo -e "========================================${NC}"
    echo ""
    echo "To get started:"
    echo "1. Run: ./setup_env.sh"
    echo "2. Run: python3 test_towr.py"
    echo "3. Run: python3 quick_test.py"
    echo ""
    echo "For detailed usage, see RUN_GUIDE.md"
    echo ""
else
    echo -e "${RED}Installation failed. Please check the errors above.${NC}"
    exit 1
fi 