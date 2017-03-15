//
//  SHCustomDatePickerView.h
//  SpaceHome
//
//  Created by ZhangWei-SpaceHome on 16/1/6.
//
//

#import <UIKit/UIKit.h>

@protocol SHCustomDatePickerViewDelegate <NSObject>

@optional

-(void)selectDateDone:(NSString *)dateString;

-(void)selectDateDoneWithDate:(NSDate *)selectedDate;

-(void)selectDateDone:(NSString *)dateString timeIntervarl:(NSString *)timeIntervalString;

-(void)cancelButtonClick;

@end

@interface SHCustomDatePickerView : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) NSString *dateFormatString;

@property (nonatomic, assign) BOOL withOutLimit;

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, assign) id<SHCustomDatePickerViewDelegate> delegate;

@property (nonatomic, copy) void(^selectDateString)(NSString *dateString);

-(void)showDatePickerView;

-(void)hideDatePickerView;

@end
