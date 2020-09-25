//
//  UIImage+Bundle.swift
//  IRSticker-swift
//
//  Created by Phil on 2020/9/16.
//  Copyright © 2020 Phil. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func imageNamedForCurrentBundle(name: String) -> UIImage? {
        return UIImage.init(named: name, in: Utilities.getCurrentBundle(), compatibleWith: nil)
    }
}
