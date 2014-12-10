//
//  CMPMapView.h
//  Compass
//
//  Created by Grant Butler on 12/9/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

@interface CMPMapView : UIView

@property (nonatomic) CGSize mapSize;
@property (nonatomic) CMPTilesheet *tilesheet;
@property (nonatomic) NSArray *layers;

- (instancetype)initWithMapSize:(CGSize)mapSize tilesheet:(CMPTilesheet *)tilesheet;

@end
