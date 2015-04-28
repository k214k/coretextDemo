//
//  NSMutableAttributedString+YYMutableAttributedString.m
//  coreTextApp
//
//  Created by  on 15-4-22.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import "NSMutableAttributedString+YYMutableAttributedString.h"

@implementation NSMutableAttributedString (YYMutableAttributedString)
-(void)setFont:(UIFont*)font
{//kCTFontAttributeName
    if (font)
    {
        [self removeAttribute:(NSString*)kCTFontAttributeName range:NSMakeRange(0, self.length)];
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
        if (fontRef)
        {
            [self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, self.length)];
        }
    }
}

- (void)setTextColor:(UIColor*)color range:(NSRange)range
{//kCTForegroundColorAttributeName
    if (color)
    {
        [self removeAttribute:(NSString*)kCTForegroundColorAttributeName range:range];
        [self addAttribute:(NSString*)kCTForegroundColorAttributeName value:(__bridge id)color.CGColor range:range];
    }

}

-(void)setTextColor:(UIColor*)color
{//kCTForegroundColorAttributeName
    if (color)
    {
        [self removeAttribute:(NSString*)kCTForegroundColorAttributeName range:NSMakeRange(0, self.length)];
        [self addAttribute:(NSString*)kCTForegroundColorAttributeName value:(__bridge id)color.CGColor range:NSMakeRange(0, self.length)];
    }
}

-(void)setUnderlineStyle:(CTUnderlineStyle)style
                modifier:(CTUnderlineStyleModifiers)modifier
                   range:(NSRange)range
{//kCTUnderlineColorAttributeName
    [self removeAttribute:(NSString*)kCTUnderlineStyleAttributeName range:range];
    [self addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:(style|modifier)] range:range];

}
@end
