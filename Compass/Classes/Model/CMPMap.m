//
//  CMPMap.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMap.h"
#import "CMPMapParser.h"
#import "CMPV1MapSerializer.h"

#import "CMPTilesheet.h"

@interface CMPMap ()

@property (nonatomic, readwrite) CMPTilesheet *tilesheet;

@property (nonatomic, readonly) NSMutableArray *mutableLayers;

@end

@implementation CMPMap

@synthesize mutableLayers = _mutableLayers;

+ (instancetype)mapWithContentsOfURL:(NSURL *)url {
    CMPMap *map = [[CMPMap alloc] init];
    map.filename = [url lastPathComponent];
    
    NSData *mapData = [[NSData alloc] initWithContentsOfURL:url options:0 error:nil];
    if (!mapData) {
        return nil;
    }
    
    CMPMapParser *parser = [[CMPMapParser alloc] initWithData:mapData];
    
    NSError *error;
    if (![parser parseIntoMap:map error:&error]) {
        NSLog(@"Error parsing map: %@", error);
        
        return nil;
    }
    
    return map;
}

- (BOOL)saveToDirectory:(NSURL *)directoryURL error:(NSError **)error {
    NSAssert(self.filename.length > 0, @"A valid filename must have been provided.");
    
    CMPV1MapSerializer *serializer = [[CMPV1MapSerializer alloc] init];
    NSData *serializedMap = [serializer serializeMap:self];
    
    NSURL *fileURL = [directoryURL URLByAppendingPathComponent:self.filename];
    return [serializedMap writeToURL:fileURL options:NSDataWritingAtomic error:error];
}

- (void)setLayers:(NSArray *)layers {
    // Use the getter here to make sure that we have a mutable array.
    [self.mutableLayers removeAllObjects];
    
    [layers enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
        [self.mutableLayers addObject:[obj mutableCopy]];
    }];
}

- (NSArray *)layers {
    return self.mutableLayers;
}

- (NSMutableArray *)mutableLayers {
    if (!_mutableLayers) {
        _mutableLayers = [[NSMutableArray alloc] init];
    }
    return _mutableLayers;
}

- (void)setSize:(CGSize)size {
    _size = size;
    
    [self.layers enumerateObjectsUsingBlock:^(NSMutableData *layerData, NSUInteger idx, BOOL *stop) {
        [layerData setLength:size.width * size.height];
    }];
}

- (void)setTilesheetPath:(NSString *)tilesheetPath {
    if ([_tilesheetPath isEqualToString:tilesheetPath]) {
        return;
    }
    
    _tilesheetPath = tilesheetPath;
    self.tilesheet = nil;
}

- (CMPTilesheet *)tilesheet {
    if (!_tilesheet) {
        if (self.tilesheetPath) {
            NSString *tilesheetPath;
            
            if ([self.tilesheetPath hasPrefix:[[NSBundle mainBundle] resourcePath]]) {
                tilesheetPath = self.tilesheetPath;
            }
            else {
                tilesheetPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.tilesheetPath];
            }
            
            _tilesheet = [[CMPTilesheet alloc] initWithPath:tilesheetPath];
        }
        else {
            _tilesheet = [[CMPTilesheet alloc] init];
        }
    }
    
    return _tilesheet;
}

#pragma mark - Layers API

- (void)addLayer:(NSData *)layerData {
    [self.mutableLayers addObject:[layerData mutableCopy]];
}

- (void)addEmptyLayer {
    [self.mutableLayers addObject:[[NSMutableData alloc] initWithCapacity:self.size.width * self.size.height]];
}

- (void)removeLayerAtIndex:(NSUInteger)layerIndex {
    [self.mutableLayers removeObjectAtIndex:layerIndex];
}

@end
