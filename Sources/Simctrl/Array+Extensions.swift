//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 10/16/19.
//

extension Array where Element: Equatable {
    public mutating func appendUnique(_ element: Element) {
        if contains(element) {
            removeAll(where: { $0 == element })
        }
        append(element)
    }
}
