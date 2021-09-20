//  Converted to Swift 5.4 by Swiftify v5.4.25812 - https://swiftify.com/
//
//  SpecialEffects.swift
//  StockList Demo for tvOS
//
//  Copyright © 2016 Lightstreamer. All rights reserved.
//

import UIKit

class SpecialEffects: NSObject {
    // MARK: -
    // MARK: UI element flashing
    class func flash(_ label: UILabel?, with color: UIColor?) {
        label?.layer.backgroundColor = color?.cgColor
        if label?.tag == COLORED_LABEL_TAG {
            label?.textColor = UIColor.black
        }

        SpecialEffects.self.perform(#selector(unflashLabel(_:)), with: label, afterDelay: FLASH_DURATION)
    }

    class func flashImage(_ imageView: UIImageView?, with color: UIColor?) {
        imageView?.backgroundColor = color

        SpecialEffects.self.perform(#selector(unflashImage(_:)), with: imageView, afterDelay: FLASH_DURATION)
    }

    // MARK: -
    // MARK: Internals

    @objc class func unflashLabel(_ label: UILabel?) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.easeIn)
        UIView.setAnimationDuration(FLASH_DURATION)

        label?.layer.backgroundColor = UIColor.clear.cgColor
        if label?.tag == COLORED_LABEL_TAG {
            label?.textColor = (Double(label?.text ?? "") ?? 0.0 >= 0.0) ? DARK_GREEN_COLOR : RED_COLOR
        }

        UIView.commitAnimations()
    }

    @objc class func unflashImage(_ imageView: UIImageView?) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.easeIn)
        UIView.setAnimationDuration(FLASH_DURATION)

        imageView?.backgroundColor = UIColor.clear

        UIView.commitAnimations()
    }
}