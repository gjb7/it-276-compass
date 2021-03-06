//
//  CMPTilesheetViewController.h
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

@protocol CMPTilesheetViewControllerDelegate;

@interface CMPTilesheetViewController : UICollectionViewController

@property (nonatomic) CMPTilesheet *tilesheet;

@property (nonatomic, weak) id <CMPTilesheetViewControllerDelegate> delegate;

@end

@protocol CMPTilesheetViewControllerDelegate <NSObject>

- (void)tilesheetViewController:(CMPTilesheetViewController *)viewController didSelectTileAtIndex:(uint8_t)tileIndex;

@end
