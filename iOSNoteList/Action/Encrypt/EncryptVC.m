//
//  EncryptVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/10.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import "EncryptVC.h"
#import "AESEncrypt.h"
#import "DESEncrypt.h"

@interface EncryptVC ()

@property (weak, nonatomic) IBOutlet UITextView *secretkeyTF;
@property (weak, nonatomic) IBOutlet UITextView *plaintextTF;
@property (weak, nonatomic) IBOutlet UITextView *ciphertextTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *encryptTypeSegment;
- (IBAction)encodeEvent:(UIButton *)sender;
- (IBAction)decodeEvent:(UIButton *)sender;

@end

@implementation EncryptVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)encodeEvent:(UIButton *)sender {
    if (!self.plaintextTF.text || !self.secretkeyTF.text || [self.plaintextTF.text isEqualToString:@""] || [self.secretkeyTF.text isEqualToString:@""]) {
        return;
    }
    NSString *ciphertext = @"";
    if (0 == self.encryptTypeSegment.selectedSegmentIndex) {
        ciphertext = [AESEncrypt encodeWithKey:self.secretkeyTF.text iv:@"" text:self.plaintextTF.text];
    } else if (1 == self.encryptTypeSegment.selectedSegmentIndex) {
        ciphertext = [DESEncrypt encrypt:self.plaintextTF.text key:self.secretkeyTF.text];
    }
    [self.ciphertextTF setText:ciphertext];
}

- (IBAction)decodeEvent:(UIButton *)sender {
    if (!self.ciphertextTF.text || !self.secretkeyTF.text || [self.ciphertextTF.text isEqualToString:@""] || [self.secretkeyTF.text isEqualToString:@""]) {
        return;
    }
    NSString *plaintext = @"";
    if (0 == self.encryptTypeSegment.selectedSegmentIndex) {
        plaintext = [AESEncrypt decodeWithKey:self.secretkeyTF.text iv:@"" text:self.ciphertextTF.text];
    } else if (1 == self.encryptTypeSegment.selectedSegmentIndex) {
        plaintext = [DESEncrypt decrypt:self.ciphertextTF.text key:self.secretkeyTF.text];
    }
    [self.plaintextTF setText:plaintext];
}
@end
