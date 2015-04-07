//
//  DJXAttributedString.m
//  JXView
//
//  Created by dujinxin on 14-11-27.
//  Copyright (c) 2014年 e-future. All rights reserved.
//

#import "DJXAttributedString.h"

@implementation DJXAttributedString

//设置文本格式的两种方式

//方式一：
//首先初始化一个NSMutableAttributedString，然后向里面添加文字样式，最后将它赋给控件的AttributedText，该方法适合于文本较少而又需要分段精细控制的情况。
//label.AttributedText = attributedStr;即可
- (NSAttributedString *)customContentText:(NSString *)text{
    //创建 NSMutableAttributedString
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: text];
    //添加属性
    //给所有字符设置字体为Zapfino，字体高度为15像素
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"Zapfino" size: 15] range: NSMakeRange(0, text.length)];
    //分段控制，最开始4个字符颜色设置成蓝色
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(0, 4)];
    //分段控制，第5个字符开始的3个字符，即第5、6、7字符设置为红色
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(4, 3)];
    
    //赋值给显示控件label的 attributedText
    return  attributedStr;
}
//方式二
//首先创建属性字典，初始化各种属性，然后和需要控制的文本一起创建并赋值给控件的AttributedText，该方法适合于需要控制的文本较多整体控制的情况，通常是从文件中读取的大段文本控制。
//创建属性字典
- (NSAttributedString *)customContentText:(NSString *)text attributes:(NSDictionary *)dict{
    //字典里内容是可以自己设置的
    NSDictionary *attrDict = @{ NSFontAttributeName: [UIFont fontWithName: @"Zapfino" size: 15],NSForegroundColorAttributeName: [UIColor blueColor] };
    
    //创建 NSAttributedString 并赋值
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString: text attributes: attrDict];
    return attributedString;
}

/*
 需求通过一个简单小巧的AttributedString就可以轻松搞定，所以本文的关注点只有一个，那就是AttributedString，至于CoreText和TextKit，在真正需要的时候再进行深入研究和总结。
 
 与NSString类似，在iOS中AttributedString也分为NSAttributedString和NSMutableAttributedString，不同的是，AttributedString对象多了一个Attribute的概念，一个AttributedString的对象包含很多的属性，每一个属性都有其对应的字符区域，在这里是使用NSRange来进行描述的。


 通过对比两个例子可以看出，方式一比较容易处理复杂的格式，但是属性设置比较繁多复杂，而方式二的属性设置比较简单明了，却不善于处理复杂多样的格式控制，但是不善于并不等于不能，可以通过属性字符串分段的方式来达到方式一的效果，如下：
 
 //方式二的分段处理
 //第一段
 NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont fontWithName: @"Zapfino" size: 15],
 NSForegroundColorAttributeName: [UIColor blueColor] };
 NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: [originStr substringWithRange: NSMakeRange(0, 4)] attributes: attrDict1];
 
 //第二段
 NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont fontWithName: @"Zapfino" size: 15],
 NSForegroundColorAttributeName: [UIColor redColor] };
 NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: [originStr substringWithRange: NSMakeRange(4, 3)] attributes: attrDict2];
 
 //第三段
 NSDictionary *attrDict3 = @{ NSFontAttributeName: [UIFont fontWithName: @"Zapfino" size: 15],
 NSForegroundColorAttributeName: [UIColor blackColor] };
 NSAttributedString *attrStr3 = [[NSAttributedString alloc] initWithString: [originStr substringWithRange:
 NSMakeRange(7, originStr.length - 4 - 3)] attributes: attrDict3];
 //合并
 NSMutableAttributedString *attributedStr03 = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
 [attributedStr03 appendAttributedString: attrStr2];
 [attributedStr03 appendAttributedString: attrStr3];
 
 _label03.attributedText = attributedStr03;
 

 
 好了，讲完AttributedString的创建方式，下面研究下AttributedString究竟可以设置哪些属性，具体来说，有以下21个：
 
 // NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
 // NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
 // NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
 // NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 // NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 // NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
 // NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 // NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 // NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 // NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 // NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
 // NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
 // NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 // NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 // NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 // NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 // NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
 // NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 // NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
 // NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 // NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
 
 
 下面就一一举例说明：
 
 1. NSFontAttributeName
 
 
 //NSForegroundColorAttributeName 设置字体颜色，取值为 UIColor，默认为黑色
 
 NSDictionary *attrDict1 = @{ NSForegroundColorAttributeName: [UIColor redColor] };
 NSDictionary *attrDict2 = @{ NSForegroundColorAttributeName: [UIColor blueColor] };
 NSDictionary *attrDict3 = @{ NSForegroundColorAttributeName: [UIColor orangeColor] };
 
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 注意：
 
 NSForegroundColorAttributeName设置的颜色与UILabel的textColor属性设置的颜色在地位上是相等的，谁最后赋值，最终显示的就是谁的颜色。

 2. NSBackgroundColorAttributeName
 
 
 //NSForegroundColorAttributeName 设置字体颜色，取值为 UIColor，默认为黑色
 
 NSDictionary *attrDict1 = @{ NSForegroundColorAttributeName: [UIColor redColor] };
 NSDictionary *attrDict2 = @{ NSForegroundColorAttributeName: [UIColor blueColor] };
 NSDictionary *attrDict3 = @{ NSForegroundColorAttributeName: [UIColor orangeColor] };
 
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 //NSBackgroundColorAttributeName 设置字体所在区域背景的颜色，取值为UIColor，默认值为nil
 
 NSDictionary *attrDict4 = @{ NSBackgroundColorAttributeName: [UIColor orangeColor] };
 NSDictionary *attrDict5 = @{ NSBackgroundColorAttributeName: [UIColor redColor] };
 NSDictionary *attrDict6 = @{ NSBackgroundColorAttributeName: [UIColor cyanColor] };
 
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict4];
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict5];
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict6];
 
 
 
 
 仔细观察会发现个问题，我并没有关闭 NSForegroundColorAttributeName 属性，但是在运行结果中，所有字体的颜色都变成了默认色——黑色，这说明 NSForegroundColorAttributeName 和 NSBackgroundColorAttributeName 的低位是相等的，跟前面介绍的 textColor 一样，哪个属性最后一次赋值，就会冲掉前面的效果，若是我们把属性代码顺序交换一下
 
 
 //NSBackgroundColorAttributeName 设置字体所在区域背景的颜色，取值为UIColor，默认值为nil
 
 NSDictionary *attrDict4 = @{ NSBackgroundColorAttributeName: [UIColor orangeColor] };
 NSDictionary *attrDict5 = @{ NSBackgroundColorAttributeName: [UIColor redColor] };
 NSDictionary *attrDict6 = @{ NSBackgroundColorAttributeName: [UIColor cyanColor] };
 
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict4];
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict5];
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict6];
 
 //NSForegroundColorAttributeName 设置字体颜色，取值为 UIColor，默认为黑色
 
 NSDictionary *attrDict1 = @{ NSForegroundColorAttributeName: [UIColor redColor] };
 NSDictionary *attrDict2 = @{ NSForegroundColorAttributeName: [UIColor blueColor] };
 NSDictionary *attrDict3 = @{ NSForegroundColorAttributeName: [UIColor orangeColor] };
 
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 
 但是textColor属性可以与 NSBackgroundColorAttributeName 属性叠加
 
 
 _label01.textColor = [UIColor greenColor];
 _label02.textColor = [UIColor yellowColor];
 _label03.textColor = [UIColor blueColor];
 
 //NSForegroundColorAttributeName 设置字体颜色，取值为 UIColor，默认为黑色
 
 NSDictionary *attrDict1 = @{ NSForegroundColorAttributeName: [UIColor redColor] };
 NSDictionary *attrDict2 = @{ NSForegroundColorAttributeName: [UIColor blueColor] };
 NSDictionary *attrDict3 = @{ NSForegroundColorAttributeName: [UIColor orangeColor] };
 
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 //NSBackgroundColorAttributeName 设置字体所在区域背景的颜色，取值为UIColor，默认值为nil
 
 NSDictionary *attrDict4 = @{ NSBackgroundColorAttributeName: [UIColor orangeColor] };
 NSDictionary *attrDict5 = @{ NSBackgroundColorAttributeName: [UIColor redColor] };
 NSDictionary *attrDict6 = @{ NSBackgroundColorAttributeName: [UIColor cyanColor] };
 
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict4];
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict5];
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict6];
 
 
 
 虽然 textColor 在 NSFontAttributeName 之前赋值，但是由于 NSFontAttributeName 的属性效果被NSBackgroundColorAttributeName 属性冲掉了，所以最终显示了 textColor 的颜色。
 
 
 
 3. NSLigatureAttributeName
 
 //NSLigatureAttributeName 设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符，
 //                        2 表示使用所有连体符号，默认值为 1（iOS 不支持 2）
 
 NSString *ligatureStr = @"flush";
 
 NSDictionary *attrDict1 = @{ NSLigatureAttributeName: [NSNumber numberWithInt: 0],
 NSFontAttributeName: [UIFont fontWithName: @"futura" size: 30] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: ligatureStr attributes: attrDict1];
 
 NSDictionary *attrDict2 = @{ NSLigatureAttributeName: @(1),
 NSFontAttributeName: [UIFont fontWithName: @"futura" size: 30]
 };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: ligatureStr attributes: attrDict2];
 由于要展示连体字符，所以将前面使用的带有中文的字符串换成 flush
 
 NSLigatureAttributeName的取值为NSNumber对象，所以不能直接将一个整数值赋给它，创建 NSNumber 对象的方法有很多，或者可以简写成 @(int)
 
 
 
 
 
 注意观察字母f和l之间的变化。
 
 感觉连写就是一个艺术字功能，当字符f和l组合使用组合符号（所谓的字形(glyph)）绘制时，看起来确实更加美观。但是并非所有的字符之间都有组合符号，事实上，只有某些字体中得某些字符的组合（如字符f和l，字符f和i等）才具有美观的组合符号。
 
 
 
 4. NSKernAttributeName
 
 
 //NSKernAttributeName 设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 
 
 NSDictionary *attrDict1 = @{ NSKernAttributeName: @(-3),
 NSFontAttributeName: [UIFont systemFontOfSize: 20]
 };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSKernAttributeName: @(0),
 NSFontAttributeName: [UIFont systemFontOfSize: 20]
 };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSKernAttributeName: @(10),
 NSFontAttributeName: [UIFont systemFontOfSize: 20]
 };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 
 
 
 5. NSStrikethroughStyleAttributeName
 
 
 //NSStrikethroughStyleAttributeName 设置删除线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值
 // NSUnderlineStyleNone   不设置删除线
 // NSUnderlineStyleSingle 设置删除线为细单实线
 // NSUnderlineStyleThick  设置删除线为粗单实线
 // NSUnderlineStyleDouble 设置删除线为细双实线
 
 
 NSDictionary *attrDict1 = @{ NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSStrikethroughStyleAttributeName: @(NSUnderlineStyleThick),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSStrikethroughStyleAttributeName: @(NSUnderlineStyleDouble),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 注意：
 
 虽然使用了枚举常量，但是枚举常量的本质仍为整数，所以同样必须先转化为 NSNumber 才能使用
 
 删除线和下划线使用相同的枚举常量作为其属性值
 
 目前iOS中只有上面列出的4中效果，虽然我们能够在头文件中发现其他更多的取值，但是使用后没有任何效果
 
 
 
 
 
 
 可以看出，中文和英文删除线的位置有所不同
 
 另外，删除线属性取值除了上面的4种外，其实还可以取其他整数值，有兴趣的可以自行试验，取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
 
 NSDictionary *attrDict1 = @{ NSStrikethroughStyleAttributeName: @(1),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSStrikethroughStyleAttributeName: @(3),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSStrikethroughStyleAttributeName: @(7),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 
 
 6. NSStrikethroughColorAttributeName
 
 
 //NSStrikethroughColorAttributeName 设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 
 NSDictionary *attrDict1 = @{ NSStrikethroughColorAttributeName: [UIColor blueColor],
 NSStrikethroughStyleAttributeName: @(1),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSStrikethroughColorAttributeName: [UIColor orangeColor],
 NSStrikethroughStyleAttributeName: @(3),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSStrikethroughColorAttributeName: [UIColor greenColor],
 NSStrikethroughStyleAttributeName: @(7),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 
 
 
 7. NSUnderlineStyleAttributeName
 
 下划线除了线条位置和删除线不同外，其他的都可以完全参照删除线设置。
 
 
 //NSUnderlineStyleAttributeName 设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 
 NSDictionary *attrDict1 = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleThick),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleDouble),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 
 
 8. NSUnderlineColorAttributeName
 
 可以完全参照下划线颜色设置
 
 
 //NSUnderlineColorAttributeName 设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 
 NSDictionary *attrDict1 = @{ NSUnderlineColorAttributeName: [UIColor blueColor],
 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSUnderlineColorAttributeName: [UIColor orangeColor],
 NSUnderlineStyleAttributeName: @(NSUnderlineStyleThick),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSUnderlineColorAttributeName: [UIColor greenColor],
 NSUnderlineStyleAttributeName: @(NSUnderlineStyleDouble),
 NSFontAttributeName: [UIFont systemFontOfSize:20] };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 
 
 
 9. NSStrokeWidthAttributeName
 
 
 //NSStrokeWidthAttributeName 设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 
 NSDictionary *attrDict1 = @{ NSStrokeWidthAttributeName: @(-3),
 NSFontAttributeName: [UIFont systemFontOfSize:30] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSStrokeWidthAttributeName: @(0),
 NSFontAttributeName: [UIFont systemFontOfSize:30] };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSStrokeWidthAttributeName: @(3),
 NSFontAttributeName: [UIFont systemFontOfSize:30] };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 
 
 
 
 
 10. NSStrokeColorAttributeName
 
 
 //NSStrokeColorAttributeName 填充部分颜色，不是字体颜色，取值为 UIColor 对象
 
 NSDictionary *attrDict1 = @{ NSStrokeWidthAttributeName: @(-3),
 NSStrokeColorAttributeName: [UIColor orangeColor],
 NSFontAttributeName: [UIFont systemFontOfSize:30] };
 _label01.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict1];
 
 
 NSDictionary *attrDict2 = @{ NSStrokeWidthAttributeName: @(0),
 NSStrokeColorAttributeName: [UIColor blueColor],
 NSFontAttributeName: [UIFont systemFontOfSize:30] };
 _label02.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict2];
 
 
 NSDictionary *attrDict3 = @{ NSStrokeWidthAttributeName: @(3),
 NSStrokeColorAttributeName: [UIColor greenColor],
 NSFontAttributeName: [UIFont systemFontOfSize:30] };
 _label03.attributedText = [[NSAttributedString alloc] initWithString: originStr attributes: attrDict3];
 
 */
@end
