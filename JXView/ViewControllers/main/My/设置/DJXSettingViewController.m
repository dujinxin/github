//
//  DJXSettingViewController.m
//  JXView
//
//  Created by dujinxin on 15-4-8.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXSettingViewController.h"
#import "DJXFileManager.h"

@interface DJXSettingViewController ()

@end

@implementation DJXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@"打开系统设置"];
    [self.dataArray addObject:@"清除缓存"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if (indexPath.row == 1) {
            UILabel * sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 70, 44)];
            sizeLabel.textColor = [UIColor blackColor];
            sizeLabel.tag = 10;
            [cell.contentView addSubview:sizeLabel];
        }
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 1) {
        UILabel * sizeLabel = (UILabel *)[cell.contentView viewWithTag:10];
        NSString * sizeString = [[DJXFileManager defaultManager] sizeOfFolderWithPath:kCacheFolderPath];
//        NSString * sizeString = nil;
//        if (size < 1) {
//            size /= 1024.0;
//            sizeString = [NSString stringWithFormat:@"%fK", size];
//        }else{
//            sizeString = [NSString stringWithFormat:@"%fM", size];
//        }
        sizeLabel.text = sizeString;
    }
    return cell;
}
/*
 其他调用系统设置的命令：
 
 NSURL *appSettings = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
 [[UIApplication sharedApplication] openURL:appSettings];
 
 ******iOS5以后已经废弃？******
 
 About – prefs:root=General&path=About
 Accessibility – prefs:root=General&path=ACCESSIBILITY
 Airplane Mode On – prefs:root=AIRPLANE_MODE
 Auto-Lock – prefs:root=General&path=AUTOLOCK
 Brightness – prefs:root=Brightness
 Bluetooth – prefs:root=General&path=Bluetooth
 Date & Time – prefs:root=General&path=DATE_AND_TIME
 FaceTime – prefs:root=FACETIME
 General – prefs:root=General
 Keyboard – prefs:root=General&path=Keyboard
 iCloud – prefs:root=CASTLE
 iCloud Storage & Backup – prefs:root=CASTLE&path=STORAGE_AND_BACKUP
 International – prefs:root=General&path=INTERNATIONAL
 Location Services – prefs:root=LOCATION_SERVICES
 Music – prefs:root=MUSIC
 Music Equalizer – prefs:root=MUSIC&path=EQ
 Music Volume Limit – prefs:root=MUSIC&path=VolumeLimit
 Network – prefs:root=General&path=Network
 Nike + iPod – prefs:root=NIKE_PLUS_IPOD
 Notes – prefs:root=NOTES
 Notification – prefs:root=NOTIFICATIONS_ID
 Phone – prefs:root=Phone
 Photos – prefs:root=Photos
 Profile – prefs:root=General&path=ManagedConfigurationList
 Reset – prefs:root=General&path=Reset
 Safari – prefs:root=Safari
 Siri – prefs:root=General&path=Assistant
 Sounds – prefs:root=Sounds
 Software Update – prefs:root=General&path=SOFTWARE_UPDATE_LINK
 Store – prefs:root=STORE
 Twitter – prefs:root=TWITTER
 Usage – prefs:root=General&path=USAGE
 VPN – prefs:root=General&path=Network/VPN
 Wallpaper – prefs:root=Wallpaper
 Wi-Fi – prefs:root=WIFI
 */
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row){
        case 0:{
            if ( IOS_VERSION >=8) {
                if ( &UIApplicationOpenSettingsURLString != NULL ) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                    return;
                }
            }
        }
        break;
        case 1:{
            DJXFileManager * fileManager = [DJXFileManager defaultManager];
            [fileManager cleanCacheFolderWithPath:kCacheFolderPath];
        }
            break;
            
        default:
        break;
    }

}
@end
