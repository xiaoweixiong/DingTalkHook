//
//  UIResponder+JFUtil.m
//  DingTalkDylib
//
//  Created by 耿建峰 on 17/1/22.
//
//

#import "UIResponder+JFUtil.h"
#import "JF_Helper.h"
#import "NSBundle+JFUtil.h"
#import "DTGPSButton.h"

@implementation UIResponder (JFUtil)

- (BOOL)jf_application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class bundle = [NSBundle class];
        
        _jf_Hook_Method(bundle, @selector(bundleIdentifier), bundle, @selector(jf_bundleIdentifier));
        
        _jf_Hook_Method(bundle, @selector(infoDictionary), bundle, @selector(jf_infoDictionary));
    });
    
    // 执行原方法
    BOOL bRe = [self jf_application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    static dispatch_once_t onceToken_setting;
    dispatch_once(&onceToken_setting, ^{
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        // 在Window最上层添加一个位置设置按钮
        UIWindow *window = [application keyWindow];
        UIViewController *rootViewController = window.rootViewController;
        DTGPSButton *button = [DTGPSButton sharedInstance];
        button.frame = CGRectMake(bounds.size.width - 39 - 15, bounds.size.height - 100, 40, 40);
        [rootViewController.view addSubview:button];
        
        [self authorization];
    });
    
    return bRe;
}

// 授权
- (void)authorization{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入激活码" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self authorization];
    }]];
    
    
    
    //增加确定按钮；
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获取第1个输入框；
        
        
        
        UITextField *userNameTextField = alertController.textFields.firstObject;
        
        if(![userNameTextField.text isEqualToString:@"yangziyao"]){
            
            [self authorization];
        }
        
    }]];
    
    
    
    //定义第一个输入框；
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入激活码";
        
        textField.secureTextEntry = YES;
        
    }];
    
    
    
     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
