//
//  Logging.swift
//
//
//  Created by Bosco Ho on 2023-12-23.
//

import Foundation
import os

struct Log {
    
    static let `default` = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "TabStar"
    )
}
