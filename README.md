# LimitedInputTextFiled

------

> 功能 : 根据限制类型，自动配置键盘，可输入字符类型等：

```objet-c
typedef enum {
    Limit_None = 0,                   //无限制输入条件
    Limit_OnlyInputNumber,            //仅限制输入数字
    Limit_OnlyInputPhoneNumber,       //限制输入手机号(首位是1，长度11)
    Limit_OnlyInputPrice,             //仅限制输入金额(小数点前9位，小数点后两位)
    Limit_OnlyInputNumberAndLetter    //仅限制输入数字和大小写字母
}LimitType;

/* 最大输入字数 */
@property(nonatomic , assign) NSInteger m_maxInputCounts;

/* 限制输入类型 */
@property(nonatomic , assign) LimitType m_limitType;
```

### 限制输入框的方法

> 限制输入框输入类型的方法是通过将当前输入的值转化为`ASCII`值（即内部索引值），与其在表中对应的值做判断，若在限制的范围内，则不可以输入。可以参考`ASCII`表：

> * [ASCII对照表](http://tool.oschina.net/commons?type=4)
> * 判断规则

![判断规则](https://github.com/yonsjl/PictureBed/raw/master/LimitedInputTextFiled_02.png)

------
