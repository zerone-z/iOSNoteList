//
//  GraphicsVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "GraphicsVC.h"

#import "GraphicsView.h"

@interface GraphicsVC ()

@end

@implementation GraphicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GraphicsView *gv = [[GraphicsView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:gv];
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
