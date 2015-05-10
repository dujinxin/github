//
//  JXAlertView.m
//  JXView
//
//  Created by dujinxin on 14-11-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "JXAlertView.h"

@interface JXAlertView (){
//    UIView * bgView;
}
@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)JXLabel * textLabel;
@property (nonatomic,strong)UIView * customView;
@property (nonatomic,assign)CGFloat top;
@end

@implementation JXAlertView
@synthesize title = _title;
@synthesize message = _message;
@synthesize delegate = _delegate;

#pragma CustomInit
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//纯文本信息
- (id)initWithTitle:(NSString *)title message:(NSString *)message target:(id)target buttonTitles:(NSArray *)buttonTitles{
    self = [super init];
    if (self) {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, 260, 200);
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor yellowColor];
        self.center = [UIApplication sharedApplication].keyWindow.center;

        //添加标题
        BOOL isHasTitle = NO;
        if (title) {
            self.title = title;
            [self addSubview:self.titleLabel];
            isHasTitle = YES;
        }
        //文本信息
        self.top = isHasTitle ? _titleLabel.frame.size.height : 10;
        if (message) {
            self.message = message;
            [self addSubview:self.textLabel];
            
            //分割线
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.frame.size.height-1, self.frame.size.width, 1)];
            line.backgroundColor = UIColorFromRGB(0xfc5860);
            [self addSubview:line];
        }
        if (target) {
            self.delegate = target;
        }
        totalHeight = _textLabel.frame.size.height + _top;
        //添加按钮---暂定一行显示2个，奇数个时最后一个放满一行。其他显示以后有空再加
        CGFloat space = 20;
        CGFloat width = (self.frame.size.width - space -10*2)/2;
        CGFloat height = 30;
        CGFloat x = 0;
        CGFloat y = 0;
        for (int i = 0 ; i < buttonTitles.count; i ++) {
            x = i %2;
            y = i /2;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 + (width +space) * x, _textLabel.frame.size.height + _textLabel.frame.origin.y +10 + (10 +height) *y, width, height);
            button.backgroundColor = UIColorFromRGB(0xfc5860);
            button.tag = kButtonTag + i;
            button.layer.cornerRadius = 5;
            [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (buttonTitles.count %2 != 0){
                if (i == buttonTitles.count -1) {
                    button.frame = CGRectMake(10, _textLabel.frame.size.height + _textLabel.frame.origin.y +10 + (10 +height) *y, (self.frame.size.width -10*2), height);
                    totalHeight = button.frame.origin.y + button.frame.size.height ;
                }
            }
            
        }
        self.frame = CGRectMake(0, 0, 260, totalHeight +10);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        
    }
    return self;
}
//可以自定义内容
- (id)initWithTitle:(NSString *)title customView:(UIView *)customView target:(id)target buttonTitles:(NSArray *)buttonTitles{
    self = [super init];
    if (self) {
        CGFloat totalHeight = 0;
        self.frame = CGRectMake(0, 0, 280, 200);
        self.layer.cornerRadius = 8;
        self.backgroundColor = [UIColor whiteColor];
        
        //添加标题
        BOOL isHasTitle = NO;
        if (title) {
            self.title = title;
            [self addSubview:self.titleLabel];
            isHasTitle = YES;
            //分割线
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.frame.size.height-1, self.frame.size.width, 1)];
            line.backgroundColor = UIColorFromRGB(0xfc5860);
            [self addSubview:line];
        }
        //自定义视图
        _top = isHasTitle ? self.titleLabel.frame.size.height : 10;
        CGRect frame = customView.frame;
        customView.frame = CGRectMake(20, _top, self.frame.size.width -20, frame.size.height);
//        customView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:customView];
        if (target) {
            self.delegate = target;
        }
        totalHeight = frame.size.height + _top;
        //添加按钮---暂定一行显示2个，奇数个时最后一个放满一行。其他显示以后有空再加
        CGFloat space = 20;
        CGFloat width = (self.frame.size.width - space -10*2)/2;
        CGFloat height = 30;
        CGFloat x = 0;
        CGFloat y = 0;
        for (int i = 0 ; i < buttonTitles.count; i ++) {
            x = i %2;
            y = i /2;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20 + (width +space) * x, customView.frame.size.height + customView.frame.origin.y +10 + (10 +height) *y, width, height);
            button.backgroundColor = UIColorFromRGB(0xfc5860);
            button.tag = kButtonTag + i;
            button.layer.cornerRadius = 5;
            [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (buttonTitles.count %2 != 0){
                if (i == buttonTitles.count -1) {
                    button.frame = CGRectMake(20, customView.frame.size.height + customView.frame.origin.y +10 + (10 +height) *y, (self.frame.size.width -10*2), height);
                    totalHeight = button.frame.origin.y + button.frame.size.height;
                }
            }else{
                if (i == buttonTitles.count -1) {
                    totalHeight = button.frame.origin.y + button.frame.size.height ;
                }
            }
            
        }
        self.frame = CGRectMake(0, 0, 280, totalHeight +10);
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }
    return self;
}
- (void)buttonClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [_delegate alertView:self willDismissWithButtonIndex:btn.tag -kButtonTag];
    }
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:btn.tag -kButtonTag];
    }
    if ([_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [_delegate alertView:self didDismissWithButtonIndex:btn.tag -kButtonTag];
    }
    
    [self dismiss];
    
}

- (void)show{
    [self showInView:nil animate:NO];
}
- (void)showInView:(UIView *)view animate:(BOOL)animated{
    //将要出现
    if ([_delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [_delegate willPresentAlertView:self];
    }
    //添加背景
    if (view) {
        //动画暂时先不加了。。。
        [view addSubview:self.bgView];
        CGPoint center =[UIApplication sharedApplication].keyWindow.center;
        self.center = CGPointMake(center.x, center.y -64);
        [view addSubview:self];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    //已经出现
    if ([_delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [_delegate willPresentAlertView:self];
    }
}
- (void)dismiss
{
    [self dismiss:NO];
}
- (void)dismiss:(BOOL)animated
{
    //    UIView * bgView = [self.superview viewWithTag:kBgViewTag];
    //    [bgView removeFromSuperview];
    //暂时没有动画
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    [self removeFromSuperview];
}
#pragma mark - ViewInit
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.tag = kBgViewTag;
        _bgView.alpha = 0.5;
    }
    return _bgView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        //添加标题
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _title;
    }
    return _titleLabel;
}
-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[JXLabel alloc]initWithFrame:CGRectMake(10, _top, self.frame.size.width -40, 40)];
        _textLabel.useContextHeight = YES;
        //        messageLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _textLabel.backgroundColor = [UIColor redColor];
        _textLabel.text = _message;
        _textLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _textLabel;
}
-(UIView *)customView{
    if (!_customView) {
        //....
    }
    return nil;
}
- (NSString *)title{
    return _title;
}
- (NSString *)message{
    return _message;
}
- (id<JXAlertViewDelegate>)delegate{
    return _delegate;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
