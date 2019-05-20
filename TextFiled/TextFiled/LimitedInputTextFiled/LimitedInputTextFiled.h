//
//  LimitedInputTextFiled.h
//  textfiled
//
//  Created by 朱嘉磊 on 2018/10/24.
//  Copyright © 2018年 朱嘉磊. All rights reserved.
//  根据限制类型，自动配置键盘，可输入字符类型等

#import <UIKit/UIKit.h>
typedef enum {
    Limit_None = 0,                   //无限制输入条件
    Limit_OnlyInputNumber,            //仅限制输入数字
    Limit_OnlyInputPhoneNumber,       //限制输入手机号(首位是1，长度11)
    Limit_OnlyInputPrice,             //仅限制输入金额(小数点前9位，小数点后两位)
    Limit_OnlyInputNumberAndLetter    //仅限制输入数字和大小写字母
}LimitType;


@interface LimitedInputTextFiled : UITextField

/**
 最大输入字数
 */
@property(nonatomic , assign) NSInteger m_maxInputCounts;

/**
 限制输入类型
 */
@property(nonatomic , assign) LimitType m_limitType;

@end
