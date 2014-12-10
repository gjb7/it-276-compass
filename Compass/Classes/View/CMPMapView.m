//
//  CMPMapView.m
//  Compass
//
//  Created by Grant Butler on 12/9/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapView.h"
#import "CMPTilesheet.h"
#import "CMPLayerView.h"

@interface CMPMapView ()

@property (nonatomic) NSMutableArray *layerViews;

@end

@implementation CMPMapView

- (instancetype)initWithMapSize:(CGSize)mapSize tilesheet:(CMPTilesheet *)tilesheet {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, mapSize.width * CMPTilesheetTileSize.width, mapSize.height * CMPTilesheetTileSize.height)];
    if (self) {
        _mapSize = mapSize;
        _tilesheet = tilesheet;
        
        _layerViews = [NSMutableArray array];
    }
    return self;
}

- (void)setTilesheet:(CMPTilesheet *)tilesheet {
    _tilesheet = tilesheet;
    
    [self.layerViews enumerateObjectsUsingBlock:^(CMPLayerView *layerView, NSUInteger idx, BOOL *stop) {
        layerView.tilesheet = tilesheet;
    }];
}

- (void)setMapSize:(CGSize)mapSize {
    _mapSize = mapSize;
    
    [self.layerViews enumerateObjectsUsingBlock:^(CMPLayerView *layerView, NSUInteger idx, BOOL *stop) {
        layerView.layerSize = mapSize;
    }];
}

- (void)setLayers:(NSArray *)layers {
    if (layers.count > _layers.count) {
        for (NSUInteger i = _layers.count; i < layers.count; i++) {
            CMPLayerView *layerView = [[CMPLayerView alloc] initWithLayerSize:self.mapSize tilesheet:self.tilesheet];
            [self addSubview:layerView];
            [self.layerViews addObject:layerView];
        }
    }
    else if (layers.count < _layers.count) {
        for (NSUInteger i = _layerViews.count; i > layers.count; i--) {
            CMPLayerView *layerView = [self.layerViews lastObject];
            [layerView removeFromSuperview];
            [self.layerViews removeLastObject];
        }
    }
    
    _layers = layers;
    
    [self.layerViews enumerateObjectsUsingBlock:^(CMPLayerView *layerView, NSUInteger idx, BOOL *stop) {
        layerView.layerData = _layers[idx];
    }];
}

@end
