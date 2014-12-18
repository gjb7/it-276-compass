//
//  CMPMap.h
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

@interface CMPMap : NSObject

@property (nonatomic) CGSize size;

@property (nonatomic) NSArray *layers;

@property (nonatomic) NSString *tilesheetPath;

@property (nonatomic, readonly) CMPTilesheet *tilesheet;

@property (nonatomic) NSString *filename;

+ (instancetype)mapWithContentsOfURL:(NSURL *)url;

- (BOOL)saveToDirectory:(NSURL *)directoryURL error:(NSError **)error;

- (void)addLayer:(NSData *)layerData;
- (void)addEmptyLayer;
- (void)removeLayerAtIndex:(NSUInteger)layerIndex;

@end
