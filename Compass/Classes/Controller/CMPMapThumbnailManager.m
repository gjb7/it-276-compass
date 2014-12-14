//
//  CMPMapThumbnailManager.m
//  Compass
//
//  Created by Grant Butler on 12/14/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPMapThumbnailManager.h"
#import "CMPMap.h"

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

- (void)thumbnailForMap:(CMPMap *)map completion:(CMPMapThumbnailManagerCompletionBlock)completion {
    
}

@end
