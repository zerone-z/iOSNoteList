//
//  OtherRecord.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "OtherRecord.h"
#import <mach/mach_time.h>

@implementation OtherRecord

- (void)runTime
{
    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeLength = dateLength(time2, time1);
    
    clock_t clock1 = clock();
    clock_t clock2 = clock();
    double clocLength = clockLength(clock2, clock1);
    
    uint64_t mach1 = mach_absolute_time(); //可以精确到微秒级别
    uint64_t mach2 = mach_absolute_time();
    double length = subtractTimes(mach2, mach1);
}

NSTimeInterval dateLength(NSTimeInterval timeEnd, NSTimeInterval timeStart)
{
    return timeEnd - timeStart;
}

double clockLength(clock_t clockEnd, clock_t clockStart)
{
    double length = clockEnd - clockStart;
    return length / CLOCKS_PER_SEC;
}

/*
mach_absolute_time是一个CPU/总线依赖函数，返回一个基于系统启动后的时钟”嘀嗒”数。它没有很好的文档定义，但这不应该成为使用它的障碍，因为在MAC OS X上可以确保它的行为，并且，它包含系统时钟包含的所有时间区域。那是否应该在产品代码中使用它呢？可能不应该。但是对于测试，它却恰到好处。
 
 
 这里最重要的是调用mach_timebase_info。我们传递一个结构体以返回时间基准值。最后，一旦我们获取到系统的心跳，我们便能生成一个转换因子。通常，转换是通过分子(info.numer)除以分母(info.denom)。这里我乘了一个1e-9来获取秒数。最后，我们获取两个时间的差值，并乘以转换因子，便得到真实的时间差。
*/
double subtractTimes( uint64_t endTime, uint64_t startTime )
{
    uint64_t difference = endTime - startTime;
    static double conversion = 0.0;
    if( conversion == 0.0 )
    {
        mach_timebase_info_data_t info;
        kern_return_t err = mach_timebase_info( &info );
        //Convert the timebase into seconds
        if( err == 0  )
            conversion= 1e-9 * (double) info.numer / (double) info.denom;
    } 
    return conversion * (double)difference; 
}

@end
