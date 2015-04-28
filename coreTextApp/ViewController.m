//
//  ViewController.m
//  coreTextApp
//
//  Created by  on 15-4-22.
//  Copyright (c) 2015年 zl. All rights reserved.
//

#import "ViewController.h"
#import "YYLabel.h"
#import "YYOutLabel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    YYOutLabel* tem = [[YYOutLabel alloc] initWithFrame:self.view.frame str:@"NSRegularExpression http://biancheng.dnbcw.info/shouji/463547.html登山is a new class 12222222 (described at http://userguide.icu-project.org/strings/regexp).[高兴]有人问一位登山[[高兴]]家为什么要去登山——谁都知道登山这件事既危险，又没什么实际的好处，他回答道：“因为那座山峰在那里。”我喜欢这个答案，因为里面包含着幽默感——明明是自己想要登山，偏说是山在那里使他心里痒痒。除此之外，我还喜欢这位登山家干的事，没来由地往悬崖上爬。它会导致肌 flags. The pattern syntax currently supported is that specified by ICU (described at http://userguide.icu-project.org/strings/regexp)."];
    [self.view addSubview:tem];
//    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionCaseInsensitive error:NULL];
//    NSString *someString = @"因为里面包含着幽1111111112默感——明明是自己想要登山This is a sample of a http://abc.com/efg.php?EFAei687e3EsA登山 sentence with a URL within it.因为里面包含着幽默感——明明是自己想要登山http://biancheng.dnbcw.info/shouji/463547.html登山";
//    NSString *match = [someString substringWithRange:[expression rangeOfFirstMatchInString:someString options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [someString length])]];
//    NSLog(@"%@", match);
    
//    NSString *string = @"家为什么要去登山——谁都知道登山这件事既危险 http://abc.com/efg.php?EFAei687e3EsA sentence with a URL within it.家为什么要去登山——谁都知道登山这件事既危险http://blog.csdn.net/devday/article/details/6213671 为什么要";
//    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
//    NSArray *matches = [linkDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
//    for (NSTextCheckingResult *match in matches) {
//        if ([match resultType] == NSTextCheckingTypeLink) {
//            NSURL *url = [match URL];
//            NSLog(@"found URL: %@", url);
//        }  
//    }
     //label.text = @"[高兴]有人问一位登山[高兴]家为什么要去登山——谁都知道登山这件事既危险，又没什么实际的好处，他回答道：“因为那座山峰在那里。”我喜欢这个答案，因为里面包含着幽默感——明明是自己想要登山，偏说是山在那里使他心里痒痒。除此之外，我还喜欢这位登山家干的事，没来由地往悬崖上爬。它会导致肌肉疼痛，还要冒摔出脑子的危险，所以一般人尽量避免爬山。用热力学的角度来看，这是个反熵的现象，所发趋害避利肯定反熵。,";
    
//    YYLabel* label = [[YYLabel alloc] initWithFrame:CGRectZero];
//    label.lineSpace = 5.0;
//    label.paragrphSpace = 10.0;
//    [label checkText:@"NSRegularExpression http://biancheng.dnbcw.info/shouji/463547.html登山is a new class 12222222 (described at http://userguide.icu-project.org/strings/regexp).[高兴]有人问一位登山[[高兴]]家为什么要去登山——谁都知道登山这件事既危险，又没什么实际的好处，他回答道：“因为那座山峰在那里。”我喜欢这个答案，因为里面包含着幽默感——明明是自己想要登山，偏说是山在那里使他心里痒痒。除此之外，我还喜欢这位登山家干的事，没来由地往悬崖上爬。它会导致肌 flags. The pattern syntax currently supported is that specified by ICU (described at http://userguide.icu-project.org/strings/regexp)."];
//    [self.view addSubview:label];
//    CGSize labelSize = [label sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.bounds) - 40, CGFLOAT_MAX)];
//    [label setFrame:CGRectMake(20, 100, labelSize.width, labelSize.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
