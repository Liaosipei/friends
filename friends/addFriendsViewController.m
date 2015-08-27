//
//  addFriendsViewController.m
//  Linkr
//
//  Created by liaosipei on 15/8/27.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import "addFriendsViewController.h"
#import "addFriendsCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define lightGrayColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
#define fontBlueColor [UIColor colorWithRed:89.0/255 green:166.0/255 blue:212.0/255 alpha:1.0]
static NSString *CellIdentifier=@"CellIdentifier";

@interface addFriendsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tableViewConstraintHorizontal;
    NSArray *tableViewConstraintVertical;
    
    BOOL shouldInvite;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *inviteBar;
@property(nonatomic,strong)UIButton *inviteButton;


@end

@implementation addFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Add Friends";
    self.view.backgroundColor=[UIColor whiteColor];
    shouldInvite=NO;
    //tableView
    self.tableView=[[UITableView alloc]init];
    self.tableView.rowHeight=60;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    UINib *cellNib=[UINib nibWithNibName:@"addFriendsCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CellIdentifier];
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:self.tableView];
    //tableView约束
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary *viewsDic=NSDictionaryOfVariableBindings(_tableView);
    tableViewConstraintHorizontal=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:0 views:viewsDic];
    [self.view addConstraints:tableViewConstraintHorizontal];
    tableViewConstraintVertical=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]-45-|" options:0 metrics:0 views:viewsDic];
    [self.view addConstraints:tableViewConstraintVertical];
    
    [self getAddFriends];
    NSLog(@"==%@==",self.addFriendsName);
    
    [self creatInviteBar];
    self.selectNames=[NSMutableArray array];
    
}

-(void)getAddFriends
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(getAddFriendsName)])
        self.addFriendsName=[self.delegate getAddFriendsName];
}

-(void)creatInviteBar
{
    self.inviteBar=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-45, SCREEN_WIDTH, 45)];
    self.inviteBar.backgroundColor=lightGrayColor;
    //邀请按钮
    self.inviteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.inviteButton.frame=CGRectMake(0, 0, SCREEN_WIDTH, 45);
    [self.inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    [self.inviteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.inviteButton addTarget:self action:@selector(inviteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.inviteBar addSubview:self.inviteButton];
    [self.view addSubview:self.inviteBar];
}

-(void)inviteButtonPressed:(UIButton *)button
{
    if(shouldInvite==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Are you sure to invite this friend to your friends list?" delegate:self cancelButtonTitle:@"Sure" otherButtonTitles:@"cancel", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)//删除
    {
        NSMutableArray *indexSet=[NSMutableArray array];
        for (NSString *name in self.selectNames)
        {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.addFriendsName indexOfObject:name] inSection:0];
            [indexSet addObject:indexPath];
            [self.addFriendsName removeObject:name];
        }
        [self.tableView reloadData];
        [self.selectNames removeAllObjects];
    }
}

#pragma mark - tableView Data Source & Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addFriendsName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    addFriendsCell *cell=[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.addFriendsName.text=[self.addFriendsName objectAtIndex:indexPath.row];
    NSString *name=[NSString stringWithFormat:@"%@",[self.addFriendsName objectAtIndex:indexPath.row]];
    if([self.selectNames indexOfObject:name]==NSNotFound)
        cell.selectButton.hidden=YES;
    else
        cell.selectButton.hidden=NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *name=[NSString stringWithFormat:@"%@",[self.addFriendsName objectAtIndex:indexPath.row]];
    if([self.selectNames indexOfObject:name]==NSNotFound)
        [self.selectNames addObject:name];
    else
        [self.selectNames removeObject:name];

    [self.tableView reloadData];
    
    if(self.selectNames.count==0){
        [self.inviteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        shouldInvite=NO;
    }
    else {
        [self.inviteButton setTitleColor:fontBlueColor forState:UIControlStateNormal];
        shouldInvite=YES;
    }
    NSLog(@"%@",self.selectNames);
}

@end
