//
//  FetchEventRequest.m
//  JianYue
//
//  Created by Tangdixi on 12/8/15.
//  Copyright (c) 2015 Nishit Shah. All rights reserved.
//

#import "FetchEventRequest.h"

@interface FetchEventRequest ()

@property (strong, nonatomic) NSString *index;

@end

@implementation FetchEventRequest

- (instancetype)initWithEventIndex:(NSString *)index {
    
    if (self = [super init]) {
        
        _index = index;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    if (self.index) {
        return [NSString stringWithFormat:@"/event/%@", self.index];
    }
    
    return @"/event/";
    
}

@end
