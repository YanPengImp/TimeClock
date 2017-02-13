//
//  ClockView.m
//  TimeClock
//
//  Created by Imp on 17/2/13.
//  Copyright © 2017年 codoon. All rights reserved.
//

#import "ClockView.h"

static const CGFloat KRoundWidth = 5;
static const CGFloat KDialLength = 4;
static const NSInteger KDialCount = 60;

#define center self.center
#define width self.frame.size.width / 2

@interface ClockView ()

@property (nonatomic, strong) CALayer *dialLayer;
@property (nonatomic, strong) UIView *hourView;
@property (nonatomic, strong) UIView *minView;
@property (nonatomic, strong) UIView *secView;

@end

@implementation ClockView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addLayer];
        [self addViews];
    }
    return self;
}

- (void)addLayer {
    self.dialLayer = [CALayer layer];
    for (NSInteger i = 0; i < KDialCount; i++) {
        [self addDialLineWithIndex:i];
    }
    [self.layer addSublayer:self.dialLayer];
    [self.layer addSublayer:[self roundLayer]];
}

- (CAShapeLayer *)roundLayer {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.lineWidth = KRoundWidth;
    shapeLayer.path = [self roundPath].CGPath;
    return shapeLayer;
}

- (UIBezierPath *)roundPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:width startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    return path;
}

- (void)addDialLineWithIndex:(NSInteger)i {
    CAShapeLayer *dial = [CAShapeLayer layer];
    dial.strokeColor = [UIColor blackColor].CGColor;
    dial.lineWidth = 1;

    CGFloat radiusOut = width - KRoundWidth;
    CGFloat radiusIn = radiusOut - KDialLength;
    if (i % 5 == 0) {
        radiusIn -= 3;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat angle = -M_PI_2 + i * (2*M_PI/60);
    CGPoint start,end;
    start = CGPointMake(center.x + (radiusIn * cos(angle)), center.y + (radiusIn * sin(angle)));
    end = CGPointMake(center.x + (radiusOut * cos(angle)), center.y + (radiusOut * sin(angle)));
    [bezierPath moveToPoint:start];
    [bezierPath addLineToPoint:end];
    dial.path = bezierPath.CGPath;
    [self.dialLayer addSublayer:dial];
}

- (void)addViews {
    _hourView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, width - 30)];
    _hourView.center = center;
    _hourView.backgroundColor = [UIColor redColor];
    _hourView.layer.anchorPoint = CGPointMake(0.5, 0.95);//锚点 以这个点为支点旋转
    [self addSubview:_hourView];
    _minView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, width - 20)];
    _minView.center = center;
    _minView.backgroundColor = [UIColor blueColor];
    _minView.layer.anchorPoint = CGPointMake(0.5, 0.95);
    [self addSubview:_minView];
    _secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, width - 15)];
    _secView.center = center;
    _secView.backgroundColor = [UIColor grayColor];
    _secView.layer.anchorPoint = CGPointMake(0.5, 0.95);
    [self addSubview:_secView];
}

- (void)setDateComponents:(NSDateComponents *)dateComponents {
    _dateComponents = dateComponents;
    //秒针角度
    CGFloat secAngle = (M_PI * 2 / 60) * dateComponents.second;
    self.secView.transform = CGAffineTransformMakeRotation(secAngle);
    //分针角度
    CGFloat minuteAngle = (M_PI * 2 / 60) * dateComponents.minute + (M_PI * 2 / 60 / 60) * dateComponents.second;
    self.minView.transform = CGAffineTransformMakeRotation(minuteAngle);
    //时针角度
    CGFloat hourAngle = (M_PI * 2 / 12) * dateComponents.hour + (M_PI * 2 / 12 / 60) * dateComponents.minute;
    self.hourView.transform = CGAffineTransformMakeRotation(hourAngle);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1);
    UIFont *font = [UIFont systemFontOfSize:10];
    UIColor *foregroundColor = [UIColor blackColor];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: foregroundColor};

    NSArray *numArr = @[@"12",@"3",@"6",@"9"];
    NSArray *offsetXArr = @[@(-5),@(-13),@(-3),@(8)];
    NSArray *offsetYArr = @[@(3),@(-7),@(-15),@(-7)];
    CGFloat radiusOut = width - KRoundWidth;
    CGFloat radiusIn = radiusOut - KDialLength;
    for (NSInteger i = 0; i < numArr.count; i++) {
        CGFloat angle =  -M_PI_2 + i * M_PI_2;
        CGPoint insidePoint = CGPointMake(width + (radiusIn * cos(angle)), width + (radiusIn * sin(angle))); //相对于当前view的坐标 当前宽度高度的一半 即中心点
        CGFloat offsetX = [offsetXArr[i] floatValue];
        CGFloat offsetY = [offsetYArr[i] floatValue];
        CGRect rect = CGRectMake(insidePoint.x + offsetX, insidePoint.y + offsetY, 12, 10);
        NSString *text = numArr[i];
        [text drawInRect:rect withAttributes:attributes];
    }
}

@end
