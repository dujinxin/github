//
//  NSDate+Method.m
//  JXView
//
//  Created by dujinxin on 14-11-3.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "NSDate+Method.h"

@implementation NSDate (Method)

+(NSString *)getWeekday
{
    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    NSString *weekday = [self getWeekdayWithNumber:[componets weekday]];
    return weekday;
}

//1代表星期日、如此类推
+(NSString *)getWeekdayWithNumber:(int)number
{
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}
@end
