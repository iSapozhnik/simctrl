//
//  DeviceListDecoder.swift
//  
//
//  Created by Ivan Sapozhnik on 10.10.19.
//

import Foundation

final class DeviceListDecoder<T: Decodable> {
    func decode(string: String) -> T? {
        guard let jsonData = string.data(using: .utf8) else { return nil }
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode(T.self, from: jsonData)
        } catch {
            print(error)
            return nil
        }
    }
}
