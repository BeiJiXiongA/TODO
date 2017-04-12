//
//  Tools.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/7.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "Tools.h"

@implementation Tools
+(NSString *)getTimeWithSeconds:(NSString *)seconds
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[seconds floatValue]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

+(NSString*)getChineseCalendarWithDate:(NSDate *)date
{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
//    NSLog(@"%ld_%ld_%ld  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day>0?(localeComp.day-1):localeComp.day];
    if (localeComp.day == 0) {
        d_str = [chineseDays lastObject];
    }
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    return chineseCal_str;
}

+(NSInteger)getWeekDayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDate *date = [[self class] getDateWithYear:year month:month day:day];
    NSDateComponents *comp = [[[self class] getCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSInteger weekDay = [comp weekday];
    return weekDay;
}

+(NSString *)getWeekDayStringWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDate *date = [self getDateWithYear:year month:month day:day];
    NSDateComponents *comp = [[self getCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSInteger weekDay = [comp weekday];
    NSString *weekString = @"";
    switch (weekDay) {
        case 1:
            weekString = @"日";
            break;
        case 2:
            weekString = @"一";
            break;
        case 3:
            weekString = @"二";
            break;
        case 4:
            weekString = @"三";
            break;
        case 5:
            weekString = @"四";
            break;
        case 6:
            weekString = @"五";
            break;
        case 7:
            weekString = @"六";
            break;
        default:
            break;
    }
    return weekString;
}

+(NSCalendar *)getCalendar
{
    return [NSCalendar currentCalendar];
}

+(NSDateComponents *)getComponents
{
    NSDateComponents *comp = [[[self class] getCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:[self getOriginDate]];
//    if ([comp month]>5) {
//        [comp setMonth:[comp month]-5];
//    }else{
//        [comp setYear:[comp year]-1];
//        [comp setMonth:([comp month]+12)-5];
//    }
    return comp;
}

+(NSInteger)getYear
{
    return [[self getComponents] year];
}

+(NSInteger)getMonth
{
    return [[self getComponents] month];
}

+(NSInteger)getWeek
{
    return [[self getComponents] weekday];
}

+(NSInteger)getDay
{
    return [[self getComponents] day];
}

+(NSInteger)getMonthWithSection:(NSInteger)section
{
    if (([self getMonth] + section)%12 == 0) {
        return 12;
    }
    NSInteger currentMonth = [self getMonth];
    if (currentMonth+section > 0) {
        return (currentMonth + section)%12;
    }
    return 12+(currentMonth + section)%12;
}

+(NSInteger)getYearWithSection:(NSInteger)section
{
    NSInteger currentYear = [self getYear];
    NSInteger currentMonth = [self getMonth];
    if (currentMonth+section > 0) {
        return currentYear + (currentMonth + section)/12;
    }
    return currentYear + ([self getMonth] + section)/12-1;
}

+(NSDate *)getDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *comp = [self getComponents];
    [comp setYear:year];
    [comp setMonth:month];
    [comp setDay:day];
    NSDate *date = [[self getCalendar] dateFromComponents:comp];
    return date;
}

+(NSDate *)getOriginDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *originDate = [formatter dateFromString:@"2016-03-01"];
    NSDate *originDate = [NSDate date];
    return originDate;
}

+(NSInteger)calculateMonthsWithDate:(NSDate *)date
{
    NSDate *originDate = [self getOriginDate];
    NSDateComponents *originComp = [[self getCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:originDate];
    NSDateComponents *tempComp = [[self getCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    return ([tempComp year] - [originComp year])*12+[tempComp month]-[originComp month];
}

+(BOOL)isTodayWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *nowDate = [NSDate date];
    if ([[formatter stringFromDate:nowDate] isEqualToString:[formatter stringFromDate:date]]) {
        return YES;
    }
    return NO;
}

@end
