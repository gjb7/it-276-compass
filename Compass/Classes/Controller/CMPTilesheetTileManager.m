//
//  CMPTilesheetTileManager.m
//  Compass
//
//  Created by Grant Butler on 12/16/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPTilesheetTileManager.h"

#import "CMPTilesheet.h"

#import "NSString+CMPAdditions.h"
#import "UIImage+CMPAdditions.h"
#import "UIImage+Tint.h"

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
        cacheDirectoryURL = [[cacheURLs firstObject] URLByAppendingPathComponent:CMPTilesheetTileManagerDirectoryName isDirectory:YES];
    });
    
    return cacheDirectoryURL;
}

- (instancetype)initWithTilesheet:(CMPTilesheet *)tilesheet {
    self = [super init];
    if (self) {
        _tilesheet = tilesheet;
        
        
        NSString *tilesheetNameKey = [tilesheet.path MD5Hash];
        _tileCacheURL = [[[self class] cacheDirectoryURL] URLByAppendingPathComponent:tilesheetNameKey isDirectory:YES];
        
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtURL:_tileCacheURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Error creating directories for cache: %@", error);
        }
        
        _tileCache = [[NSCache alloc] init];
    }
    
    return self;
}

- (NSString *)cacheKeyForTileIndex:(NSUInteger)tileIndex isActive:(BOOL)active {
    NSString *activeString = active ? @"_active" : @"";
    NSString *key = [NSString stringWithFormat:@"%li%@", (unsigned long)tileIndex, activeString];
    return [key MD5Hash];
}

- (UIImage *)tileAtIndex:(NSUInteger)tileIndex isActive:(BOOL)active {
    NSString *key = [self cacheKeyForTileIndex:tileIndex isActive:active];
    UIImage *tile = [self.tileCache objectForKey:key];
    if (tile) {
        return tile;
    }
    
    NSURL *tileURL = [self.tileCacheURL URLByAppendingPathComponent:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tileURL.path]) {
        tile = [UIImage imageWithContentsOfFile:tileURL.path];
        [self.tileCache setObject:tile forKey:key];
        
        return tile;
    }
    
    NSUInteger columnCount = self.tilesheet.numberOfColumns;
    CGFloat x = (tileIndex % columnCount) * CMPTilesheetTileSize.width;
    CGFloat y = floor(tileIndex / columnCount) * CMPTilesheetTileSize.height;
    
    tile = [self.tilesheet.sprite imageWithRect:CGRectMake(x, y, CMPTilesheetTileSize.width, CMPTilesheetTileSize.height)];
    if (!active) {
        tile = [tile imageTintedWithColor:[UIColor blackColor] fraction:0.75];
    }
    
    NSData *pngData = UIImagePNGRepresentation(tile);
    NSError *error;
    if (![pngData writeToURL:tileURL options:NSDataWritingAtomic error:&error]) {
        NSLog(@"Error saving thumbnail: %@", error);
    }
    
    [self.tileCache setObject:tile forKey:key];
    
    return tile;
}

@end
