//
//  ViewController.m
//  NLRichTextView
//
//  Created by Nick.Lin on 14/11/12.
//  Copyright (c) 2014年 changhong. All rights reserved.
//

#import "ViewController.h"
#import "NLRichTextView.h"
@interface ViewController ()
@property (strong, nonatomic) NLRichTextView    *rtView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _rtView = [[NLRichTextView alloc]initWithFrame:CGRectMake(50, 340, self.view.frame.size.width - 100, 200)];
    _rtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rtView.layer.borderWidth = 1;
    _rtView.alignment = NLTextAlignmentCenter;
    [_rtView setRichText:@"<text><b color='0xaa1245' size='12' font-name='Optim' font-style='underline' background-color='0x000000'>烹饪123456</b><i>aaa</i> </text>"];
    [self.view addSubview:_rtView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
