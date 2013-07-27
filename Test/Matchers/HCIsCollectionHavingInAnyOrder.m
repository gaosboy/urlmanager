//
//  HCIsCollectionHavingInAnyOrder.m
//  Demo
//
//  Created by jiajun on 7/27/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import "HCIsCollectionHavingInAnyOrder.h"

#import <OCHamcrestIOS/HCAllOf.h>
#import <OCHamcrestIOS/HCDescription.h>
#import <OCHamcrestIOS/HCWrapInMatcher.h>

@interface HCMatchingInAnyOrderEx : NSObject
@end

@interface HCMatchingInAnyOrderEx ()

@property   (strong, nonatomic) NSMutableArray  *matchers;
@property   (assign, nonatomic) id<HCDescription, NSObject> mismatchDescription;

@end

@implementation HCMatchingInAnyOrderEx

- (id)initWithMatchers:(NSMutableArray *)itemMatchers
   mismatchDescription:(id<HCDescription, NSObject>)description
{
    self = [super init];
    if (self)
    {
        self.matchers = itemMatchers;
        self.mismatchDescription = description;
    }
    return self;
}

- (BOOL)matches:(id)item
{
    NSUInteger index = 0;
    BOOL matched = (0 >= [self.matchers count]);
    for (id<HCMatcher> matcher in self.matchers)
    {
        if ([matcher matches:item]) {
            [self.matchers removeObjectAtIndex:index];
            matched = YES;
            return YES;
        }
        ++index;
    }
    return matched;
}

- (BOOL)isFinishedWith:(NSArray *)collection
{
    if ([self.matchers count] == 0)
        return YES;
    
    [[[[self.mismatchDescription appendText:@"no item matches: "]
       appendList:self.matchers start:@"" separator:@", " end:@""]
      appendText:@" in "]
     appendList:collection start:@"[" separator:@", " end:@"]"];
    return NO;
}

@end


#pragma mark -

@implementation HCIsCollectionHavingInAnyOrder

- (BOOL)matches:(id)collection describingMismatchTo:(id<HCDescription>)mismatchDescription
{
    if (![collection conformsToProtocol:@protocol(NSFastEnumeration)])
    {
        [super describeMismatchOf:collection to:mismatchDescription];
        return NO;
    }
    
    HCMatchingInAnyOrderEx *matchSequence =
    [[HCMatchingInAnyOrderEx alloc] initWithMatchers:matchers
                                 mismatchDescription:mismatchDescription];
    for (id item in collection)
        if (![matchSequence matches:item])
            return NO;
    
    return [matchSequence isFinishedWith:collection];
}

@end

#pragma mark -

id<HCMatcher> HC_hasInAnyOrder(id itemMatch, ...)
{
    NSMutableArray *matchers = [NSMutableArray arrayWithObject:HCWrapInMatcher(itemMatch)];
    
    va_list args;
    va_start(args, itemMatch);
    itemMatch = va_arg(args, id);
    while (itemMatch != nil)
    {
        [matchers addObject:HCWrapInMatcher(itemMatch)];
        itemMatch = va_arg(args, id);
    }
    va_end(args);
    
    return [HCIsCollectionHavingInAnyOrder isCollectionContainingInAnyOrder:matchers];
}
