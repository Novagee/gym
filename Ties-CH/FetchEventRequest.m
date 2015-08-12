//
//  FetchEventRequest.m
//  JianYue
//
//  Created by Tangdixi on 12/8/15.
//  Copyright (c) 2015 Nishit Shah. All rights reserved.
//

#import "FetchEventRequest.h"

@interface FetchEventRequest ()

@property (assign, nonatomic) NSUInteger index;

@end

@implementation FetchEventRequest

- (instancetype)initWithEventIndex:(NSUInteger)index {
    
    if (self = [super init]) {
        
        _index = index;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    NSLog(@"%@", [super requestUrl]);
    
    return [super requestUrl];
    
}

@end
