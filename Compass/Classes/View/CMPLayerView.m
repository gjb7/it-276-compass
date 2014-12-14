//
//  CMPLayerView.m
//  Compass
//
//  Created by Grant Butler on 12/9/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLayerView.h"
#import "CMPTilesheet.h"
#import "CMPRendering.h"

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
        
        self.layer.magnificationFilter = kCAFilterNearest;
    }
    return self;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)drawRect:(CGRect)rect {
    CMPRenderMapLayer(self.layerData, self.tilesheet, self.layerSize, self.isActive);
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
