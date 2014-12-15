//
//  CMPLevelIconView.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPLevelIconView.h"
#import "CMPMap.h"

#import "CMPMapThumbnailManager.h"

@interface CMPLevelIconView ()

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UILabel *fileNameLabel;

@end

@implementation CMPLevelIconView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpImageView];
        [self setUpFileNameLabel];
    }
    return self;
}

- (void)setUpImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageView];
    
    NSDictionary *views = @{ @"imageView": self.imageView };
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:100.0]]; // TODO: Turn this into a constant.
}

- (void)setUpFileNameLabel {
    self.fileNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fileNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.fileNameLabel];
    
    NSDictionary *views = @{ @"fileNameLabel": self.fileNameLabel };
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fileNameLabel]|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fileNameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.imageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fileNameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.0]];
}

- (void)setMap:(CMPMap *)map {
    _map = map;
    
    self.fileNameLabel.text = map.filename;
    
    [[CMPMapThumbnailManager sharedManager] thumbnailForMap:map context:map completion:^(UIImage *image, id context) {
        if (context != self.map) {
            return;
        }
        
        self.imageView.image = image;
    }];
}

@end
