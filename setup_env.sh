#!/bin/bash

# TOWRpy 环境设置脚本
# 用于在macOS上设置运行TOWRpy所需的环境变量

echo "========================================"
echo "TOWRpy Environment Setup"
echo "========================================"

# 设置动态库路径
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH

# 激活Python虚拟环境
if [ -d ".venv" ]; then
    echo "Activating Python virtual environment..."
    source .venv/bin/activate
    echo "✓ Virtual environment activated"
else
    echo "⚠ Virtual environment not found. Using system Python."
fi

# 检查依赖
echo ""
echo "Checking dependencies..."

# 检查Python模块
python3 -c "import pybullet; print('✓ PyBullet available')" 2>/dev/null || echo "✗ PyBullet not available"
python3 -c "import numpy; print('✓ NumPy available')" 2>/dev/null || echo "✗ NumPy not available"

# 检查TOWR库
if [ -f "./build/libtowr_anymal_dll.dylib" ]; then
    echo "✓ TOWR library found"
else
    echo "✗ TOWR library not found. Please run 'make' in build directory."
fi

# 检查机器人模型
if [ -f "./rsc/anymal/anymal_no_mass.urdf" ]; then
    echo "✓ Robot model files found"
else
    echo "✗ Robot model files not found"
fi

echo ""
echo "Environment setup complete!"
echo ""
echo "Available commands:"
echo "  python3 test_towr.py       - Run system tests"
echo "  python3 quick_test.py      - Run a quick TOWR demo"
echo "  python3 run_towr_demo.py   - Interactive TOWR demo"
echo ""
echo "Environment variables set:"
echo "  DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH"

# 如果在.bashrc或.zshrc中没有设置，提醒用户
echo ""
echo "To make these settings permanent, add this to your ~/.bashrc or ~/.zshrc:"
echo "export DYLD_LIBRARY_PATH=/usr/local/lib:\$DYLD_LIBRARY_PATH" 