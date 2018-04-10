//
//  AudioRecorderVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/10.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import "AudioRecorderVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ButtonAudioRecorder.h"

@interface AudioRecorderVC () <ButtonAudioRecorderDelegate> {
    AVAudioPlayer *_player;
}

@property (strong, nonatomic) ButtonAudioRecorder *audioRecorderBtn;

@end

@implementation AudioRecorderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.audioRecorderBtn];
    [self.audioRecorderBtn setFrame:CGRectMake(100, 100, 80, 30)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ButtonAudioRecorderDelegate
- (void)buttonAudioRecorder:(ButtonAudioRecorder *)audioRecorder didFinishRcordWithAudioInfo:(NSDictionary *)audioInfo sendFlag:(BOOL)flag
{
    if (flag) {
        MZOLog(@"\n文件名称:%@\n音频时长:%@\n文件路径:%@",audioInfo[AudioRecorderName],audioInfo[AudioRecorderDuration],audioInfo[AudioRecorderPath]);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //设置类别,此处只支持支持播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSURL *urlAudio=[NSURL fileURLWithPath:audioInfo[AudioRecorderPath]];
        _player=[[AVAudioPlayer alloc]initWithContentsOfURL:urlAudio error:nil];
        [_player play];
        
    }else{
        NSLog(@"取消录音");
    }
}

#pragma mark - Lazy Load
- (ButtonAudioRecorder *)audioRecorderBtn
{
    if (!_audioRecorderBtn) {
        _audioRecorderBtn = [ButtonAudioRecorder new];
        [_audioRecorderBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_audioRecorderBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_audioRecorderBtn setChangeTitle:@"松开 发送"];
        [_audioRecorderBtn setUpChangeTitle:@"松开 取消"];
        _audioRecorderBtn.delegate=self;
    }
    return _audioRecorderBtn;
}

@end
