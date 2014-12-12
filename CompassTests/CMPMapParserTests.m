//
//  CMPMapParserTests.m
//  Compass
//
//  Created by Grant Butler on 12/5/14.
//  Copyright (c) 2014 Grant Butler. All rights reserved.
//

@import UIKit;
@import XCTest;

#import "CMPMap.h"
#import "CMPMapParser.h"

@interface CMPMapParserTests : XCTestCase

@end

@implementation CMPMapParserTests

- (void)testValidV1MapParsing {
    char valid_map[] = {
        0x56, 0x01, 0x3B, 0x57, 0x0A, 0x3B, 0x48, 0x0A, 0x3B, 0x4C, 0x01, 0x3B, 0x54, 0x72, 0x65, 0x73, 0x2F, 0x74, 0x69, 0x6C, 0x65, 0x73, 0x68, 0x65, 0x65, 0x74, 0x73, 0x2F, 0x6F, 0x76, 0x65, 0x72, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x2E, 0x79, 0x61, 0x6D, 0x6C, 0x3B, 0x6C, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x3B
    };
    
    CMPMap *map = [[CMPMap alloc] init];
    CMPMapParser *mapParser = [[CMPMapParser alloc] initWithData:[NSData dataWithBytes:valid_map length:sizeof(valid_map)]];
    
    NSError *parseError;
    BOOL result = [mapParser parseIntoMap:map error:&parseError];
    
    XCTAssertTrue(result);
    XCTAssertNil(parseError);
}

- (void)testInvalidGameMapVersion {
    char invalid_map[] = {
        0x56, 0x10, 0x3B, 0x57, 0x0A, 0x3B, 0x48, 0x0A, 0x3B, 0x4C, 0x01, 0x3B, 0x54, 0x72, 0x65, 0x73, 0x2F, 0x74, 0x69, 0x6C, 0x65, 0x6D, 0x61, 0x70, 0x73, 0x2F, 0x6F, 0x76, 0x65, 0x72, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x2E, 0x70, 0x6E, 0x67, 0x3B, 0x6C, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x3B
    };
    
    CMPMap *map = [[CMPMap alloc] init];
    CMPMapParser *mapParser = [[CMPMapParser alloc] initWithData:[NSData dataWithBytes:invalid_map length:sizeof(invalid_map)]];
    
    NSError *parseError;
    BOOL result = [mapParser parseIntoMap:map error:&parseError];
    
    XCTAssertFalse(result);
    XCTAssertNotNil(parseError);
    XCTAssertEqualObjects(parseError.domain, CMPMapParserErrorDomain);
    XCTAssertEqual(parseError.code, CMPMapParserErrorCodeUnknownVersion);
}

#pragma mark - V1 Game Map Tests

- (void)testInvalidV1GameMapSizeTooLarge {
    char invalid_map[] = {
        0x56, 0x01, 0x3B, 0x57, 0x10, 0x3B, 0x48, 0x10, 0x3B, 0x4C, 0x01, 0x3B, 0x54, 0x72, 0x65, 0x73, 0x2F, 0x74, 0x69, 0x6C, 0x65, 0x6D, 0x61, 0x70, 0x73, 0x2F, 0x6F, 0x76, 0x65, 0x72, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x2E, 0x70, 0x6E, 0x67, 0x3B, 0x6C, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x3B
    };
    
    CMPMap *map = [[CMPMap alloc] init];
    CMPMapParser *mapParser = [[CMPMapParser alloc] initWithData:[NSData dataWithBytes:invalid_map length:sizeof(invalid_map)]];
    
    NSError *parseError;
    BOOL result = [mapParser parseIntoMap:map error:&parseError];
    
    XCTAssertFalse(result);
    XCTAssertNotNil(parseError);
    XCTAssertEqualObjects(parseError.domain, CMPMapParserErrorDomain);
    XCTAssertEqual(parseError.code, CMPMapParserErrorCodeNotEnoughBytes);
}

- (void)testInvalidV1GameMapSizeTooSmall {
    char invalid_map[] = {
        0x56, 0x01, 0x3B, 0x57, 0x01, 0x3B, 0x48, 0x01, 0x3B, 0x4C, 0x01, 0x3B, 0x54, 0x72, 0x65, 0x73, 0x2F, 0x74, 0x69, 0x6C, 0x65, 0x6D, 0x61, 0x70, 0x73, 0x2F, 0x6F, 0x76, 0x65, 0x72, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x2E, 0x70, 0x6E, 0x67, 0x3B, 0x6C, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x3B
    };
    
    CMPMap *map = [[CMPMap alloc] init];
    CMPMapParser *mapParser = [[CMPMapParser alloc] initWithData:[NSData dataWithBytes:invalid_map length:sizeof(invalid_map)]];
    
    NSError *parseError;
    BOOL result = [mapParser parseIntoMap:map error:&parseError];
    
    XCTAssertFalse(result);
    XCTAssertNotNil(parseError);
    XCTAssertEqualObjects(parseError.domain, CMPMapParserErrorDomain);
    XCTAssertEqual(parseError.code, CMPMapParserErrorCodeInvalidSyntax);
}

- (void)testInvalidV1GameMapNoTilemapFilename {
    char invalid_map[] = {
        0x56, 0x01, 0x3B, 0x57, 0x0A, 0x3B, 0x48, 0x0A, 0x3B, 0x4C, 0x01, 0x3B, 0x6C, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x3B
    };
    
    CMPMap *map = [[CMPMap alloc] init];
    CMPMapParser *mapParser = [[CMPMapParser alloc] initWithData:[NSData dataWithBytes:invalid_map length:sizeof(invalid_map)]];
    
    NSError *parseError;
    BOOL result = [mapParser parseIntoMap:map error:&parseError];
    
    XCTAssertFalse(result);
    XCTAssertNotNil(parseError);
    XCTAssertEqualObjects(parseError.domain, CMPMapParserErrorDomain);
    XCTAssertEqual(parseError.code, CMPMapParserErrorCodeInvalidSyntax);
}

- (void)testInvalidV1GameMapTooFewLayers {
    char invalid_map[] = {
        0x56, 0x01, 0x3B, 0x57, 0x10, 0x3B, 0x48, 0x10, 0x3B, 0x4C, 0x01, 0x3B, 0x54, 0x72, 0x65, 0x73, 0x2F, 0x74, 0x69, 0x6C, 0x65, 0x6D, 0x61, 0x70, 0x73, 0x2F, 0x6F, 0x76, 0x65, 0x72, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x2E, 0x70, 0x6E, 0x67, 0x3B
    };
    
    CMPMap *map = [[CMPMap alloc] init];
    CMPMapParser *mapParser = [[CMPMapParser alloc] initWithData:[NSData dataWithBytes:invalid_map length:sizeof(invalid_map)]];
    
    NSError *parseError;
    BOOL result = [mapParser parseIntoMap:map error:&parseError];
    
    XCTAssertFalse(result);
    XCTAssertNotNil(parseError);
    XCTAssertEqualObjects(parseError.domain, CMPMapParserErrorDomain);
    XCTAssertEqual(parseError.code, CMPMapParserErrorCodeInvalidSyntax);
}

- (void)testInvalidV1GameMapNoLayers {
    char invalid_map[] = {
        0x56, 0x01, 0x3B, 0x57, 0x10, 0x3B, 0x48, 0x10, 0x3B, 0x4C, 0x00, 0x3B, 0x54, 0x72, 0x65, 0x73, 0x2F, 0x74, 0x69, 0x6C, 0x65, 0x6D, 0x61, 0x70, 0x73, 0x2F, 0x6F, 0x76, 0x65, 0x72, 0x77, 0x6F, 0x72, 0x6C, 0x64, 0x2E, 0x70, 0x6E, 0x67, 0x3B
    };
    
    CMPMap *map = [[CMPMap alloc] init];
    CMPMapParser *mapParser = [[CMPMapParser alloc] initWithData:[NSData dataWithBytes:invalid_map length:sizeof(invalid_map)]];
    
    NSError *parseError;
    BOOL result = [mapParser parseIntoMap:map error:&parseError];
    
    XCTAssertFalse(result);
    XCTAssertNotNil(parseError);
    XCTAssertEqualObjects(parseError.domain, CMPMapParserErrorDomain);
    XCTAssertEqual(parseError.code, CMPMapParserErrorCodeInvalidSyntax);
}

@end
