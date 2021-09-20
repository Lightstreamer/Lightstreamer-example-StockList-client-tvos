//  Converted to Swift 5.4 by Swiftify v5.4.25812 - https://swiftify.com/
//
//  StockListCell.swift
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

import UIKit

class StockListCell: UITableViewCell {
    // MARK: -
    // MARK: Properties
    @IBOutlet private(set) weak var nameLabel: UILabel?
    @IBOutlet private(set) weak var lastLabel: UILabel?
    @IBOutlet private(set) weak var timeLabel: UILabel?
    @IBOutlet private(set) weak var dirImage: UIImageView?
    @IBOutlet private(set) weak var changeLabel: UILabel?
    @IBOutlet private(set) weak var bidLabel: UILabel?
    @IBOutlet private(set) weak var askLabel: UILabel?
    @IBOutlet private(set) weak var minLabel: UILabel?
    @IBOutlet private(set) weak var maxLabel: UILabel?
    @IBOutlet private(set) weak var refLabel: UILabel?
    @IBOutlet private(set) weak var openLabel: UILabel?

    // MARK: -
    // MARK: Initialization

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
            // Nothing to do, actually
    }

    // MARK: -
    // MARK: Properties
}
