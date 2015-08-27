//
//  addFriendsCell.m
//  Linkr
//
//  Created by liaosipei on 15/8/27.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import "addFriendsCell.h"

@implementation addFriendsCell

- (void)awakeFromNib {
    self.selectButton.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
