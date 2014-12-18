//
//  CMPMapEditorScrollView.m
//  Compass
//
//  Created by Grant Butler on 12/15/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapEditorScrollView.h"

#import "CMPMapView.h"

@interface CMPMapEditorScrollView () <UIScrollViewDelegate>

@property (nonatomic, readwrite) CMPMapView *mapView;

@end

@implementation CMPMapEditorScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        [self setUpMapView];
        
        _mode = CMPMapEditorScrollViewModeScroll;
    }
    return self;
}

- (void)setUpMapView {
    self.mapView = [[CMPMapView alloc] initWithMapSize:CGSizeMake(1, 1) tilesheet:nil];
    self.mapView.editing = NO;
    [self addSubview:self.mapView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.mapView sizeToFit];
    
    [self updateContentSizeWithScale:self.zoomScale];
    [self centerMapView];
}

- (void)updateContentSizeWithScale:(CGFloat)scale {
    CGFloat contentWidth = MAX(CGRectGetWidth(self.frame), CGRectGetWidth(self.mapView.frame));
    CGFloat contentHeight = MAX(CGRectGetHeight(self.frame), CGRectGetHeight(self.mapView.frame));
    
    self.contentSize = CGSizeMake(contentWidth * scale, contentHeight * scale);
}

- (void)centerMapView {
    CGPoint center = CGPointZero;
    center.x = roundf(self.contentSize.width / 2.0);
    center.y = roundf(self.contentSize.height / 2.0);
    self.mapView.center = center;
}

#pragma mark - Accessors

- (void)setMode:(CMPMapEditorScrollViewMode)mode {
    _mode = mode;
    
    if (mode == CMPMapEditorScrollViewModeScroll) {
        self.mapView.editing = NO;
        self.panGestureRecognizer.enabled = YES;
    }
    else if (mode == CMPMapEditorScrollViewModeDraw) {
        self.mapView.editing = YES;
        self.panGestureRecognizer.enabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return self.mapView;
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    [self updateContentSizeWithScale:scale];
//    
//    CGRect oldMapViewFrame = self.mapView.frame;
//    
//    [self centerMapView];
//    
//    CGRect newMapViewFrame = self.mapView.frame;
//    
//    CGFloat xDelta = CGRectGetMinX(newMapViewFrame) - CGRectGetMinX(oldMapViewFrame);
//    CGFloat yDelta = CGRectGetMinY(newMapViewFrame) - CGRectGetMinY(oldMapViewFrame);
//    
//    CGPoint contentOffset = self.contentOffset;
//    contentOffset.x += xDelta;
//    contentOffset.y += yDelta;
//    self.contentOffset = contentOffset;
//}

@end
