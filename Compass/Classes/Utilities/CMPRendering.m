//
//  CMPRendering.c
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPRendering.h"

#import "CMPTilesheet.h"

void CMPRenderMap(NSArray *layers, CMPTilesheet *tilesheet, CGSize mapSize) {
    [layers enumerateObjectsUsingBlock:^(NSData *layerData, NSUInteger idx, BOOL *stop) {
        CMPRenderMapLayer(layerData, tilesheet, mapSize, YES);
    }];
}

void CMPRenderMapLayer(NSData *layerData, CMPTilesheet *tilesheet, CGSize mapSize, BOOL isActive) {
    NSUInteger columnCount = tilesheet.numberOfColumns;
    CGImageRef sprite = tilesheet.sprite.CGImage;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    if (!isActive) {
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0 alpha:1.0].CGColor);
    }
    
    uint8_t *bytes = (uint8_t *)layerData.bytes;
    for (NSInteger i = 0; i < layerData.length; i++) {
        NSUInteger x = (i % (NSUInteger)mapSize.width) * CMPTilesheetTileSize.width;
        NSUInteger y = floorf(i / (NSUInteger)mapSize.width) * CMPTilesheetTileSize.height;
        uint8_t tileIndex = bytes[i];
        
        CGRect fromRect = CGRectMake((tileIndex % columnCount) * CMPTilesheetTileSize.width, floor(tileIndex / columnCount) * CMPTilesheetTileSize.height, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height);
        CGRect drawRect = CGRectMake(x, y, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height);
        
        CGImageRef drawImage = CGImageCreateWithImageInRect(sprite, fromRect);
        if (drawImage != NULL) {
            // Push current graphics state so we can restore later
            CGContextSaveGState(context);
            
            // Take care of Y-axis inversion problem by translating the context on the y axis
            CGContextTranslateCTM(context, 0, drawRect.origin.y + fromRect.size.height);
            
            // Scaling -1.0 on y-axis to flip
            CGContextScaleCTM(context, 1.0, -1.0);
            
            // Then accommodate the translate by adjusting the draw rect
            drawRect.origin.y = 0.0f;
            
            if (!isActive) {
                CGContextFillRect(context, drawRect);
                
                CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
                
                CGContextDrawImage(context, drawRect, drawImage);
                
                CGContextSetBlendMode(context, kCGBlendModeDestinationAtop);
                
                CGContextSetAlpha(context, 0.5);
            }
            
            // Draw the image
            CGContextDrawImage(context, drawRect, drawImage);
            
            // Clean up memory and restore previous state
            CGImageRelease(drawImage);
            
            // Restore previous graphics state to what it was before we tweaked it
            CGContextRestoreGState(context);
        }
    }
    
    CGContextRestoreGState(context);
}
