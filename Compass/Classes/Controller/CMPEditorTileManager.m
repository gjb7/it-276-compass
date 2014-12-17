//
//  CMPEditorTileManager.m
//  Compass
//
//  Created by Grant Butler on 12/17/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPEditorTileManager.h"

#import "CMPTilesheetTileManager.h"

#import "CMPTilesheet.h"
#import "CMPMap.h"

@interface CMPEditorTileManager ()

@property (nonatomic, readonly) CMPTilesheetTileManager *tileManager;

@end

@implementation CMPEditorTileManager

+ (CGRect)tileRectInMapCoordinates:(CGRect)tileRect {
    CGRect convertedRect = tileRect;
    
    CGPoint renderingOrigin = [self renderingOriginForTileRectInMapCoordinates:tileRect];
    
    CGFloat widthDelta = ((int)tileRect.size.width % (int)CMPTilesheetTileSize.width);
    CGFloat heightDelta = ((int)tileRect.size.height % (int)CMPTilesheetTileSize.height);
    
    if (renderingOrigin.x != 0) {
        // These numbers are returned as negatives, which is why the operations appear to be the opposite of what they should be.
        convertedRect.origin.x += renderingOrigin.x;
        convertedRect.size.width -= renderingOrigin.x;
    }
    
    if (renderingOrigin.y != 0) {
        convertedRect.origin.y += renderingOrigin.y;
        convertedRect.size.height -= renderingOrigin.y;
    }
    
    if (widthDelta != 0) {
        convertedRect.size.width += widthDelta;
    }
    
    if (heightDelta != 0) {
        convertedRect.size.height += heightDelta;
    }
    
    return convertedRect;
}

+ (CGPoint)renderingOriginForTileRectInMapCoordinates:(CGRect)tileRect {
    CGFloat xDelta = ((int)tileRect.origin.x % (int)CMPTilesheetTileSize.width);
    CGFloat yDelta = ((int)tileRect.origin.y % (int)CMPTilesheetTileSize.height);
    
    return CGPointMake(-xDelta, -yDelta);
}

- (instancetype)initWithTilesheet:(CMPTilesheet *)tilesheet {
    self = [super init];
    if (self) {
        _tileManager = [[CMPTilesheetTileManager alloc] initWithTilesheet:tilesheet];
    }
    return self;
}

- (UIImage *)tileForRect:(CGRect)tileRect withMap:(CMPMap *)map activeLayerIndex:(NSUInteger)activeLayerIndex {
    UIGraphicsBeginImageContextWithOptions(tileRect.size, YES, self.tileManager.tilesheet.sprite.scale);
    
    CGRect tileRectInMapCoordinates = [[self class] tileRectInMapCoordinates:tileRect];
    CGPoint offsetRenderingOrigin = [[self class] renderingOriginForTileRectInMapCoordinates:tileRect];
    
    [map.layers enumerateObjectsUsingBlock:^(NSData *layerData, NSUInteger idx, BOOL *stop) {
        BOOL isActive = idx == activeLayerIndex;
        NSUInteger dataIndex = tileRectInMapCoordinates.origin.y * map.size.height + tileRectInMapCoordinates.origin.x;
        
        for (NSUInteger row = 0; row < tileRectInMapCoordinates.size.height; row++) {
            NSUInteger dataLength = (NSUInteger)tileRectInMapCoordinates.size.width;
            uint8_t bytes[dataLength];
            [layerData getBytes:bytes range:NSMakeRange(dataIndex, dataLength)];
            
            CGPoint renderingOrigin = CGPointMake(offsetRenderingOrigin.x, offsetRenderingOrigin.y + row * CMPTilesheetTileSize.height);
            
            // TODO: Render
            for (NSUInteger bytesIndex = 0; bytesIndex < dataLength; bytesIndex++) {
                NSUInteger tileIndex = bytes[bytesIndex];
                UIImage *tile = [self.tileManager tileAtIndex:tileIndex isActive:isActive];
                [tile drawAtPoint:renderingOrigin];
                renderingOrigin.x += CMPTilesheetTileSize.width;
            }
            
            dataIndex += map.size.height;
        }
    }];
    
    UIImage *tile = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tile;
}

@end
