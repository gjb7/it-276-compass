//
//  CMPMapParser.h
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import Foundation;

@class CMPMap;

@interface CMPMapParser : NSObject

@property (nonatomic, readonly) NSData *data;

- (instancetype)initWithData:(NSData *)data;

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError **)error;

@end
