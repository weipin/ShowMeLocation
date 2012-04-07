//
//  XWPLocation.m
//  GeoLocation
//
//  Created by Weipin Xia on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "XWPLocation.h"

@interface XWPLocation ()

@property (readwrite, retain) CLLocationManager *locationManager;
@property (readwrite, retain) NSError *lastUpdatingError;

- (void)_stopUpdatingLocation;

@end


const NSTimeInterval kXWPLocationStopUpdatingTimeInterval = 15.0;

NSString *const kXWPLocationErrorDomain = @"com.xiaweipin.locationerror";

NSString *const kXWPLocationDidUpdateNotification = @"XWPLocationDidUpdateNotification";
NSString *const kXWPLocationDidFailNotification = @"XWPLocationDidFailNotification";

NSString *const kXWPLocationLocationKey = @"Location";
NSString *const kXWPLocationErrorKey = @"Error";

@implementation XWPLocation

@synthesize locationManager = locationManager_;
@synthesize current = current_;
@synthesize lastUpdatingError = lastUpdatingError_;

- (id)init {
  if (self = [super init]) {
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;    
  }
  
  return self;
}

- (void)dealloc {
  [self _stopUpdatingLocation];
  
  self.locationManager = nil;
  self.current = nil;
  self.lastUpdatingError = nil;
  
  [super dealloc];
}

#pragma mark - Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                           selector:@selector(stopUpdatingLocationDelay:)
                                             object:self];
  // Minimize power usage by stopping the location manager as soon as possible.
  [self _stopUpdatingLocation];

  self.current = newLocation;
  self.lastUpdatingError = nil;
  
  NSLog(@"XWPLocation did update location:%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
  
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.current 
                                                       forKey:kXWPLocationLocationKey];
  [[NSNotificationCenter defaultCenter] postNotificationName:kXWPLocationDidUpdateNotification 
                                                      object:self 
                                                    userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  // The location "unknown" error simply means the manager is currently unable to get the location.
  // We can ignore this error for the scenario of getting a single location fix, because we already have a 
  // timeout that will stop the location manager to save power.
  if ([error code] != kCLErrorLocationUnknown) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                             selector:@selector(stopUpdatingLocationDelay:)
                                               object:self];
    NSLog(@"location manager failed:%@", error);
    [self _stopUpdatingLocation];
    
    self.lastUpdatingError = error;

    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error
                                                         forKey:kXWPLocationErrorKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kXWPLocationDidFailNotification 
                                                        object:self 
                                                      userInfo:userInfo];
    
  }
}

#pragma mark - Locating

- (void)startUpdatingLocation {
  self.locationManager.delegate = self;
  [self.locationManager startUpdatingLocation];
  NSLog(@"locationManager started updating location");  
  
  [self performSelector:@selector(stopUpdatingLocationDelay:) 
             withObject:self
             afterDelay:kXWPLocationStopUpdatingTimeInterval];  
}

- (void)stopUpdatingLocation {
  [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                           selector:@selector(stopUpdatingLocationDelay:)
                                             object:self];
  [self _stopUpdatingLocation];  
  
}

#pragma mark - Helper

- (void)_stopUpdatingLocation {
  [self.locationManager stopUpdatingLocation];
  self.locationManager.delegate = nil;
  
  NSLog(@"tried to stop locationManager updating");
}

- (void)stopUpdatingLocationDelay:(id)sender {
  [self _stopUpdatingLocation];
  
  NSString *str = NSLocalizedString(@"Determinating current location timed out.", @"");
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:str
                                                       forKey:NSLocalizedDescriptionKey];
  self.lastUpdatingError = [NSError errorWithDomain:kXWPLocationErrorDomain
                                               code:kXWPLocationErrorTimeout 
                                          userInfo:userInfo];

  userInfo = [NSDictionary dictionaryWithObject:self.lastUpdatingError
                                         forKey:kXWPLocationErrorKey];
  [[NSNotificationCenter defaultCenter] postNotificationName:kXWPLocationDidFailNotification 
                                                      object:self 
                                                    userInfo:userInfo];
}

@end
