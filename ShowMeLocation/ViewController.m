//
//  ViewController.m
//  ShowMeLocation
//
//  Created by Weipin Xia on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XWPLocation.h"

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize location = location_;

@synthesize label = label_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    location_ = [[XWPLocation alloc] init];
  }
  
  return self;
}

- (void)dealloc {
  [location_ release];
  
  self.label = nil;
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(locationDidUpdate:)
                                               name:kXWPLocationDidUpdateNotification
                                             object:nil];
  
  [self.location startUpdatingLocation];
}

- (void)viewDidUnload
{
    self.label = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Notification

- (void)locationDidUpdate:(NSNotification *)notification {
  self.label.text = [NSString stringWithFormat:@"%@", self.location.current];
}

#pragma mark - Action

- (IBAction)copy:(id)sender {
  [UIPasteboard generalPasteboard].string = self.label.text;
}


@end
