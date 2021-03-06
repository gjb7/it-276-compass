//
//  CMPMapParser.h
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import Foundation;

@class CMPMap;
@class CMPDataReader;

extern NSString * const CMPMapParserErrorDomain;

enum {
    CMPMapParserErrorCodeInvalidSyntax = 1,
    CMPMapParserErrorCodeUnknownVersion = 2,
    CMPMapParserErrorCodeValueAlreadyParsed = 3,
};

@interface CMPMapParser : NSObject

@property (nonatomic, readonly) CMPDataReader *dataReader;

- (instancetype)initWithData:(NSData *)data;

- (BOOL)parseIntoMap:(CMPMap *)map error:(NSError **)error;

@end
