//
// EYEDeviceTool.m
// eyeApp
//
// Create by 周涛 on 2019/1/11.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

#import "EYEDeviceTool.h"

@implementation EYEDeviceTool
+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
@end
