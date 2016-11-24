//
//  ViewController.h
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Lightstreamer_tvOS_Client/Lightstreamer_tvOS_Client.h>


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LSClientDelegate, LSSubscriptionDelegate>
@end

