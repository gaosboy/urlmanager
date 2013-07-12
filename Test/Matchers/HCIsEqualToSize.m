//
//  HCIsEqualToSize.m
//  Demo
//
//  Created by jiajun on 7/11/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "HCIsEqualToSize.h"
#import <OCHamcrestIOS/HCDescription.h>

id <HCMatcher> HC_equalToSize(CGSize size)
{
    return [HCIsEqualToSize equalToSize:size];
}

@implementation HCIsEqualToSize

+ (id)equalToSize:(CGSize)size
{
    return [[self alloc] initWithSize:size];
}

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.width  = size.width;
        self.height = size.height;
    }
    return self;
}

- (BOOL)matches:(id)item
{
    if (! [item isKindOfClass:[NSString class]]) {
        return NO;
    }
    CGSize size = CGSizeFromString((NSString *)item);
    
    return (size.width == self.width && size.height == self.height);
}

- (void)describeTo:(id<HCDescription>)description
{
    [description appendText:@"Size not equaled."];
}

@end
