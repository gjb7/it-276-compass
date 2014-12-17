//
//  CMPMapView.h
//  Compass
//
//  Created by Grant Butler on 12/9/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;
@class CMPLayerView;

@protocol CMPMapViewDelegate;

@interface CMPMapView : UIView

@property (nonatomic) CGSize mapSize;
@property (nonatomic) CMPTilesheet *tilesheet;
@property (nonatomic) NSArray *layers;

@property (nonatomic, getter=isEditing) BOOL editing;

@property (nonatomic, weak) id <CMPMapViewDelegate> delegate;

@property (nonatomic) CGFloat zoomScale;

- (instancetype)initWithMapSize:(CGSize)mapSize tilesheet:(CMPTilesheet *)tilesheet;

- (void)deleteLayerAtIndex:(NSUInteger)layerIndex;

- (void)insertLayerAtIndex:(NSUInteger)layerIndex withData:(NSData *)data;

- (void)activateLayerAtIndex:(NSUInteger)layerIndex;

@end

@protocol CMPMapViewDelegate <NSObject>

- (void)mapView:(CMPMapView *)mapView didTouchTileAtPoint:(CGPoint)point inLayerView:(CMPLayerView *)layerView;

@end
