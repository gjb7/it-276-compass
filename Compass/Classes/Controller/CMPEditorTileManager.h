//
//  CMPEditorTileManager.h
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;
@class CMPMap;

@interface CMPEditorTileManager : NSObject

- (instancetype)initWithTilesheet:(CMPTilesheet *)tilesheet;

- (UIImage *)tileForRect:(CGRect)tileRect withMap:(CMPMap *)map activeLayerIndex:(NSUInteger)activeLayerIndex;

@end
