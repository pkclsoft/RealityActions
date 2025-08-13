//
//  QuatMath.swift
//  
//
//  Created by Miguel de Icaza on 8/2/23.
//

import Foundation
import RealityKit

/// Converts the incoming euler angles (in radians) to a quaternion.
/// - Parameter angles: the euler angles in radians
/// - Returns: the equivalent quaternian.
func quaternionFromEuler (angles: SIMD3<Float>) -> simd_quatf {
    let halfAngles = angles / 2.0
    let s = sin (halfAngles)
    let c = cos (halfAngles)
    
    return simd_quatf (vector: [
        c.y * s.x * c.z + s.y * c.x * s.z,
        s.y * c.x * c.z - c.y * s.x * s.z,
        c.y * c.x * s.z - s.y * s.x * c.z,
        c.y * c.x * c.z + s.y * s.x * s.z
    ])
}

/// Converts the input quaternian into euler angles (in radians).
/// - Parameter quat: the quaternian to convert
/// - Returns: the equivalent euler angles in radians
func toEulerAngles (_ quat: simd_quatf) -> SIMD3<Float> {
    // Derivation from http://www.geometrictools.com/Documentation/EulerAngles.pdf
    // Order of rotations: Z first, then X, then Y
    let qv = quat.vector

    let check: Float = 2.0*(-qv.y*qv.z + qv.w*qv.x);
    
    if check < -0.995 {
        return SIMD3<Float> (-.pi / 2.0, 0,
                              -atan2f(2.0 * (qv.x * qv.z - qv.w * qv.y), 1.0 - 2.0 * (qv.y * qv.y + qv.z * qv.z)))
    } else if check > 0.995 {
        return SIMD3<Float> (-.pi / 2.0, 0,
                              atan2f(2.0 * (qv.x * qv.z - qv.w * qv.y), 1.0 - 2.0 * (qv.y * qv.y + qv.z * qv.z)))
    } else {
        return SIMD3<Float> (
            asinf (check),
            atan2f(2.0 * (qv.x * qv.z + qv.w * qv.y), 1.0 - 2.0 * (qv.x * qv.x + qv.y * qv.y)),
            atan2f(2.0 * (qv.x * qv.y + qv.w * qv.z), 1.0 - 2.0 * (qv.x * qv.x + qv.z * qv.z)))
    }

}

