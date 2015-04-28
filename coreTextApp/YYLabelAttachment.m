//
//  YYLabelAttachment.m
//  coreTextApp
//
//  Created by  on 15-4-24.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import "YYLabelAttachment.h"
#define SWITCHACTUAL(ref)  ((__bridge YYLabelAttachment*)ref)

CGFloat ascentCallback(void* ascentRef)
{
    YYLabelAttachment* tmp = SWITCHACTUAL(ascentRef);
    CGFloat ascent = 0;
    CGFloat height = [tmp boxSize].height;
    switch (tmp.labStyle)
    {
        case YYLabelTop:
            ascent = tmp.ascent;
            break;
        case YYLabelMiddle:
        {
            CGFloat mid = (tmp.ascent + tmp.descent)/2-tmp.descent;
            ascent = height/2 + mid;
        }
            break;
        case YYLabelButtom:
            ascent = height - tmp.descent;
            break;
        default:
            break;
    }
    return ascent;
}

CGFloat descentCallback(void* descentRef)
{
    YYLabelAttachment* tmp = SWITCHACTUAL(descentRef);
    CGFloat descent = 0;
    CGFloat height = [tmp boxSize].height;
    switch (tmp.labStyle)
    {
        case YYLabelTop:
            descent = height - tmp.ascent;
            break;
        case YYLabelMiddle:
        {
            CGFloat mid = (tmp.ascent + tmp.descent)/2-tmp.descent;
            descent = height/2 + mid;
        }
            break;
        case YYLabelButtom:
            descent = tmp.descent;
            break;
        default:
            break;
    }
    return descent;
}

CGFloat widthCallback(void* widthRef)
{
    YYLabelAttachment* tmp = SWITCHACTUAL(widthRef);

    return [tmp boxSize].width;
}

void deallocCallback(void* deallocRef)
{
    
}
@implementation YYLabelAttachment
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+(instancetype)initYYLabelAttachment:(id)aImage
                          edgeInsets:(UIEdgeInsets)aEdgeInsets
                           alignment:(YYLabelStyle)aLabStyle
                                size:(CGSize)aSize
{
    YYLabelAttachment* attachment = [YYLabelAttachment new];
    attachment.content = aImage;
    attachment.edgeInsets = aEdgeInsets;
    attachment.labStyle = aLabStyle;
    attachment.maxSize = aSize;
    return attachment;
}

-(CGSize)boxSize
{
    CGSize size = [self getContent];
    if ((size.width > 0)&&(size.height > 0)&&(_maxSize.width > 0)&&(_maxSize.height > 0))
    {
        size = [self calContent];
    }
    
    return CGSizeMake(size.width + _edgeInsets.left+_edgeInsets.right,size.height + _edgeInsets.top+_edgeInsets.bottom);
}

-(CGSize)calContent
{
    CGSize size = [self getContent];
    if ((size.width <= _maxSize.width)&&(size.height <= _maxSize.height))
    {
        return size;
    }
    //_maxSize是基准进行计算
    if ((size.width/size.height) > (_maxSize.width/_maxSize.height))
    {//_maxSize以width为基准
        size = CGSizeMake(_maxSize.width, _maxSize.width*size.width/size.height);
    }
    else
    {//_maxSize以height为基准
         size = CGSizeMake(_maxSize.height*size.width/size.height, _maxSize.height);
    }
    return size;
}

-(CGSize)getContent
{//目前只考虑图片，其他暂不考虑
    UIImage* image = (UIImage*)_content;
    return image.size;
}
@end
