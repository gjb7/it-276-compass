//
//  CMPSplitViewController.h
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

// We need our own implementation of a split view controller as UISplitViewController is not allowed to be used inside a navigation controller.
@interface CMPSplitViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIViewController *masterViewController;
@property (nonatomic, weak) IBOutlet UIViewController *detailViewController;

@property (nonatomic) IBOutletCollection(UIViewController) NSArray *viewControllers;

@property (nonatomic) CGFloat masterViewControllerWidth;

@end
