//
//  CMPMapEditorViewController.h
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPMap;

#import "CMPMapEditorScrollView.h"

@interface CMPMapEditorViewController : UIViewController

@property (nonatomic) CMPMap *map;

@property (nonatomic) uint8_t selectedTileIndex;

@property (nonatomic) CMPMapEditorScrollViewMode mode;

- (instancetype)initWithMap:(CMPMap *)map;

- (void)deleteLayerAtIndex:(NSUInteger)layerIndex;

- (void)insertLayerAtIndex:(NSUInteger)layerIndex withData:(NSData *)data;

- (void)activateLayerAtIndex:(NSUInteger)layerIndex;

@end
