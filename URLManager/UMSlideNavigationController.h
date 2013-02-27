//
//  UMSlideNavigationController.h
//  SegmentFault
//
//  Created by jiajun on 11/26/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#define UMNotificationWillShow      @"um_slide_notifcation_slide_nav_will_show"
#define UMNotificationHidden        @"um_slide_notifcation_slide_nav_hidden"

#import <UIKit/UIKit.h>

@interface UMSlideNavigationController : UIViewController

@property (strong, nonatomic)   NSMutableArray      *items;
@property (strong, nonatomic)   NSIndexPath         *currentIndex;
@property (strong, nonatomic)   UINavigationItem    *navItem;
@property (strong, nonatomic)   UITableView         *slideView;

- (id)initWithItems:(NSArray *)items;
- (void)showItemAtIndex:(NSIndexPath *)index withAnimation:(BOOL)animated;

@end
