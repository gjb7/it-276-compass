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

@interface CMPLayerView ()

@property (nonatomic) NSMutableData *mutableLayerData;

@end

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
    NSUInteger columnCount = self.tilesheet.numberOfColumns;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
//    if (!self.isActive) {
//        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.0 alpha:0.5].CGColor);
//    }
    
    uint8_t *bytes = (uint8_t *)self.layerData.bytes;
    for (NSInteger i = 0; i < self.layerData.length; i++) {
        NSUInteger x = (i % (NSUInteger)self.layerSize.width) * CMPTilesheetTileSize.width;
        NSUInteger y = floorf(i / (NSUInteger)self.layerSize.width) * CMPTilesheetTileSize.height;
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
            
//            if (!self.isActive) {
//                CGContextFillRect(context, drawRect);
//                
//                CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
//            }
            
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

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.layerSize.width * CMPTilesheetTileSize.width, self.layerSize.height * CMPTilesheetTileSize.height);
}

#pragma mark - Accessors

- (void)setActive:(BOOL)active {
    if (_active == active) {
        return;
    }
    
    _active = active;
    
    [self setNeedsDisplay];
}

- (void)setTilesheet:(CMPTilesheet *)tilesheet {
    _tilesheet = tilesheet;
    
    [self setNeedsDisplay];
}

- (void)setLayerData:(NSData *)layerData {
    self.mutableLayerData = [layerData mutableCopy];
    
    [self setNeedsDisplay];
}

- (NSData *)layerData {
    return self.mutableLayerData;
}

- (void)setLayerSize:(CGSize)layerSize {
    _layerSize = layerSize;
    
    [self setNeedsDisplay];
}

- (void)setTile:(uint8_t)tile atIndex:(NSUInteger)tileIndex {
    NSUInteger size = sizeof(tile);
    [self.mutableLayerData replaceBytesInRange:NSMakeRange(tileIndex, size) withBytes:&tile length:size];
    
    // TODO: At some point in the future, we could just redraw the area that contains the tile and that's it.
    [self setNeedsDisplay];
}

- (uint8_t)tileAtIndex:(NSUInteger)tileIndex {
    uint8_t *bytes = (uint8_t *)self.mutableLayerData.bytes;
    return bytes[tileIndex];
}

@end
