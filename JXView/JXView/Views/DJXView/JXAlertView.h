//
//  JXAlertView.h
//  JXView
//
//  Created by dujinxin on 14-11-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXLabel.h"


typedef enum{
    kBgViewTag = 9900,
    kButtonTag = 10000,
}kViewTag;

@class JXAlertView;
@protocol JXAlertViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(JXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(JXAlertView *)alertView;

- (void)willPresentAlertView:(JXAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(JXAlertView *)alertView;  // after animation

- (void)alertView:(JXAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(JXAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;

@end

@interface JXAlertView : UIView
{
    @public
    id<JXAlertViewDelegate> delegate;
    
}
@property (nonatomic, assign)id<JXAlertViewDelegate> delegate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;


- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles;
- (id)initWithTitle:(NSString *)title customView:(UIView *)customView delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles;
- (void)show;
- (void)showInView:(UIView *)view animate:(BOOL)animated;
- (void)dismiss;
- (void)dismiss:(BOOL)animated;
@end
