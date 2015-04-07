//
//  DJXAnimationViewController.m
//  JXView
//
//  Created by dujinxin on 15-3-17.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXAnimationViewController.h"

@interface DJXAnimationViewController(){
    UIImageView * imageView;
}

@end
@implementation DJXAnimationViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 120, 80, 80)];
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView];
    
    
    
    
    UIButton * start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [start setFrame:CGRectMake(120, 400, 80, 80)];
    [start setTag:100];
    [start setTitle:@"start" forState:UIControlStateNormal];
    [start addTarget:self action:@selector(startAnimating:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    
//    [self intiUIOfView];
    
}
-(void)startAnimating:(id)sender{
    UIButton * drawButton = (UIButton *)sender;
    [drawButton setEnabled:NO];
    
    CGMutablePathRef starPath = CGPathCreateMutable();
//    CGPathMoveToPoint(starPath,NULL,160.0f, 100.0f);
//    CGPathAddLineToPoint(starPath, NULL, 100.0f, 280.0f);
//    CGPathAddLineToPoint(starPath, NULL, 260.0, 170.0);
//    CGPathAddLineToPoint(starPath, NULL, 60.0, 170.0);
//    CGPathAddLineToPoint(starPath, NULL, 220.0, 280.0);
    UIColor * aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
//    CGContextSetFillColorWithColor(imageView, aColor.CGColor);//填充颜色
    CGPathAddArc(starPath, NULL, self.view.frame.size.width/2,self.view.frame.size.height/2-20, 100, 0, 2*M_PI, NO);
    
    CGPathCloseSubpath(starPath);
    

    
    CAKeyframeAnimation *animation = nil;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setDuration:10.0f];
    [animation setDelegate:self];
    [animation setPath:starPath];

    CFRelease(starPath);
    starPath = nil;
    [[imageView layer] addAnimation:animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    UIButton * drawButton = (UIButton *)[self.view viewWithTag:100];
    [drawButton setEnabled:YES];
}


//定义所需要画的图形
-(void)intiUIOfView
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2-20) radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO];
    CAShapeLayer * arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;//46,169,230
    arcLayer.fillColor=[UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1].CGColor;
    arcLayer.strokeColor=[UIColor colorWithWhite:1 alpha:0.7].CGColor;
    arcLayer.lineWidth=3;
    arcLayer.frame=self.view.frame;
    [self.view.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];
    
}

//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}
@end
