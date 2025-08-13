//
//  EaseInOut.swift
//
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Easing function: ease-in-and-then-out
public class EaseInOut: EaseRateAction {
    public override init (_ action: FiniteTimeAction, rate: Double) {
        super.init(action, rate: rate)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        EaseInOutState (action: self, target: target)
    }
    
    public override func reverse() -> ActionEase {
        EaseInOut (innerAction.reverse (), rate: rate)
    }
}

class EaseInOutState: EaseRateActionState {
    init? (action: EaseInOut, target: Entity) {
        super.init(action: action, target: target)
    }
    
    override func update(time: Double) {
        let atime = time * 2
        if atime < 2 {
            innerActionState.update (time: 0.5 * pow (atime, rate))
        } else {
            innerActionState.update (time: 1 - 0.5 * pow (2-atime, rate))
        }
    }
}
