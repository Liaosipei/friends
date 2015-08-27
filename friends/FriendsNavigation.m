//
//  FriendsNavigation.m
//  Linkr
//
//  Created by liaosipei on 15/8/24.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import "FriendsNavigation.h"

@interface FriendsNavigation ()

@end

@implementation FriendsNavigation

-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.friends=[[FriendsViewController alloc]init];
        [self pushViewController:self.friends animated:YES];
        //[self addChildViewController:self.friends];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
