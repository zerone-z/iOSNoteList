//
//  NSString+SystemInfo.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/10.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "NSString+SystemInfo.h"

#import <UIKit/UIDevice.h>
#import <sys/utsname.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>

@implementation NSString (SystemInfo)

+ (NSString *)terminalType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *terminalType =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return terminalType;
}

+ (BOOL)isJailBreak
{
    //以下检测的过程是越往下，越狱越高级
    
    // /Applications/Cydia.app, /privte/var/stash
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    NSString *applications = @"/User/Applications/";
    NSString *Mobile = @"/Library/MobileSubstrate/MobileSubstrate.dylib";
    NSString *bash = @"/bin/bash";
    NSString *sshd =@"/usr/sbin/sshd";
    NSString *sd = @"/etc/apt";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
        return jailbroken;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
        return jailbroken;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:applications]){
        jailbroken = YES;
        return jailbroken;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:Mobile]){
        jailbroken = YES;
        return jailbroken;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:bash]){
        jailbroken = YES;
        return jailbroken;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:sshd]){
        jailbroken = YES;
        return jailbroken;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:sd]){
        jailbroken = YES;
        return jailbroken;
    }
    
    //可能存在hook了NSFileManager方法，此处用底层C stat去检测
    struct stat stat_info;
    if (0 == stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &stat_info)) {
        jailbroken = YES;
        return jailbroken;
    }
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        jailbroken = YES;
        return jailbroken;
    }
    if (0 == stat("/var/lib/cydia/", &stat_info)) {
        jailbroken = YES;
        return jailbroken;
    }
    if (0 == stat("/var/cache/apt", &stat_info)) {
        jailbroken = YES;
        return jailbroken;
    }
    //  /Library/MobileSubstrate/MobileSubstrate.dylib 最重要的越狱文件，几乎所有的越狱机都会安装MobileSubstrate
    //  /Applications/Cydia.app/ /var/lib/cydia/绝大多数越狱机都会安装
    //  /var/cache/apt /var/lib/apt /etc/apt
    //  /bin/bash /bin/sh
    //  /usr/sbin/sshd /usr/libexec/ssh-keysign /etc/ssh/sshd_config
    
    //可能存在stat也被hook了，可以看stat是不是出自系统库，有没有被攻击者换掉
    //这种情况出现的可能性很小
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char *,struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        NSLog(@"lib:%s",dylib_info.dli_fname);      //如果不是系统库，肯定被攻击了
        if (strcmp(dylib_info.dli_fname, "/usr/lib/system/libsystem_kernel.dylib")) {
            //不相等，肯定被攻击了，相等为0
            jailbroken = YES;
            return jailbroken;
        }
    }
    
    //还可以检测链接动态库，看下是否被链接了异常动态库，但是此方法存在appStore审核不通过的情况，这里不作罗列
    //通常，越狱机的输出结果会包含字符串： Library/MobileSubstrate/MobileSubstrate.dylib——之所以用检测链接动态库的方法，是可能存在前面的方法被hook的情况。这个字符串，前面的stat已经做了
    
    //如果攻击者给MobileSubstrate改名，但是原理都是通过DYLD_INSERT_LIBRARIES注入动态库
    //那么可以，检测当前程序运行的环境变量
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) {
        jailbroken = YES;
    }
    
    return jailbroken;
}

#pragma mark - 操作系统
+ (NSString *)systemName
{
    return [[UIDevice currentDevice] systemName];
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)deviceModel
{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)deviceLocalizedModel
{
    return [[UIDevice currentDevice] localizedModel];
}

+ (NSString *)currentUserName
{
    return NSUserName();
}

+ (NSString *)currentFullUserName
{
    return NSFullUserName();
}

#pragma mark - 程序信息
+ (NSString *)appName
{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return [appInfo objectForKey:(NSString *)kCFBundleNameKey];
}

+ (NSString *)appLocalizedName
{
    NSDictionary *appInfo = [[NSBundle mainBundle] localizedInfoDictionary];
    return [appInfo objectForKey:(NSString *)kCFBundleNameKey];
}

+ (NSString *)appDisplayName
{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return [appInfo objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)appLocalizedDisplayName
{
    NSDictionary *appInfo = [[NSBundle mainBundle] localizedInfoDictionary];
    return [appInfo objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)appVersion
{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return [appInfo objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBuildVersion
{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    return [appInfo objectForKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)appIdentifierPrefix
{
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge NSString *)kSecClassGenericPassword, kSecClass,
                           @"bundleID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    
    CFDictionaryRef result = nil;
    
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound) {
        status = SecItemAdd((CFDictionaryRef)query, (CFTypeRef *)&result);
    }
    if (status != errSecSuccess) {
        return nil;
    }
    
    NSString *accessGroup = [(__bridge_transfer NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    return [[components objectEnumerator] nextObject];
}

@end
