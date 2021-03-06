//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 27.09.19.
//

import Foundation

enum ArgumentError: Error {
    case invalidBatteryLevelValue
    case invalidWiFiBarsAmount
}

public enum SimctrlError: Swift.Error {
    case missingCommand
    case missingOutput
    case unknown(Swift.Error)
}
