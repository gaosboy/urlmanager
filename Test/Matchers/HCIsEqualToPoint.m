//
//  HCIsEqualToPoint.m
//  Demo
//
//  Created by jiajun on 7/12/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "HCIsEqualToPoint.h"
#import <OCHamcrestIOS/HCDescription.h>

id <HCMatcher> HC_equalToPoint(CGPoint point)
{
    return [HCIsEqualToPoint equalToPoint:point];
}

@implementation HCIsEqualToPoint

+ (id)equalToPoint:(CGPoint)point
{
    return [[self alloc] initWithPoint:point];
}

- (id)initWithPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        self.x = point.x;
        self.y = point.y;
    }
    return self;
}

- (BOOL)matches:(id)item
{
    if (! [item isKindOfClass:[NSString class]]) {
        return NO;
    }
    CGPoint point = CGPointFromString((NSString *)item);
    
    return (point.x == self.x && point.y == self.y);
}

- (void)describeTo:(id<HCDescription>)description
{
    [description appendText:@"Point not equaled."];
}

@end
