//
//  CMPMapEditorViewController.m
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapEditorViewController.h"

#import "CMPMap.h"

#import "CMPMapView.h"
#import "CMPLayerView.h"
#import "CMPMapEditorScrollView.h"

@interface CMPMapEditorViewController () <CMPMapViewDelegate, UIScrollViewDelegate>

@property (nonatomic) CMPMapEditorScrollView *scrollView;

@property (nonatomic, readonly) CMPMapView *mapView;

@end

@implementation CMPMapEditorViewController

- (instancetype)initWithMap:(CMPMap *)map {
    self = [super init];
    if (self) {
        _map = map;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpEditorScrollView];
    [self configureMapViewWithMap:self.map];
}

- (void)setUpEditorScrollView {
    self.scrollView = [[CMPMapEditorScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.mapView.delegate = self;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    NSDictionary *views = @{ @"scrollView": self.scrollView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
}

- (void)configureMapViewWithMap:(CMPMap *)map {
    self.mapView.tilesheet = map.tilesheet;
    self.mapView.mapSize = map.size;
    self.mapView.layers = map.layers;
    
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentOffset = CGPointZero;
    
    [self.view setNeedsLayout];
    [self.scrollView setNeedsLayout];
}

#pragma mark - Accessors

- (void)setMap:(CMPMap *)map {
    if (_map == map) {
        return;
    }
    
    _map = map;
    
    [self configureMapViewWithMap:_map];
}

- (CMPMapView *)mapView {
    return self.scrollView.mapView;
}

- (void)setMode:(CMPMapEditorScrollViewMode)mode {
    self.scrollView.mode = mode;
}

- (CMPMapEditorScrollViewMode)mode {
    return self.scrollView.mode;
}

#pragma mark - Public API

- (void)deleteLayerAtIndex:(NSUInteger)layerIndex {
    [self.mapView deleteLayerAtIndex:layerIndex];
}

- (void)insertLayerAtIndex:(NSUInteger)layerIndex withData:(NSData *)data {
    [self.mapView insertLayerAtIndex:layerIndex withData:data];
}

- (void)activateLayerAtIndex:(NSUInteger)layerIndex {
    [self.mapView activateLayerAtIndex:layerIndex];
}

#pragma mark - CMPMapViewDelegate

- (void)mapView:(CMPMapView *)mapView didTouchTileAtPoint:(CGPoint)point inLayerView:(CMPLayerView *)layerView {
    NSUInteger tileIndex = point.x + (point.y * self.map.size.height);
    
    [layerView setTile:self.selectedTileIndex atIndex:tileIndex];
    
    self.map.layers = [mapView.layers mutableCopy];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
