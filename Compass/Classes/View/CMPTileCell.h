//
//  CMPTileCell.h
//  Compass
//
//  Created by Grant Butler on 12/11/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPTilesheet;

extern const CGFloat CMPTileCellSelectedBorderWidth;

@interface CMPTileCell : UICollectionViewCell

@property (nonatomic) uint8_t tileIndex;

@property (nonatomic) UIImageView *imageView;

- (void)setTileIndex:(uint8_t)tileIndex inTilesheet:(CMPTilesheet *)tilesheet;

@end
