//
//  ShowCrashLogViewController.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/12/3.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "ShowCrashLogViewController.h"
#import "NLCommon.h"

typedef enum{
    ShowCrashTypeNormal,
    ShowCrashTypeLabel,
    ShowCrashTypeAlert
}ShowCrashType;

@interface ShowCrashLogViewController ()<SafeKitPrinterFormat>{
    ShowCrashType   _showCrashType;
}
- (IBAction)actionTrigerCrash:(UIButton *)sender;

@end

@implementation ShowCrashLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SafeKitLog shareInstance].formater = self;
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

- (IBAction)actionTrigerCrash:(UIButton *)sender {
    _showCrashType = ShowCrashTypeAlert;
    [self setValue:@2 forKey:nil];
}

- (void)logExceptionStr:(NSString *)exceptionStr{
    switch (_showCrashType) {
        case ShowCrashTypeNormal:{
            NSLog(@"%@", exceptionStr);
            break;
        }
        case ShowCrashTypeLabel:{
            
            break;
    
        }
        case ShowCrashTypeAlert:{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:exceptionStr preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }]];
            alertC.view.frame = [[UIScreen mainScreen] applicationFrame];
            [self presentViewController:alertC animated:YES completion:nil];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:exceptionStr delegate:nil cancelButtonTitle:@"ok"  otherButtonTitles:nil];
//            alert.frame = [[UIScreen mainScreen] applicationFrame];
//            [alert show];
            break;
        }
        default:
            break;
    }
}
@end
