//
//  DemoSettingController.m
//  XBSettingControllerDemo
//
//  Created by XB on 15/9/23.
//  Copyright © 2015年 XB. All rights reserved.
//

#import "MSSettingController.h"
#import "MSConst.h"
#import "MSSettingCell.h"
#import "MSSettingItemModel.h"
#import "MSSettingSectionModel.h"
@interface MSSettingController ()
@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/

@end

@implementation MSSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MSMakeColorWithRGB(234, 234, 234, 1);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setupSections];
}

- (void)showAlert:(NSString *)title
{
}

#pragma - mark setup
- (void)setupSections
{
    //************************************section1
    MSSettingItemModel *item1 = [[MSSettingItemModel alloc]init];
    item1.funcName = @"我的余额";
    item1.executeCode = ^{
        NSLog(@"我的余额");
        [self showAlert:@"我的余额"];
    };
    item1.detailText = @"做任务赢大奖";
    item1.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item2 = [[MSSettingItemModel alloc]init];
    item2.funcName = @"修改密码";
    item2.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingSectionModel *section1 = [[MSSettingSectionModel alloc]init];
    section1.sectionHeaderHeight    = 18;
    section1.itemArray              = @[item1,item2];
    
    //************************************section2
    MSSettingItemModel *item3 = [[MSSettingItemModel alloc]init];
    item3.funcName = @"推送提醒";
    item3.accessoryType = MSSettingAccessoryTypeSwitch;
    item3.switchValueChanged = ^(BOOL isOn)
    {
        NSLog(@"推送提醒开关状态===%@",isOn?@"open":@"close");
    };
    
    MSSettingItemModel *item4 = [[MSSettingItemModel alloc]init];
    item4.funcName      = @"给我们打分";
    item4.detailImage   = [UIImage imageNamed:@"icon-new"];
    item4.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item5 = [[MSSettingItemModel alloc]init];
    item5.funcName      = @"意见反馈";
    item5.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingSectionModel *section2 = [[MSSettingSectionModel alloc]init];
    section2.sectionHeaderHeight    = 18;
    section2.itemArray              = @[item3,item4,item5];
    
    
    //************************************section3
    MSSettingItemModel *item6   = [[MSSettingItemModel alloc]init];
    item6.funcName              = @"关于我们";
    item6.accessoryType         = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item7   = [[MSSettingItemModel alloc]init];
    item7.funcName              = @"帮助中心";
    item7.accessoryType         = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item8   = [[MSSettingItemModel alloc]init];
    item8.funcName              = @"清除缓存";
    item8.accessoryType         = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingSectionModel *section3 = [[MSSettingSectionModel alloc]init];
    section3.sectionHeaderHeight    = 18;
    section3.itemArray = @[item6,item7,item8];
    
    self.sectionArray = @[section1,section2,section3];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MSSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier         = @"setting";
    MSSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    MSSettingItemModel *itemModel       = sectionModel.itemArray[indexPath.row];
    
    MSSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MSSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = itemModel;
    return cell;
}

#pragma - mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MSSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MSSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    MSSettingItemModel *itemModel       = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    MSSettingSectionModel *sectionModel = [self.sectionArray firstObject];
    CGFloat sectionHeaderHeight         = sectionModel.sectionHeaderHeight;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end