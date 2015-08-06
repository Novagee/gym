//
//  TCHUtility.m
//  JianYue
//
//  Created by peng wan on 15/8/6.
//  Copyright (c) 2015年 Nishit Shah. All rights reserved.
//

#import "TCHUtility.h"

@implementation TCHUtility

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
