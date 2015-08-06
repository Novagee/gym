//
//  NSString+HandleNull.m
//  Ties
//
//  Created by Viral Sonawala on 07/04/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import "NSString+HandleNull.h"

@implementation NSString (HandleNull)

+ (NSString*)performHandleNUll:(id)obj placeHolder:(NSString *)strPlaceHolder
{
    if ([obj isKindOfClass:[NSNull class]] || !obj || [obj isEqualToString:@""])
        return strPlaceHolder;
    else
        return obj;
}

@end
