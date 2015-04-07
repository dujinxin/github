//
//  DJXAPPTableViewCell.m
//  JXView
//
//  Created by dujinxin on 15-3-25.
//  Copyright (c) 2015年 e-future. All rights reserved.
//

#import "DJXAPPTableViewCell.h"

@implementation DJXAPPTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.image.layer.cornerRadius = 10;
        self.image.clipsToBounds = YES;
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 230, 20)];
        self.name.font = [UIFont boldSystemFontOfSize:15.0];
        
        self.detail = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 230, 30)];
        self.detail.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:self.image];
        [self addSubview:self.name];
        [self addSubview:self.detail];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
