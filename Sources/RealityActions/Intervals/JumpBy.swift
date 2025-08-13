//
//  JumpBy.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Moves a Node object simulating a parabolic jump movement by modifying it's position attribute.
public class JumpBy: FiniteTimeAction {
    let jumps: Int
    let height: Double
    let position: SIMD3<Float>
    
    public init (duration: TimeInterval, position: SIMD3<Float>, height: Double, jumps: Int) {
        self.jumps = jumps
        self.height = height
        self.position = position
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        return JumpByState (action: self, target: target, delta: position)
    }
    
    public override func reverse() -> FiniteTimeAction {
        JumpBy(duration: duration, position: -position, height: height, jumps: jumps)
    }

}

class JumpByState: FiniteTimeActionState {
    let aj: JumpBy
    var startPosition: SIMD3<Float>
    var previousPosition: SIMD3<Float>
    var delta: SIMD3<Float>
    
    init(action: JumpBy, target: Entity, delta: SIMD3<Float>) {
        aj = action
        self.delta = delta
        startPosition = target.position
        previousPosition = target.position
        super.init(action: action, target: target)
    }
    
    override func update(time: Double) {
        guard let target else { return }
        let fTime = Float(time)
        let frac = fmod (time * Double (aj.jumps), 1)
        let y = Float(aj.height * 4 * frac * (1 - frac))
        let delta: SIMD3<Float> = [delta.x * fTime, y * fTime, delta.z * fTime]
        
        let currentPos = target.position
        
        let diff = currentPos - previousPosition
        startPosition = diff + startPosition
        
        let newPos = startPosition + delta
        target.position = newPos
        
        previousPosition = newPos
    }
}
