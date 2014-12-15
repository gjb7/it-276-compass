//
//  CMPProjectViewController.m
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLevelViewController.h"

#import "CMPMapEditorViewController.h"
#import "CMPTilesheetViewController.h"
#import "CMPLayersViewController.h"

#import "CMPMap.h"

@interface CMPLevelViewController () <CMPTilesheetViewControllerDelegate>

@property (nonatomic) CMPMapEditorViewController *mapEditorViewController;
@property (nonatomic) CMPTilesheetViewController *tilesheetViewController;
@property (nonatomic) CMPLayersViewController *layersViewController;

@end

@implementation CMPLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarController *tabBarController = (UITabBarController *)self.masterViewController;
    self.tilesheetViewController = tabBarController.viewControllers[0];
    self.layersViewController = tabBarController.viewControllers[1];
    self.mapEditorViewController = (CMPMapEditorViewController *)self.detailViewController;
    
    self.tilesheetViewController.tilesheet = self.map.tilesheet;
    self.tilesheetViewController.delegate = self;
    
    self.layersViewController.layers = self.map.layers;
    
    self.mapEditorViewController.map = self.map;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CMPTilesheetViewControllerDelegate

- (void)tilesheetViewController:(CMPTilesheetViewController *)viewController didSelectTileAtIndex:(uint8_t)tileIndex {
    self.mapEditorViewController.selectedTileIndex = tileIndex;
}

@end
