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

- (BOOL)readFromURL:(NSURL *)url error:(NSError *__autoreleasing *)outError {
    NSData *mapData = [[NSData alloc] initWithContentsOfURL:url options:0 error:outError];
    if (!mapData) {
        return NO;
    }
    
    CMPMapParser *parser = [[CMPMapParser alloc] initWithData:mapData];
    
    NSError *parseError;
    if (![parser parseIntoMap:self error:&parseError]) {
        if (outError) {
            *outError = parseError;
        }
        
        return NO;
    }
    
    if (outError) {
        *outError = nil;
    }
    
    return YES;
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
        NSAssert(self.tilesheetPath, @"Missing required tilesheet path.");
        
        _tilesheet = [[CMPTilesheet alloc] initWithPath:self.tilesheetPath];
    }
    
    return _tilesheet;
}

@end
