//
//  CMPRendering.h
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreGraphics;

@class CMPTilesheet;

void CMPRenderMap(NSArray *layers, CMPTilesheet *tilesheet, CGSize mapSize);
void CMPRenderMapLayer(NSData *layerData, CMPTilesheet *tilesheet, CGSize mapSize, BOOL isActive);