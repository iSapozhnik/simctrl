//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 13.03.20.
//

import Foundation

public enum DeviceFamily: CaseIterable {
    case iPhone
    case iPad
    case tv
    case watch
}

extension DeviceFamily {
    public var displayName: String {
        switch self {
            case .iPhone: return "iPhone"
            case .iPad: return "iPad"
            case .watch: return "Apple Watch"
            case .tv: return "Apple TV"
        }
    }
}
