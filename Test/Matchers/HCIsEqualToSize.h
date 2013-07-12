//
//  HCIsEqualToSize.h
//  Demo
//
//  Created by jiajun on 7/11/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <OCHamcrestIOS/HCBaseMatcher.h>

OBJC_EXPORT id<HCMatcher> HC_equalToSize(CGSize size);

/**
 equalToSize(value) -
 匹配@c CGSize转化出的字符串是否与给出的CGSize相等
 
 @param value  CGSize结构
 
 这个规则会存储 @c CGSize 的 @c width 和 @c height，比较被匹配的CGSize中的两个值是否相等
 
 (如果有命名冲突，则不要 \#define @c HC_SHORTHAND，直接使用 @c HC_equalToSize)
 */

#ifdef HC_SHORTHAND
#define equalToSize HC_equalToSize
#endif

@interface HCIsEqualToSize : HCBaseMatcher

+ (id)equalToSize:(CGSize)size;
- (id)initWithSize:(CGSize)size;

@property (nonatomic, assign)       CGFloat     width;
@property (nonatomic, assign)       CGFloat     height;

@end
