//
//  CMPTilesheetViewController.h
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

@interface CMPTilesheetViewController : UICollectionViewController

@property (nonatomic, readonly) CMPTilesheet *tilesheet;

- (instancetype)initWithTilesheet:(CMPTilesheet *)tilesheet;

@end
