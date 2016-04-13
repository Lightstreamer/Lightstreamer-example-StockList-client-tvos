//
//  ViewController.h
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <LightstreamerClientAll.h>


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LSClientDelegate, LSSubscriptionDelegate>
@end

