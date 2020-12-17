//
//  Reusable.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import Foundation

protocol Reusable {
    
    static var reuseIdentifier: String { get }
    
}

extension Reusable {
    
    static var reuseIdentifier: String { String(describing: type(of: self)) }
    
}
