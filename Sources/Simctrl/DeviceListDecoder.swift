//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10.10.19.
//

import Foundation

final class DeviceListDecoder {
    func decode<T: Decodable>(string: String) -> T? {
        guard let jsonData = string.data(using: .utf8) else { return nil }
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode(T.self, from: jsonData)
    }
}
