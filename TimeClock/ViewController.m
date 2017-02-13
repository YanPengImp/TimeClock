//
//  ViewController.m
//  TimeClock
//
//  Created by Imp on 17/2/13.
//  Copyright © 2017年 codoon. All rights reserved.
//

#import "ViewController.h"
#import "ClockView.h"

@interface ViewController ()

@property (nonatomic, strong) ClockView *clockView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _clockView = [[ClockView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    _clockView.center = self.view.center;
    [self.view addSubview:_clockView];

    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(clockAction)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)clockAction {
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    [calendar setTimeZone:zone];
    NSDateComponents *currentTime = [calendar components:NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitTimeZone fromDate:currentDate];
    _clockView.dateComponents = currentTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
