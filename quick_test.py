#!/usr/bin/env python3

import os
import sys

# 设置动态库路径
os.environ['DYLD_LIBRARY_PATH'] = '/usr/local/lib:' + os.environ.get('DYLD_LIBRARY_PATH', '')

try:
    from towr_position_control import run_towr_tracking_position_control
    print('✓ TOWR position control module imported successfully')
    
    print('\nTesting TOWR with basic parameters...')
    print('Target: Move 1 meter forward on flat ground with trot gait')
    print('This will open PyBullet GUI...')
    
    # 运行基本测试
    run_towr_tracking_position_control(
        target_pos=[1.0, 0.0, 0.54],
        target_angle=[0, 0, 0], 
        terrain_id=0,  # 平地
        gait_pattern=1  # 飞奔步态
    )
    
    print('✓ TOWR simulation completed successfully!')
    
except Exception as e:
    print(f'✗ Error running TOWR: {e}')
    import traceback
    traceback.print_exc() 