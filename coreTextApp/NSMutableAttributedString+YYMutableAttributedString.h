//
//  NSMutableAttributedString+YYMutableAttributedString.h
//  coreTextApp
//
//  Created by  on 15-4-22.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface NSMutableAttributedString (YYMutableAttributedString)
-(void)setFont:(UIFont*)font;
-(void)setTextColor:(UIColor*)color;
-(void)setTextColor:(UIColor*)color range:(NSRange)range;
-(void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;
@end
