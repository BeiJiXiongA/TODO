//
//  Tools.h
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/7.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(NSInteger)getDay;
+(NSInteger)getWeek;
+(NSInteger)getMonth;
+(NSInteger)getYear;
+(NSDateComponents *)getComponents;
+(NSCalendar *)getCalendar;
+(NSDate *)getDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+(NSInteger)getYearWithSection:(NSInteger)section;
+(NSInteger)getMonthWithSection:(NSInteger)section;

+(NSString *)getTimeWithSeconds:(NSString *)seconds;
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;
+(NSString *)getWeekDayStringWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+(NSInteger)getWeekDayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
///计算指定日期过了多少个月
+(NSInteger)calculateMonthsWithDate:(NSDate *)date;
+(BOOL)isTodayWithDate:(NSDate *)date;
@end
