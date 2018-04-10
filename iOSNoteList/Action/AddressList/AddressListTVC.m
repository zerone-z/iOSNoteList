//
//  AddressListTVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

/**
 单值属性
 kABPersonFirstNameProperty，名字
 kABPersonLastNameProperty，姓氏
 kABPersonMiddleNameProperty，中间名
 kABPersonPrefixProperty，前缀
 kABPersonSuffixProperty，后缀
 kABPersonNicknameProperty，昵称
 kABPersonFirstNamePhoneticProperty，名字汉语拼音或音标
 kABPersonLastNamePhoneticProperty，姓氏汉语拼音或音标
 kABPersonMiddleNamePhoneticProperty，中间名汉语拼音或音标
 kABPersonOrganizationProperty，组织名
 kABPersonJobTitleProperty，头衔
 kABPersonDepartmentProperty，部门
 kABPersonNoteProperty，备注
 
 多值属性
 包含多个值的集合类型，如：电话号码、Email、URL等，它们主要是由下面常量定义的：
 kABPersonPhoneProperty，电话号码属性，kABMultiStringPropertyType类型多值属性；
 kABPersonEmailProperty，Email属性，kABMultiStringPropertyType类型多值属性；
 kABPersonURLProperty，URL属性，kABMultiStringPropertyType类型多值属性；
 kABPersonRelatedNamesProperty，亲属关系人属性，kABMultiStringPropertyType类型多值属性；
 kABPersonAddressProperty，地址属性，kABMultiDictionaryPropertyType类型多值属性；
 kABPersonInstantMessageProperty，即时聊天属性，kABMultiDictionaryPropertyType类型多值属性；
 kABPersonSocialProfileProperty，社交账号属性，kABMultiDictionaryPropertyType类型多值属性；
 
 在多值属性中包含了label（标签）、value（值）和ID等部分，其中标签和值都是可以重复的，而ID是不能重复的
 **/

#import "AddressListTVC.h"
#import <AddressBook/AddressBook.h>


@interface AddressListTVC () {
    ABAddressBookRef _addressBook;
    NSArray *_peopleList;
}

@end

@implementation AddressListTVC

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson:)];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                [self getAllPeople];
                NSLog(@"授权为允许访问！%@", error);
            }else {
                NSLog(@"授权为拒绝访问！%@", error);
            }
        });
    }
#else
    _addressBook = ABAddressBookCreate();
#endif
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusNotDetermined:       // 用户还没有决定是否授权你的程序进行访问
        {
            
        }
            break;
        case kABAuthorizationStatusRestricted:          // iOS设备上的家长控制或其他的一些许可配置组织了你的程序与通讯录数据库进行交互
        {
            
        }
            break;
        case kABAuthorizationStatusDenied:              // 用户明确拒绝了你的程序对通讯录的访问
        {
            
        }
            break;
        case kABAuthorizationStatusAuthorized:          // 用户已经授权你的程序对通讯录进行访问
        {
            [self getAllPeople];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method Private
- (void)getAllPeople
{
    _peopleList = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBook);    // 获取所有联系人数据
    //_peopleList = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(_addressBook)); CFBridgingRetain
    
    [self.tableView reloadData];
    
    // 通过人名查询通讯录中的联系人
    CFArrayRef peoples = ABAddressBookCopyPeopleWithName(_addressBook, (__bridge CFStringRef)@"人名");
    
//    CFArrayRef peopleList = ABAddressBookCopyArrayOfAllPeople(_addressBook);    // 获取所有联系人数据
//    int peopleCount = CFArrayGetCount(peopleList);  // 联系人总数
//    for (int i = 0; i < peopleCount; i++) {
//        ABRecordRef people = CFArrayGetValueAtIndex(peopleList, i); // 获取某个联系人
//    }
//    // 释放
//    CFRelease(peopleList);
}

- (void)addPerson:(UIBarButtonItem *)sender
{
    // 创建一个新的联系人
    ABRecordRef person = ABPersonCreate();
    
    // 设置联系人的属性(简单)
    ABRecordSetValue(person, kABPersonFirstNameProperty, @"小明", NULL);
    ABRecordSetValue(person, kABPersonLastNameProperty, @"李", NULL);
    // 设置联系人的属性(复杂)
    ABMultiValueRef email = ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(email, @"work@qq.com", kABWorkLabel, NULL);    // 工作邮箱
    ABMultiValueAddValueAndLabel(email, @"home@qq.com", kABHomeLabel, NULL);    // 家庭邮箱
    ABRecordSetValue(person, kABPersonEmailProperty, email, NULL);
    CFRelease(email);
    
    //kABPersonPhoneMainLabel，主要电话号码标签；
    //kABPersonPhoneHomeFAXLabel，家庭传真电话号码标签；
    //kABPersonPhoneWorkFAXLabel，工作传真电话号码标签；
    //kABPersonPhonePagerLabel，寻呼机号码标签。
    
    // 将联系人添加到通讯录数据库中
    ABAddressBookAddRecord(_addressBook, person, NULL);
    
    // 保存刚才所作的修改
    ABAddressBookSave(_addressBook, NULL);
    
    // 放弃更改
    ABAddressBookRevert(_addressBook);
    
    // 判断是否有未保存的修改
    ABAddressBookHasUnsavedChanges(_addressBook);
    
    // 释放
    CFRelease(person);
}

- (void)addGroup
{
    // 创建一个新的组
    ABRecordRef group = ABPersonCreate();
    
    // 设置组名
    ABRecordSetValue(group, kABGroupNameProperty, @"分组", NULL);
    
    // 将组添加到通讯录数据库中
    ABAddressBookAddRecord(_addressBook, group, NULL);
    
    // 保存刚才所作的修改
    ABAddressBookSave(_addressBook, NULL);
    
    // 释放
    CFRelease(group);
}

- (void)other
{
    // 获取所有的群组信息，
    NSArray *groups = (__bridge NSArray *)ABAddressBookCopyArrayOfAllGroups(_addressBook);
    
    // 添加联系人到组中
    //ABGroupAddMember(<#ABRecordRef group#>, <#ABRecordRef person#>, <#CFErrorRef *error#>)
    
    // 从组中移除联系人
    //ABGroupRemoveMember(<#ABRecordRef group#>, <#ABRecordRef member#>, <#CFErrorRef *error#>)
    
    // 从通讯录中移除组或者联系人
    //ABAddressBookRemoveRecord(<#ABAddressBookRef addressBook#>, <#ABRecordRef record#>, <#CFErrorRef *error#>)
}

- (void)operateAddressIcon
{
    // CFDateRef ==> NSData
    
    // 判断通讯录中的联系人是否有图片
    //ABPersonHasImageData(<#ABRecordRef person#>)
    
    // 取得图片数据(假如有的话)
    //ABPersonCopyImageData(<#ABRecordRef person#>)
    //ABPersonCopyImageDataWithFormat(<#ABRecordRef person#>, <#ABPersonImageFormat format#>)
    
    // 设置联系人的图片数据
    //ABPersonSetImageData(<#ABRecordRef person#>, <#CFDataRef imageData#>, <#CFErrorRef *error#>)
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"dao"], 1);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peopleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ABRecordRef recordRef = (__bridge ABRecordRef)_peopleList[indexPath.row];
    
    // 获得名
    CFStringRef firstName = ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);
    // 获得姓
    CFStringRef lastName = ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", lastName, firstName];
    
    CFRelease(firstName);
    CFRelease(lastName);
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 联系人复杂属性的获取
    ABRecordRef recordRef = (__bridge ABRecordRef)_peopleList[indexPath.row];
    
    // 获取ID
    ABRecordID recordID = ABRecordGetRecordID(recordRef);
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, recordID);
    
    // 所有邮箱
    NSLog(@"========所有邮箱==========");
    ABMultiValueRef emails = ABRecordCopyValue(recordRef, kABPersonEmailProperty);
    int emailsCount = ABMultiValueGetCount(emails);
    for (int i = 0; i < emailsCount; i++) {
        // 获取的标签名称
        CFStringRef emailLabel = ABMultiValueCopyLabelAtIndex(emails, i);
        // 转为本地标签名称
        CFStringRef localizedEmailLabel = ABAddressBookCopyLocalizedLabel(emailLabel);
        // 获取的邮件地址
        CFStringRef email = ABMultiValueCopyValueAtIndex(emails, i);
        
        // 获取所有邮箱
        CFArrayRef emailValues = ABMultiValueCopyArrayOfAllValues(emails);
        
        NSLog(@"%@-%@: %@", emailLabel, localizedEmailLabel, email);
        
        // 释放
        CFRelease(emailLabel);
        CFRelease(localizedEmailLabel);
        CFRelease(email);
        CFRelease(emailValues);
    }
    CFRelease(emails);
    
    // 所有联系方式
    NSLog(@"========所有联系方式==========");
    ABMultiValueRef phones = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
    int phonessCount = ABMultiValueGetCount(phones);
    for (int i = 0; i < phonessCount; i++) {
        // 获取的标签名称
        CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phones, i);
        // 转为本地标签名称
        CFStringRef localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel);
        // 获取的邮件地址
        CFStringRef phone = ABMultiValueCopyValueAtIndex(phones, i);
        
        NSLog(@"%@-%@: %@", phoneLabel, localizedPhoneLabel, phone);
        
        // 释放
        CFRelease(phoneLabel);
        CFRelease(localizedPhoneLabel);
        CFRelease(phone);
    }
    CFRelease(phones);
    
}

- (void)dealloc
{
    CFRelease((__bridge CFArrayRef)_peopleList);
    CFRelease(_addressBook);
}

@end
