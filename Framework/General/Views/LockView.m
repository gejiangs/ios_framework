//
//  YYLockView.m
//  Framework
//
//  Created by guojiang on 23/10/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import "LockView.h"


@interface LockView ()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, assign) CGPoint currentPoint;

@end


@implementation LockView


-(NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)setup
{    
    //创建9个按钮
    for (int i=0; i<9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [btn setTag:i];
        [self addSubview:btn];
        btn.userInteractionEnabled = NO;
    }
    self.currentPoint = CGPointZero;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (int i=0; i<self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        
        //计算按钮frame
        CGFloat row = i/3;
        CGFloat loc = i%3;
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        CGFloat padding = (self.frame.size.width - btnW*3)/4;
        CGFloat btnX = padding + (btnW + padding) * loc;
        CGFloat btnY = padding + (btnW + padding) * row;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

//监听手续的移动
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint starPoint = [self getCurrentPoint:touches];
    UIButton *btn = [self getCurrentBtnWithPoint:starPoint];
    if (btn && btn.selected != YES) {
        btn.selected = YES;
        [self.buttons addObject:btn];
        
    }
    self.currentPoint = starPoint;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint movePoint = [self getCurrentPoint:touches];
    UIButton *btn = [self getCurrentBtnWithPoint:movePoint];
    //存储按钮
    //已经连过的按钮，不可再连
    if (btn && btn.selected != YES) {
        //设置按钮选中状态
        btn.selected = YES;
        //按按钮添加到数据中
        [self.buttons addObject:btn];
        
    }
    
    //记录当前起点(不在按钮的范围内)
    self.currentPoint = movePoint;
    
    //通知view重新绘制
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableString *result = [NSMutableString string];
    for (UIButton *btn in self.buttons) {
        [result appendFormat:@"%ld", (long)btn.tag];
    }
    
    if ([self.delegate respondsToSelector:@selector(LockViewDidClick:andPwd:)]) {
        [self.delegate LockViewDidClick:self andPwd:result];
    }
    
    //调用该方法，
    for (UIButton *btn in self.buttons) {
        btn.selected = NO;
    }
    
    //清空数组
    [self.buttons removeAllObjects];
    
    //清空当前点
    self.currentPoint = CGPointZero;
    
    [self setNeedsDisplay];
    
    
}

//对功能点进行封装
-(CGPoint)getCurrentPoint:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

-(UIButton *)getCurrentBtnWithPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (int i=0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        if (i == 0) {
            //设置起点(注意连接的是中点)
            CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
        }else{
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
        
    }
    
    if (self.currentPoint.x != 0 && self.currentPoint.y != 0) {
        CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
    }
    
    //渲染
    //设置线条的属性
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetRGBStrokeColor(ctx, 20/255.0, 107/255.0, 153/255.0, 1);
    CGContextStrokePath(ctx);
}


@end
