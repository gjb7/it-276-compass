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

- (CGSize)sizeThatFits:(CGSize)size {
    return self.intrinsicContentSize;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.mapSize.width * CMPTilesheetTileSize.width, self.mapSize.height * CMPTilesheetTileSize.height);
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isEditing) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint locationInView = [touch locationInView:self];
    CGPoint calculatedLocation = CGPointMake(floor(locationInView.x / CMPTilesheetTileSize.width), floor(locationInView.y / CMPTilesheetTileSize.height));
    
    __block CMPLayerView *layerView;
    [self.layerViews enumerateObjectsUsingBlock:^(CMPLayerView *aLayerView, NSUInteger idx, BOOL *stop) {
        if (aLayerView.isActive) {
            layerView = aLayerView;
            
            *stop = YES;
        }
    }];
    
    if (!layerView) {
        return;
    }
    
    [self.delegate mapView:self didTouchTileAtPoint:calculatedLocation inLayerView:layerView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isEditing) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint locationInView = [touch locationInView:self];
    CGPoint previousLocationInView = [touch previousLocationInView:self];
    
    CGPoint calculatedLocation = CGPointMake(floor(locationInView.x / CMPTilesheetTileSize.width), floor(locationInView.y / CMPTilesheetTileSize.height));
    CGPoint calculatedPreviousLocation = CGPointMake(floor(previousLocationInView.x / CMPTilesheetTileSize.width), floor(previousLocationInView.y / CMPTilesheetTileSize.height));
    
    if (CGPointEqualToPoint(calculatedLocation, calculatedPreviousLocation)) {
        return;
    }
    
    if (calculatedLocation.x < 0 || calculatedLocation.y < 0 || calculatedLocation.x >= self.mapSize.width || calculatedLocation.y >= self.mapSize.height) {
        return;
    }
    
    __block CMPLayerView *layerView;
    [self.layerViews enumerateObjectsUsingBlock:^(CMPLayerView *aLayerView, NSUInteger idx, BOOL *stop) {
        if (aLayerView.isActive) {
            layerView = aLayerView;
            
            *stop = YES;
        }
    }];
    
    if (!layerView) {
        return;
    }
    
    [self.delegate mapView:self didTouchTileAtPoint:calculatedLocation inLayerView:layerView];
}

#pragma mark - Accessors

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
    
    [self setNeedsLayout];
}

- (void)setLayers:(NSArray *)layers {
    BOOL hasActiveLayerView = self.layerViews.count > 0;
    
    if (layers.count > self.layerViews.count) {
        for (NSUInteger i = self.layerViews.count; i < layers.count; i++) {
            CMPLayerView *layerView = [self createNewLayerView];
            [self.layerViews addObject:layerView];
        }
    }
    else if (layers.count < self.layerViews.count) {
        for (NSUInteger i = self.layerViews.count; i > layers.count; i--) {
            CMPLayerView *layerView = [self.layerViews lastObject];
            
            if (layerView.isActive) {
                hasActiveLayerView = NO;
            }
            
            [layerView removeFromSuperview];
            [self.layerViews removeLastObject];
        }
    }
    
    [self.layerViews enumerateObjectsUsingBlock:^(CMPLayerView *layerView, NSUInteger idx, BOOL *stop) {
        layerView.layerData = layers[idx];
    }];
    
    if (!hasActiveLayerView) {
        CMPLayerView *topLayer = self.layerViews.lastObject;
        topLayer.active = YES;
    }
}

- (NSArray *)layers {
    return [self.layerViews valueForKey:NSStringFromSelector(@selector(layerData))];
}

#pragma mark - 

- (CMPLayerView *)createNewLayerView {
    CMPLayerView *layerView = [[CMPLayerView alloc] initWithLayerSize:self.mapSize tilesheet:self.tilesheet];
    layerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:layerView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(layerView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[layerView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[layerView]|" options:0 metrics:nil views:views]];
    
    return layerView;
}

- (void)deleteLayerAtIndex:(NSUInteger)layerIndex {
    CMPLayerView *layerView = self.layerViews[layerIndex];
    [self.layerViews removeObjectAtIndex:layerIndex];
    [layerView removeFromSuperview];
}

- (void)insertLayerAtIndex:(NSUInteger)layerIndex withData:(NSData *)data {
    CMPLayerView *layerView = [self createNewLayerView];
    [self.layerViews insertObject:layerView atIndex:layerIndex];
    layerView.layerData = data;
}

- (void)activateLayerAtIndex:(NSUInteger)layerIndex {
    __block CMPLayerView *activeLayerView;
    [self.layerViews enumerateObjectsUsingBlock:^(CMPLayerView *aLayerView, NSUInteger idx, BOOL *stop) {
        if (aLayerView.isActive) {
            activeLayerView = aLayerView;
            
            *stop = YES;
        }
    }];
    
    activeLayerView.active = NO;
    
    CMPLayerView *layerView = self.layerViews[layerIndex];
    layerView.active = YES;
}

#pragma mark - CMPLayerViewDelegate

- (void)layerView:(CMPLayerView *)layerView didTouchTileAtPoint:(CGPoint)point {
    if (!layerView.isActive) {
        return;
    }
    
    [self.delegate mapView:self didTouchTileAtPoint:point inLayerView:layerView];
}

@end
