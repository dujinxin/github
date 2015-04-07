//
//  NetManager.h
//  JXView
//
//  Created by dujinxin on 14-10-28.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef enum{
    kNetworkStateNone = 0,
    kNetworkState2G =1,
    kNetworkState3G ,
    kNetworkState4G ,
    kNetworkStateWIFI = 5,
}kNetworkType;
@interface NetManager : NSObject

+ (NetManager *)shareNetManager;

+ (BOOL)networkConnection;
@end
