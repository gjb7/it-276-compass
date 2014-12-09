//
//  CMPMapEditorViewController.h
//  Compass
//
//  Created by ACM Member on 12/8/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPMap;

@interface CMPMapEditorViewController : UIViewController

@property (nonatomic, readonly) CMPMap *map;

- (instancetype)initWithMap:(CMPMap *)map;

@end
