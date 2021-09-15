//  Converted to Swift 5.4 by Swiftify v5.4.25812 - https://swiftify.com/
//
//  ViewController.swift
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

import Lightstreamer_tvOS_Client
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LSClientDelegate, LSSubscriptionDelegate {
    private var backgroundQueue: DispatchQueue?
    private var client: LSLightstreamerClient?
    private var subscription: LSSubscription?
    private var itemUpdated: [AnyHashable : Any]?
    private var itemData: [AnyHashable : Any]?
    private var rowsToBeReloaded: Set<AnyHashable>?

    // MARK: -
    // MARK: Properties
    @IBOutlet private weak var table: UITableView!

    // MARK: -
    // MARK: Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            // Data structure
            itemUpdated = [:]
            itemData = [:]

            // List of rows marked to be reloaded by the table
            rowsToBeReloaded = Set<AnyHashable>() // capacity: NUMBER_OF_ITEMS

            // Queue for background execution
            backgroundQueue = DispatchQueue(label: "backgroundQueue")

            // Create the Lightstreamer client
            client = LSLightstreamerClient(serverAddress: PUSH_SERVER_URL, adapterSet: ADAPTER_SET)
    }

    // MARK: -
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start connecting in background
        backgroundQueue?.async(execute: { [self] in
            connectToPushServer()
        })
    }

    // MARK: -
    // MARK: Lightstreamer life cycle
    private func connectToPushServer() {
        print("Connecting to push server \(PUSH_SERVER_URL)...")

        client?.addDelegate(self)
        client?.connect()
    }

    private func subscribeToTable() {
        print("Subscribing to table...")

        subscription = LSSubscription(subscriptionMode: "MERGE", items: TABLE_ITEMS, fields: LIST_FIELDS)
        subscription?.dataAdapter = DATA_ADAPTER
        subscription?.requestedSnapshot = "yes"
        subscription?.requestedMaxFrequency = "1.0"

        subscription?.addDelegate(self)
        client?.subscribe(subscription)

        print("Subscribed to table")
    }

    // MARK: -
    // MARK: Methods of LSClientDelegate

    func client(_ client: LSLightstreamerClient, didChangeProperty property: String) {
        print("Client property changed: \(property)")
    }

    func client(_ client: LSLightstreamerClient, didChangeStatus status: String) {
        print("Client status changed: \(status)")

        if status.hasPrefix("CONNECTED:") {

            // We subscribe, if not already subscribed. The LSClient will reconnect automatically
            // in most of the cases, so we don't need to resubscribe each time.
            if subscription == nil {
                backgroundQueue?.async(execute: { [self] in
                    subscribeToTable()
                })
            }
        } else if status.hasPrefix("DISCONNECTED:") {

            // The client will reconnect automatically in this case.
        } else if status == "DISCONNECTED" {

            // In this case the session has been closed by the server, the client
            // will not automatically reconnect. Let's prepare for a new connection.
            subscription = nil

            backgroundQueue?.async(execute: { [self] in
                connectToPushServer()
            })
        }
    }

    // MARK: -
    // MARK: Methods of LSSubscriptionDelegate

    func subscription(_ subscription: LSSubscription, didUpdateItem itemUpdate: LSItemUpdate) {
        let itemPosition = itemUpdate.itemPos
        var item: [AnyHashable : Any]? = nil
        var itemUpdated: [AnyHashable : Any]? = nil

        let lockQueue = DispatchQueue(label: "itemData")
        lockQueue.sync {
            item = itemData?[NSNumber(value: UInt((itemPosition - 1)))] as? [AnyHashable : Any]
            if item == nil {
                item = [:]
                itemData?[NSNumber(value: UInt((itemPosition - 1)))] = item
            }

            itemUpdated = self.itemUpdated?[NSNumber(value: UInt((itemPosition - 1)))] as? [AnyHashable : Any]
            if itemUpdated == nil {
                itemUpdated = [:]
                self.itemUpdated?[NSNumber(value: UInt((itemPosition - 1)))] = itemUpdated
            }
        }

        var previousLastPrice = 0.0
        for fieldName in LIST_FIELDS {
            let value = itemUpdate.value(withFieldName: fieldName)

            // Save previous last price to choose blink color later
            if fieldName == "last_price" {
                previousLastPrice = (item?[fieldName] as? NSNumber)?.doubleValue ?? 0.0
            }

            if value != "" {
                item?[fieldName] = value
            } else {
                item?[fieldName] = NSNull()
            }

            if itemUpdate.isValueChanged(withFieldName: fieldName) {
                itemUpdated?[fieldName] = NSNumber(value: true)
            }
        }

        // Check variation and store appropriate color
        let currentLastPrice = itemUpdate.value(withFieldName: "last_price").doubleValue
        if currentLastPrice >= previousLastPrice {
            item?["color"] = "green"
        } else {
            item?["color"] = "orange"
        }

        let lockQueue = DispatchQueue(label: "self.rowsToBeReloaded")
        lockQueue.sync {
            self.rowsToBeReloaded?.insert(IndexPath(row: itemPosition - 1, section: 0))
        }

        DispatchQueue.main.async(execute: { [self] in

            // Update the table view
            var rowsToBeReloaded: [AnyHashable]? = nil
            let lockQueue = DispatchQueue(label: "self.rowsToBeReloaded")
            lockQueue.sync {
                rowsToBeReloaded = [AnyHashable](repeating: 0, count: self.rowsToBeReloaded?.count ?? 0)

                for indexPath in self.rowsToBeReloaded ?? [] {
                    guard let indexPath = indexPath as? IndexPath else {
                        continue
                    }
                    rowsToBeReloaded?.append(indexPath)
                }

                self.rowsToBeReloaded?.removeAll()
            }

            // Ask the table to reload the marked rows
            if let rowsToBeReloaded = rowsToBeReloaded as? [IndexPath] {
                table.reloadRows(at: rowsToBeReloaded, with: .none)
            }
        })
    }

    // MARK: -
    // MARK: Methods of UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_ITEMS
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Prepare the table cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "StockListCell") as? StockListCell
        if cell == nil {
            let niblets = Bundle.main.loadNibNamed("StockListCell", owner: self, options: nil)
            cell = niblets?.last as? StockListCell
        }

        // Retrieve the item's data structures
        var item: [AnyHashable : Any]? = nil
        var itemUpdated: [AnyHashable : Any]? = nil
        let lockQueue = DispatchQueue(label: "itemData")
        lockQueue.sync {
            item = itemData?[NSNumber(value: indexPath.row)] as? [AnyHashable : Any]
            itemUpdated = self.itemUpdated?[NSNumber(value: indexPath.row)] as? [AnyHashable : Any]
        }

        if let item = item {
            let lockQueue = DispatchQueue(label: "item")
            lockQueue.sync {

                // Update the cell appropriately
                let colorName = item["color"] as? String
                var color: UIColor? = nil
                if colorName == "green" {
                    color = GREEN_COLOR
                } else if colorName == "orange" {
                    color = ORANGE_COLOR
                } else {
                    color = UIColor.white
                }

                cell?.nameLabel.text = item["stock_name"]
                if (itemUpdated?["stock_name"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.nameLabel, with: color)
                    }

                    itemUpdated?["stock_name"] = NSNumber(value: false)
                }

                cell?.lastLabel.text = item["last_price"]
                if (itemUpdated?["last_price"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.lastLabel, with: color)
                    }

                    itemUpdated?["last_price"] = NSNumber(value: false)
                }

                cell?.timeLabel.text = item["time"]
                if (itemUpdated?["time"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.timeLabel, with: color)
                    }

                    itemUpdated?["time"] = NSNumber(value: false)
                }

                let pctChange = (item["pct_change"] as? NSNumber)?.doubleValue ?? 0.0
                if pctChange > 0.0 {
                    cell?.dirImage.image = UIImage(named: "Arrow-up.png")
                } else if pctChange < 0.0 {
                    cell?.dirImage.image = UIImage(named: "Arrow-down.png")
                } else {
                    cell?.dirImage.image = nil
                }

                if let object = item["pct_change"] {
                    cell?.changeLabel.text = String(format: "%@%%", object)
                }
                cell?.changeLabel.textColor = ((item["pct_change"] as? NSNumber)?.doubleValue ?? 0.0 >= 0.0) ? DARK_GREEN_COLOR : RED_COLOR

                if (itemUpdated?["pct_change"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashImage(cell?.dirImage, with: color)
                        SpecialEffects.flashLabel(cell?.changeLabel, with: color)
                    }

                    itemUpdated?["pct_change"] = NSNumber(value: false)
                }

                cell?.askLabel.text = item["ask"]
                if (itemUpdated?["ask"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.askLabel, with: color)
                    }

                    itemUpdated?["ask"] = NSNumber(value: false)
                }

                cell?.bidLabel.text = item["bid"]
                if (itemUpdated?["bid"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.bidLabel, with: color)
                    }

                    itemUpdated?["bid"] = NSNumber(value: false)
                }

                cell?.minLabel.text = item["min"]
                if (itemUpdated?["min"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.minLabel, with: color)
                    }

                    itemUpdated?["min"] = NSNumber(value: false)
                }

                cell?.maxLabel.text = item["max"]
                if (itemUpdated?["max"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.maxLabel, with: color)
                    }

                    itemUpdated?["max"] = NSNumber(value: false)
                }

                cell?.refLabel.text = item["ref_price"]
                if (itemUpdated?["ref_price"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.refLabel, with: color)
                    }

                    itemUpdated?["ref_price"] = NSNumber(value: false)
                }

                cell?.openLabel.text = item["open_price"]
                if (itemUpdated?["open_price"] as? NSNumber)?.boolValue ?? false {
                    if !table.isDragging {
                        SpecialEffects.flashLabel(cell?.openLabel, with: color)
                    }

                    itemUpdated?["open_price"] = NSNumber(value: false)
                }
            }
        }

        return cell!
    }

    // MARK: -
    // MARK: Methods of UITableViewDelegate

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let niblets = Bundle.main.loadNibNamed("StockListSection", owner: self, options: nil)

        return niblets?.last as? UIView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = LIGHT_ROW_COLOR
        } else {
            cell.backgroundColor = DARK_ROW_COLOR
        }
    }
}

// MARK: -
// MARK: ViewController extension
// MARK: -
// MARK: ViewController implementation
