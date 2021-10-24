//
//  Observable.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/15/21.
//

import Foundation

// Obserable
class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    /// Binds and add a listener to a generic
    /// - Parameter listener: gets called anytime the generic value changes
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
