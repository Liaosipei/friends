//
//  addFriendsViewController.h
//  Linkr
//
//  Created by liaosipei on 15/8/27.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addFriendsDataSource <NSObject>

-(NSMutableArray *)getAddFriendsName;

@end

@interface addFriendsViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *selectNames;
@property(nonatomic,strong)NSMutableArray *addFriendsName;

@property(nonatomic,weak)id<addFriendsDataSource> delegate;

@end
