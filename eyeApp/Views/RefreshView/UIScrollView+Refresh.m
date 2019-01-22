//
// UIScrollView+Refresh.m
// eyeApp
//
// Create by 周涛 on 2019/1/8.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

#import "UIScrollView+Refresh.h"
#import "eyeApp-Swift.h"
#import <objc/runtime.h>

@implementation UIScrollView (Refresh)

static const char ZTRefreshHeaderKey = '\0';
static const char ZTRefreshFooterKey = '\0';
- (ZTRefreshComponent *)header {
    return objc_getAssociatedObject(self, &ZTRefreshHeaderKey);
}

- (void)setHeader:(ZTRefreshComponent *)header {
    if (self.header != header) {
        [self.header removeFromSuperview];
        [self insertSubview:header atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &ZTRefreshHeaderKey,
                                 header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (ZTRefreshComponent *)footer {
    return objc_getAssociatedObject(self, &ZTRefreshFooterKey);
}

- (void)setFooter:(ZTRefreshComponent *)footer {
    if (self.footer != footer) {
        [self.footer removeFromSuperview];
        [self insertSubview:footer atIndex:0];
        
        // 存储新的
        objc_setAssociatedObject(self, &ZTRefreshFooterKey,
                                 footer, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
