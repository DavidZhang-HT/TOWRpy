#!/usr/bin/env python3

import sys
import os
import numpy as np
from ctypes import *

def test_basic_imports():
    """测试基本模块导入"""
    print("Testing basic imports...")
    
    try:
        import pybullet as p
        print("✓ PyBullet imported successfully")
    except ImportError as e:
        print(f"✗ PyBullet import failed: {e}")
        return False
    
    try:
        import numpy as np
        print("✓ NumPy imported successfully")
    except ImportError as e:
        print(f"✗ NumPy import failed: {e}")
        return False
    
    return True

def test_towr_library():
    """测试TOWR动态库加载"""
    print("\nTesting TOWR library...")
    
    try:
        # 设置动态库路径
        os.environ['DYLD_LIBRARY_PATH'] = '/usr/local/lib:' + os.environ.get('DYLD_LIBRARY_PATH', '')
        
        # 加载TOWR库
        lib_path = "./build/libtowr_anymal_dll.dylib"
        if not os.path.exists(lib_path):
            print(f"✗ Library file not found: {lib_path}")
            return False
            
        lib = CDLL(lib_path)
        print(f"✓ TOWR library loaded successfully from {lib_path}")
        return True
        
    except OSError as e:
        print(f"✗ TOWR library loading failed: {e}")
        return False

def test_pybullet_basic():
    """测试PyBullet基本功能"""
    print("\nTesting PyBullet basic functionality...")
    
    try:
        import pybullet as p
        import pybullet_data
        
        # 连接到物理引擎 (DIRECT模式，不显示GUI)
        p.connect(p.DIRECT)
        print("✓ PyBullet physics engine connected")
        
        # 加载一个简单的平面
        plane = p.loadURDF(os.path.join(pybullet_data.getDataPath(), "plane.urdf"))
        print("✓ Plane URDF loaded successfully")
        
        # 设置重力
        p.setGravity(0, 0, -10)
        print("✓ Gravity set successfully")
        
        # 断开连接
        p.disconnect()
        print("✓ PyBullet disconnected successfully")
        
        return True
        
    except Exception as e:
        print(f"✗ PyBullet basic test failed: {e}")
        return False

def test_robot_model():
    """测试机器人模型加载"""
    print("\nTesting robot model loading...")
    
    try:
        robot_path = "./rsc/anymal/anymal_no_mass.urdf"
        if not os.path.exists(robot_path):
            print(f"✗ Robot URDF file not found: {robot_path}")
            return False
        
        print(f"✓ Robot URDF file found: {robot_path}")
        
        import pybullet as p
        p.connect(p.DIRECT)
        
        try:
            robot = p.loadURDF(robot_path)
            print("✓ Robot URDF loaded successfully")
            p.disconnect()
            return True
        except Exception as e:
            print(f"✗ Robot URDF loading failed: {e}")
            p.disconnect()
            return False
            
    except Exception as e:
        print(f"✗ Robot model test failed: {e}")
        return False

def main():
    """主测试函数"""
    print("="*50)
    print("TOWRpy System Test")
    print("="*50)
    
    tests = [
        test_basic_imports,
        test_towr_library,
        test_pybullet_basic,
        test_robot_model
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
        print()
    
    print("="*50)
    print(f"Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! TOWRpy is ready to use.")
        return True
    else:
        print("❌ Some tests failed. Please check the issues above.")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1) 