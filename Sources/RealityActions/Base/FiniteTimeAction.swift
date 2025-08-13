//
//  FiniteTimeAction.swift
//  
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation
import RealityKit

/// Base class for actions that have a time duration.
public class FiniteTimeAction: BaseAction {
    /// The duration for this action
    public let duration: TimeInterval
    
    public init (duration: TimeInterval) {
        self.duration = max (.ulpOfOne, duration)
    }
    
    /// Produces an action that is the reverse of the current action
    public func reverse() -> FiniteTimeAction {
        return self
    }
    
    override func startAction(target: Entity) -> ActionState? {
        FiniteTimeActionState (action: self, target: target)
    }
}

class FiniteTimeActionState: ActionState {
    var firstTick: Bool
    var duration: TimeInterval
    var elapsed: TimeInterval
    
    override var isDone: Bool { elapsed >= duration }
    
    init (action: FiniteTimeAction, target: Entity) {
        duration = action.duration
        elapsed = 0
        firstTick = true
        super.init(action: action, target: target)
    }
    
    override func step (dt: TimeInterval) {
        if firstTick {
            firstTick = false
            elapsed = 0
        } else {
            elapsed += dt
        }
        
        update(time: max (0.0, min (1.0, elapsed / max (duration, TimeInterval.ulpOfOne))))
    }
}
