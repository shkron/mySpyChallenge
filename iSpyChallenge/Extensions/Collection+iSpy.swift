//
//  Collection+iSpy.swift
//  iSpyChallenge
//
//  Created by Alex Scharch on 12/25/21.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    subscript(safe index: Index?) -> Iterator.Element? {
        guard let index = index else {
            return nil
        }
        
        return self[safe: index]
    }
}
