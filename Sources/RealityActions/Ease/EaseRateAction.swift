//
//  EaseRateAction.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Base class for easing function with rate parameters
public class EaseRateAction: ActionEase {
    let rate: Double
    public init (_ action: FiniteTimeAction, rate: Double) {
        self.rate = rate
        super.init(action)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseRateActionState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseRateAction (innerAction.reverse (), rate: 1/rate)
    }
}

class EaseRateActionState: ActionEaseState {
    let rate: Double
    init? (action: EaseRateAction, target: Entity) {
        rate = action.rate
        super.init(action: action, target: target)
    }
    
    override func update(time: Double) {
        innerActionState.update (time: exponentialOut(time: time))
    }
}
