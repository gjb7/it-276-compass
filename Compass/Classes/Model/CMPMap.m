//
//  CMPMap.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMap.h"
#import "CMPMapParser.h"

#import "CMPTilesheet.h"

@interface CMPMap ()

@property (nonatomic, readwrite) CMPTilesheet *tilesheet;

@end

@implementation CMPMap

+ (instancetype)mapWithContentsOfURL:(NSURL *)url {
    CMPMap *map = [[CMPMap alloc] init];
    
    NSData *mapData = [[NSData alloc] initWithContentsOfURL:url options:0 error:nil];
    if (!mapData) {
        return nil;
    }
    
    CMPMapParser *parser = [[CMPMapParser alloc] initWithData:mapData];
    
    if (![parser parseIntoMap:map error:nil]) {
        return nil;
    }
    
    return map;
}

- (NSMutableArray *)layers {
    if (!_layers) {
        _layers = [[NSMutableArray alloc] init];
    }
    return _layers;
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
            _tilesheet = [[CMPTilesheet alloc] initWithPath:self.tilesheetPath];
        }
        else {
            _tilesheet = [[CMPTilesheet alloc] init];
        }
    }
    
    return _tilesheet;
}

@end
