//
//  CMPRendering.c
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPRendering.h"

#import "CMPTilesheet.h"

#import "UIImage+Tint.h"
#import "UIImage+CMPAdditions.h"

void CMPRenderMap(NSArray *layers, CMPTilesheet *tilesheet, CGSize mapSize) {
    [layers enumerateObjectsUsingBlock:^(NSData *layerData, NSUInteger idx, BOOL *stop) {
        CMPRenderMapLayer(layerData, tilesheet, mapSize, 1.0, YES);
    }];
}

void CMPRenderMapLayer(NSData *layerData, CMPTilesheet *tilesheet, CGSize mapSize, CGFloat scale, BOOL isActive) {
    NSUInteger columnCount = tilesheet.numberOfColumns;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    uint8_t *bytes = (uint8_t *)layerData.bytes;
    for (NSInteger i = 0; i < layerData.length; i++) {
        NSUInteger x = (i % (NSUInteger)mapSize.width) * CMPTilesheetTileSize.width * scale;
        NSUInteger y = floorf(i / (NSUInteger)mapSize.width) * CMPTilesheetTileSize.height * scale;
        uint8_t tileIndex = bytes[i];
        
        UIImage *tileImage = [tilesheet.sprite imageWithRect:CGRectMake((tileIndex % columnCount) * CMPTilesheetTileSize.width, floor(tileIndex / columnCount) * CMPTilesheetTileSize.height, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height)];
        
        if (!isActive) {
            tileImage = [tileImage imageTintedWithColor:[UIColor blackColor] fraction:0.75];
        }
        
        [tileImage drawInRect:CGRectMake(x, y , CMPTilesheetTileSize.width * scale, CMPTilesheetTileSize.height * scale)];
    }
    
    CGContextRestoreGState(context);
}
