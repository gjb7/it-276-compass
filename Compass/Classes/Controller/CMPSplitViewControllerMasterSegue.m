//
//  CMPSplitViewControllerMasterSegue.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPSplitViewControllerMasterSegue.h"

#import "CMPSplitViewController.h"

NSString * const CMPSplitViewControllerMasterSegueIdentifier = @"CMPSplitViewControllerMasterSegue";

@implementation CMPSplitViewControllerMasterSegue

- (void)perform {
    NSAssert([self.sourceViewController isKindOfClass:[CMPSplitViewController class]], @"Source view controller is not an instance of CMPSplitViewController");
    
    CMPSplitViewController *splitViewController = (CMPSplitViewController *)self.sourceViewController;
    splitViewController.masterViewController = self.destinationViewController;
}

@end
