//
//  BlockedUsersViewController.m
//  Linkr
//
//  Created by liaosipei on 15/8/27.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import "BlockedUsersViewController.h"

static NSString *cellIdentifier=@"cellIdentifier";

@interface BlockedUsersViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tableViewConstraintHorizontal;
    NSArray *tableViewConstraintVertical;
}

@property(nonatomic,strong)NSMutableArray *blockedUsers;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation BlockedUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Blocked Users";
    self.view.backgroundColor=[UIColor whiteColor];
    self.blockedUsers=[NSMutableArray array];
    [self getblockedUsers];
    NSLog(@"%@",self.blockedUsers);
    
    //tableView
    self.tableView=[[UITableView alloc]init];
    self.tableView.rowHeight=60;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:self.tableView];
    //tableView约束
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary *viewsDic=NSDictionaryOfVariableBindings(_tableView);
    tableViewConstraintHorizontal=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:0 views:viewsDic];
    [self.view addConstraints:tableViewConstraintHorizontal];
    tableViewConstraintVertical=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]-45-|" options:0 metrics:0 views:viewsDic];
    [self.view addConstraints:tableViewConstraintVertical];
}

-(void)getblockedUsers
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getblockedUsersName)])
        self.blockedUsers=[self.delegate getblockedUsersName];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.blockedUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text=[self.blockedUsers objectAtIndex:indexPath.row];
    return cell;
}

@end
