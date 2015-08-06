//
//  TCHCurrentLocationHelper.h
//  Ties-CH
//
//  Created by  on 6/5/14.
//  Copyright (c) 2014 Human Services Hub, Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^CurrentLocationCallBack)(CLLocation *currentLocation);
typedef void (^CurrentLocationError)(NSString *strCurrentLocationError);

@interface TCHCurrentLocationHelper : NSObject<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

- (id)init:(CurrentLocationCallBack)callbackBlock failure:(CurrentLocationError)error;
- (void)stopUpdatingLocation:(NSString *)state;

@end

