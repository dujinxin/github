//
//  JXLabel.h
//  JXView
//
//  Created by dujinxin on 14-10-18.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXEventProtocol.h"
@interface JXLabel : UILabel <JXEventProtocol> {
    void (^saveA)(id sender);
}

@end
