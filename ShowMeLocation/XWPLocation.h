//
//  XWPLocation.h
//  GeoLocation
//
//  Created by Weipin Xia on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

enum {
  kXWPLocationErrorUnknown = 0,
  kXWPLocationErrorTimeout = 1,
};

extern NSString *const kXWPLocationErrorDomain;

extern NSString *const kXWPLocationDidUpdateNotification;
extern NSString *const kXWPLocationDidFailNotification;

extern NSString *const kXWPLocationLocationKey;
extern NSString *const kXWPLocationErrorKey;

@interface XWPLocation : NSObject<CLLocationManagerDelegate> {
  CLLocationManager *locationManager_;
  CLLocation *current_;
  NSError *lastUpdatingError_;
}

@property (readwrite, retain) CLLocation *current;

- (void)startUpdatingLocation;

@end
