//
//  CMPMapThumbnailManager.h
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;

@class CMPMap;

typedef void(^CMPMapThumbnailManagerCompletionBlock)(UIImage *image, id context);

@interface CMPMapThumbnailManager : NSObject

+ (instancetype)sharedManager;

- (instancetype)initWithCacheURL:(NSURL *)cacheURL NS_DESIGNATED_INITIALIZER;

- (void)thumbnailForMap:(CMPMap *)map context:(id)context completion:(CMPMapThumbnailManagerCompletionBlock)completion;

@end
