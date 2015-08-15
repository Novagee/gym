//
//  ApplyEventRequest.h
//  JianYue
//
//  Created by Tangdixi on 14/8/15.
//  Copyright (c) 2015 Nishit Shah. All rights reserved.
//

#import "TCHRequest.h"

@interface ApplyEventRequest : TCHRequest

- (instancetype)initWithUDID:(NSString *)udid mobile:(NSString *)mobile withEventIndex:(NSNumber *)index;

@end
