//
//  CMPSplitViewController.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPSplitViewController.h"

#import "CMPSplitViewControllerMasterSegue.h"
#import "CMPSplitViewControllerDetailSegue.h"

@interface CMPSplitViewController () <UITabBarControllerDelegate>

@property (nonatomic) UIView *lineView;

@end

@implementation CMPSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.masterViewControllerWidth = 320.0;
    
    [self setUpLineView];
    
    [self performSegueWithIdentifier:CMPSplitViewControllerMasterSegueIdentifier sender:nil];
    [self performSegueWithIdentifier:CMPSplitViewControllerDetailSegueIdentifier sender:nil];
    
    if (self.masterViewController && !self.masterViewController.view.superview) {
        [self addMasterViewController];
    }
    
    if (self.detailViewController && !self.detailViewController.view.superview) {
        [self addDetailViewController];
    }
}

- (void)setUpLineView {
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView.translatesAutoresizingMaskIntoConstraints = NO;
    self.lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.lineView];
    
    NSDictionary *views = @{ @"line": self.lineView, @"topLayoutGuide": self.topLayoutGuide };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][line]|" options:0 metrics:nil views:views]];
    [self.lineView addConstraint:[NSLayoutConstraint constraintWithItem:self.lineView
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:1.0]];
}

- (void)addMasterViewController {
    self.masterViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.masterViewController];
    [self.view addSubview:self.masterViewController.view];
    [self.masterViewController didMoveToParentViewController:self];
    
    NSDictionary *metrics = @{ @"masterWidth": @(self.masterViewControllerWidth) };
    NSDictionary *views = @{ @"master": self.masterViewController.view, @"line": self.lineView, @"topLayoutGuide": self.topLayoutGuide };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[master(==masterWidth)][line]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][master]|" options:0 metrics:nil views:views]];
}

- (void)removeMasterViewController {
    [self.masterViewController willMoveToParentViewController:nil];
    [self.masterViewController.view removeFromSuperview];
    [self.masterViewController removeFromParentViewController];
}

- (void)addDetailViewController {
    self.detailViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.detailViewController];
    [self.view addSubview:self.detailViewController.view];
    [self.detailViewController didMoveToParentViewController:self];
    
    NSDictionary *views = @{ @"detail": self.detailViewController.view, @"line": self.lineView, @"topLayoutGuide": self.topLayoutGuide };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[line][detail]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][detail]|" options:0 metrics:nil views:views]];
}

- (void)removeDetailViewController {
    [self.detailViewController willMoveToParentViewController:nil];
    [self.detailViewController.view removeFromSuperview];
    [self.detailViewController removeFromParentViewController];
}

#pragma mark - Accessors

- (void)setMasterViewController:(UIViewController *)masterViewController {
    if (self.masterViewController && self.isViewLoaded) {
        [self removeMasterViewController];
    }
    
    _masterViewController = masterViewController;
    
    if (self.isViewLoaded) {
        [self addMasterViewController];
    }
}

- (void)setDetailViewController:(UIViewController *)detailViewController {
    if (self.detailViewController && self.isViewLoaded) {
        [self removeDetailViewController];
    }
    
    _detailViewController = detailViewController;
    
    if (self.isViewLoaded) {
        [self addDetailViewController];
    }
}

#pragma mark - UITabBarControllerDelegate

@end
