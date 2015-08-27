# friends

friends展示朋友列表，实现以下功能：  
1. 按照首字母排列名字，并以首字母作为tableView的headerInSection，右边显示字母索引，并可准确定位到指定位置。  
2. tableView的上方添加了搜索框，并可快速搜索包含指定字符的名字，同时实时显示在另一个tableView中。  
3. 编辑Edit功能：点击右上角的Edit后，下方出现“Select All”和“Block”按钮，分别实现选择全部和将选中的朋友加入block功能。  
4. “Add friends”功能：点击进入后显示可邀请的朋友列表，选择（以cell右方是否有star为准）朋友即可邀请。  
5. “Blocked Users”功能：主界面选择朋友加入block（黑名单），该朋友在列表中删除，需要进入Blocked Users界面方可看到。  
6. 大部分布局和frame的改动均用AutoLayout实现，使得应用在不同设备上运行良好。  

#使用说明

使用时，需要在AppDelegate.m中import文件"FriendsNavigation.h"，并在函数application:didFinishLaunchingWithOptions:中添加如下代码：  
    FriendsNavigation *friendsNav=[[FriendsNavigation alloc]init];  
    self.window.rootViewController=friendsNav;  
    [self.window makeKeyAndVisible];  
