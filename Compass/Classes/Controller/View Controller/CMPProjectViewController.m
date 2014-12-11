//
//  CMPProjectViewController.m
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPProjectViewController.h"

#import "CMPMapEditorViewController.h"
#import "CMPTilesheetViewController.h"

#import "CMPMap.h"

@interface CMPProjectViewController () <CMPTilesheetViewControllerDelegate>

@property (nonatomic) CMPMapEditorViewController *mapEditorViewController;
@property (nonatomic) CMPTilesheetViewController *tilesheetViewController;

@end

@implementation CMPProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tilesheetViewController = self.viewControllers[0];
    self.mapEditorViewController = self.viewControllers[1];
    
    self.tilesheetViewController.tilesheet = self.map.tilesheet;
    self.tilesheetViewController.delegate = self;
    
    self.mapEditorViewController.map = self.map;
    
    UIBarButtonItem *projectsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Projects", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeProject:)];
    
    self.navigationItem.leftBarButtonItems = @[projectsBarButtonItem];
    
    UIBarButtonItem *layersBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Layers"] style:UIBarButtonItemStylePlain target:self action:@selector(showLayers:)];
    UIBarButtonItem *componentsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Components"] style:UIBarButtonItemStylePlain target:self action:@selector(showComponents:)];
    UIBarButtonItem *infoBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Info"] style:UIBarButtonItemStylePlain target:self action:@selector(showInfo:)];
    
    self.navigationItem.rightBarButtonItems = @[infoBarButtonItem, componentsBarButtonItem, layersBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)closeProject:(id)sender {
    
}

- (void)showLayers:(id)sender {
    
}

- (void)showComponents:(id)sender {
    
}

- (void)showInfo:(id)sender {
    
}

#pragma mark - CMPTilesheetViewControllerDelegate

- (void)tilesheetViewController:(CMPTilesheetViewController *)viewController didSelectTileAtIndex:(uint8_t)tileIndex {
    self.mapEditorViewController.selectedTileIndex = tileIndex;
}

@end
