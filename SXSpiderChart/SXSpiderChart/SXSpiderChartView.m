//
//  SXSpiderChartView.m
//  SXSpiderChart
//
//  Created by wanglei on 16/11/30.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "SXSpiderChartView.h"

@implementation SXSpiderChartView{
    NSArray *_subjectsArray;
    NSArray *_thisMonthArray;
    NSArray *_lastMonthArray;
    
    NSMutableArray *_dashLinePointArrayArray;
    NSMutableArray *_lastMonthPointLocationArray;
    NSMutableArray *_thisMonthPointLocationArray;
    
    CGFloat _centerX;
    CGFloat _centerY;
}
- (instancetype)initWithFrame:(CGRect)frame subjectsArray:(NSArray *)subjects andThisMonth:(NSArray *)thisMonth andLastMonth:(NSArray *)lastMonth{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = [UIColor clearColor];
        _subjectsArray = subjects.copy;
        _thisMonthArray = thisMonth.copy;
        _lastMonthArray = lastMonth.copy;
        
        _centerX = frame.size.width / 2;
        _centerY = frame.size.height / 2;
        [self calculateAllPoints];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor clearColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    //下面
    CGContextRef graphContext = UIGraphicsGetCurrentContext();
    CGContextBeginPath(graphContext);
    CGPoint beginPoint = [[_lastMonthPointLocationArray objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(graphContext, beginPoint.x, beginPoint.y);
    for (NSValue* pointValue in _lastMonthPointLocationArray){
        CGPoint point = [pointValue CGPointValue];
        CGContextAddLineToPoint(graphContext, point.x, point.y);
    }
    CGContextClosePath(graphContext);
    CGContextSetFillColorWithColor(graphContext, [UIColor colorWithRed:103 / 255.0 green:255 / 255.0 blue:164 / 255.0 alpha:0.8].CGColor);
    CGContextSetStrokeColorWithColor(graphContext, [UIColor colorWithRed:64 / 255.0 green:255 / 255.0 blue:129 / 255.0 alpha:1].CGColor);
    CGContextSetLineWidth(graphContext, (CGFloat) 1.2);
    CGContextDrawPath(graphContext,kCGPathFillStroke);
    
    //上面
    CGContextBeginPath(graphContext);
    beginPoint = [[_thisMonthPointLocationArray objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(graphContext, beginPoint.x, beginPoint.y);
    for (NSValue* pointValue in _thisMonthPointLocationArray){
        CGPoint point = [pointValue CGPointValue];
        CGContextAddLineToPoint(graphContext, point.x, point.y);
    }
    CGContextClosePath(graphContext);
    CGContextSetFillColorWithColor(graphContext, [UIColor colorWithRed:121 / 255.0 green:190 / 255.0 blue:255 / 255.0 alpha:0.7].CGColor);
    CGContextSetStrokeColorWithColor(graphContext, [UIColor colorWithRed:49 / 255.0 green:144 / 255.0 blue:253 / 255.0 alpha:0.9].CGColor);
    CGContextSetLineWidth(graphContext, (CGFloat) 1.2);
    CGContextDrawPath(graphContext,kCGPathFillStroke);
    
    //环形虚线
    for (NSArray *pointArray in _dashLinePointArrayArray) {
        CGContextBeginPath(graphContext);
        CGPoint beginPoint = [[pointArray objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(graphContext, beginPoint.x, beginPoint.y);
        for (NSValue* pointValue in pointArray){
            CGPoint point = [pointValue CGPointValue];
            CGContextAddLineToPoint(graphContext, point.x, point.y);
        }
        CGContextAddLineToPoint(graphContext, beginPoint.x, beginPoint.y);
        CGContextSetStrokeColorWithColor(graphContext, [UIColor colorWithRed:246/255.0 green:104/255.0 blue:139/255.0 alpha:0.8].CGColor);
        
        CGFloat a = 1;
        CGContextSetLineDash(graphContext,0,&a,1);
        CGContextSetLineWidth(graphContext, (CGFloat) 0.88);
        CGContextStrokePath(graphContext);
    }
    
    //穿插虚线
    NSArray *largestPointArray = [_dashLinePointArrayArray lastObject];
    for (NSValue* pointValue in largestPointArray){
        CGContextBeginPath(graphContext);
        CGContextMoveToPoint(graphContext, _centerX, _centerY);
        CGPoint point = [pointValue CGPointValue];
        CGContextAddLineToPoint(graphContext, point.x, point.y);
        CGContextSetStrokeColorWithColor(graphContext, [UIColor colorWithRed:246/255.0 green:104/255.0 blue:139/255.0 alpha:0.8].CGColor);
        CGContextStrokePath(graphContext);
    }
}

- (void)calculateAllPoints{
    CGFloat halfWidth = self.frame.size.width / 2;
    
    NSArray *angleArray = [self calculateAngleArray];
    
    //虚线点
    _dashLinePointArrayArray = @[].mutableCopy;
    for ( int i = 1; i <= 4; i++ ) {
        CGFloat length = i / 4.0 * halfWidth;
        [_dashLinePointArrayArray addObject:[self getDashLinePointWithLength:length angleArray:angleArray]];
    }
    
    //下面图形的点
    _lastMonthPointLocationArray = @[].mutableCopy;
    int number = 0;
    for (id value in _lastMonthArray) {
        CGFloat valueFloat = [value floatValue];
        if ( valueFloat > 100 ) {
            return;
        }
        CGFloat length = valueFloat / 100.0 * halfWidth;
        CGFloat angle = [[angleArray objectAtIndex:number] floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [_lastMonthPointLocationArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        number++;
    }
    
    //上面图形的点
    _thisMonthPointLocationArray = @[].mutableCopy;
    number = 0;
    for (id value in _thisMonthArray) {
        CGFloat valueFloat = [value floatValue];
        if ( valueFloat > 100 ) {
            return;
        }
        CGFloat length = valueFloat / 100.0 * halfWidth;
        CGFloat angle = [[angleArray objectAtIndex:number] floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [_thisMonthPointLocationArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        number++;
    }
    
    //添加学科Label
    number = 0;
    for (NSString *text in _subjectsArray) {
        UILabel *label = [UILabel new];
        label.text = text;
        label.font = [UIFont systemFontOfSize:12];
        [label sizeToFit];
        
        CGFloat length = 1.2 * halfWidth;
        CGFloat angle = [[angleArray objectAtIndex:number] floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        label.center = CGPointMake(x, y);
        
        [self addSubview:label];
        number++;
    }
    
    //添加梯度Label
    for (int i = 0; i < 5; i++) {
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%d",i * 25];
        label.font = [UIFont systemFontOfSize:12];
        [label sizeToFit];
        
        CGFloat x;
        CGFloat y;
        if ( i == 0 ) {
            x = _centerX;
            y = _centerY;
        }
        else{
            NSArray *array = _dashLinePointArrayArray[i - 1];
            x = ([array.firstObject CGPointValue].x + [array.lastObject CGPointValue].x) / 2;
            y = ([array.firstObject CGPointValue].y + [array.lastObject CGPointValue].y) / 2;
        }
        label.center = CGPointMake(x, y);
        
        [self addSubview:label];
    }
}

- (NSArray *)calculateAngleArray{
    NSMutableArray *angleArray = [NSMutableArray array];
    for (int section = 0; section < _subjectsArray.count; section++) {
        [angleArray addObject:[NSNumber numberWithFloat:((float)section)/(float)[_subjectsArray count] * 2*M_PI - 0.5 * M_PI]];
    }
    return angleArray;
}

- (NSArray *)getDashLinePointWithLength:(CGFloat)length angleArray:(NSArray *)angleArray
{
    NSMutableArray *pointArray = [NSMutableArray array];
    for (NSNumber *angleNumber in angleArray) {
        CGFloat angle = [angleNumber floatValue];
        CGFloat x = _centerX + length*cos(angle);
        CGFloat y = _centerY + length*sin(angle);
        [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    return pointArray;
}

@end
