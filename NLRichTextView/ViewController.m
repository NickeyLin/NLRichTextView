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
    [self.view addSubview:_rtView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (IBAction)actionButton:(id)sender {

    [_rtView setRichText:@"<text size='14'>ss级please<i>ll</i>ssd<a color='0xff0000'> %sd级火力 </a><b color='0x000000'>烹饪</b><b color='0xff0000'> %d分钟 </b></text>"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
