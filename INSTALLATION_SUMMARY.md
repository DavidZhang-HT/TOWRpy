# TOWRpy 安装总结

## 🎯 快速安装（推荐）

### 方法1：一键自动安装
```bash
# 克隆项目后，在TOWRpy目录运行：
./install_script.sh
```

### 方法2：手动安装
详细步骤请查看：[INSTALL_GUIDE_macOS.md](./INSTALL_GUIDE_macOS.md)

## 📁 安装后的文件结构

```
TOWRpy/
├── build/libtowr_anymal_dll.dylib  # 编译好的TOWR库
├── .venv/                          # Python虚拟环境
├── setup_env.sh                    # 环境设置脚本 ⭐
├── test_towr.py                    # 系统测试 ⭐
├── quick_test.py                   # 快速演示 ⭐
├── run_towr_demo.py               # 交互式演示
├── towr_position_control.py       # 主控制脚本
├── INSTALL_GUIDE_macOS.md         # 详细安装指南
├── RUN_GUIDE.md                   # 使用指南
└── rsc/anymal/                    # 机器人模型文件
```

## 🚀 验证安装

```bash
# 1. 设置环境
./setup_env.sh

# 2. 运行测试
python3 test_towr.py

# 3. 快速演示（可选）
python3 quick_test.py
```

## 🔧 已安装的依赖

### 系统级C++库
- ✅ **Eigen3** - 线性代数库
- ✅ **IPOPT** - 非线性优化求解器  
- ✅ **ifopt** - C++优化接口库
- ✅ **TOWR** - 轨迹优化库

### Python环境
- ✅ **Python 3.13+** - 虚拟环境
- ✅ **NumPy** - 数值计算
- ✅ **PyBullet** - 物理仿真引擎

## 🎮 使用示例

### 基本用法
```bash
./setup_env.sh
python3 -c "
import os
os.environ['DYLD_LIBRARY_PATH'] = '/usr/local/lib:' + os.environ.get('DYLD_LIBRARY_PATH', '')
from towr_position_control import run_towr_tracking_position_control

# 四足机器人前进1米
run_towr_tracking_position_control(
    target_pos=[1.0, 0.0, 0.54],
    target_angle=[0, 0, 0],
    terrain_id=0,    # 0=平地, 2=楼梯
    gait_pattern=1   # 1=飞奔步态
)
"
```

### 步态选项
- `0` - 重叠步行 (Overlap Walk)
- `1` - 飞奔步态 (Fly Trot) 🏃‍♂️
- `2` - 对步步态 (Pace)  
- `3` - 跳跃步态 (Bound)
- `4` - 驰骋步态 (Gallop)

### 地形选项  
- `0` - 平地行走 🏞️
- `2` - 楼梯攀爬 🏗️

## 🚨 常见问题

### Q: 库加载失败？
```bash
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH
```

### Q: Python模块找不到？
```bash
source .venv/bin/activate
```

### Q: 重新编译项目？
```bash
cd build && make clean && cmake .. && make -j4
```

## 🏆 技术成就

通过这次安装，您已经掌握了：
- ✅ 复杂机器人学软件的安装配置
- ✅ C++/Python混合项目的构建
- ✅ 现代轨迹优化工具的使用
- ✅ 四足机器人仿真环境的搭建

## 📞 获取帮助

如果遇到问题：
1. 查看 [INSTALL_GUIDE_macOS.md](./INSTALL_GUIDE_macOS.md) 详细说明
2. 运行 `python3 test_towr.py` 诊断系统
3. 检查 GitHub Issues 或提交新问题

---

**🎉 恭喜！您已成功安装TOWRpy，开始探索四足机器人的运动世界吧！** 🤖✨ 