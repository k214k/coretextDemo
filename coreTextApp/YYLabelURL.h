//
//  YYLabelURL.h
//  coreTextApp
//
//  Created by  on 15-4-24.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface YYLabelURL : NSObject
@property(nonatomic,strong)id urlData;
@property(nonatomic,strong)UIColor* urlColor;
@property(nonatomic,assign)NSRange  urlRange;
@property(nonatomic,assign)BOOL  urlIsPhone;
+(YYLabelURL*)initYYLabelURL:(id)aUrlData
                       color:(UIColor*)aUrlColor
                       range:(NSRange)aUrlRange;
@end
