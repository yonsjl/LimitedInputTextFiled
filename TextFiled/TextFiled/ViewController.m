//
//  ViewController.m
//  TextFiled
//
//  Created by 朱嘉磊 on 2019/5/20.
//  Copyright © 2019 朱嘉磊. All rights reserved.
//

#import "ViewController.h"
#import "LimitedInputTextFiled.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LimitedInputTextFiled * tf = [[LimitedInputTextFiled alloc] init];
    tf.m_limitType = Limit_OnlyInputPrice;
    tf.bounds = CGRectMake(0, 0, 150, 30);
    tf.center = self.view.center;
    tf.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tf];
}


@end
