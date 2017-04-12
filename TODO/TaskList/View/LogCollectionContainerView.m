//
//  LogCollectionView.m
//  TODO
//
//  Created by ZhangWei-SpaceHome on 16/7/12.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "LogCollectionContainerView.h"
#import "CustomCollectionReusableView.h"
#import "CustomCollectionViewCell.h"
#import "SHCustomDatePickerView.h"

NSString * const KcollectionViewCellID = @"cellID";
NSString * const KReusableHeaderView = @"reuseHeader";
NSString * const KReusableFooterView = @"reuseFooter";

@interface LogCollectionContainerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *logCollectionView;
    NSMutableArray *indexArray;
    NSMutableArray *itemCountArray;
    NSInteger currentIndex;
    NSInteger currentYear;
}
@end

@implementation LogCollectionContainerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *weekView = [[UIView alloc] init];
        weekView.frame = CGRectMake(0, 0, self.width, 20);
        weekView.backgroundColor = [UIColor whiteColor];
        [self addSubview:weekView];
        
        currentYear = [Tools getYear];
        
        NSArray *weeks = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i = 0; i < weeks.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(WIDTH/7.0*i, 0, WIDTH/7.0, weekView.height);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = weeks[i];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = RGB(102, 102, 102);
            [weekView addSubview:label];
        }

        indexArray = [[NSMutableArray alloc] init];
        itemCountArray = [[NSMutableArray alloc] init];
        for (int i = -2; i < 5; i ++) {
            [indexArray addObject:@(i)];
            [itemCountArray addObject:@([self itemCountWithIndex:i])];
        }
        currentIndex = 0;
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        logCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, weekView.bottom, self.width, self.height - weekView.height) collectionViewLayout:flowLayout];
        logCollectionView.delegate = self;
        logCollectionView.dataSource = self;
        [self addSubview:logCollectionView];
        logCollectionView.backgroundColor = [UIColor whiteColor];
        logCollectionView.showsVerticalScrollIndicator = NO;
        
        //注册重复使用的cell
        [logCollectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:KcollectionViewCellID];
        
        //注册重复使用的headerView和footerView
        [logCollectionView registerClass:[CustomCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KReusableHeaderView];
        
//        NSInteger monthCount = [Tools calculateMonthsWithDate:[NSDate date]];
//        [logCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:monthCount] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
    }
    return self;
}

-(void)setDateArray:(NSArray *)dateArray
{
    _dateArray = dateArray;
    [logCollectionView reloadData];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[itemCountArray objectAtIndex:section] integerValue];
}

-(NSInteger)itemCountWithIndex:(NSInteger)index
{
    NSDateComponents *comp = [Tools getComponents];
    NSInteger year = [Tools getYearWithSection:index];
    NSInteger month = [Tools getMonthWithSection:index];
    [comp setMonth:month];
    [comp setYear:year];
    NSInteger week = [Tools getWeekDayWithYear:year month:month day:1];
    NSRange range = [[Tools getCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[[Tools getCalendar] dateFromComponents:comp]];
    return (range.length+week-1)+7-((week-1 + range.length)%7==0?7:((week-1 + range.length)%7));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KcollectionViewCellID forIndexPath:indexPath];
    NSInteger index = ((NSNumber *)indexArray[indexPath.section]).integerValue;
    NSInteger year = [Tools getYearWithSection:index];
    NSInteger month = [Tools getMonthWithSection:index];
    
    NSDateComponents *comp = [Tools getComponents];
    [comp setYear:year];
    [comp setMonth:month];
    NSInteger week = [Tools getWeekDayWithYear:year month:month day:1];
    NSRange range = [[Tools getCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[[Tools getCalendar] dateFromComponents:comp]];
    NSInteger day = indexPath.item + 1 - (week - 1);
    if (indexPath.item >= week-1 && indexPath.item < range.length + week-1) {
        
        cell.dayLabel.text = [NSString stringWithFormat:@"%ld",day];
        cell.infoLabel.text = [Tools getChineseCalendarWithDate:[Tools getDateWithYear:year month:month day:day]];
        cell.topLine.hidden = NO;
    }else{
        cell.infoLabel.text = @"";
        cell.dayLabel.text = @"";
        cell.dayLabel.backgroundColor = [UIColor whiteColor];
        cell.topLine.hidden = YES;
    }
    if ([self haveThisDayWithYear:year month:month day:day]) {
        cell.dayLabel.backgroundColor = [UIColor orangeColor];
        cell.dayLabel.textColor = [UIColor whiteColor];
    }else{
        cell.dayLabel.backgroundColor = [UIColor whiteColor];
        cell.dayLabel.textColor = RGB(51, 51, 51);
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidStop:scrollView];
}

- (void)scrollViewDidStop:(UIScrollView *)scrollView {
    
    
    NSInteger offset = 0;
    CGFloat temH = 0;
    for (int i = 0; i < indexArray.count; i++) {
        if (temH < fabs(scrollView.contentOffset.y)) {
            offset ++;
            NSInteger index = ((NSNumber *)indexArray[i]).integerValue;
            temH = temH + ([self itemCountWithIndex:index]/7+ ([self itemCountWithIndex:index]%7==0?0:1));
        }else{
            break;
        }
    }
    NSLog(@"offset====%zi",offset);
    
    
    NSInteger index = ((NSNumber *)indexArray[2]).integerValue;
    [indexArray replaceObjectAtIndex:2 withObject:@(index+1)];
    [itemCountArray replaceObjectAtIndex:2 withObject:@([self itemCountWithIndex:index]-1)];
    //        [logCollectionView reloadData];
//    NSIndexPath *idxPath = [NSIndexPath indexPathForItem:1 inSection:0];
//    [logCollectionView scrollToItemAtIndexPath:idxPath atScrollPosition:0 animated:NO];
    //        [logCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    
    for (int i = 0; i < indexArray.count; i++) {
        if(i == 2){
            continue;
        }
        NSInteger index = ((NSNumber *)indexArray[i]).integerValue;
        [indexArray replaceObjectAtIndex:i withObject:@(index+1)];
        [itemCountArray replaceObjectAtIndex:i withObject:@([self itemCountWithIndex:index])];
    }
//    scrollView.contentOffset.x/ scrollView.bounds.size.width - 1;
    //当前(上一个当前)图片的索引加上滚动的大小就是滚动后图片的索引（也就是最新的currentIndex）
    currentIndex = (currentIndex + offset + indexArray.count) % indexArray.count;
    
    // cell.headline = self.headlines[index];这段代码的内部是异步执行的(加载网络图片)，所以把下面的代码放在主队列中，等主线程上的代码执行完毕之后再执行.
    dispatch_async(dispatch_get_main_queue(), ^{
        // 当滚动结束后，让第一个cell再偷偷的(无动画)滚回界面
        // 所以还会自动执行返回cell的方法
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [logCollectionView scrollToItemAtIndexPath:idxPath atScrollPosition:0 animated:NO];
    });
    return;
    
    NSLog(@"\nsize== %f offset==%f",scrollView.contentSize.height,scrollView.contentOffset.y+HEIGHT);
    if (scrollView.contentOffset.y == 0) {
        NSLog(@"滑到顶部");
        NSInteger index = ((NSNumber *)indexArray[2]).integerValue;
        [indexArray replaceObjectAtIndex:2 withObject:@(index-1)];
        [itemCountArray replaceObjectAtIndex:2 withObject:@([self itemCountWithIndex:index]-1)];
//        [logCollectionView reloadData];
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [logCollectionView scrollToItemAtIndexPath:idxPath atScrollPosition:0 animated:NO];
//        [logCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
        for (int i = 0; i < indexArray.count; i++) {
            if(i == 2){
                continue;
            }
            NSInteger index = ((NSNumber *)indexArray[i]).integerValue;
            [indexArray replaceObjectAtIndex:i withObject:@(index-1)];
            [itemCountArray replaceObjectAtIndex:i withObject:@([self itemCountWithIndex:index])];
        }
//        [logCollectionView reloadData];
    }else if(scrollView.contentOffset.y + HEIGHT > scrollView.contentSize.height){
        NSLog(@"滑到底部");
        NSInteger index = ((NSNumber *)indexArray[2]).integerValue;
        [indexArray replaceObjectAtIndex:2 withObject:@(index+1)];
        [itemCountArray replaceObjectAtIndex:2 withObject:@([self itemCountWithIndex:index]-1)];
//        [logCollectionView reloadData];
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [logCollectionView scrollToItemAtIndexPath:idxPath atScrollPosition:0 animated:NO];
        //        [logCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
        for (int i = 0; i < indexArray.count; i++) {
            if(i == 2){
                continue;
            }
            NSInteger index = ((NSNumber *)indexArray[i]).integerValue;
            [indexArray replaceObjectAtIndex:i withObject:@(index+1)];
            [itemCountArray replaceObjectAtIndex:i withObject:@([self itemCountWithIndex:index])];
        }
//        [logCollectionView reloadData];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//设置headerView和footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KReusableHeaderView forIndexPath:indexPath];
        NSInteger index = ((NSNumber *)indexArray[indexPath.section]).integerValue;
        reusableView.titleLabel.text = [NSString stringWithFormat:@"%ld年%ld月",[Tools getYearWithSection:index],[Tools getMonthWithSection:index]];
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((WIDTH - 7*2)/7.0, (WIDTH - 7*2)/7.0);
    return size;
}

//设置cell与边缘的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 2, 0, 2);
    return inset;
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //行与行间距
    return 8;
}

//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //列与列间距
    return 1;
}

//设置header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    //header 高度
    CGSize size = CGSizeMake(0, 50);
    return size;
}

//设置footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    //footer 高度
    CGSize size = CGSizeMake(0, 0);
    return size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击section%ld的第%ld个cell",indexPath.section,indexPath.row);
    NSInteger index = ((NSNumber *)indexArray[indexPath.section]).integerValue;
    NSInteger year = [Tools getYearWithSection:index];
    NSInteger month = [Tools getMonthWithSection:index];
    
    NSDateComponents *comp = [Tools getComponents];
    NSInteger week = [Tools getWeekDayWithYear:year month:month day:1];
    NSRange range = [[Tools getCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[[Tools getCalendar] dateFromComponents:comp]];
    NSInteger day = indexPath.item + 1 - (week - 1);
    if (indexPath.item >= week-1 && indexPath.item < range.length + week-1) {
        [comp setYear:year];
        [comp setMonth:month];
        [comp setDay:day];
        [comp setHour:9];
        NSDate *selectedDate = [[Tools getCalendar] dateFromComponents:comp];
        if (![self haveThisDayWithYear:year month:month day:day] && [self.logCollectionViewDelegate respondsToSelector:@selector(selectItemWithDate:)]) {
            [self.logCollectionViewDelegate selectItemWithDate:selectedDate];
        }
    }
}

-(BOOL)haveThisDayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    if (_dateArray.count == 0) {
        return NO;
    }
    for (NSDate *tempDate in _dateArray) {
        NSDateComponents *tempComp = [[Tools getCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
        
        if ([tempComp year] == year &&
            [tempComp month] == month &&
            [tempComp day] == day) {
            return YES;
        }
    }
    return NO;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat pointY = scrollView.contentOffset.y;
//    if (pointY >= HEIGHT * 2) {
//        [scrollView setContentOffset:CGPointMake(0, HEIGHT) animated:NO];
//    }else if (pointY <= 0){
//        [scrollView setContentOffset:CGPointMake(0, HEIGHT * 3) animated:NO];
//    }
//}


@end
