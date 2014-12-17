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

+ (CGRect)tileRectInMapCoordinates:(CGRect)tileRect scale:(NSInteger)scale {
    CGRect convertedRect = tileRect;
    CGSize tilesheetTileSize = CGSizeMake(CMPTilesheetTileSize.width * scale, CMPTilesheetTileSize.height * scale);
    
    convertedRect.origin.x = floor(convertedRect.origin.x / tilesheetTileSize.width);
    convertedRect.origin.y = floor(convertedRect.origin.y / tilesheetTileSize.height);
    
    convertedRect.size.width = ceil(convertedRect.size.width / tilesheetTileSize.width);
    convertedRect.size.height = ceil(convertedRect.size.height / tilesheetTileSize.width);
    
    return convertedRect;
}

+ (CGPoint)renderingOriginForTileRectInMapCoordinates:(CGRect)tileRect scale:(NSInteger)scale {
    CGSize tilesheetTileSize = CGSizeMake(CMPTilesheetTileSize.width * scale, CMPTilesheetTileSize.height * scale);
    
    CGFloat xDelta = ((int)tileRect.origin.x % (int)tilesheetTileSize.width);
    CGFloat yDelta = ((int)tileRect.origin.y % (int)tilesheetTileSize.height);
    
    return CGPointMake(-xDelta, -yDelta);
}

- (instancetype)initWithTilesheet:(CMPTilesheet *)tilesheet {
    self = [super init];
    if (self) {
        _tileManager = [[CMPTilesheetTileManager alloc] initWithTilesheet:tilesheet];
    }
    return self;
}

- (UIImage *)tileForRect:(CGRect)tileRect scale:(NSInteger)scale withMap:(CMPMap *)map activeLayerIndex:(NSUInteger)activeLayerIndex {
    CGRect tileRectInMapCoordinates = [[self class] tileRectInMapCoordinates:tileRect scale:scale];
    CGSize tilesheetTileSize = CGSizeMake(CMPTilesheetTileSize.width * scale, CMPTilesheetTileSize.height * scale);
    
    CGPoint maximumTiles = CGPointMake(map.size.width - tileRectInMapCoordinates.origin.x, map.size.height - tileRectInMapCoordinates.origin.y);
    CGPoint numberOfTiles = CGPointMake(MIN(maximumTiles.x, tileRectInMapCoordinates.size.width), MIN(maximumTiles.y, tileRectInMapCoordinates.size.height));
    
    CGSize imageSize = CGSizeMake(numberOfTiles.x * tilesheetTileSize.width, numberOfTiles.y * tilesheetTileSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, self.tileManager.tilesheet.sprite.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    CGPoint offsetRenderingOrigin = [[self class] renderingOriginForTileRectInMapCoordinates:tileRect scale:scale];
    
    [map.layers enumerateObjectsUsingBlock:^(NSData *layerData, NSUInteger idx, BOOL *stop) {
        BOOL isActive = idx == activeLayerIndex;
        NSUInteger rowCount = MIN(tileRectInMapCoordinates.size.height, map.size.height - tileRectInMapCoordinates.origin.y);
        
        for (NSUInteger row = 0; row < rowCount; row++) {
            NSInteger dataIndex = (row * map.size.height) + (tileRectInMapCoordinates.origin.y * map.size.height) + tileRectInMapCoordinates.origin.x;
            NSUInteger remainingBytesCount = layerData.length - dataIndex;
            NSUInteger dataLength = MIN((NSUInteger)tileRectInMapCoordinates.size.width, map.size.width - tileRectInMapCoordinates.origin.x);
            dataLength = MIN(dataLength, remainingBytesCount);
            
            uint8_t bytes[dataLength];
            [layerData getBytes:bytes range:NSMakeRange(dataIndex, dataLength)];
            
            CGPoint renderingOrigin = CGPointMake(offsetRenderingOrigin.x, offsetRenderingOrigin.y + row * tilesheetTileSize.height);
            
            for (NSUInteger bytesIndex = 0; bytesIndex < dataLength; bytesIndex++) {
                NSUInteger tileIndex = bytes[bytesIndex];
                UIImage *tile = [self.tileManager tileAtIndex:tileIndex isActive:isActive];
                [tile drawInRect:CGRectMake(renderingOrigin.x, renderingOrigin.y, tilesheetTileSize.width, tilesheetTileSize.height)];
                renderingOrigin.x += tilesheetTileSize.width;
            }
        }
    }];
    
    UIImage *tile = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tile;
}

@end
