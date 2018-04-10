//
//  ArchiverVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "ArchiverVC.h"
#import "ClassArchiver.h"

@interface ArchiverVC ()
@property (weak, nonatomic) IBOutlet UISwitch *boolSwitch;
@property (weak, nonatomic) IBOutlet UITextField *integerTF;
@property (weak, nonatomic) IBOutlet UITextField *stringTF;
@property (weak, nonatomic) IBOutlet UITextField *objectTF;
- (IBAction)archiveEvent:(UIButton *)sender;
- (IBAction)unarchiveEvent:(UIButton *)sender;

@end

@implementation ArchiverVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Response
- (IBAction)archiveEvent:(UIButton *)sender {
    [self.view endEditing:YES];
    ClassArchiver *archive = [ClassArchiver new];
    archive.archiverBool = self.boolSwitch.on;
    archive.archiverInteger = [self.integerTF.text integerValue];
    archive.archiverString = self.stringTF.text;
    archive.archiverObject.archiverItem = self.objectTF.text;
    [archive archiverClassArchiver];
}

- (IBAction)unarchiveEvent:(UIButton *)sender {
    ClassArchiver *archive = [ClassArchiver defaultClassArchiver];
    self.boolSwitch.on = archive.archiverBool;
    self.integerTF.text = @(archive.archiverInteger).stringValue;
    self.stringTF.text = archive.archiverString;
    self.objectTF.text = archive.archiverObject.archiverItem;
}
@end
