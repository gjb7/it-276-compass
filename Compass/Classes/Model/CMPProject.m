//
//  CMPProject.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPProject.h"
#import "CMPMap.h"

static NSString * const CMPProjectMapsDirectoryName = @"maps";

@interface CMPProject ()

@end

@implementation CMPProject

- (NSMutableArray *)maps {
    if (!_maps) {
        _maps = [[NSMutableArray alloc] init];
    }
    return _maps;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSFileWrapper *fileWrapper = (NSFileWrapper *)contents;
    
    [self loadMapMetadataFromFileWrapper:fileWrapper];
    
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
//    return self.fileWrapper;
    return nil;
}

- (void)loadMapMetadataFromFileWrapper:(NSFileWrapper *)fileWrapper {
    NSFileWrapper *mapDirectoryFileWrapper = fileWrapper.fileWrappers[CMPProjectMapsDirectoryName];
    
    [self.maps removeAllObjects];
    
    [mapDirectoryFileWrapper.fileWrappers enumerateKeysAndObjectsUsingBlock:^(NSString *fileName, NSFileWrapper *fileWrapper, BOOL *stop) {
        [self.maps addObject:[[CMPMap alloc] initWithFileURL:[self.fileURL URLByAppendingPathComponent:fileWrapper.filename]]];
    }];
}

@end
