//
//  CMPTilesheetTileManager.m
//  Compass
//
//  Created by Grant Butler on 12/16/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTilesheetTileManager.h"

#import "CMPTilesheet.h"

static NSString * const CMPTilesheetTileManagerDirectoryName = @"CMPTilesheetTileManager";

@interface CMPTilesheetTileManager ()

@property (nonatomic, readwrite) CMPTilesheet *tilesheet;

@property (nonatomic) NSURL *tileCacheURL;

@property (nonatomic) NSCache *tileCache;

@end

@implementation CMPTilesheetTileManager

+ (NSURL *)cacheDirectoryURL {
    static NSURL *cacheDirectoryURL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *cacheURLs = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        cacheDirectoryURL = [cacheURLs firstObject];
    });
    
    return cacheDirectoryURL;
}

- (instancetype)initWithTilesheet:(CMPTilesheet *)tilesheet {
    self = [super init];
    if (self) {
        _tileCacheURL = [[[self class] cacheDirectoryURL] URLByAppendingPathComponent:CMPTilesheetTileManagerDirectoryName isDirectory:YES];
        
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtURL:_tileCacheURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Error creating directories for cache: %@", error);
        }
        
        _tileCache = [[NSCache alloc] init];
    }
    
    return self;
}

@end
