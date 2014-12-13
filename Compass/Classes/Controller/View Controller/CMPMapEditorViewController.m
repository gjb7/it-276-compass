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

@interface CMPMapEditorViewController () <CMPMapViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic) CMPMapView *mapView;

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
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    
    self.scrollView.delegate = self;
    self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 3;
    self.scrollView.panGestureRecognizer.maximumNumberOfTouches = 3;
    
    [self setUpMapView];
    [self configureMapViewWithMap:self.map];
}

- (void)setUpMapView {
    self.mapView = [[CMPMapView alloc] initWithMapSize:self.map.size tilesheet:self.map.tilesheet];
    self.mapView.editing = YES;
    self.mapView.delegate = self;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.mapView];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0]];
}

- (void)configureMapViewWithMap:(CMPMap *)map {
    self.mapView.tilesheet = map.tilesheet;
    self.mapView.mapSize = map.size;
    self.mapView.layers = map.layers;
    
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentOffset = CGPointZero;
    
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize mapViewContentSize = self.mapView.intrinsicContentSize;
    self.scrollView.contentSize = CGSizeMake(MAX(CGRectGetWidth(self.view.frame), mapViewContentSize.width), MAX(CGRectGetHeight(self.view.frame), mapViewContentSize.height));
}

- (void)setMap:(CMPMap *)map {
    if (_map == map) {
        return;
    }
    
    _map = map;
    
    [self configureMapViewWithMap:_map];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mapView;
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
