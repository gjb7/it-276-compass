//
//  CMPMapEditorScrollView.h
//  Compass
//
//  Created by Grant Butler on 12/15/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPMapView;

typedef NS_ENUM(NSUInteger, CMPMapEditorScrollViewMode) {
    CMPMapEditorScrollViewModeScroll,
    CMPMapEditorScrollViewModeDraw,
};

@interface CMPMapEditorScrollView : UIScrollView

@property (nonatomic, readonly) CMPMapView *mapView;

@property (nonatomic) CMPMapEditorScrollViewMode mode;

@end
