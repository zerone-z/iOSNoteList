//
//  ViewHierarchyVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "ViewHierarchyVC.h"

#import "UIView+Hierarchy.h"

@interface ViewHierarchyVC ()

@end

@implementation ViewHierarchyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateValue];
}

- (void)updateValue
{
    self.indexLb.text = [@([self.viewBlue getIndexInSuperview]) stringValue];
    self.isFront.on = [self.viewBlue isInFront];
    self.isBack.on = [self.viewBlue isAtBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)bringFront:(UIButton *)sender {
    [self.viewBlue bringToFront];
    [self updateValue];
}

- (IBAction)bringOneLevel:(UIButton *)sender {
    [self.viewBlue bringOneLevelUp];
    [self updateValue];
}

- (IBAction)exchangeView:(UIButton *)sender {
    [self.viewBlue exchangeDepthsWithView:self.viewBrown];
    [self updateValue];
}

- (IBAction)sendBack:(UIButton *)sender {
    [self.viewBlue sendToBack];
    [self updateValue];
    
}

- (IBAction)sendOneLevel:(UIButton *)sender {
    [self.viewBlue sendOneLevelDown];
    [self updateValue];
}
@end
