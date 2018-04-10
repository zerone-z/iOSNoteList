//
//  SafeCollectionVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/10/28.
//  Copyright © 2015年 myzerone. All rights reserved.
//

#import "SafeCollectionVC.h"

@interface SafeCollectionVC ()

@property (nonatomic, strong) NSArray *globalArray;

@end

@implementation SafeCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testArray];
    
    [self testSet];
    
    [self testDictionary];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Array
- (void)testArray
{
    // NSArray
    NSLog(@"\n\n==================NSArray============\n\n");
    NSArray *emptyArray = [[NSArray alloc] init];
    NSArray *notArray = [[NSArray alloc] initWithObjects:@"nihao", nil];
    
    @try {
        NSLog(@"%@ objectAtIndex success : %@", emptyArray, [emptyArray objectAtIndex:1]);
    }
    @catch (NSException *exception) {
        NSLog(@"%@ objectAtIndex error", emptyArray);
    }
    
    @try {
        NSLog(@"%@ objectAtIndex success : %@", notArray, [notArray objectAtIndex:1]);
    }
    @catch (NSException *exception) {
        NSLog(@"%@ objectAtIndex error", notArray);
    }
    
    @try {
        NSLog(@"%@ array[] success : %@", emptyArray, emptyArray[1]);
    }
    @catch (NSException *exception) {
        NSLog(@"%@ array[] error", emptyArray);
    }
    
    @try {
        NSLog(@"%@ array[] success : %@", notArray, notArray[1]);
    }
    @catch (NSException *exception) {
        NSLog(@"%@ array[] error", notArray);
    }
    
    // NSMutableArray
    NSLog(@"\n\n==================NSMutableArray============\n\n");
    
    NSMutableArray *mutableEmpty = [NSMutableArray array];
    NSMutableArray *mutableNotEmpty = [NSMutableArray arrayWithObject:@"ceshi"];
    
    @try {
        NSString *str = [mutableNotEmpty objectAtIndex:2];
        NSLog(@"NSMutableArray objectAtIndex success : %@", str);
    }
    @catch (NSException *exception) {
        NSLog(@"NSMutableArray objectAtIndex error");
    }
    
    @try {
        [mutableNotEmpty addObject:nil];
        NSLog(@"NSMutabelArray addObject success : %@", mutableNotEmpty);
        
        [mutableNotEmpty addObject:@"add"];
        NSLog(@"NSMutabelArray addObject success : %@", mutableNotEmpty);
    }
    @catch (NSException *exception) {
        NSLog(@"NSMutabelArray addObject error");
    }
    
    @try {
        [mutableNotEmpty replaceObjectAtIndex:5 withObject:@"replace"];
        NSLog(@"NSMutabelArray replaceObject success: %@", mutableNotEmpty);
        
        [mutableNotEmpty replaceObjectAtIndex:0 withObject:nil];
        NSLog(@"NSMutabelArray replaceObject success: %@", mutableNotEmpty);
        
        [mutableNotEmpty replaceObjectAtIndex:0 withObject:@"replace"];
        NSLog(@"NSMutabelArray replaceObject success: %@", mutableNotEmpty);
    }
    @catch (NSException *exception) {
        NSLog(@"NSMutabelArray replaceObject error");
    }
    
    @try {
        [mutableNotEmpty insertObject:@"insert" atIndex:2];
        NSLog(@"NSMutableArray insertObject success : %@", mutableNotEmpty);
        
        [mutableNotEmpty insertObject:@"insert" atIndex:5];
        NSLog(@"NSMutableArray insertObject success : %@", mutableNotEmpty);
        
        [mutableNotEmpty insertObject:nil atIndex:1];
        NSLog(@"NSMutableArray insertObject success : %@", mutableNotEmpty);
        
        [mutableNotEmpty insertObject:@"insert" atIndex:1];
        NSLog(@"NSMutableArray insertObject success : %@", mutableNotEmpty);
    }
    @catch (NSException *exception) {
        NSLog(@"NSMutableArray insertObject error");
    }
    
    @try {
        [mutableNotEmpty removeObjectAtIndex:5];
        
        NSLog(@"NSMutabelArray removeObject success: %@", mutableNotEmpty);
    }
    @catch (NSException *exception) {
        NSLog(@"NSMutabelArray removeObject error");
    }
    
    @try {
        [mutableNotEmpty exchangeObjectAtIndex:5 withObjectAtIndex:6];
        
        NSLog(@"NSMutableArray exchange success : %@", mutableNotEmpty);
    }
    @catch (NSException *exception) {
        NSLog(@"NSMutableArray exchange error");
    }
}

#pragma mark - Set
- (void)testSet
{
    // NSSet
    
    // NSMutableSet
}

#pragma mark - Dictionary
- (void)testDictionary
{
    NSLog(@"\n\n==================NSMutableDictionary============\n\n");
    // NSMutableDictionary
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:@"objcet" forKey:@"key"];
    
    @try {
        [dictionary removeObjectForKey:@"dddd"];
        NSLog(@"removeObjectForKey success %@", dictionary);
    }
    @catch (NSException *exception) {
        NSLog(@"removeObjectForKey error");
        
    }
}

@end
