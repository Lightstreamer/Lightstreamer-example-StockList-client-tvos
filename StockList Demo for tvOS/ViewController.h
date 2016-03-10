//
//  ViewController.h
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LSConnectionDelegate.h"
#import "LSTableDelegate.h"


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LSConnectionDelegate, LSTableDelegate>
@end

