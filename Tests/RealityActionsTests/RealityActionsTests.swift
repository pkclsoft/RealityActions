import XCTest
@testable import RealityActions

final class RealityActionsTests: XCTestCase {
    
    func testQuatMath() throws {
        let euler : SIMD3<Float> = SIMD3<Float>(.pi, .pi * 1.5, .pi / 2.0)
        
        let quat = quaternionFromEuler(angles: euler)
        
        let result = toEulerAngles(quat)
        
        XCTAssertEqual(euler.x, result.x, accuracy: Float.ulpOfOne)
        XCTAssertEqual(euler.y, result.y, accuracy: Float.ulpOfOne)
        XCTAssertEqual(euler.z, result.z, accuracy: Float.ulpOfOne)
    }
}
