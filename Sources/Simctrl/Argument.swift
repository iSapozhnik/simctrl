//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 27.09.19.
//

import Foundation

public protocol Argument {
    func validatedParameter() throws -> String?
}

/*

 --time <string>
      Set the date or time to a fixed value.
      If the string is a valid ISO date string it will also set the date on relevant devices.
 --dataNetwork <dataNetworkType>
      If specified must be one of 'wifi', '3g', '4g', 'lte', 'lte-a', or 'lte+'.
 --wifiMode <mode>
      If specified must be one of 'searching', 'failed', or 'active'.
 --wifiBars <int>
      If specified must be 0-3.
 --cellularMode <mode>
      If specified must be one of 'notSupported', 'searching', 'failed', or 'active'.
 --cellularBars <int>
      If specified must be 0-4.
 --batteryState <state>
      If specified must be one of 'charging', 'charged', or 'discharging'.
 --batteryLevel <int>
      If specified must be 0-100.

*/

public enum DataNetworkType: String {
    case wifi
    case threeG = "3g"
    case fourG = "4g"
    case lte
    case lteA = "lte-a"
    case ltePlus = "lte+"
}

public enum WiFiMode: String {
    case searching
    case failed
    case active
}

public enum CellularModeType: String, Equatable {
    case notSupported
    case searching
    case failed
    case active
}

public enum BatteryState: String, Equatable {
    case charging
    case charged
    case discharging
}

public enum StatusBarArgument: Equatable {
    case batteryLevel(Int)
    case dataNetwork(DataNetworkType)
    case wifiMode(WiFiMode)
    case wifiBars(Int)
    case cellularMode(CellularModeType)
    case batteryState(BatteryState)
}

extension StatusBarArgument: Argument {
    public func validatedParameter() throws -> String? {
        switch self {
        case .batteryLevel(let level):
            guard (0...100).contains(level) else { throw ArgumentError.invalidBatteryLevelValue }
            return "--batteryLevel \(level)"
        case .dataNetwork(let dataNetworkType):
            return "--dataNetwork \(dataNetworkType.rawValue)"
        case .wifiMode(let wifiMode):
            return "--wifiMode \(wifiMode.rawValue)"
        case .wifiBars(let barsAmount):
            guard (0...3).contains(barsAmount) else { throw ArgumentError.invalidWiFiBarsAmount }
            return "--wifiBars \(barsAmount)"
        case .cellularMode(let cellularMode):
            return "--cellularMode \(cellularMode.rawValue)"
        case .batteryState(let batteryState):
            return "--batteryState \(batteryState.rawValue)"
        }
    }
}
