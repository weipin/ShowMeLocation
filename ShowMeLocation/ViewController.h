//
//  ViewController.h
//  ShowMeLocation
//
//  Created by Weipin Xia on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWPLocation;
@interface ViewController : UIViewController {
  XWPLocation *location_;
  
  UILabel *label_;
}

@property (readwrite, retain) XWPLocation *location;

@property (nonatomic, retain) IBOutlet UILabel *label;

@end
