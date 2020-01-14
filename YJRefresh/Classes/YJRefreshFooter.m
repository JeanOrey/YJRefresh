//
//  YJRefreshFooter.m
//  RefreshTool
//
//  Created by apple on 2019/9/20.
//  Copyright © 2019 Jean. All rights reserved.
//

#import "YJRefreshFooter.h"

@implementation YJRefreshFooter

- (void)prepare
{
    [super prepare];
    
    NSBundle *selfBundle = [NSBundle bundleForClass:self];
    
    NSURL *gifUrl = [selfBundle URLForResource:@"YJRefresh.bundle/yj_refresh" withExtension:@"gif"];
    //获取Gif图的原数据
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifUrl, NULL);
    
    //获取Gif图有多少帧
    size_t gifcount = CGImageSourceGetCount(gifSource);
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < gifcount; i++) {
        
        //由数据源gifSource生成一张CGImageRef类型的图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        
        [images addObject:image];
        
        CGImageRelease(imageRef);
    }
    CFRelease(gifSource);
    
    self.stateLabel.hidden = YES;
    [self setImages:images forState:MJRefreshStatePulling];
    [self setImages:images forState:MJRefreshStateRefreshing];
}

@end
