
//
//  DJXLoginViewController.m
//  JXView
//
//  Created by dujinxin on 15-4-29.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXLoginViewController.h"
#import "LoginEntity.h"

@interface DJXLoginViewController()<UITextFieldDelegate>{
    UITextField * userName;
    UITextField * passWord;
    
    UIButton    * loginButton;
}

@end

@implementation DJXLoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self setNavigationBar];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x654fa2)];
//    self.navigationItem.leftBarButtonItems = [self getNavigationItems:self selector:@selector(count) image:[UIImage imageNamed: @"二维码"] style:kSingleImage isLeft:YES];
    self.navigationItem.leftBarButtonItems =  [self getNavigationItems:self selector:@selector(cancel) title:@"取消" style:kDefault isLeft:YES];
    self.navigationItem.rightBarButtonItems =  [self getNavigationItems:self selector:@selector(logOut) title:@"退出" style:kDefault isLeft:NO];
    [self setTitleViewWithTitle:@"登陆"];
    [self initView];
}
-(void)setNavigationBar{
    UIButton * left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"退出" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:[self setNavigationBar:@"登陆" backgroundColor:UIColorFromRGB(0x654fa2) leftItem:left rightItem:right delegete:self]];
}
-(void)initView{
    userName = [[UITextField alloc]initWithFrame:CGRectMake(40, 64 + 40, 240, 40)];
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.placeholder = @"用户名";
    userName.delegate = self;
    [self.view addSubview:userName];
    
    passWord = [[UITextField alloc]initWithFrame:CGRectMake(40, userName.bottom + 30, 240, 40)];
    passWord.borderStyle = UITextBorderStyleRoundedRect;
    passWord.placeholder = @"密码";
    passWord.delegate = self;
    [self.view addSubview:passWord];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(40, passWord.bottom + 160, 240, 40);
    loginButton.backgroundColor = UIColorFromRGB(0xfc5860);
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    userName.text = @"13121273646";
    passWord.text = @"123456a";
}

-(void)login:(id)sender{
//    [[DJXRequestManager sharedInstance] requestWithBlock:[LoginObj className] param:@{@"user_name":userName.text,@"password":passWord.text} success:^(id object) {
//        //
//    } failure:^(id object) {
//        //
//    }];
    [[DJXRequestManager sharedInstance] requestWithDelegate:self className:[LoginObj className] param:@{@"user_name":userName.text,@"password":passWord.text} kApiTag:kApiUserLoginTag];
    
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)logOut{
    [[UserInfo shareManager] logOut];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [userName resignFirstResponder];
    [passWord resignFirstResponder];
    return YES;
}
-(void)responseFailed:(int)tag withStatus:(NSString*)status withMessage:(NSString*)errMsg{
    NSLog(@"%@",errMsg);
}
-(void)responseSuccess:(id)arrData tag:(int)tag{
    if (tag == kApiUserLoginTag) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"登陆成功！");
        }];
    }
}
@end
