//
//  SHCustomDatePickerView.m
//  SpaceHome
//
//  Created by ZhangWei-SpaceHome on 16/1/6.
//
//

#import "SHCustomDatePickerView.h"

@interface SHCustomDatePickerView ()
{
    NSDateFormatter *dateFormatter;
}
@end

@implementation SHCustomDatePickerView

-(id)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, HEIGHT, WIDTH, 240);
        self.backgroundColor = ROOT_VIEW_BGCOLOR;
        
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        barView.backgroundColor = ROOT_VIEW_BGCOLOR;
        [self addSubview:barView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0, WIDTH, 1);
        lineView.backgroundColor = Line_Color;
        [barView addSubview:lineView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(12, 5, 40, 30);
        [cancelButton addTarget:self action:@selector(cancelDateSelect) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:DarkTextColor forState:UIControlStateNormal];
        [barView addSubview:cancelButton];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        doneButton.frame = CGRectMake(WIDTH - 52, 5, 40, 30);
        [doneButton addTarget:self action:@selector(dateSelectedDone) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setTitleColor:DarkTextColor forState:UIControlStateNormal];
        [barView addSubview:doneButton];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 40, WIDTH, 180);
        _datePicker.datePickerMode = UIDatePickerModeTime;
//        _datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];//这就是GMT+0时区了 ;
        [self addSubview:_datePicker];
        
        dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    return self;
}

-(void)setDateFormatString:(NSString *)dateFormatString
{
    [dateFormatter setDateFormat:dateFormatString];
}

-(void)cancelDateSelect
{
    [self hideDatePickerView];
}

-(void)dateSelectedDone
{
//    NSDate *currentDate = [NSDate date];
    NSDate *date = [_datePicker date];
//    NSTimeInterval seconds = [date timeIntervalSince1970];
//    NSString *secondString = [NSString stringWithFormat:@"%.0f",seconds];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"dateString == %@",dateString);
//    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
//    if (!_withOutLimit && [dateString compare:currentDateString] > 0) {
//        return ;
//    }
//    if ([self.delegate respondsToSelector:@selector(selectDateDone:)]) {
//        [self.delegate selectDateDone:dateString];
//    }
    
    if (self.selectDateString) {
        self.selectDateString(dateString);
    }
    
//    if ([self.delegate respondsToSelector:@selector(selectDateDone:timeIntervarl:)]) {
//        [self.delegate selectDateDone:dateString timeIntervarl:secondString];
//    }
//    if ([self.delegate respondsToSelector:@selector(selectDateDoneWithDate:)]) {
//        [self.delegate selectDateDoneWithDate:date];
//    }
    [self hideDatePickerView];
}

-(void)showDatePickerView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.top = HEIGHT - self.height;
        self.alpha = 1;
    }];
    [self.superview endEditing:YES];
}

-(void)hideDatePickerView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.top = HEIGHT;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(cancelButtonClick)]) {
            [self.delegate cancelButtonClick];
        }
    }];
}

-(void)setCurrentDate:(NSDate *)currentDate
{
    _datePicker.date = currentDate;
}
@end
