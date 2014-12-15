//
//  CMPMapThumbnailManager.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapThumbnailManager.h"

#import "CMPMap.h"
#import "CMPTilesheet.h"

#import "CMPRendering.h"

#import "NSString+CMPAdditions.h"

static NSString * const CMPMapThumbnailManagerDirectoryName = @"CMPMapThumbnails";

@interface CMPMapThumbnailManager ()

@property (nonatomic) NSURL *cacheURL;

@end

@implementation CMPMapThumbnailManager

+ (instancetype)sharedManager {
    static CMPMapThumbnailManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CMPMapThumbnailManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    NSArray *cacheURLs = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *cacheURL = [cacheURLs firstObject];
    
    return [self initWithCacheURL:cacheURL];
}

- (instancetype)initWithCacheURL:(NSURL *)cacheURL {
    self = [super init];
    if (self) {
        _cacheURL = [cacheURL URLByAppendingPathComponent:CMPMapThumbnailManagerDirectoryName isDirectory:YES];
    }
    return self;
}

- (NSString *)cachedThumbnailPathForMap:(CMPMap *)map {
    NSString *mapFileName = map.filename;
    NSString *cacheKey = [mapFileName MD5Hash];
    return [self.cacheURL URLByAppendingPathComponent:cacheKey].path;
}

- (void)thumbnailForMap:(CMPMap *)map context:(id)context completion:(CMPMapThumbnailManagerCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cacheThumbnailPath = [self cachedThumbnailPathForMap:map];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cacheThumbnailPath]) {
            UIImage *thumbnail = [[UIImage alloc] initWithContentsOfFile:cacheThumbnailPath];
            if (thumbnail) {
                completion(thumbnail, context);
                
                return;
            }
            else {
                [[NSFileManager defaultManager] removeItemAtPath:cacheThumbnailPath error:nil];
            }
        }
        
        CGSize imageSize = CGSizeMake(map.size.width * CMPTilesheetTileSize.width, map.size.height * CMPTilesheetTileSize.height);
        UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1.0);
        
        CMPRenderMap(map.layers, map.tilesheet, map.size);
        
        UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *thumbnailData = UIImagePNGRepresentation(thumbnail);
        [thumbnailData writeToFile:cacheThumbnailPath atomically:YES];
        
        completion(thumbnail, context);
    });
}

@end
