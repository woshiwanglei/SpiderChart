//
//  ViewController.m
//  SXSpiderChart
//
//  Created by wanglei on 16/11/30.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "SXSpiderChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *subjectArray = @[@"语文",@"数学",@"英语",@"物理", @"化学",@"生物"];
    NSArray *schoolAverage = @[@"92",@"94",@"88",@"77",@"86",@"78"];
    NSArray *myPoint = @[@"76",@"85",@"76",@"83",@"91",@"93"];
    SXSpiderChartView *spiderChartView = [[SXSpiderChartView alloc]initWithFrame:CGRectMake(80, 80, 160, 160) subjectsArray:subjectArray andThisMonth:myPoint andLastMonth:schoolAverage];
    spiderChartView.alpha = 0;
    [self.view addSubview:spiderChartView];
    
    [UIView animateWithDuration:1.5 animations:^{
        spiderChartView.alpha = 1;
    }];
}


@end
