//
//  DemoMeController.m
//  XBSettingControllerDemo
//
//  Created by XB on 15/9/23.
//  Copyright © 2015年 XB. All rights reserved.
//

#import "MSMeController.h"
#import "MSMeHeaderView.h"
#import "MSConst.h"
#import "MSSettingCell.h"
#import "MSSettingItemModel.h"
#import "MSSettingSectionModel.h"
#import "MSSettingController.h"
@interface MSMeController ()

@property (nonatomic,strong) MSMeHeaderView *header;
@property (nonatomic,strong) NSArray  *sectionArray; /*section模型数组*/

@end

@implementation MSMeController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor       = MSMakeColorWithRGB(234, 234, 234, 1);
    self.tableView.backgroundColor  = [UIColor whiteColor];
    [self setupSections];
    
    MSMeHeaderView *header  = [[[NSBundle mainBundle]loadNibNamed:@"MSMeHeaderView" owner:nil options:nil] firstObject];
    self.header             = header;
    self.tableView.tableHeaderView = header;
}

- (void)setupSections
{
    //************************************section1
    MSSettingItemModel *item1   = [[MSSettingItemModel alloc]init];
    item1.funcName              = @"我的任务1";
    item1.executeCode = ^{
        NSLog(@"我的任务1");
    };
    item1.img           = [UIImage imageNamed:@"icon-list01"];
    item1.detailText    = @"做任务赢大奖";
    item1.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item2 = [[MSSettingItemModel alloc]init];
    item2.funcName      = @"我的任务2";
    item2.img           = [UIImage imageNamed:@"icon-list01"];
    item2.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item3 = [[MSSettingItemModel alloc]init];
    item3.funcName      = @"我的任务3";
    item3.img           = [UIImage imageNamed:@"icon-list01"];
    item3.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item4 = [[MSSettingItemModel alloc]init];
    item4.funcName      = @"我的任务4";
    item4.img           = [UIImage imageNamed:@"icon-list01"];
    item4.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingSectionModel *section1 = [[MSSettingSectionModel alloc]init];
    section1.sectionHeaderHeight    = 18;
    section1.itemArray = @[item1,item2,item3,item4];
    
    MSSettingItemModel *item5 = [[MSSettingItemModel alloc]init];
    item5.funcName  = @"充值中心";
    item5.img       = [UIImage imageNamed:@"icon-list01"];
    item5.executeCode = ^{
        NSLog(@"充值中心");
    };
    item5.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingItemModel *item6   = [[MSSettingItemModel alloc]init];
    item6.funcName              = @"设置";
    item6.img           = [UIImage imageNamed:@"icon-list01"];
    item6.executeCode   = ^{
        MSSettingController *settingController = [[MSSettingController alloc] init];
        [self.navigationController pushViewController:settingController animated:YES];
    };
    item6.accessoryType = MSSettingAccessoryTypeDisclosureIndicator;
    
    MSSettingSectionModel *section2 = [[MSSettingSectionModel alloc]init];
    section2.sectionHeaderHeight    = 18;
    section2.itemArray              = @[item5,item6];
    
    self.sectionArray = @[section1,section2];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    MSSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;}

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

#pragma mark - Table view delegate
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
//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
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
