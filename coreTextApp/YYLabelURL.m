//
//  YYLabelURL.m
//  coreTextApp
//
//  Created by  on 15-4-24.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import "YYLabelURL.h"

@implementation YYLabelURL
+(YYLabelURL*)initYYLabelURL:(id)aUrlData
                       color:(UIColor*)aUrlColor
                       range:(NSRange)aUrlRange
{
    YYLabelURL* temp = [YYLabelURL new];
    temp.urlColor = aUrlColor;
    temp.urlData = aUrlData;
    temp.urlRange = aUrlRange;
    return temp;
}
@end
