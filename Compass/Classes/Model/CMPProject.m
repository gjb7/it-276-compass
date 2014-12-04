//
//  CMPProject.m
//  Compass
//
//  Created by Grant Butler on 12/3/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

#import "CMPProject.h"

@interface CMPProject ()

@property (nonatomic) NSFileWrapper *fileWrapper;

@end

@implementation CMPProject

- (NSFileWrapper *)fileWrapper {
    if (!_fileWrapper) {
        _fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    return _fileWrapper;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    self.fileWrapper = (NSFileWrapper *)contents;
    
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    return self.fileWrapper;
}

@end
