//
//  CMPMapEditorViewController.m
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapEditorViewController.h"

#import "CMPMap.h"
#import "CMPTilesheet.h"

#import "CMPEditorTileManager.h"

#import "CMPTiledScrollView.h"
#import "CMPTiledLayer.h"

#import <JCTiledScrollView/JCTiledScrollView.h>
#import <JCTiledScrollView/JCTiledView.h>

@interface CMPMapEditorViewController () <JCTileSource, JCTiledScrollViewDelegate>

@property (nonatomic) CMPTiledScrollView *scrollView;

@property (nonatomic) CMPEditorTileManager *tileManager;

@property (nonatomic) NSUInteger activeLayerIndex;

@property (nonatomic) UIPanGestureRecognizer *drawPanGestureRecognizer;

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
    
    [self setUpEditorScrollViewWithMap:self.map];
}

- (void)setUpEditorScrollViewWithMap:(CMPMap *)map {
    CGSize mapSize = map.size;
    self.scrollView = [[CMPTiledScrollView alloc] initWithFrame:CGRectZero contentSize:CGSizeMake(mapSize.width * CMPTilesheetTileSize.width, mapSize.height * CMPTilesheetTileSize.height)];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.dataSource = self;
    self.scrollView.tiledScrollViewDelegate = self;
    [self.view addSubview:self.scrollView];
    
    NSDictionary *views = @{ @"scrollView": self.scrollView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    
    [self.view layoutIfNeeded];
    
    self.scrollView.scrollView.contentSize = self.scrollView.scrollView.frame.size;
    [self centerTiledViewInScrollView:self.scrollView];
    
    self.drawPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    [self.scrollView.tiledView addGestureRecognizer:self.drawPanGestureRecognizer];
    self.drawPanGestureRecognizer.enabled = NO;
}

- (void)centerTiledViewInScrollView:(JCTiledScrollView *)scrollView {
    CGFloat offsetX = MAX((scrollView.scrollView.bounds.size.width - scrollView.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.scrollView.bounds.size.height - scrollView.scrollView.contentSize.height) * 0.5, 0.0);
    
    scrollView.tiledView.center = CGPointMake(scrollView.scrollView.contentSize.width * 0.5 + offsetX,
                                              scrollView.scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - Accessors

- (void)setMap:(CMPMap *)map {
    if (_map == map) {
        return;
    }
    
    _map = map;
    
    self.tileManager = nil;
    
    if (self.isViewLoaded) {
        [self.scrollView removeFromSuperview];
        [self setUpEditorScrollViewWithMap:_map];
    }
}

- (CMPEditorTileManager *)tileManager {
    if (!_tileManager) {
        _tileManager = [[CMPEditorTileManager alloc] initWithTilesheet:self.map.tilesheet];
    }
    
    return _tileManager;
}

- (void)setScrollingEnabled:(BOOL)enabled {
    self.scrollView.scrollView.pinchGestureRecognizer.enabled = enabled;
    self.scrollView.scrollView.panGestureRecognizer.enabled = enabled;
    
    self.scrollView.zoomsInOnDoubleTap = enabled;
    self.scrollView.zoomsOutOnTwoFingerTap = enabled;
    self.scrollView.zoomsToTouchLocation = enabled;
    
    CATiledLayer *tiledLayer = (CATiledLayer *)self.scrollView.tiledView.layer;
    tiledLayer.drawsAsynchronously = enabled;
}

- (void)setMode:(CMPMapEditorViewControllerMode)mode {
    _mode = mode;
    
    switch (mode) {
        case CMPMapEditorViewControllerModeScroll:
            [self setScrollingEnabled:YES];
            
            [CMPTiledLayer setFadingInEnabled:YES];
            self.drawPanGestureRecognizer.enabled = NO;
            
            break;
            
        case CMPMapEditorViewControllerModeDraw:
            [self setScrollingEnabled:NO];
            
            [CMPTiledLayer setFadingInEnabled:NO];
            self.drawPanGestureRecognizer.enabled = YES;
            
            break;
    }
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint locationInView = [panGestureRecognizer locationInView:panGestureRecognizer.view];
    
    if (!CGRectContainsPoint(panGestureRecognizer.view.bounds, locationInView)) {
        return;
    }
    
    CGPoint calculatedLocation = CGPointMake(floor(locationInView.x / CMPTilesheetTileSize.width), floor(locationInView.y / CMPTilesheetTileSize.height));
    
    NSUInteger tileIndex = calculatedLocation.x + (calculatedLocation.y * self.map.size.height);
    NSMutableData *layerData = self.map.layers[self.activeLayerIndex];
    
    uint8_t tile = self.selectedTileIndex;
    NSUInteger size = sizeof(tile);
    [layerData replaceBytesInRange:NSMakeRange(tileIndex, size) withBytes:&tile length:size];
    
    CGRect redrawRect;
    redrawRect.origin.x = calculatedLocation.x * CMPTilesheetTileSize.width;
    redrawRect.origin.y = calculatedLocation.y * CMPTilesheetTileSize.height;
    redrawRect.size = CMPTilesheetTileSize;
    
    [self.scrollView.tiledView setNeedsDisplayInRect:redrawRect];
}

#pragma mark - Public API

- (void)deleteLayerAtIndex:(NSUInteger)layerIndex {
//    [self.mapView deleteLayerAtIndex:layerIndex];
}

- (void)insertLayerAtIndex:(NSUInteger)layerIndex withData:(NSData *)data {
//    [self.mapView insertLayerAtIndex:layerIndex withData:data];
}

- (void)activateLayerAtIndex:(NSUInteger)layerIndex {
    self.activeLayerIndex = layerIndex;
    
    [self.scrollView.tiledView setNeedsDisplay];
}

#pragma mark - JCTileSource

- (UIImage *)tiledScrollView:(JCTiledScrollView *)scrollView imageForRow:(NSInteger)row column:(NSInteger)column scale:(NSInteger)scale {
    CGSize tileSize = scrollView.tiledView.tileSize;
    CGRect tileRect = CGRectMake(column * tileSize.width, row * tileSize.height, tileSize.width, tileSize.height);
    
    return [self.tileManager tileForRect:tileRect scale:scale withMap:self.map activeLayerIndex:self.activeLayerIndex];
}

#pragma mark - JCTiledScrollViewDelegate

- (void)tiledScrollViewDidZoom:(JCTiledScrollView *)scrollView {
    [self centerTiledViewInScrollView:scrollView];
}

- (JCAnnotationView *)tiledScrollView:(JCTiledScrollView *)scrollView viewForAnnotation:(id<JCAnnotation>)annotation {
    return nil;
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
