//
//  SystemInfoTVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/10.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "SystemInfoTVC.h"

#import "NSString+SystemInfo.h"

@interface SystemInfoTVC ()

@end

@implementation SystemInfoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
        {
            count = 7;
        }
            break;
        case 1:
        {
            count = 4;
        }
            break;
        default:
        {
            count = 2;
        }
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"headerView";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    switch (section) {
        case 0:
        {
            headerView.textLabel.text = @"系统信息";
        }
            break;
        case 1:
        {
            headerView.textLabel.text = @"程序信息";
        }
            break;
        default:
        {
            headerView.textLabel.text = @"其他";
        }
            break;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"操作系统名称";
                    cell.detailTextLabel.text = [NSString systemName];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"操作系统版本";
                    cell.detailTextLabel.text = [NSString systemVersion];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"设备名称";
                    cell.detailTextLabel.text = [NSString deviceName];
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"设备模型";
                    cell.detailTextLabel.text = [NSString deviceModel];
                }
                    break;
                case 4:
                {
                    cell.textLabel.text = @"设备本地模型";
                    cell.detailTextLabel.text = [NSString deviceLocalizedModel];
                }
                    break;
                case 5:
                {
                    cell.textLabel.text = @"当前用户的登陆名";
                    cell.detailTextLabel.text = [NSString currentUserName];
                }
                    break;
                case 6:
                {
                    cell.textLabel.text = @"当前用户的完整登陆名";
                    cell.detailTextLabel.text = [NSString currentFullUserName];
                }
                    break;
                default:
                {
                    
                }
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"程序名称";
                    cell.detailTextLabel.text = [NSString appName];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"程序用于显示的名称";
                    cell.detailTextLabel.text = [NSString appDisplayName];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"程序软件版本号";
                    cell.detailTextLabel.text = [NSString appVersion];
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = @"程序编译的版本号";
                    cell.detailTextLabel.text = [NSString appBuildVersion];
                }
                    break;
                default:
                {
                    
                }
                    break;
            }
        }
            break;
        default:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"设备型号,终端类型";
                    cell.detailTextLabel.text = [NSString terminalType];
                }
                    break;
                default:
                {
                    cell.textLabel.text = @"是否越狱";
                    cell.detailTextLabel.text = @([NSString isJailBreak]).stringValue;
                }
                    break;
            }
        }
            break;
    }
    
    return cell;
}

@end
