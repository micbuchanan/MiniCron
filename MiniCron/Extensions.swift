//
//  Extensions.swift
//  MiniCron
//
//  Created by Michael Buchanan on 21/08/2022.
//

import Foundation

extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
    
    var fields: [String] {
        return self.components(separatedBy: " ")
    }
}

extension Array {
    func sectioned(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
