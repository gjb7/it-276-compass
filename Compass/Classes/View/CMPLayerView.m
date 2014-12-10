//
//  CMPLayerView.m
//  Compass
//
//  Created by Grant Butler on 12/9/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLayerView.h"
#import "CMPTilesheet.h"

@import QuartzCore;

@implementation CMPLayerView

- (instancetype)initWithLayerSize:(CGSize)layerSize tilesheet:(CMPTilesheet *)tilesheet {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, layerSize.width * CMPTilesheetTileSize.width, layerSize.height * CMPTilesheetTileSize.height)];
    if (self) {
        _layerSize = layerSize;
        _tilesheet = tilesheet;
    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect {
    CGImageRef sprite = self.tilesheet.sprite.CGImage;
    NSUInteger columnCount = self.tilesheet.sprite.size.width / CMPTilesheetTileSize.width;
    
    uint8_t *bytes = (uint8_t *)self.layerData.bytes;
    for (NSInteger i = 0; i < self.layerData.length; i++) {
        NSUInteger x = (i % (NSUInteger)self.layerSize.width) * CMPTilesheetTileSize.width;
        NSUInteger y = floorf(i / (NSUInteger)self.layerSize.width) * CMPTilesheetTileSize.height;
        uint8_t tileIndex = bytes[i];
        
        CGRect fromRect = CGRectMake((tileIndex % columnCount) * CMPTilesheetTileSize.width, floor(tileIndex / columnCount) * CMPTilesheetTileSize.height, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height);
        CGRect drawRect = CGRectMake(x, y, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height);
        
        CGImageRef drawImage = CGImageCreateWithImageInRect(sprite, fromRect);
        if (drawImage != NULL) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            // Push current graphics state so we can restore later
            CGContextSaveGState(context);
            
            // Take care of Y-axis inversion problem by translating the context on the y axis
            CGContextTranslateCTM(context, 0, drawRect.origin.y + fromRect.size.height);
            
            // Scaling -1.0 on y-axis to flip
            CGContextScaleCTM(context, 1.0, -1.0);
            
            // Then accommodate the translate by adjusting the draw rect
            drawRect.origin.y = 0.0f;
            
            // Draw the image
            CGContextDrawImage(context, drawRect, drawImage);
            
            // Clean up memory and restore previous state
            CGImageRelease(drawImage);
            
            // Restore previous graphics state to what it was before we tweaked it
            CGContextRestoreGState(context); 
        }
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.layerSize.width * CMPTilesheetTileSize.width, self.layerSize.height * CMPTilesheetTileSize.height);
}

- (void)setTilesheet:(CMPTilesheet *)tilesheet {
    _tilesheet = tilesheet;
    
    [self setNeedsDisplay];
}

- (void)setLayerData:(NSData *)layerData {
    _layerData = layerData;
    
    [self setNeedsDisplay];
}

- (void)setLayerSize:(CGSize)layerSize {
    _layerSize = layerSize;
    
    [self setNeedsDisplay];
}

@end
