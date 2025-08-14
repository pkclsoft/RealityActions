//
//  ActionTweenEntity.swift
//  RealityActions
//
//  Created by Peter Easdown on 14/8/2025.
//  Based heavily on ActionTween, created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// ActionTweenEntity is an action that lets you update an Entity using a value that
/// varies over the timespan of the action.
public class ActionTweenEntity: FiniteTimeAction {
    public let from: Float
    public let to: Float
    public let tweenAction: (Entity, Float) -> ()

    
    /// Invokes your custom code for the specified duration interpolating the values from `from` to `to`, and communicating the value along with a reference to the target Entity.
    /// - Parameters:
    ///   - duration: The time that this action will run for
    ///   - from: Initial value
    ///   - to: Final value
    ///   - tweenAction: The callback that will be invoked repeatedly with the computed value in the range `from`..`to` interpolated into the duration.  The first argument
    ///   is the Entity that is the target of the action.
    public init (duration: TimeInterval, from: Float, to: Float, tweenAction: @escaping (Entity, Float)->())
    {
        self.to = to
        self.from = from
        self.tweenAction = tweenAction
        super.init(duration: duration)
    }
    
    override func startAction (target: Entity) -> ActionState? {
        ActionTweenEntityState(action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        ActionTweenEntity(duration: duration, from: to, to: from, tweenAction: tweenAction)
    }
}
    
class ActionTweenEntityState : FiniteTimeActionState
{
    let at: ActionTweenEntity
    let delta: Float
    
    public init (action: ActionTweenEntity, target: Entity) {
        at = action
        delta = at.to - at.from
        super.init (action: action, target: target)
    }
    
    override func update(time: Double) {
        let amt = at.to - delta * Float(1 - time)
        at.tweenAction(target!, amt)
    }
}
