//
//  YYLabel.h
//  coreTextApp
//
//  Created by  on 15-4-22.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#define REGULAREXPRESSION_OPTION(regularExpression,regex,option) \
\
static inline NSRegularExpression * k##regularExpression() { \
static NSRegularExpression *_##regularExpression = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_##regularExpression = [[NSRegularExpression alloc] initWithPattern:(regex) options:(option) error:nil];\
});\
\
return _##regularExpression;\
}


#define REGULAREXPRESSION(regularExpression,regex) REGULAREXPRESSION_OPTION(regularExpression,regex,NSRegularExpressionCaseInsensitive)


REGULAREXPRESSION(URLRegularExpression,@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)")

REGULAREXPRESSION(PhoneNumerRegularExpression, @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}")

REGULAREXPRESSION(EmailRegularExpression, @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}")

REGULAREXPRESSION(AtRegularExpression, @"@[\\u4e00-\\u9fa5\\w\\-]+")


//@"#([^\\#|.]+)#"
//REGULAREXPRESSION_OPTION(PoundSignRegularExpression, @"#([\\u4e00-\\u9fa5\\w\\-]+)#", NSRegularExpressionCaseInsensitive)

//微信的表情符其实不是这种格式，这个格式的只是让人看起来更友好。。
//REGULAREXPRESSION(EmojiRegularExpression, @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]")

//@"/:[\\w:~!@$&*()|+<>',?-]{1,8}" , // @"/:[\\x21-\\x2E\\x30-\\x7E]{1,8}" ，经过检测发现\w会匹配中文，好奇葩。
//REGULAREXPRESSION(SlashEmojiRegularExpression, @"/:[\\x21-\\x2E\\x30-\\x7E]{1,8}")

//只绘制文本、文本连接,图文混排，没有按钮，
@interface YYLabel : UIView
@property(nonatomic,strong)UIView* parentView;
@property(nonatomic,strong)UIFont* font;
@property(nonatomic,strong)UIColor* textColor;
@property(nonatomic,strong)UIColor* linkColor;
@property(nonatomic,strong)UIColor* highlightColor;
@property(nonatomic,assign)CTTextAlignment textAlignment;  //文字排版样式
@property(nonatomic,assign)CTLineBreakMode lineBreakMode;  //LineBreakMode
@property(nonatomic,assign)CGFloat  lineSpace;
@property(nonatomic,assign)CGFloat  paragrphSpace;
@property(nonatomic,assign)BOOL        isAllDraw;

-(void)checkText:(NSString *)text;
//- (void)setText:(NSString *)text;
//-(void)setAttributedText:(NSString*)aStr;
@end
