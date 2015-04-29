//
//  YYOutLabel.m
//  coreTextApp
//
//  Created by  on 15-4-27.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import "YYOutLabel.h"
#import "YYLabel.h"
@interface YYOutLabel()
{
    BOOL isAllDraw;
    YYLabel* label;
    UIMenuController *menu;
    UIImageView* imageView;
}
@end
@implementation YYOutLabel
-(instancetype)initWithFrame:(CGRect)frame str:(NSString*)aStr
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = [UIColor clearColor];
       
        UIImage *bubbleImage = [UIImage imageNamed:@"chat_send_dim"];
        bubbleImage = [bubbleImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        imageView = [[UIImageView alloc] initWithImage:bubbleImage];
        imageView.backgroundColor = [UIColor redColor];
        [imageView setFrame:CGRectMake(0, 0,320, 568)];
        [self addSubview:imageView];
        
        label = [[YYLabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.lineSpace = 5.0;
        label.paragrphSpace = 10.0;
        [label checkText:aStr];
        label.parentView = self;
        [self addSubview:label];
        CGSize labelSize = [label sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds) - 60, CGFLOAT_MAX)];
        [label setFrame:CGRectMake(20, 150, labelSize.width, labelSize.height)];
   
        
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                        
                                                        initWithTarget:self action:@selector(handleLongPress:)];
        
        longPressReger.minimumPressDuration = 0.5;
        
        [self addGestureRecognizer:longPressReger];
    }
    return self;
}

#pragma mark - Copying Method

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyed:))
    {
        return YES;
    }
    return NO;
}


#pragma mark - 长按事件的内部方法
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
    {
        return;
    }
    
    isAllDraw = YES;
    label.isAllDraw = isAllDraw;
    [label setNeedsDisplay];
    [self shownMenu];
    
}

#pragma mark -菜单事件方法
- (void)copyed:(id)sender
{
    
}

#pragma mark - 内部方法
-(void)shownMenu
{
    if(!menu)
    {
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyed:)];
        menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copy,nil]];
        [menu setTargetRect:label.frame inView:self];
    }

    [menu setMenuVisible:YES animated:YES];
}

-(void)hideMenu
{
    isAllDraw = NO;
    [menu setMenuVisible:NO animated:YES];
}

@end
