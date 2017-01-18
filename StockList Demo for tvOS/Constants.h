//
//  Constants.h
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


// Configuration for local installation
#define PUSH_SERVER_URL            (@"http://localhost:8080/")
#define ADAPTER_SET                (@"STOCKLISTDEMO")
#define DATA_ADAPTER               (@"STOCKLIST_ADAPTER")

/* Configuration for online demo server
#define PUSH_SERVER_URL            (@"https://push.lightstreamer.com")
#define ADAPTER_SET                (@"DEMO")
#define DATA_ADAPTER               (@"QUOTE_ADAPTER")
 */

#define NUMBER_OF_ITEMS            (30)
#define NUMBER_OF_LIST_FIELDS      (4)

#define TABLE_ITEMS                (@[@"item1", @"item2", @"item3", @"item4", @"item5", @"item6", @"item7", @"item8", @"item9", @"item10", @"item11", @"item12", @"item13", @"item14", @"item15", @"item16", @"item17", @"item18", @"item19", @"item20", @"item21", @"item22", @"item23", @"item24", @"item25", @"item26", @"item27", @"item28", @"item29", @"item30"])
#define LIST_FIELDS                (@[@"stock_name", @"last_price", @"time", @"pct_change", @"bid", @"ask", @"min", @"max", @"open_price", @"ref_price"])

#define ALERT_DELAY                (0.250)
#define FLASH_DURATION             (0.150)

#define GREEN_COLOR                ([UIColor colorWithRed:0.5647 green:0.9294 blue:0.5373 alpha:1.0])
#define ORANGE_COLOR               ([UIColor colorWithRed:0.9843 green:0.7216 blue:0.4510 alpha:1.0])

#define DARK_GREEN_COLOR           ([UIColor colorWithRed:0.0000 green:0.6000 blue:0.2000 alpha:1.0])
#define RED_COLOR                  ([UIColor colorWithRed:1.0000 green:0.0706 blue:0.0000 alpha:1.0])

#define LIGHT_ROW_COLOR            ([UIColor colorWithRed:0.9333 green:0.9333 blue:0.9333 alpha:1.0])
#define DARK_ROW_COLOR             ([UIColor colorWithRed:0.8667 green:0.8667 blue:0.9373 alpha:1.0])
#define SELECTED_ROW_COLOR         ([UIColor colorWithRed:0.0000 green:0.0000 blue:1.0000 alpha:1.0])

#define COLORED_LABEL_TAG          (456)

#define HEADER_HEIGHT              (60)


#endif /* Constants_h */
