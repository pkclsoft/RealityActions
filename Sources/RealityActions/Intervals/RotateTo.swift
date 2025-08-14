//
//  RotateTo.swift
//
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Rotates the transformation of the target by the specified radians
public class RotateTo: FiniteTimeAction {
    // The angle in radians
    let distanceAngle: SIMD3<Float>
    
    let deg2radians: Float = .pi / 360

    /// Creates a rotation
    /// - Parameters:
    ///   - duration: time for the rotation to take place
    ///   - deltaAngles: this vector contains the angle values in X, Y and Z in degrees that you want to perform
    public init (duration: TimeInterval, distanceAngle: SIMD3<Float>) {
        self.distanceAngle = distanceAngle * deg2radians
        super.init(duration: duration)
    }
    
    /// Creates a rotation
    /// - Parameters:
    ///   - duration: time for the rotation to take place
    ///   - deltaAngles: this vector contains the angle values in X, Y and Z in radians that you want to perform
    public init (duration: TimeInterval, distanceAngleRad: SIMD3<Float>) {
        self.distanceAngle = distanceAngleRad
        super.init(duration: duration)
    }
    
    override func startAction(target: Entity) -> ActionState? {
        RotateToState (action: self, target: target)
    }
    
    public override func reverse() -> FiniteTimeAction {
        fatalError("Not supported")
    }

}

class RotateToState: FiniteTimeActionState {
    let rt: RotateTo
    var distanceAngle: SIMD3<Float>
    var diffAngleX, diffAngleY, diffAngleZ: Float
    var startAngleX, startAngleY, startAngleZ: Float
    
    let deg360 : Float = .pi * 2.0
    let deg180 : Float = .pi
    
    init(action: RotateTo, target: Entity) {
        rt = action
        distanceAngle = action.distanceAngle
        let sourceRotation = toEulerAngles (target.transform.rotation)
        
        // Calculate X
        startAngleX = sourceRotation.x
        startAngleX = startAngleX > 0 ? startAngleX.truncatingRemainder(dividingBy: deg360) : startAngleX.truncatingRemainder(dividingBy: -deg360)
        diffAngleX = distanceAngle.x - startAngleX
        if diffAngleX > deg180 {
            diffAngleX -= deg360
        }
        if diffAngleX < -deg180 {
            diffAngleX += deg360
        }
        
        //Calculate Y
        startAngleY = sourceRotation.y
        startAngleY = startAngleY > 0 ? startAngleY.truncatingRemainder(dividingBy: deg360) : startAngleY.truncatingRemainder(dividingBy: -deg360)
        diffAngleY = distanceAngle.y - startAngleY
        if diffAngleY > deg180 {
            diffAngleY -= deg360
        }
        if diffAngleY < -deg180 {
            diffAngleY += deg360
        }
        
        //Calculate Z
        startAngleZ = sourceRotation.z
        startAngleZ = startAngleZ > 0 ? startAngleZ.truncatingRemainder(dividingBy: deg360) : startAngleZ.truncatingRemainder(dividingBy: -deg360)
        diffAngleZ = distanceAngle.z - startAngleZ
        if diffAngleZ > deg180 {
            diffAngleZ -= deg360
        }
        if diffAngleZ < -deg180 {
            diffAngleZ += deg360
        }
        super.init(action: action, target: target)
    }
    
    override func update(time: Double) {
        guard let target else { return }
        let fTime = Float(time)
        
        target.transform.rotation = quaternionFromEuler(
            angles: SIMD3<Float> (
                startAngleX+diffAngleX * fTime,
                startAngleY+diffAngleY * fTime,
                startAngleZ+diffAngleZ * fTime))
    }
}
