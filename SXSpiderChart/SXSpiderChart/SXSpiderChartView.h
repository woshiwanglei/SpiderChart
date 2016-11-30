//
//  SXSpiderChartView.h
//  SXSpiderChart
//
//  Created by wanglei on 16/11/30.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXSpiderChartView : UIView
- (instancetype)initWithFrame:(CGRect)frame subjectsArray:(NSArray *)subjects andThisMonth:(NSArray *)thisMonth andLastMonth:(NSArray *)lastMonth;
@end
