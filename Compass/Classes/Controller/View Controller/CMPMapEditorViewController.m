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

@interface CMPMapEditorViewController ()

@property (nonatomic, readwrite) CMPMap *map;

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
    
    self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.scrollView.panGestureRecognizer.maximumNumberOfTouches = 2;
    
    [self setUpMapView];
}

- (void)setUpMapView {
    self.mapView = [[CMPMapView alloc] initWithMapSize:self.map.size tilesheet:self.map.tilesheet];
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
