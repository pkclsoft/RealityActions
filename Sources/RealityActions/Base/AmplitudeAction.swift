//
//  AmplitudeAction.swift
//  
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

class AmplitudeAction: FiniteTimeAction
{
    public var amplitude: Double = 0
}

class AmplitudeActionState: FiniteTimeActionState {
    var amplitude: Double
    var amplitudeRate: Double
    
    init (action: AmplitudeAction, target: Entity) {
        amplitude = action.amplitude
        amplitudeRate = 1
        super.init(action: action, target: target)
    }
}
