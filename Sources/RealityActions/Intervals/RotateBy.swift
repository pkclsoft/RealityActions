//
//  RotateBy.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Rotates the transformation of the target by the specified radians
public class RotateBy: FiniteTimeAction {
    
    // The angle in radians
    let deltaAngles: SIMD3<Float>
    
    let deg2radians: Float = .pi / 180

    /// Creates a rotation
    /// - Parameters:
    ///   - duration: time for the rotation to take place
    ///   - deltaAngles: this vector contains the angle values in X, Y and Z in degrees that you want to perform
    public init (duration: TimeInterval, deltaAngles: SIMD3<Float>) {
        self.deltaAngles = deltaAngles * deg2radians
        super.init(duration: duration)
    }

    /// Creates a rotation
    /// - Parameters:
    ///   - duration: time for the rotation to take place
    ///   - deltaAngles: this vector contains the angle values in X, Y and Z i radians that you want to perform
    public init (duration: TimeInterval, deltaAnglesRad: SIMD3<Float>) {
        self.deltaAngles = deltaAnglesRad
        super.init(duration: duration)
    }

    override func startAction(target: Entity) -> ActionState? {
        RotateByState (action: self, target: target, deltaAngles: deltaAngles)
    }
    
    public override func reverse() -> FiniteTimeAction {
        RotateBy(duration: duration, deltaAngles: -deltaAngles)
    }

}

class RotateByState: FiniteTimeActionState {
    let rb: RotateBy
    var startRotation: simd_quatf
    var deltaAngles: SIMD3<Float>
    
    init(action: RotateBy, target: Entity, deltaAngles: SIMD3<Float>) {
        rb = action
        startRotation = target.transform.rotation
        self.deltaAngles = deltaAngles
        super.init(action: action, target: target)
    }

    override func update(time: Double) {
        guard let target else { return }
        let newRot = startRotation * quaternionFromEuler(angles: deltaAngles * Float(time))
        target.transform.rotation = newRot.normalized
    }
}
