//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 13.03.20.
//

import Foundation

public struct DeviceList: Decodable, Equatable {
    public let devices: [String: [Device]]
}

public struct Device: Decodable, Equatable {
    public let state: String?
    public let isAvailable: Bool
    public let name: String
    public let udid: String
    public let deviceTypeIdentifier: String?
    public let dataPath: String?
}

public struct DeviceType: Decodable, Hashable, Identifiable {
    public let bundlePath: String
    public let name: String
    public let identifier: String
    public var id: String { identifier }

    public var modelTypeIdentifier: TypeIdentifier? {
        guard let bundle = Bundle(path: bundlePath) else { return nil }
        guard let plist = bundle.url(forResource: "profile", withExtension: "plist") else { return nil }
        guard let contents = NSDictionary(contentsOf: plist) else { return nil }
        guard let modelIdentifier = contents.object(forKey: "modelIdentifier") as? String else { return nil }

        return TypeIdentifier(modelIdentifier: modelIdentifier)
    }

    public var family: DeviceFamily {
        let type = modelTypeIdentifier ?? .defaultiPhone
        if type.conformsTo(.tv) { return .tv }
        if type.conformsTo(.watch) { return .watch }
        if type.conformsTo(.pad) { return .iPad }
        return .iPhone
    }
}

public struct DeviceTypeList: Decodable {
    public let devicetypes: [DeviceType]
}
