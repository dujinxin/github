//
//  DJXShakeViewController.m
//  JXView
//
//  Created by dujinxin on 14-11-7.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXShakeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

@interface DJXShakeViewController ()
{
    UIImageView * shake;
    SystemSoundID soundId;
}
@end

@implementation DJXShakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    shake = [[UIImageView alloc]initWithFrame:CGRectMake(120, 80, 150, 150)];
    shake.image = [UIImage imageNamed:@"ico_deco_shake"];
    [self.view addSubview:shake];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"wav"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundId);
    
}

-(void)addAnimations
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"transform"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_4, 0, 0, 100)];
    
    
    
    translation.duration = 0.2;
    translation.repeatCount = 2;
    translation.autoreverses = YES;
    
    [shake.layer addAnimation:translation forKey:@"translation"];
    
}



-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
    if(motion==UIEventSubtypeMotionShake)
    {
        NSLog(@"摇一摇");
        
        [self addAnimations];
        AudioServicesPlaySystemSound (soundId);
        
    }
    
}


- (void)clickControlButton:(id)sender {
    
    
    [self addAnimations];
    AudioServicesPlaySystemSound (soundId);
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
