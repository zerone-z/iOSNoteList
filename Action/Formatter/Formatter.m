//
//  Formatter.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/20.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "Formatter.h"

#import "NSDate+Extend.h"
#import "NSNumber+Extend.h"

@interface Formatter ()

@end

@implementation Formatter

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)DateFormat:(UIButton *)sender {
    NSDate *now = [NSDate date];
    
    NSLog(@"================DateFormat=============");
    NSLog(@"把时间格式化为一个指定格式的字符串：%@", [now stringWithDateFormat:XJDateFormat_zh_y_M_d_H_m_s]);
    NSString *dateStr = @"2015-05-06";
    NSLog(@"把日期字符串转为NSDate对象：%@", [NSDate dateFromString:dateStr withDateFormat:XJDateFormat_y_M_d]);
    
    NSLog(@"================日期时间获取=============");
    NSLog(@"获取当前日期所在的年：%@", [now getYear]);
    NSLog(@"获取当前日期所在的季度：%@", [now getQuarter]);
    NSLog(@"获取当前日期所在的月份：%@", [now getMonth]);
    NSLog(@"获取当前日期在年份中的第几周：%@", [now getWeekOfYear]);
    NSLog(@"获取当前日期在月份中的第几周：%@", [now getWeekOfMonth]);
    NSLog(@"获取当前日期在年份中的第几天：%@", [now getDayOfYear]);
    NSLog(@"获取当前日期在月份中的第几天：%@", [now getDayOfMonth]);
    NSLog(@"获取当前日期在这周中的第几天：%@", [now getDayOfWeek]);
    
    NSLog(@"本地化月份缩写：%@, %@, %@", [now getSimplyMonthForLocalIdentifier:nil],[now getSimplyMonthForLocalIdentifier:@"en_US"],[now getSimplyMonthForLocalIdentifier:@"zh"]);
    NSLog(@"本地化月份全写：%@, %@, %@", [now getFullMonthForLocalIdentifier:nil],[now getFullMonthForLocalIdentifier:@"en_US"],[now getFullMonthForLocalIdentifier:@"zh"]);
    
    NSLog(@"本地化星期缩写：%@, %@, %@", [now getSimplyWeekDayForLocalIdentifier:nil],[now getSimplyWeekDayForLocalIdentifier:@"en_US"],[now getSimplyWeekDayForLocalIdentifier:@"zh"]);
    NSLog(@"本地化星期全写：%@, %@, %@", [now getFullWeekDayForLocalIdentifier:nil],[now getFullWeekDayForLocalIdentifier:@"en_US"],[now getFullWeekDayForLocalIdentifier:@"zh"]);
    
    NSLog(@"================日期时间运算:%@=============", [now stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"清理：%@",
          [[now dateByCleaningDateFormat:XJDateFormat_y_M_d] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"比较：%ld, %ld",
          (long)[now compare:[now dateByAddingSecond:3]],
           (long)[now compare:[now dateByAddingSecond:3] withDateFormat:XJDateFormat_y_M_d]);
    NSLog(@"秒：%@, %@",
          [[now dateByAddingSecond:-3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now dateByAddingSecond:3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"分钟：%@, %@",
          [[now dateByAddingMinute:-3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now dateByAddingMinute:3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"小时：%@, %@",
          [[now dateByAddingHour:-3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now dateByAddingHour:3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"天：%@, %@",
          [[now dateByAddingDay:-3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now dateByAddingDay:3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"周：%@, %@",
          [[now dateByAddingWeek:-3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now dateByAddingWeek:3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"月：%@, %@",
          [[now dateByAddingMonth:-3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now dateByAddingMonth:3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"年：%@, %@",
          [[now dateByAddingYear:-3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now dateByAddingYear:3] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    
    
    NSDate *anotherDate = [NSDate dateFromString:@"2016-01-03 20:20:20" withDateFormat:XJDateFormat_y_M_d_H_m_s];
    NSDate *anotherDate1 = [NSDate dateFromString:@"2014-01-03 20:20:20" withDateFormat:XJDateFormat_y_M_d_H_m_s];
    
    NSLog(@"星期：末：%@，一：%@, 二：%@, 三：%@, 四：%@, 五：%@, 六：%@",
          [[now weekday:XJWeekDaySun byAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now weekday:XJWeekDayMon byAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now weekday:XJWeekDayTues byAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now weekday:XJWeekDayWed byAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now weekday:XJWeekDayThurs byAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now weekday:XJWeekDayFri byAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now weekday:XJWeekDaySat byAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"周＝第一天：%@, 最后一天：%@",
          [[now firstDayOfWeekByAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now lastDayOfWeekByAddingWeek:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"月＝第一天：%@, 最后一天：%@",
          [[now firstDayOfMonthByAddingMonth:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now lastDayOfMonthByAddingMonth:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    NSLog(@"年＝第一天：%@, 最后一天：%@",
          [[now firstDayOfYearByAddingYear:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s],
          [[now lastDayOfYearByAddingYear:1] stringWithDateFormat:XJDateFormat_y_M_d_H_m_s]);
    
    NSLog(@"一年的月数：%ld", (long)[now monthNumbersByAddingYear:0]);
    NSLog(@"一年的周数：%ld", (long)[now weekNumbersByAddingYear:0]);
    NSLog(@"月的周数：%ld", (long)[now weekNumbersByAddingMonth:0]);
    NSLog(@"一年的天数：%ld", (long)[now dayNumbersByAddingYear:0]);
    NSLog(@"月的天数：%ld", (long)[now dayNumbersByAddingMonth:0]);
    
    NSLog(@"================时间差=============");
    NSLog(@"时间相差天数：%ld, %ld",
          (long)[now dayNumberSinceDate:[NSDate dateFromString:@"2015-05-20 15:12:12" withDateFormat:XJDateFormat_y_M_d_H_m_s]],
          (long)[now dayNumberSinceDate:[NSDate dateFromString:@"2015-05-30 06:12:12" withDateFormat:XJDateFormat_y_M_d_H_m_s]]);
    NSLog(@"时间相差周数：%ld, %ld",
          (long)[now weekNumberSinceDate:[NSDate dateFromString:@"2016-02-26" withDateFormat:XJDateFormat_y_M_d]],
          (long)[now weekNumberSinceDate:[NSDate dateFromString:@"2016-02-29" withDateFormat:XJDateFormat_y_M_d]]);
    NSLog(@"时间相差月数：%ld, %ld",
          (long)[now monthNumberSinceDate:[NSDate dateFromString:@"2016-03-02" withDateFormat:XJDateFormat_y_M_d]],
          (long)[now monthNumberSinceDate:[NSDate dateFromString:@"2016-02-27" withDateFormat:XJDateFormat_y_M_d]]);
    NSLog(@"时间相差年数：%ld, %ld",
          (long)[now yearNumberSinceDate:[NSDate dateFromString:@"2013-05-27" withDateFormat:XJDateFormat_y_M_d]],
          (long)[now yearNumberSinceDate:[NSDate dateFromString:@"2017-05-27" withDateFormat:XJDateFormat_y_M_d]]);
    
    NSLog(@"================日期区域判断=============");
    
    NSLog(@"是否在当天：%d", [[NSDate dateFromString:@"2015-05-25" withDateFormat:XJDateFormat_y_M_d] isThisDay]);
    NSLog(@"是否在本周内：%d", [[NSDate dateFromString:@"2015-05-30" withDateFormat:XJDateFormat_y_M_d] isThisWeek]);
    NSLog(@"是否在本月：%d", [[NSDate dateFromString:@"2015-04-30" withDateFormat:XJDateFormat_y_M_d] isThisMonth]);
    NSLog(@"是否在本年：%d", [[NSDate dateFromString:@"2015-12-31" withDateFormat:XJDateFormat_y_M_d] isThisYear]);
}

- (IBAction)NumberFormat:(UIButton *)sender {
    NSLog(@"%@", [@(-12121212.12721212) stringWithNumberFormat:@"#,##0.00"]);
    NSLog(@"%@", [@(-12121212.12121212) stringOfDecimal]);
    NSLog(@"%@", [@(-12121212.12121212) stringOfCurrency]);
    NSLog(@"%@", [@(-12121212.12121212) stringOfPercent]);
    NSLog(@"%@", [@(-12121212.12121212) stringOfScience]);
    NSLog(@"%@", [@(-123456.123) stringOfSpellOut]);
}
@end
