//
//  CMPAddLevelViewController.h
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import <JMStaticContentTableViewController/JMStaticContentTableViewController.h>

@class CMPMap;

@protocol CMPAddLevelViewControllerDelegate;

@interface CMPAddLevelViewController : JMStaticContentTableViewController

@property (nonatomic, weak) id <CMPAddLevelViewControllerDelegate> delegate;

@end

@protocol CMPAddLevelViewControllerDelegate <NSObject>

- (void)addLevelViewControllerDidCancel:(CMPAddLevelViewController *)addLevelViewController;
- (void)addLevelViewController:(CMPAddLevelViewController *)addLevelViewController didCompleteWithMap:(CMPMap *)map;

@end
