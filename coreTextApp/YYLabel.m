//
//  YYLabel.m
//  coreTextApp
//
//  Created by  on 15-4-22.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import "YYLabel.h"
#import "NSMutableAttributedString+YYMutableAttributedString.h"
#import "YYLabelAttachment.h"
#import "YYLabelURL.h"
#import "YYOutLabel.h"
#define  KREGULARCOUNT  3
@interface YYLabel()<UIActionSheetDelegate>
{
    NSMutableArray  *attachmentArray;//图片数组
    NSMutableArray  *linkLocationArray;//连接数组包括电话号码和url地址、email地址
    CTFrameRef  frameRef;
    CGFloat     ascent;
    CGFloat     descent;
    CGFloat     fontHeight;
    NSInteger   lineNumber;
    NSString*   customEmojiRegex;
    NSRegularExpression* customEmojiRegularExpression;
    NSDictionary* emojDic;
    NSRegularExpression* regexps[4];
    NSMutableAttributedString* afterAttributedString;
    YYLabelURL* touchesLinkUrl;
    NSString*   phoneStr;
    
    CGSize      allSize;
}
@property(nonatomic,strong)NSMutableAttributedString* attributedString;
@end


@implementation YYLabel
#pragma mark - 系统方法
-(void)dealloc
{
    CFRelease(frameRef);
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initCommon];
    }
    return self;
}

//计算区域
-(CGSize)sizeThatFits:(CGSize)size
{//
    NSAttributedString *drawString = [self setWillParagraphAttributedstring];
    if (!drawString)
    {
        return  CGSizeZero;
    }
    CFAttributedStringRef attributedStringRef =(__bridge  CFAttributedStringRef)drawString;
    CTFramesetterRef settingRef = CTFramesetterCreateWithAttributedString(attributedStringRef);
    CFRange range = CFRangeMake(0, 0);
    if (settingRef&&lineNumber)
    {
        
    }
    CFRange fitCFRange = CFRangeMake(0, 0);
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(settingRef, range, NULL, size, &fitCFRange);
    if (settingRef)
    {
        CFRelease(settingRef);
    }
    afterAttributedString = [drawString mutableCopy];
    allSize = newSize;
    return newSize;
}

#pragma mark - 内部方法
-(void)initCommon
{
    attachmentArray = [NSMutableArray new];
    linkLocationArray = [NSMutableArray new];
    NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"expressionImage_custom.plist"];
    emojDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
    self.font = [UIFont systemFontOfSize:15];
    self.textColor = [UIColor blackColor];
    self.linkColor = [UIColor blueColor];
    self.highlightColor  = [UIColor colorWithRed:0xd7/255.0
                                           green:0xf2/255.0
                                            blue:0xff/255.0
                                           alpha:1];
    allSize = CGSizeZero;
    self.isAllDraw = NO;
    self.lineSpace = 0;
    self.paragrphSpace = 0;
    self.textAlignment = kCTTextAlignmentLeft;
    self.lineBreakMode = kCTLineBreakByWordWrapping;
    self.backgroundColor = [UIColor clearColor];
    frameRef = nil;
    touchesLinkUrl = nil;
    _attributedString = [NSMutableAttributedString new];
    customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";//表情
    customEmojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:customEmojiRegex options:NSRegularExpressionCaseInsensitive error:nil];
    regexps[0] = kURLRegularExpression();
    regexps[1] = kPhoneNumerRegularExpression();
    regexps[2] = kEmailRegularExpression();
    //regexps[3] = kAtRegularExpression();
    [self resetFont];
    
}

-(void)resetFrame
{
    if (frameRef)
    {
        CFRelease(frameRef);
        frameRef = nil;
    }
}

-(void)resetFont
{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
    if (fontRef)
    {
        ascent = CTFontGetAscent(fontRef);
        descent = CTFontGetDescent(fontRef);
        fontHeight = CTFontGetSize(fontRef);
        CFRelease(fontRef);
    }
}

-(NSMutableAttributedString*)getAttributed:(NSString*)aStr
{
    if ([aStr length])
    {
        NSMutableAttributedString* tmp = [[NSMutableAttributedString alloc] initWithString:aStr];
        [tmp setFont:self.font];
        [tmp setTextColor:self.textColor];
        return tmp;
    }
    else
    {
        return [NSMutableAttributedString new];
    }
}

-(NSInteger)numberLine
{
    CFArrayRef arrayRef = CTFrameGetLines(frameRef);
    return lineNumber > 0 ? MIN(lineNumber, CFArrayGetCount(arrayRef)):CFArrayGetCount(arrayRef);
}

- (void)setAttachment:(NSString *)text
{
    YYLabelAttachment* tmp = [YYLabelAttachment initYYLabelAttachment:[UIImage imageNamed:text] edgeInsets:UIEdgeInsetsZero alignment:YYLabelButtom size:CGSizeMake(15, 15)];
    [self appendAttachment:tmp];
}

-(void)appendAttributed:(NSMutableAttributedString*)aStr
{
    [_attributedString appendAttributedString:aStr];
    [self resetFrame];
}

-(void)appendAttachment:(YYLabelAttachment*)aYYLabelAttachment
{
    aYYLabelAttachment.ascent = ascent;
    aYYLabelAttachment.descent = descent;
    unichar objectReplacementChar = 0xFFFC;
    NSString *objectReplacementString       = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString *attachText   = [[NSMutableAttributedString alloc]initWithString:objectReplacementString];
    
    CTRunDelegateCallbacks callBack;
    callBack.version = kCTRunDelegateVersion1;
    callBack.dealloc = deallocCallback;
    callBack.getAscent = ascentCallback;
    callBack.getDescent = descentCallback;
    callBack.getWidth = widthCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBack, (void *)aYYLabelAttachment);

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)delegate,kCTRunDelegateAttributeName, nil];
    CFRelease(delegate);
    [attachText setAttributes:dic range:NSMakeRange(0, 1)];
    [attachmentArray addObject:aYYLabelAttachment];
    [self appendAttributed:attachText];
    
}

- (void)setText:(NSString *)text
{
    if ([text length])
    {
        [_attributedString appendAttributedString:[self getAttributed:text]];
        [self resetFrame];
    }
}

-(void)setAttributedText:(NSString*)aStr
{
    if ([aStr length])
    {
        [_attributedString appendAttributedString:[self getAttributed:aStr]];
        [self resetFrame];
    }
}

#pragma mark - 外部方法
-(void)checkText:(NSString *)text
{//检测文本字段
    NSArray *emojis = [customEmojiRegularExpression matchesInString:text
                                        options:NSMatchingWithTransparentBounds
                                        range:NSMakeRange(0, [text length])];
    if (0 == emojis.count)
    {
        [self setText:text];
        return;
    }

    int location = 0;
    for (NSTextCheckingResult * result in emojis)
    {
        NSRange range = result.range;
        NSString* subStr = [text substringWithRange:NSMakeRange(location, range.location - location)];
        [self setAttributedText:subStr];
        NSString* subEmoStr = [text substringWithRange:range];
        NSString* emoImage = emojDic[subEmoStr];
        if ([emoImage length])
        {
            [self setAttachment:emoImage];
        }
        location =(range.location+range.length);
    }
    if (location < [text length])
    {
        NSString* subStr = [text substringWithRange:NSMakeRange(location, text.length - location)];
        [self setText:subStr];
    }
}


#pragma mark - 系统绘制
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (ctx == nil)
    {
        return;
    }
    CGContextSaveGState(ctx);
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
    CGContextConcatCTM(ctx, transform);
    
    NSAttributedString *drawString = [afterAttributedString mutableCopy];
    if (drawString)
    {
        [self setWillCTFrameAttributedstring:drawString rect:rect];
        [self drawLightAttributedstring:rect];
        [self drawAllBackGround:rect];
        [self drawAttachment];
        [self drawText: drawString
                  rect: rect
               context: ctx];
    }
    CGContextRestoreGState(ctx);
}
#pragma mark - 绘制前的样式设置
-(NSMutableAttributedString*)setWillParagraphAttributedstring
{
    if ([_attributedString length])
    {
        //添加排版格式
        NSMutableAttributedString* tmp = [_attributedString mutableCopy];
        //如果LineBreakMode为TranncateTail,那么默认排版模式改成kCTLineBreakByCharWrapping,使得尽可能地显示所有文字
        /*CTLineBreakMode lineBreakMode = self.lineBreakMode;
        if (self.lineBreakMode == kCTLineBreakByTruncatingTail)
        {//kCTLineBreakByTruncatingTail目前没有考虑的
            lineBreakMode = lineNumber == 1 ? kCTLineBreakByCharWrapping : kCTLineBreakByWordWrapping;
        }*/
        CGFloat fontLineHeight = self.font.lineHeight;  //使用全局fontHeight作为最小lineHeight
        
        
        CTParagraphStyleSetting settings[] =
        {
            {kCTParagraphStyleSpecifierAlignment,sizeof(_textAlignment),&_textAlignment},
            {kCTParagraphStyleSpecifierLineBreakMode,sizeof(_lineBreakMode),&_lineBreakMode},
            {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(_lineSpace),&_lineSpace},
            {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(_lineSpace),&_lineSpace},
            {kCTParagraphStyleSpecifierParagraphSpacing,sizeof(_paragrphSpace),&_paragrphSpace},
            {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(fontLineHeight),&fontLineHeight},
        };
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings,sizeof(settings)/sizeof(settings[0]));
        [tmp addAttribute:(id)kCTParagraphStyleAttributeName
                           value:(__bridge id)paragraphStyle
                           range:NSMakeRange(0, [tmp length])];
        CFRelease(paragraphStyle);
        
        //添加链接形式计算区域和保存连接数组

        for (int i = 0;i < KREGULARCOUNT;++i)
        {
            NSArray *urlArray = [regexps[i] matchesInString:tmp.string
                                                    options:NSMatchingWithTransparentBounds
                                                      range:NSMakeRange(0, [tmp.string length])];
            if (0 == urlArray.count)
            {
                continue;
            }
            for (NSTextCheckingResult * result in urlArray)
            {
                NSRange range = result.range;
                NSString* subStr = [tmp.string substringWithRange:range];
                
                YYLabelURL* tmpUrl = [YYLabelURL initYYLabelURL:subStr color:self.linkColor range:range];
                if (i == 1)
                {
                    tmpUrl.urlIsPhone = YES;
                }
                [linkLocationArray addObject:tmpUrl];
                
                [tmp setTextColor:self.linkColor range:range];
                [tmp setUnderlineStyle:kCTUnderlineStyleSingle modifier:kCTUnderlinePatternSolid range:range];

            }
        }
        return tmp;
    }
    else
    {
        return nil;
    }
}

-(void)setWillCTFrameAttributedstring:(NSAttributedString*)aAttributedString rect:(CGRect)aRect
{
    if (!frameRef)
    {
        CTFramesetterRef settingRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)aAttributedString);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, aRect);
        
        frameRef = CTFramesetterCreateFrame(settingRef, CFRangeMake(0, 0), path, NULL);
        CGPathRelease(path);
        CFRelease(settingRef);
    }
}

- (CGRect)rectForRange:(NSRange)range
                inLine:(CTLineRef)line
            lineOrigin:(CGPoint)lineOrigin
{
    CGRect rectForRange = CGRectZero;
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runs);
    
    // Iterate through each of the "runs" (i.e. a chunk of text) and find the runs that
    // intersect with the range.
    for (CFIndex k = 0; k < runCount; k++)
    {
        CTRunRef run = CFArrayGetValueAtIndex(runs, k);
        
        CFRange stringRunRange = CTRunGetStringRange(run);
        NSRange lineRunRange = NSMakeRange(stringRunRange.location, stringRunRange.length);
        NSRange intersectedRunRange = NSIntersectionRange(lineRunRange, range);
        
        if (intersectedRunRange.length == 0)
        {
            // This run doesn't intersect the range, so skip it.
            continue;
        }
        
        CGFloat tmpAscent = 0.0f;
        CGFloat tmpDescent = 0.0f;
        
        // Use of 'leading' doesn't properly highlight Japanese-character link.
        CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                           CFRangeMake(0, 0),
                                                           &tmpAscent,
                                                           &tmpDescent,
                                                           NULL); //&leading);
        CGFloat height = tmpDescent + tmpAscent;
        
        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
        
        CGRect linkRect = CGRectMake(lineOrigin.x + xOffset, lineOrigin.y - tmpDescent, width, height);
        
        linkRect.origin.y = roundf(linkRect.origin.y);
        linkRect.origin.x = roundf(linkRect.origin.x);
        linkRect.size.width = roundf(linkRect.size.width);
        linkRect.size.height = roundf(linkRect.size.height);
        
        rectForRange = CGRectIsEmpty(rectForRange) ? linkRect : CGRectUnion(rectForRange, linkRect);
    }
    
    return rectForRange;
}
#pragma mark - 绘制
//绘制长按选中背景
-(void)drawAllBackGround:(CGRect)rect
{
    if (self.isAllDraw&&self.highlightColor)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect rectangle = CGRectMake(0, 0, allSize.width, allSize.height);
        CGContextSetFillColorWithColor(ctx,self.highlightColor.CGColor);
        CGContextFillRect(ctx , rectangle);
    }
    else
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect rectangle = CGRectMake(0, 0, allSize.width, allSize.height);
        CGContextSetFillColorWithColor(ctx,[UIColor clearColor].CGColor);
        CGContextFillRect(ctx , rectangle);
    }
}

//绘制url高亮背景色
-(void)drawLightAttributedstring:(CGRect)rect
{
    if (touchesLinkUrl && self.highlightColor)
    {
        [self.highlightColor setFill];
        NSRange linkRange = touchesLinkUrl.urlRange;
        
        CFArrayRef lines = CTFrameGetLines(frameRef);
        CFIndex count = CFArrayGetCount(lines);
        CGPoint lineOrigins[count];
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
        NSInteger numberOfLines = [self numberLine];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        for (CFIndex i = 0; i < numberOfLines; i++)
        {
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            
            CFRange stringRange = CTLineGetStringRange(line);
            NSRange lineRange = NSMakeRange(stringRange.location, stringRange.length);
            NSRange intersectedRange = NSIntersectionRange(lineRange, linkRange);
            if (intersectedRange.length == 0) {
                continue;
            }
            
            CGRect highlightRect = [self rectForRange:linkRange
                                               inLine:line
                                           lineOrigin:lineOrigins[i]];
            highlightRect = CGRectOffset(highlightRect, 0, -rect.origin.y);
            if (!CGRectIsEmpty(highlightRect))
            {
                CGFloat pi = (CGFloat)M_PI;
                
                CGFloat radius = 1.0f;
                CGContextMoveToPoint(ctx, highlightRect.origin.x, highlightRect.origin.y + radius);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x, highlightRect.origin.y + highlightRect.size.height - radius);
                CGContextAddArc(ctx, highlightRect.origin.x + radius, highlightRect.origin.y + highlightRect.size.height - radius,
                                radius, pi, pi / 2.0f, 1.0f);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x + highlightRect.size.width - radius,
                                        highlightRect.origin.y + highlightRect.size.height);
                CGContextAddArc(ctx, highlightRect.origin.x + highlightRect.size.width - radius,
                                highlightRect.origin.y + highlightRect.size.height - radius, radius, pi / 2, 0.0f, 1.0f);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x + highlightRect.size.width, highlightRect.origin.y + radius);
                CGContextAddArc(ctx, highlightRect.origin.x + highlightRect.size.width - radius, highlightRect.origin.y + radius,
                                radius, 0.0f, -pi / 2.0f, 1.0f);
                CGContextAddLineToPoint(ctx, highlightRect.origin.x + radius, highlightRect.origin.y);
                CGContextAddArc(ctx, highlightRect.origin.x + radius, highlightRect.origin.y + radius, radius,
                                -pi / 2, pi, 1);
                CGContextFillPath(ctx);
            }
        }
        
    }

}

-(void)drawAttachment
{//绘制图片
    if (0 == attachmentArray.count)
    {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (ctx == nil)
    {
        return;
    }

    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex  linesCount = CFArrayGetCount(lines);
    CGPoint  linesOrign[linesCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), linesOrign);
    NSInteger numberOfLines = [self numberLine];
    for (CFIndex i = 0;i < numberOfLines;++i)
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runsCount = CFArrayGetCount(runs);
        CGPoint runOrign = linesOrign[i];
        CGFloat runAscent;
        CGFloat runDescent;
        CTLineGetTypographicBounds(line, &runAscent, &runDescent,NULL);
        CGFloat  lineHeight = runAscent + runDescent;
        CGFloat  lineButtomY = runOrign.y - runDescent;
        for (CFIndex j = 0;j < runsCount;++j)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)([runAttributes valueForKey:(id)kCTRunDelegateAttributeName]);
            if (!delegate)
            {
                continue;
            }
            YYLabelAttachment* tmp = (YYLabelAttachment*)CTRunDelegateGetRefCon(delegate);
            CGFloat tmpAscent = 0.0;
            CGFloat tmpDescent = 0.0;
            CGFloat width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &tmpAscent, &tmpDescent, NULL);
            CGFloat imageHeight = [tmp boxSize].height;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            CGFloat imageY = 0.0;
            switch (tmp.labStyle)
            {//坐标调整
                case YYLabelTop:
                    imageY = lineButtomY + lineHeight - imageHeight;
                    break;
                case YYLabelMiddle:
                    imageY = lineButtomY + (lineHeight - imageHeight)/2;
                    break;
                case YYLabelButtom:
                    imageY = lineButtomY;
                    break;
                default:
                    break;
            }
            CGRect rect = CGRectMake(runOrign.x + xOffset, imageY, width, imageHeight);
            UIEdgeInsets flippedMargins = tmp.edgeInsets;
            CGFloat top = flippedMargins.top;
            flippedMargins.top = flippedMargins.bottom;
            flippedMargins.bottom = top;
            CGRect attatchmentRect = UIEdgeInsetsInsetRect(rect, flippedMargins);
            
            /*没有考虑的截断的情况,直接绘制界面*/
            
            id content = tmp.content;
            if ([content isKindOfClass:[UIImage class]])
            {
                CGContextDrawImage(ctx, attatchmentRect, ((UIImage *)content).CGImage);
            }
            else
            {
                //其他控件绘制暂不考虑
            }
        }
    }
   
}

//绘制文本
- (void)drawText: (NSAttributedString *)attributedString
            rect: (CGRect)rect
         context: (CGContextRef)context
{
    if (frameRef)
    {
        if (lineNumber)
        {//一行一行绘制
            CFArrayRef lines = CTFrameGetLines(frameRef);
            NSInteger  numberLines = [self numberLine];
            CGPoint    linesOrgins[numberLines];
            CTFrameGetLineOrigins(frameRef, CFRangeMake(0, numberLines), linesOrgins);
            for (CFIndex index = 0; index < lineNumber;index++)
            {
                CGPoint linesOrgin = linesOrgins[index];
                CGContextSetTextPosition(context, linesOrgin.x, linesOrgin.y);
                CTLineRef line = CFArrayGetValueAtIndex(lines, index);
                CTLineDraw(line, context);
            }
        }
        else
        {//整体绘制
            CTFrameDraw(frameRef,context);
        }
        
    }
}

#pragma mark - actionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {//呼叫
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",phoneStr];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if(buttonIndex == 1)
    {//复制
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [phoneStr copy];
    }
    else if(buttonIndex == 2)
    {//@"添加好友"
        
    }
    else if(buttonIndex == 3)
    {//@"加入群"
        
    }
}
#pragma mark - 内部点击事件响应的处理

-(CGRect)getRect:(CTLineRef)aLine point:(CGPoint)aPoint
{//获取当前行的点击的区域
    CGFloat tmpAscent = 0;
    CGFloat tmpDescent = 0;
    CGFloat tmpLeadering = 0;
    CGFloat tmpWidth = (CGFloat)CTLineGetTypographicBounds(aLine, &tmpAscent, &tmpDescent, &tmpLeadering);
    CGFloat tmpHeight = ascent + descent;
    return CGRectMake(aPoint.x, aPoint.y - tmpDescent, tmpWidth, tmpHeight);
}

-(YYLabelURL*)getLinkUrl:(CFIndex)aIndex
{//获取url
    for (YYLabelURL *tmp in linkLocationArray)
    {
        if(NSLocationInRange(aIndex,tmp.urlRange))
        {
            return tmp;
        }
    }
    return nil;
}

-(YYLabelURL*)touchesPoint:(CGPoint)aPoint
{//获取点击的区域
    static const CGFloat kVMargin = 5;
    if (!CGRectContainsPoint(CGRectInset(self.bounds, 0, -kVMargin), aPoint)
        || frameRef == nil)
    {
        return nil;
    }
    
    CFArrayRef lines = CTFrameGetLines(frameRef);
    NSInteger  numberLines = CFArrayGetCount(lines);
    CGPoint    linesOrgins[numberLines];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), linesOrgins);
    for (CFIndex index = 0; index < numberLines;index++)
    {
        CGPoint linesOrgin = linesOrgins[index];
        CTLineRef line = CFArrayGetValueAtIndex(lines, index);
        CGRect flipRect = [self getRect:line point:linesOrgin];
        CGRect actualRect = CGRectApplyAffineTransform(flipRect, transform);
        actualRect  = CGRectInset(actualRect, 0, -kVMargin);
        if (CGRectContainsPoint(actualRect, aPoint))
        {
            CGPoint relatePoint = CGPointMake(aPoint.x - CGRectGetMinX(actualRect), aPoint.y - CGRectGetMinY(actualRect));
            CFIndex tmpIndex = CTLineGetStringIndexForPosition(line, relatePoint);
            YYLabelURL* tmpUrl = [self getLinkUrl:tmpIndex];
            if (tmpUrl)
            {
                return tmpUrl;
            }
        }
        
    }

    return nil;
}

-(BOOL)touchesEndOpenUrl:(CGPoint)aPoint
{//打开连接
    YYLabelURL* tmpUrl = [self touchesPoint:aPoint];
    if (tmpUrl)
    {
        id tmpContent = tmpUrl.urlData;
        NSURL *url = nil;
        if ([tmpContent isKindOfClass:[NSString class]])
        {
            url = [NSURL URLWithString:tmpContent];
        }
        else if([tmpContent isKindOfClass:[NSURL class]])
        {
            url = tmpContent;
        }
        if (url)
        {
            if (!tmpUrl.urlIsPhone)
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            else
            {//@"添加好友",@"加入群"
                phoneStr = [tmpContent copy];
                NSString* str = [NSString stringWithFormat:@"%@\n可能是一个电话号码或其他的号码,你可以",tmpContent];
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:str
                                              delegate:self
                                              cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"呼叫", @"复制",nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [actionSheet showInView:self];
            }
        }
        return YES;
    }
    return NO;
}
#pragma mark - UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(__unused id)sender
{
    return (action == @selector(copy:));
}
#pragma mark - 点击事件相应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isAllDraw)
    {
        self.isAllDraw = NO;
        [((YYOutLabel*)(self.parentView)) hideMenu];
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    touchesLinkUrl = [self touchesPoint:point];
    if (touchesLinkUrl)
    {
        [self setNeedsDisplay];
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    YYLabelURL* tmp = [self touchesPoint:point];;
    if (tmp != touchesLinkUrl)
    {
        touchesLinkUrl = tmp;
        [self setNeedsDisplay];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (touchesLinkUrl)
    {
        touchesLinkUrl = nil;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(![self touchesEndOpenUrl:point])
    {
        [super touchesEnded:touches withEvent:event];
    }
    if (touchesLinkUrl)
    {
        touchesLinkUrl = nil;
        [self setNeedsDisplay];
    }
}
@end
