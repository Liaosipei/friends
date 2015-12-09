//
//  BlockedUsersViewController.h
//  Linkr
//
//  Created by liaosipei on 15/8/27.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol blockedUsersDataSource <NSObject>

-(NSMutableArray *)getblockedUsersName;

@end

@interface BlockedUsersViewController : UIViewController

@property(nonatomic,weak)id<blockedUsersDataSource> delegate;

@end
