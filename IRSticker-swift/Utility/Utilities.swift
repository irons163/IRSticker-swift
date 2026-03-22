//
//  Utilities.swift
//  IRSticker-swift
//
//  Created by Phil on 2020/9/16.
//  Copyright © 2020 Phil. All rights reserved.
//

import Foundation

enum Utilities {
    private final class BundleToken {}

    static var currentBundle: Bundle {
        return Bundle(for: BundleToken.self)
    }
}
