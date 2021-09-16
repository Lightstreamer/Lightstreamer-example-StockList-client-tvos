//
//  Utils.swift
//  StockList Demo for tvOS
//
//  Created by acarioni on 15/09/21.
//  Copyright © 2021 Lightstreamer. All rights reserved.
//

import Foundation

// Configuration for local installation
//#define PUSH_SERVER_URL            (@"http://localhost:8080/")
//#define ADAPTER_SET                (@"STOCKLISTDEMO")
//#define DATA_ADAPTER               (@"STOCKLIST_ADAPTER")

// Configuration for online demo server
let PUSH_SERVER_URL = "https://push.lightstreamer.com"
let ADAPTER_SET = "DEMO"
let DATA_ADAPTER = "QUOTE_ADAPTER"

let NUMBER_OF_ITEMS = 30
let NUMBER_OF_LIST_FIELDS = 4

let TABLE_ITEMS = [
    "item1",
    "item2",
    "item3",
    "item4",
    "item5",
    "item6",
    "item7",
    "item8",
    "item9",
    "item10",
    "item11",
    "item12",
    "item13",
    "item14",
    "item15",
    "item16",
    "item17",
    "item18",
    "item19",
    "item20",
    "item21",
    "item22",
    "item23",
    "item24",
    "item25",
    "item26",
    "item27",
    "item28",
    "item29",
    "item30"
]
let LIST_FIELDS = [
    "stock_name",
    "last_price",
    "time",
    "pct_change",
    "bid",
    "ask",
    "min",
    "max",
    "open_price",
    "ref_price"
]

let ALERT_DELAY = 0.250
let FLASH_DURATION = 0.150

let GREEN_COLOR = UIColor(red: 0.5647, green: 0.9294, blue: 0.5373, alpha: 1.0)
let ORANGE_COLOR = UIColor(red: 0.9843, green: 0.7216, blue: 0.4510, alpha: 1.0)

let DARK_GREEN_COLOR = UIColor(red: 0.0000, green: 0.6000, blue: 0.2000, alpha: 1.0)
let RED_COLOR = UIColor(red: 1.0000, green: 0.0706, blue: 0.0000, alpha: 1.0)

let LIGHT_ROW_COLOR = UIColor(red: 0.9333, green: 0.9333, blue: 0.9333, alpha: 1.0)
let DARK_ROW_COLOR = UIColor(red: 0.8667, green: 0.8667, blue: 0.9373, alpha: 1.0)
let SELECTED_ROW_COLOR = UIColor(red: 0.0000, green: 0.0000, blue: 1.0000, alpha: 1.0)

let COLORED_LABEL_TAG = 456

let HEADER_HEIGHT = 60

func toDouble(_ s: String?) -> Double {
    if let s = s {
        return Double(s) ?? 0
    }
    return 0
}
