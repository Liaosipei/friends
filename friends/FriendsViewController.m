//
//  FriendsViewController.m
//  Linkr
//
//  Created by liaosipei on 15/8/24.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import "FriendsViewController.h"
#import "addFriendsViewController.h"
#import "BlockedUsersViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define purpleColor [UIColor colorWithRed:192/255.0 green:158/255.0 blue:224/255.0 alpha:1];
#define blueColor [UIColor colorWithRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1];
#define lightGrayColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
#define fontBlueColor [UIColor colorWithRed:89.0/255 green:166.0/255 blue:212.0/255 alpha:1.0]
static NSString *CellIdentifier = @"Cell";

@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,addFriendsDataSource,blockedUsersDataSource>{
    NSArray *tableViewConstraintHorizontal;
    NSArray *tableViewConstraintVertical;
    BOOL isEditing;
}

@property(nonatomic,strong)NSMutableDictionary *friendsNameDic;
@property(nonatomic,strong)NSMutableArray *friendsNameArray;
@property(nonatomic,strong)NSMutableArray *blockedFriends;
@property(nonatomic,strong)NSMutableArray *addFriendsName;

@property(nonatomic,strong)NSMutableArray *searchName;
@property(nonatomic,strong)NSArray *nameKeys;

@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)UIView *editOptionBar;
@property(nonatomic,strong)UIButton *selectAllButton, *blockButton;

@property(nonatomic,strong)addFriendsViewController *addFriendsController;
@property(nonatomic,strong)BlockedUsersViewController *blockedUsersController;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isEditing=NO;
    //设置导航条
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title=@"Friends";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    self.navigationController.navigationBar.barTintColor=blueColor;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置导航条的右按钮
    UIBarButtonItem *editBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(clickEditButton:)];
    editBarBtn.tintColor=[UIColor whiteColor];
    editBarBtn.width=30;
    self.navigationItem.rightBarButtonItem=editBarBtn;
    self.view.backgroundColor=[UIColor whiteColor];
    //设置tableView
    self.tableView=[[UITableView alloc]init];
    self.tableView.estimatedRowHeight=60;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
        //设置tableView索引
    self.tableView.sectionIndexColor=[UIColor grayColor];
    self.tableView.sectionIndexBackgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tableView];
        //tableView约束
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    NSDictionary *viewsDic=NSDictionaryOfVariableBindings(_tableView);
    tableViewConstraintHorizontal=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:0 views:viewsDic];
    [self.view addConstraints:tableViewConstraintHorizontal];
    tableViewConstraintVertical=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_tableView]|" options:0 metrics:0 views:viewsDic];
    [self.view addConstraints:tableViewConstraintVertical];
    //设置上方搜索条
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    //self.searchController.searchBar.frame=CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
    self.searchController.searchBar.frame=CGRectMake(0, 0, SCREEN_WIDTH, 40);
    self.searchController.searchResultsUpdater=self;
    self.searchController.dimsBackgroundDuringPresentation=NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    //self.tableView.tableHeaderView=self.searchController.searchBar;
    [self.view addSubview:self.searchController.searchBar];
    //获取数据
    self.friendsNameDic=[[NSMutableDictionary alloc] init];
    self.friendsNameArray=[[NSMutableArray alloc]init];
    self.friendsNameDic=[self getData];
    for (NSString *key in [self.friendsNameDic allKeys]) {
        NSArray *array=[self.friendsNameDic objectForKey:key];
        for (NSString *name in array)
            [self.friendsNameArray addObject:name];
    }
    self.nameKeys=[[self.friendsNameDic allKeys]sortedArrayUsingSelector:@selector(compare:)];
    self.blockedFriends=[NSMutableArray array];
    self.addFriendsName=[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"addFriendsName" ofType:@"plist"]];
}

-(NSMutableDictionary *)getData
{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"friendsName" ofType:@"plist"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

-(NSMutableArray *)getAddFriendsName
{
    return self.addFriendsName;
}

-(NSMutableArray *)getblockedUsersName
{
    return self.blockedFriends;
}

#pragma mark - Edit

-(void)clickEditButton:(UIBarButtonItem *)button
{
    [self.selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
    if(!_editOptionBar)
        [self creatEditOptionBar];
    if([button.title isEqualToString:@"Edit"])
    {
        isEditing=YES;
        [self.view removeConstraints:tableViewConstraintVertical];
        NSDictionary *viewsDic=NSDictionaryOfVariableBindings(_tableView);
        tableViewConstraintVertical=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_tableView]-45-|" options:0 metrics:0 views:viewsDic];
        [self.view addConstraints:tableViewConstraintVertical];
        self.editOptionBar.hidden=NO;
        [button setTitle:@"Done"];
        [self.tableView setAllowsMultipleSelectionDuringEditing:YES];
        [self.tableView setEditing:YES animated:YES];
    }else
    {
        isEditing=NO;
        [self.view removeConstraints:tableViewConstraintVertical];
        NSDictionary *viewsDic=NSDictionaryOfVariableBindings(_tableView);
        tableViewConstraintVertical=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_tableView]|" options:0 metrics:0 views:viewsDic];
        [self.view addConstraints:tableViewConstraintVertical];
        self.editOptionBar.hidden=YES;
        
        [button setTitle:@"Edit"];
        [self.tableView setAllowsMultipleSelectionDuringEditing:NO];
        [self.tableView setEditing:NO animated:YES];
        
    }
}

-(void)creatEditOptionBar
{
    
    self.editOptionBar=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-45, SCREEN_WIDTH, 45)];
    self.editOptionBar.backgroundColor=[[UIColor grayColor]colorWithAlphaComponent:0.1f];
    //选择全部按钮
    self.selectAllButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllButton.frame=CGRectMake(0, 0, SCREEN_WIDTH/2, 45);
    [self.selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
    [self.selectAllButton setTitleColor:fontBlueColor forState:UIControlStateNormal];
    [self.selectAllButton addTarget:self action:@selector(selectAllButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //删除按钮
    self.blockButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.blockButton.frame=CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 45);
    [self.blockButton setTitle:@"Block" forState:UIControlStateNormal];
    [self.blockButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.blockButton addTarget:self action:@selector(blockButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.editOptionBar addSubview:self.selectAllButton];
    [self.editOptionBar addSubview:self.blockButton];
    [self.view addSubview:self.editOptionBar];
}

-(void)selectAllButtonPressed:(UIButton *)button
{
    if([self.selectAllButton.titleLabel.text isEqualToString:@"Select All"])
    {
        for (int section=1; section<=[self.nameKeys count]; section++)
        {
            for(int row=0;row<[[self.friendsNameDic objectForKey:[self.nameKeys objectAtIndex:section-1]] count];row++)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        
        [self.selectAllButton setTitle:@"Unselect All" forState:UIControlStateNormal];
    }else
    {
        for (int section=1; section<=[self.nameKeys count]; section++)
        {
            for(int row=0;row<[[self.friendsNameDic objectForKey:[self.nameKeys objectAtIndex:section-1]] count];row++)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            }
        }
        [self.selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
    }
    
}

-(void)blockButtonPressed:(UIButton *)button
{
    NSArray *selectedRows=[self.tableView indexPathsForSelectedRows];
    if(selectedRows>0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"When you block someone, you won't be able to see any posts from that person." delegate:self cancelButtonTitle:@"Block" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"You haven't select any friend!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *selectedRows=[self.tableView indexPathsForSelectedRows];
    if(buttonIndex==0)//删除
    {
        for (NSIndexPath *selectedIndexPath in selectedRows)
        {
            NSString *key=[self.nameKeys objectAtIndex:selectedIndexPath.section-1];
            NSMutableArray *array=[self.friendsNameDic objectForKey:key];
            [self.blockedFriends addObject:[array objectAtIndex:selectedIndexPath.row]];
            [array removeObjectAtIndex:selectedIndexPath.row];
            [self.friendsNameDic removeObjectForKey:key];
            [self.friendsNameDic setObject:array forKey:key];
        }
        [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationFade];
    }
    NSLog(@"==%@==",self.blockedFriends);
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.searchController.active==YES)
        return 1;
    return [self.nameKeys count]+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchController.active==YES)
        return [self.searchName count];
    else
    {
        if(section==0)
            return 2;
        else
        {
            NSArray *namesOfSection=[self.friendsNameDic objectForKey:[self.nameKeys objectAtIndex:section-1]];
            return [namesOfSection count];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(self.searchController.active==YES)
    {
        cell=[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text=[self.searchName objectAtIndex:indexPath.row];
    }else
    {
        if(indexPath.section==0)
        {
            cell=[[UITableViewCell alloc] init];
            if(indexPath.row==0)
            {
                UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add.png"]];
                imageView.frame=CGRectMake(15, 15, 30, 30);
                [cell.contentView addSubview:imageView];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 60)];
                label.text=@"Add friends";
                [cell.contentView addSubview:label];
            }else if(indexPath.row==1)
            {
                UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"block.png"]];
                imageView.frame=CGRectMake(16, 17, 28, 28);
                [cell.contentView addSubview:imageView];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 60)];
                label.text=@"Blocked Users";
                [cell.contentView addSubview:label];
            }
        }else
        {
            cell=[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            NSArray *namesOfSection=[self.friendsNameDic objectForKey:[self.nameKeys objectAtIndex:indexPath.section-1]];
            cell.textLabel.text=[namesOfSection objectAtIndex:indexPath.row];
        }
    }
    return cell;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.searchController.active==YES)
        return nil;
    else
    {
        NSMutableArray *array=[NSMutableArray arrayWithArray:self.nameKeys];
        [array insertObject:UITableViewIndexSearch atIndex:0];
        return array;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isEditing==NO)
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==0 && indexPath.row==0)
    {
        self.addFriendsController=[[addFriendsViewController alloc]init];
        self.addFriendsController.delegate=self;
        [self.navigationController pushViewController:self.addFriendsController animated:YES];
    }
    if(indexPath.section==0 && indexPath.row==1)
    {
        self.blockedUsersController=[[BlockedUsersViewController alloc]init];
        self.blockedUsersController.delegate=self;
        [self.navigationController pushViewController:self.blockedUsersController animated:YES];
    }
}

#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchController.active==YES)
        return 60;
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 0;
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 20)];
    label.backgroundColor=[UIColor clearColor];
    label.text=[self.nameKeys objectAtIndex:section-1];
    label.textColor=[UIColor grayColor];
    label.font=[UIFont systemFontOfSize:15];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 20)];
    view.backgroundColor=lightGrayColor;
    [view addSubview:label];
    return view;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString=self.searchController.searchBar.text;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchString];
    if(self.searchName!=nil)
        [self.searchName removeAllObjects];
    self.searchName=[NSMutableArray arrayWithArray:[self.friendsNameArray filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return NO;
    return YES;
}


@end
