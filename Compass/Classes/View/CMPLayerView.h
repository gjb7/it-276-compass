//
//  CMPLayerView.h
//  Compass
//
//  Created by Grant Butler on 12/9/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

@protocol CMPLayerViewDelegate;

@interface CMPLayerView : UIView

@property (nonatomic) CMPTilesheet *tilesheet;
@property (nonatomic) CGSize layerSize;
@property (nonatomic, copy) NSData *layerData;

@property (nonatomic, getter=isActive) BOOL active;

@property (nonatomic, getter=isEditing) BOOL editing;

@property (nonatomic, weak) id <CMPLayerViewDelegate> delegate;

- (instancetype)initWithLayerSize:(CGSize)layerSize tilesheet:(CMPTilesheet *)tilesheet;

- (void)setTile:(uint8_t)tile atIndex:(NSUInteger)tileIndex;
- (uint8_t)tileAtIndex:(NSUInteger)tileIndex;

@end

@protocol CMPLayerViewDelegate <NSObject>

- (void)layerView:(CMPLayerView *)layerView didTouchTileAtPoint:(CGPoint)point;

@end
