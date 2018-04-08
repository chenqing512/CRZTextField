//
//  DetailViewController.m
//  CRZTextField
//
//  Created by Qing Chen on 2018/4/8.
//  Copyright © 2018年 Qing Chen. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *weixinTF;
@property (weak, nonatomic) IBOutlet UITextField *weiboTF;
@property (weak, nonatomic) IBOutlet UITextView *suggestTV;
@property (nonatomic,assign) NSInteger maxLength;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _weixinTF.maxLength=15;
//    _weiboTF.maxLength=10;
//    _suggestTV.maxLength=30;
    [_weixinTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_weiboTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:_suggestTV];
}

- (void) textFieldDidChange:(UITextField *)textField
{
    if (textField==_weixinTF) {
        _maxLength=15;
    }else if (textField==_weiboTF){
        _maxLength=10;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > _maxLength) {
                textField.text = [toBeString substringToIndex:_maxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > _maxLength) {
            textField.text = [toBeString substringToIndex:_maxLength];
        }
    }
}

/**
 监测用户输入文本长度
 
 @param notification  noti
 */
- (void)textViewDidChangeText:(NSNotification *)notification

{
    _maxLength=30;
    UITextView *textView = (UITextView *)notification.object;
    
    NSString *toBeString = textView.text;
    
    // 获取键盘输入模式
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _maxLength) {
                // 截取子串
                textView.text = [toBeString substringToIndex:_maxLength];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
            NSLog(@"有高亮输入文字========      %@",position);
        }
    } else {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > _maxLength) {
            // 截取子串
            textView.text = [toBeString substringToIndex:_maxLength];
        }
    }
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

@end
