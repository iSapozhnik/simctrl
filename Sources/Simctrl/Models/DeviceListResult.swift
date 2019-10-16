//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 11.10.19.
//

import Foundation

// MARK: - Device
public struct DeviceListResult: Codable {
//    public let devicetypes: [Devicetype]
//    public let runtimes: [Runtime]
    public let devices: [String: [DeviceElement]]
//    public let pairs: [String: Pair]
}

// MARK: - DeviceElement
public struct DeviceElement: Codable {
    public let state: State
    public let isAvailable: Bool?
    public let name, udid: String
    public let availabilityError: AvailabilityError?
}

public enum AvailabilityError: String, Codable {
    case runtimeProfileNotFound = "runtime profile not found"
}

public enum State: String, Codable {
    case booted = "Booted"
    case shutdown = "Shutdown"
}

// MARK: - Devicetype
public struct Devicetype: Codable {
    public let name, bundlePath, identifier: String
}

// MARK: - Pair
public struct Pair: Codable {
    public let watch, phone: DeviceElement
    public let state: String
}

// MARK: - Runtime
public struct Runtime: Codable {
    public let version, bundlePath: String
    public let isAvailable: Bool
    public let name, identifier, buildversion: String
}
