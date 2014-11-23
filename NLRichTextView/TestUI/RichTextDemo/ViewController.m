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
@property (weak, nonatomic) IBOutlet NLRichTextView    *rtView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NLRichTextLabel *rtLabel;

- (IBAction)actionDone:(UIButton *)sender;
- (IBAction)actionRTView:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 3;
    
    _rtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rtView.layer.borderWidth = 1;
    _rtView.alignment = NLTextAlignmentCenter;
    
//    [_rtView setRichText:@"<text size='14'>ss级please<i>ll</i>ssd<a color='0xff0000'> %sd级火力 </a><b color='0x000000'>烹饪</b><b color='0xff0000'> %d分钟 </b></text>"];
    _rtLabel.numberOfLines = 0;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionDone:(UIButton *)sender {
    [_textView resignFirstResponder];
    _rtLabel.richText = _textView.text;
    
}

- (IBAction)actionRTView:(UIButton *)sender {
    [_textView resignFirstResponder];
    _rtView.richText = _textView.text;
}
@end
