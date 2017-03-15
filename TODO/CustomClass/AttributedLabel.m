//
//  AttributedLabel.m
//  Demo
//
//  Created by ZhangWei-SpaceHome on 15/8/26.
//  Copyright (c) 2015年 kongjianjia. All rights reserved.
//

#import "AttributedLabel.h"
#import <CoreText/CoreText.h>
#define KEY_WORD_COLOR [UIColor redColor]

@interface AttributedLabel ()

@property (nonatomic, assign)CTFrameRef textCTframe;

@property (nonatomic, assign)NSRange keyWordRange;

@end

@implementation AttributedLabel

@synthesize textCTframe;

@synthesize keyWordRange;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init{
    self = [super init];
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

-(void)setAttributedWithString:(NSString *)infoString
                       keyWord:(NSString *)keyWord
{
    [self setAttributedWithString:infoString keyWord:keyWord keyWordFont:[UIFont systemFontOfSize:12] keyWordColor:KEY_WORD_COLOR textAlignment:NSTextAlignmentLeft];
    
}

-(void)setAttributedWithString:(NSString *)infoString
                       keyWord:(NSString *)keyWord
                   keyWordFont:(UIFont *)keyWordFont
{
    [self setAttributedWithString:infoString keyWord:keyWord keyWordFont:keyWordFont keyWordColor:KEY_WORD_COLOR textAlignment:NSTextAlignmentLeft];
}

-(void)setAttributedWithString:(NSString *)infoString
                       keyWord:(NSString *)keyWord
                   keyWordFont:(UIFont *)keyWordFont
                  keyWordColor:(UIColor *)keyWordColor
{
    [self setAttributedWithString:infoString keyWord:keyWord keyWordFont:keyWordFont keyWordColor:keyWordColor textAlignment:NSTextAlignmentLeft];
}

-(void)setAttributedWithString:(NSString *)infoString
                       keyWord:(NSString *)keyWord
                   keyWordFont:(UIFont *)keyWordFont
                  keyWordColor:(UIColor *)keyWordColor
                 textAlignment:(NSTextAlignment)textAlign
{
    if (!keyWordColor) {
        keyWordColor = KEY_WORD_COLOR;
    }else{
        _keyWordColor = keyWordColor;
    }
    if (!keyWordFont) {
        keyWordFont = [UIFont systemFontOfSize:12];
    }
    if (!keyWord) {
        keyWord = @"0";
    }
    _keyWord = keyWord?keyWord:@"";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:infoString?infoString:@""];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:keyWordColor,NSFontAttributeName:keyWordFont} range:[infoString rangeOfString:keyWord]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = textAlign;
    paragraphStyle.lineSpacing = 5;
    self.numberOfLines = 999;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, infoString.length)];
    self.attributedText = attributedString;
    
    keyWordRange = [infoString rangeOfString:keyWord];
//    NSLog(@"keyrange=%@",NSStringFromRange(keyWordRange));
    //设置CTFramesetter
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0,self.width,self.height));
    //创建CTFrame
    textCTframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText.length), path, NULL);
}


//接受触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (textCTframe)
    {
        //获取UITouch对象
        UITouch *touch = [touches anyObject];
        //获取触摸点击当前view的坐标位置
        CGPoint location = [touch locationInView:self];
        //获取每一行
        CFArrayRef lines = CTFrameGetLines(textCTframe);
        CGPoint origins[CFArrayGetCount(lines)];
        //获取每行的原点坐标
        CTFrameGetLineOrigins(textCTframe, CFRangeMake(0, 0), origins);
        CTLineRef line = NULL;
        CGPoint lineOrigin = CGPointZero;
        for (int i= 0; i < CFArrayGetCount(lines); i++)
        {
            CGPoint origin = origins[i];
            CGPathRef path = CTFrameGetPath(textCTframe);
            //获取整个CTFrame的大小
            CGRect rect = CGPathGetBoundingBox(path);
            //坐标转换，把每行的原点坐标转换为uiview的坐标体系
            CGFloat y = rect.origin.y + rect.size.height - origin.y;
            //判断点击的位置处于那一行范围内
            if ((location.y <= y) && (location.x >= origin.x))
            {
                line = CFArrayGetValueAtIndex(lines, i);
                lineOrigin = origin;
                break;
            }
        }
        
        location.x -= lineOrigin.x;
        //获取点击位置所处的字符位置，就是相当于点击了第几个字符
        CFIndex index = CTLineGetStringIndexForPosition(line, location);
        //判断点击的字符是否在需要处理点击事件的字符串范围内
        if (index >= keyWordRange.location &&
            index <= keyWordRange.location+keyWordRange.length)
        {
            if (self.eventTouch)
            {
                self.eventTouch([self.text substringWithRange:keyWordRange]);
            }
        }
    }
    
}

-(CGSize)sizeToFitWithMaxSize:(CGSize)maxSize
{
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    CGSize size = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    [self setFrame:CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              size.width, size.height+3)];
    
    return size;
}



@end
