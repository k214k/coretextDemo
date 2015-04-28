//
//  YYLabelAttachment.h
//  coreTextApp
//
//  Created by  on 15-4-24.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
typedef NS_ENUM(NSInteger, YYLabelStyle)
{
    YYLabelTop,
    YYLabelMiddle,
    YYLabelButtom
};


CGFloat ascentCallback(void* ascentRef);
CGFloat descentCallback(void* descentRef);
CGFloat widthCallback(void* widthRef);
void    deallocCallback(void* deallocRef);

@interface YYLabelAttachment : NSObject
@property(nonatomic,assign)CGFloat ascent;
@property(nonatomic,assign)CGFloat descent;
@property(nonatomic,assign)CGSize  maxSize;
@property(nonatomic,assign)UIEdgeInsets  edgeInsets;
@property(nonatomic,assign)YYLabelStyle labStyle;
@property(nonatomic,strong)id      content;
- (CGSize)boxSize;
+(instancetype)initYYLabelAttachment:(id)aImage
                          edgeInsets:(UIEdgeInsets)aEdgeInsets
                           alignment:(YYLabelStyle)aLabStyle
                                size:(CGSize)aSize;
@end
