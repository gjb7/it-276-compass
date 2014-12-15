//
//  CMPLayersViewController.h
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@protocol CMPLayersViewControllerDelegate;

@interface CMPLayersViewController : UITableViewController

@property (nonatomic) NSArray *layers;

@property (nonatomic, weak) id <CMPLayersViewControllerDelegate> delegate;

@end

@protocol CMPLayersViewControllerDelegate <NSObject>

- (void)layersViewController:(CMPLayersViewController *)layersViewController didSelectLayerAtIndex:(NSUInteger)layerIndex;

- (void)layersViewController:(CMPLayersViewController *)layersViewController didInsertLayerAtIndex:(NSUInteger)layerIndex withData:(NSData *)data;

- (void)layersViewController:(CMPLayersViewController *)layersViewController didDeleteLayerAtIndex:(NSUInteger)layerIndex;

@end
