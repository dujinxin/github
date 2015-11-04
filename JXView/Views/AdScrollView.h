//
//  AdScrollView.h
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIPageStyle) {
    UIPageNoneStyle,            
    UIPageControlPointStyle,
    UIPageLabelNumberStyle,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@class AdScrollView;
@protocol AdScrollViewDelegate <NSObject>

-(void)adScrollView:(AdScrollView *)adScrollView clickedViewForPage:(NSInteger)page;

@end

@interface AdScrollView : UIScrollView<UIScrollViewDelegate>

@property (assign,nonatomic)id<AdScrollViewDelegate> adDelegate;

@property (retain,nonatomic,readonly) UIPageControl * pageControl;
@property (strong,nonatomic,readwrite)UILabel   * pageLabel;

@property (retain,nonatomic,readwrite) NSArray * imageNameArray;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;
@property (assign,nonatomic,readwrite) UIPageStyle  pageStyle;
@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
