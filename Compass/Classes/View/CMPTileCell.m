//
//  CMPTileCell.m
//  Compass
//
//  Created by Grant Butler on 12/11/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTileCell.h"

#import "CMPTilesheet.h"

const CGFloat CMPTileCellSelectedBorderWidth = 2.0;

@implementation CMPTileCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpImageView];
    }
    return self;
}

- (void)setUpImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.layer.borderColor = [UIColor blueColor].CGColor;
    [self.contentView addSubview:self.imageView];
    
    NSDictionary *views = @{ @"imageView": self.imageView };
    NSDictionary *metrics = @{ @"spacing": @(CMPTileCellSelectedBorderWidth) };
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(spacing)-[imageView]-(spacing)-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(spacing)-[imageView]-(spacing)-|" options:0 metrics:metrics views:views]];
}

#pragma mark - UICollectionViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.layer.borderWidth = selected ? CMPTileCellSelectedBorderWidth : 0.0;
}

#pragma mark - CMPTileCell

- (void)setTileIndex:(uint8_t)tileIndex inTilesheet:(CMPTilesheet *)tilesheet {
    _tileIndex = tileIndex;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(CMPTilesheetTileSize, NO, 1.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        NSUInteger columnCount = tilesheet.numberOfColumns;
        CGRect fromRect = CGRectMake((tileIndex % columnCount) * CMPTilesheetTileSize.width, floor(tileIndex / columnCount) * CMPTilesheetTileSize.height, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height);
        CGRect drawRect = CGRectMake(0.0, 0.0, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height);
        
        CGImageRef drawImage = CGImageCreateWithImageInRect(tilesheet.sprite.CGImage, fromRect);
        if (drawImage != NULL) {
            // Push current graphics state so we can restore later
            CGContextSaveGState(context);
            
            // Take care of Y-axis inversion problem by translating the context on the y axis
            CGContextTranslateCTM(context, 0, drawRect.origin.y + fromRect.size.height);
            
            // Scaling -1.0 on y-axis to flip
            CGContextScaleCTM(context, 1.0, -1.0);
            
            // Then accommodate the translate by adjusting the draw rect
            drawRect.origin.y = 0.0f;
            
            // Draw the image
            CGContextDrawImage(context, drawRect, drawImage);
            
            // Clean up memory and restore previous state
            CGImageRelease(drawImage);
            
            // Restore previous graphics state to what it was before we tweaked it
            CGContextRestoreGState(context);
        }
        
        UIImage *tileImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = tileImage;
        });
    });
}

@end
