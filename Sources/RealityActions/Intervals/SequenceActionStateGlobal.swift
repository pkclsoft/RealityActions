//
//  SequenceActionStateGlobal.swift
//  RealityActions
//
//  Created by Peter Easdown on 21/9/2025.
//

import Foundation

class SequenceActionStateGlobal {
    private var said : Int = 0
    
    nonisolated(unsafe) static let shared = SequenceActionStateGlobal()
    
    func increment() {
        said += 1
    }
    
    func nextSequenceActionID() -> Int {
        let result = said
        
        increment()
        
        return result
    }
}
