# TOWRpy 运行指南

## 🎉 恭喜！TOWRpy 已成功安装并可以在您的 MacBook 上运行

### 📋 系统要求
- ✅ macOS (已测试)
- ✅ Python 3.13+ (已安装)
- ✅ CMake 4.0+ (已安装)
- ✅ 必需的C++库已安装:
  - ifopt (优化库)
  - TOWR (轨迹优化)
  - Eigen3 (线性代数)

### 🚀 快速开始

#### 1. 设置环境
```bash
# 在TOWRpy目录中运行
./setup_env.sh
```

#### 2. 运行系统测试
```bash
python3 test_towr.py
```

#### 3. 运行快速演示
```bash
python3 quick_test.py
```

#### 4. 交互式演示
```bash
python3 run_towr_demo.py
```

### 🎮 可用的演示模式

#### 地形类型
- **0**: 平地 - 标准平面行走
- **2**: 楼梯 - 爬楼梯演示

#### 步态模式
- **0**: 重叠步行 (Overlap Walk)
- **1**: 飞奔步态 (Fly Trot) - 推荐
- **2**: 对步步态 (Pace)
- **3**: 跳跃步态 (Bound)
- **4**: 驰骋步态 (Gallop)

#### 目标位置示例
- 前进1米: `[1.0, 0.0, 0.54]`
- 前进并向右: `[1.5, 0.5, 0.54]`
- 前进并向左: `[0.5, -0.3, 0.54]`

### 🤖 理解仿真

仿真中您会看到两个机器人:
- **绿色机器人**: 显示TOWR生成的理想轨迹
- **灰色机器人**: 实际的物理仿真机器人

### 📁 项目结构
```
TOWRpy/
├── build/                      # 编译输出
│   └── libtowr_anymal_dll.dylib  # TOWR动态库
├── rsc/anymal/                 # 机器人模型文件
├── towr_position_control.py    # 主要控制脚本
├── test_towr.py               # 系统测试
├── quick_test.py              # 快速演示
├── run_towr_demo.py           # 交互式演示
├── setup_env.sh               # 环境设置脚本
└── RUN_GUIDE.md               # 本指南
```

### 🔧 故障排除

#### 如果遇到库加载错误:
```bash
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH
```

#### 如果PyBullet GUI不显示:
确保您的系统支持GUI显示，或者修改代码使用 `p.DIRECT` 模式。

#### 如果编译失败:
```bash
cd build
make clean
cmake ..
make -j4
```

### 🎯 下一步

1. **修改参数**: 编辑脚本中的目标位置、步态等参数
2. **添加新地形**: 扩展地形模型
3. **自定义机器人**: 添加新的URDF模型
4. **学习TOWR**: 查看 [TOWR文档](https://github.com/ethz-adrl/towr)

### 📞 获取帮助

如果遇到问题:
1. 运行 `python3 test_towr.py` 检查系统状态
2. 检查 `./setup_env.sh` 的输出
3. 查看TOWRpy和TOWR的GitHub页面

### 🏆 成就解锁
✅ 成功安装了复杂的机器人学软件栈  
✅ 配置了跨平台的C++/Python混合项目  
✅ 掌握了TOWR轨迹优化工具  
✅ 可以运行四足机器人仿真  

**开始探索机器人运动规划的世界吧！** 🚀🤖 