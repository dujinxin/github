//
//  DJXShakeViewController.h
//  JXView
//
//  Created by dujinxin on 14-11-7.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXBasicViewController.h"

typedef void(^shakeCallback)(id obj);

typedef enum {
    kCouponAward = 1,
    kIntergralAward,
    kGoodsAward,
    kNoneAward,
    kIntergralExchange,
    kNoneTimes,
    kNoneInfo,
}kAwardType;

@interface DJXShakeViewController : DJXBasicViewController<UIAlertViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) shakeCallback systemAudioCallback;
@property (nonatomic, copy) shakeCallback shareBlock;

@end
