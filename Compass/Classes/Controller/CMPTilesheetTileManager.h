//
//  CMPTilesheetTileManager.h
//  Compass
//
//  Created by Grant Butler on 12/16/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

/**
 In charge of splitting a tilesheet into its individual tiles, as well as the different variants of the tile (for example, then active and inactive variants).
 */
@interface CMPTilesheetTileManager : NSObject

@property (nonatomic, readonly) CMPTilesheet *tilesheet;

- (instancetype)initWithTilesheet:(CMPTilesheet *)tilesheet;

- (UIImage *)tileAtIndex:(NSUInteger)tileIndex isActive:(BOOL)active;

@end
