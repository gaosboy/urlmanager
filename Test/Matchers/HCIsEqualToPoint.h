//
//  HCIsEqualToPoint.h
//  Demo
//
//  Created by jiajun on 7/12/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <OCHamcrestIOS/HCBaseMatcher.h>

OBJC_EXPORT id<HCMatcher> HC_equalToPoint(CGPoint point);

/**
 equalToPoint(value) -
 匹配@c CGPoint转化出的字符串是否与给出的CGPoint相等
 
 @param value  CGPoint结构
 
 这个规则会存储 @c CGPoint 的 @c x 和 @c y，比较被匹配的CGPoint中的两个值是否相等
 
 (如果有命名冲突，则不要 \#define @c HC_SHORTHAND，直接使用 @c HC_equalToPoint)
 */

#ifdef HC_SHORTHAND
#define equalToPoint HC_equalToPoint
#endif

@interface HCIsEqualToPoint : HCBaseMatcher

+ (id)equalToPoint:(CGPoint)point;
- (id)initWithPoint:(CGPoint)point;

@property (nonatomic, assign)       CGFloat     x;
@property (nonatomic, assign)       CGFloat     y;

@end
