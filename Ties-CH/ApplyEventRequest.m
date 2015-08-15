//
//  ApplyEventRequest.m
//  JianYue
//
//  Created by Tangdixi on 14/8/15.
//  Copyright (c) 2015 Nishit Shah. All rights reserved.
//

#import "ApplyEventRequest.h"

@interface ApplyEventRequest ()

@property (strong, nonatomic) NSString *udid;
@property (strong, nonatomic) NSString *mobile;
@property (assign, nonatomic) NSString *index;
@end

@implementation ApplyEventRequest

- (instancetype)initWithUDID:(NSString *)udid mobile:(NSString *)mobile withEventIndex:(NSString *)index {
    
    if (self = [super init]) {
        
        _udid = udid;
        _mobile = mobile;
        _index = index;
        
    }
    return self;
}

- (NSString *)requestUrl {
    
    return [NSString stringWithFormat:@"/event/%@/apply?uuid=%@&mobile=%@", self.index, self.udid, self.mobile];

}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPost;
    
}

@end
