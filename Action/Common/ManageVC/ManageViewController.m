//
//  ManageViewController.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/28.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "ManageViewController.h"
#import "CategoryOnlyProperty.h"
#import <objc/runtime.h>

@interface ManageViewController ()

@end

@implementation ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加ViewController
    UIViewController *willAddVC = [[UIViewController alloc] init];
    willAddVC.manageVC = self;
    [self addChildViewController:willAddVC];
    [self.view addSubview:willAddVC.view];
    [willAddVC didMoveToParentViewController:self];
    
    // 移除ViewController
    [willAddVC willMoveToParentViewController:nil];
    [willAddVC.view removeFromSuperview];
    [willAddVC removeFromParentViewController];
    
    // 交换ViewController
    UIViewController *fromVC = [[UIViewController alloc] init];
    UIViewController *toVC = [[UIViewController alloc] init];
    
    [fromVC willMoveToParentViewController:nil];
    [self transitionFromViewController:fromVC toViewController:toVC duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:NULL completion:NULL];
    [toVC didMoveToParentViewController:self];
    
    // 自定义Categroy只读属性
    CategoryOnlyProperty *categoryOnlyProperty = [[CategoryOnlyProperty alloc] init];
    NSLog(@"自定义Categroy只读属性:%@", categoryOnlyProperty.readOnlyProperty);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取屏幕最顶端的ViewController
- (UIViewController *)topViewController
{
    UIViewController*topController =[UIApplication sharedApplication].keyWindow.rootViewController;
    while(topController.presentedViewController){
        topController = topController.presentedViewController;
    }
    return topController;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (UIViewController *)topViewController1
{
    UIView *appCurrentView= [UIApplication sharedApplication].keyWindow.subviews.lastObject;
    UIViewController *topController = (UIViewController *)[appCurrentView nextResponder];
    return topController;
}

#pragma mark 对于一个视图类UIView，我们可以利用- (UIResponder *)nextResponder方法遍历响应链，获取到它的UIViewController
- (UIViewController *)viewController {
    /// Finds the view's view controller.
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self.view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}


@end

@implementation UIViewController (Associative)

@dynamic manageVC;

- (void)setManageVC:(ManageViewController *)manageVC
{
    objc_setAssociatedObject(self, @selector(manageVC), manageVC, OBJC_ASSOCIATION_ASSIGN);
}

- (ManageViewController *)manageVC
{
    ManageViewController *manageVC = objc_getAssociatedObject(self, @selector(manageVC));
    if (!manageVC) {
        manageVC = self.parentViewController.manageVC;
    }
    
    return manageVC;
}

@end
