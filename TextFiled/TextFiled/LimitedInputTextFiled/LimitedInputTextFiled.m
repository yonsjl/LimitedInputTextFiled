//
//  LimitedInputTextFiled.m
//  textfiled
//
//  Created by 朱嘉磊 on 2018/10/24.
//  Copyright © 2018年 朱嘉磊. All rights reserved.
//

#import "LimitedInputTextFiled.h"


@interface LimitedInputTextFiled()<UITextFieldDelegate>

@end

@implementation LimitedInputTextFiled
#pragma mark - init

-(instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
        [self prepareForLimitedCondition];
    }
    return self;
}
#pragma mark - private
-(void)prepareForLimitedCondition{
    if (!_m_limitType) {
        _m_limitType = Limit_None;
    }
    self.autocorrectionType = UITextAutocorrectionTypeNo;//不自动纠错 (未输入字符时不自动显示提示文字)
    switch (_m_limitType) {
        case Limit_None:self.keyboardType = UIKeyboardTypeDefault;break;//未限制
        case Limit_OnlyInputNumber:self.keyboardType = UIKeyboardTypeNumberPad;break;//限制数字
        case Limit_OnlyInputPhoneNumber:self.keyboardType = UIKeyboardTypeNumberPad;self.m_maxInputCounts = 11; break;//限制手机号
        case Limit_OnlyInputPrice:self.keyboardType = UIKeyboardTypeDecimalPad;break;//限制价格
        case Limit_OnlyInputNumberAndLetter:self.keyboardType = UIKeyboardTypeASCIICapable;break;//限制字母和数字
        default:self.keyboardType = UIKeyboardTypeDefault;break;//不在限制范围内按未限制处理
    }
}
/**
 set方法、设置限制类型
 */
-(void)setM_limitType:(LimitType)m_limitType{
    _m_limitType = m_limitType;
    [self prepareForLimitedCondition];
}

/**
 限制输入字符条件

 @param textField 输入前文本框
 @param string 输入字符
 @return 判断是否符合输入条件
 */
-(BOOL)prepareForLimitConditionWithTextField:(UITextField *)textField  withRange:(NSRange)range replacementString:(NSString *)string{
    //不限制Delete键
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    if (isBackSpace == -8) {
        return YES;
    }
    if (!self.m_limitType) {
        self.m_limitType = Limit_None;
    }
    
    //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
    //(.:46)  (48-57:{0,9}) (65-90:{A..Z})  (97-122:{a..z})
    int character = [string characterAtIndex:0];
    BOOL isPoint = (character == 46);
    BOOL isNumber = character > 47 && character < 58;
    BOOL isLowCaseLetter = character > 96 && character < 123;
    BOOL isHighCaseLetter = character > 64 && character < 91;
    switch (self.m_limitType) {
        case Limit_None:{
            return YES;
        }
            break;
        case Limit_OnlyInputNumber:{
            if (isNumber) return YES;
        }
            break;
        case Limit_OnlyInputPhoneNumber:{
            if (range.location == 0) {//手机号码首位为1
                if (character == 49) return YES;
            }else{
                if (isNumber) return YES;
            }
        }
            break;
        case Limit_OnlyInputPrice:{
            //小数点只能存在一个
            if ([textField.text containsString:@"."]) {
                if (isPoint) return NO;
            }else{
                if (isPoint) return YES;
            }
            if (isNumber) return YES;
        }
            break;
        case Limit_OnlyInputNumberAndLetter:{
            if (isNumber) return YES;
            if (isHighCaseLetter) return YES;
            if (isLowCaseLetter) return YES;
        }
            break;
        default:{
            return YES;
        }
            break;
    }
    return NO;
}

/**
 对于价格类型，限制小数点前9位，小数点后两位

 @param textField 输入框
 @param range 输入字符位置
 @param string 输入字符
 @return 判断结果
 */
-(BOOL)prepareForLimitRetainedSecondDecimalWithTextField:(UITextField *)textField  withRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text containsString:@"."]) {
        //保留两位小数
        NSRange ran = [textField.text rangeOfString:@"."];
        if (range.location - ran.location <= 2) {
            return YES;
        }else{
            return NO;
        }
    }else{
        //小数点前限制输入9位
        if (range.location == 9) {
            if ([string isEqualToString:@"."] && range.location == 9) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return YES;
}


#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限制输入字符类型
    if (![self prepareForLimitConditionWithTextField:textField withRange:range replacementString:string]) {
        return NO;
    }
    //对于价格输入类型，做特殊处理
    if (self.m_limitType == Limit_OnlyInputPrice) {
        if (![self prepareForLimitRetainedSecondDecimalWithTextField:textField withRange:range replacementString:string]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 最大字数
-(void)setM_maxInputCounts:(NSInteger)m_maxInputCounts{
    _m_maxInputCounts = m_maxInputCounts;
    SEL selector = @selector(textFieldLimitLength:);
    //先移除之前添加的监听
    [self removeTarget:self action:selector forControlEvents:UIControlEventEditingChanged];
    //添加监听事件
    [self addTarget:self action:selector forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldLimitLength:(UITextField *)sender{
    UITextField *textField = (UITextField *)sender;
    //需要处理的字符串
    NSString *toBeString = textField.text;
    //键盘输入模式
    NSString *lang = [[[UIApplication sharedApplication] textInputMode] primaryLanguage];
    //判断当前输入法
    if ([lang isEqualToString:@"zh-Hans"]) {//中文输入法下
        //光标位置的获取
        UITextRange *selectedRange = [textField markedTextRange];
        //获取以from为基准偏移offset的光标位置。
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length >= _m_maxInputCounts) {
                [textField setText:[toBeString substringToIndex:_m_maxInputCounts]];
            }else{
                [textField setText:toBeString];
            }
        }else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if ([toBeString length] >= _m_maxInputCounts) {
            [textField setText:[toBeString substringToIndex:_m_maxInputCounts]];
        }else{
            [textField setText:toBeString];
        }
    }
    
}

@end

