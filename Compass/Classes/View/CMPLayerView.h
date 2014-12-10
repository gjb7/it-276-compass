//
//  CMPLayerView.h
//  Compass
//
//  Created by Grant Butler on 12/9/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

@interface CMPLayerView : UIView

@property (nonatomic) CMPTilesheet *tilesheet;
@property (nonatomic) CGSize layerSize;
@property (nonatomic, copy) NSData *layerData;

@property (nonatomic, getter=isActive) BOOL active;

- (instancetype)initWithLayerSize:(CGSize)layerSize tilesheet:(CMPTilesheet *)tilesheet;

- (void)setTile:(uint8_t)tile atIndex:(NSUInteger)tileIndex;
- (uint8_t)tileAtIndex:(NSUInteger)tileIndex;

@end
