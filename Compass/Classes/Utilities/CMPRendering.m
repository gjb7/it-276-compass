//
//  CMPRendering.c
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPRendering.h"

#import "CMPTilesheet.h"

#import "CMPTilesheetTileManager.h"

void CMPRenderMap(NSArray *layers, CMPTilesheet *tilesheet, CGSize mapSize) {
    CMPTilesheetTileManager *tileManager = [[CMPTilesheetTileManager alloc] initWithTilesheet:tilesheet];
    
    [layers enumerateObjectsUsingBlock:^(NSData *layerData, NSUInteger idx, BOOL *stop) {
        CMPRenderMapLayer(layerData, tileManager, mapSize, 1.0, YES);
    }];
}

void CMPRenderMapLayer(NSData *layerData, CMPTilesheetTileManager *tileManager, CGSize mapSize, CGFloat scale, BOOL isActive) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    uint8_t *bytes = (uint8_t *)layerData.bytes;
    for (NSInteger i = 0; i < layerData.length; i++) {
        NSUInteger x = (i % (NSUInteger)mapSize.width) * CMPTilesheetTileSize.width * scale;
        NSUInteger y = floorf(i / (NSUInteger)mapSize.width) * CMPTilesheetTileSize.height * scale;
        uint8_t tileIndex = bytes[i];
        
        UIImage *tileImage = [tileManager tileAtIndex:tileIndex isActive:isActive];
        [tileImage drawInRect:CGRectMake(x, y , CMPTilesheetTileSize.width * scale, CMPTilesheetTileSize.height * scale)];
    }
    
    CGContextRestoreGState(context);
}
