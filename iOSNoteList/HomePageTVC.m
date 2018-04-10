//
//  HomePageTVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/8.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "HomePageTVC.h"
#import "ClassDynamicManage.h"

@interface HomePageTVC () {
    NSArray *_dataSource;
}

@end

@implementation HomePageTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Config" withExtension:@"plist"]];
}

- (void)test:(id)t,... NS_REQUIRES_NIL_TERMINATION
{
    va_list paramList;
    va_start(paramList, t);
    id arg;
    while ((arg = va_arg(paramList, id))) {
        NSLog(@"%@", arg);
    }
    va_end(paramList);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    count = _dataSource.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = _dataSource[indexPath.row];
    cell.textLabel.text = [dictionary objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = _dataSource[indexPath.row];
    NSString *title = [dictionary objectForKey:@"title"];
    NSString *vc = [dictionary objectForKey:@"vc"];
    if (vc) {
        UIViewController *viewController = [[NSClassFromString(vc) alloc] initWithNibName:vc bundle:nil];
        viewController.title = title;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        NSString *sb = [dictionary objectForKey:@"sb"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sb bundle:nil];
        [self.navigationController pushViewController:storyboard.instantiateInitialViewController animated:YES];
    }
}

@end
