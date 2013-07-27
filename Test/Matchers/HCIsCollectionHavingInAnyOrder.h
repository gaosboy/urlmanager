//
//  HCIsCollectionHavingInAnyOrder.h
//  Demo
//
//  Created by jiajun on 7/27/13.
//  Copyright (c) 2013 SegmentFault.com. All rights reserved.
//

#import <OCHamcrestIOS/HCIsCollectionContainingInAnyOrder.h>

@interface HCIsCollectionHavingInAnyOrder : HCIsCollectionContainingInAnyOrder

@end


OBJC_EXPORT id<HCMatcher> HC_hasInAnyOrder(id itemMatch, ...) NS_REQUIRES_NIL_TERMINATION;

#ifdef HC_SHORTHAND
#define hasInAnyOrder HC_hasInAnyOrder
#endif
