//
// UIScrollView+Refresh.h
// eyeApp
//
// Create by 周涛 on 2019/1/8.
// Copyright © 2019 周涛. All rights reserved..
// github: https://github.com/taozhou321

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 因为Swiftt拓展不支持存储属性，所以采用OC方式实现

 分类头文件中添加的属性只会生成getter和setter方法的声明而不会在.m文件中添加他们的实现所以需要手动添加setter和getter方法
 */

//@class ZTZoomRefreshHeader, ZTZoomRefreshFooter;
@class ZTRefreshComponent;
@interface UIScrollView (Refresh)
@property (strong, nonatomic) ZTRefreshComponent *header;
@property (strong, nonatomic) ZTRefreshComponent *footer;
@end

NS_ASSUME_NONNULL_END
