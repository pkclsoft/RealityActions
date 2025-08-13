//
//  EaseMath.swift
//  
//
//  Created by Miguel de Icaza on 8/1/23.
//

import Foundation

func backIn(time: Double) -> Double {
    let overshoot: Double = 1.70158
    
    return time * time * ((overshoot + 1) * time - overshoot)
}

func backOut(time: Double) -> Double {
    let overshoot: Double = 1.70158
    
    let time = time - 1
    return time * time * ((overshoot + 1) * time + overshoot) + 1
}

func backInOut(time: Double) -> Double {
    let overshoot: Double = 1.70158 * 1.525
    
    let time = time * 2
    if time < 1 {
        return (time * time * ((overshoot + 1) * time - overshoot)) / 2
    } else {
        let stime = time - 2
        return (stime * stime * ((overshoot + 1) * stime + overshoot)) / 2 + 1
    }
}

func bounceOut(time: Double) -> Double {
    if time < 1 / 2.75 {
        return 7.5625 * time * time
    } else if (time < 2 / 2.75) {
        let rtime = time - 1.5 / 2.75
        return 7.5625 * rtime * rtime + 0.75
    } else if (time < 2.5 / 2.75) {
        let stime = time - 2.25 / 2.75
        return 7.5625 * stime * stime + 0.9375
    }
    
    let utime = time - 2.625 / 2.75
    return 7.5625 * utime * utime + 0.984375
}

func bounceIn(time: Double) -> Double {
    return 1 - bounceOut(time: 1 - time)
}

func bounceInOut(time: Double) -> Double {
    if time < 0.5 {
        let time = time * 2
        return (1 - bounceOut(time: 1 - time)) * 0.5
    }
    return bounceOut(time: time * 2 - 1) * 0.5 + 0.5
}

func sineOut(time: Double) -> Double {
    sin (time * .pi/2)
}

func sineIn(time: Double) -> Double {
    -1 * cos(time * .pi/2) + 1
}

func sineInOut(time: Double) -> Double {
    -0.5 * (cos(.pi * time) - 1)
}

func exponentialOut(time: Double) -> Double {
    time == 1 ? 1 : (-pow(2, -10 * time / 1) + 1)
}

func exponentialIn(time: Double) -> Double {
    time == 0 ? 0 : pow(2, 10 * (time / 1 - 1)) - 1 * 0.001
}

func exponentialInOut(time: Double) -> Double {
    let time = time / 0.5
    if time < 1 {
        return 0.5 * pow(2, 10 * (time - 1))
    } else {
        return 0.5 * (-pow(2, -10 * (time - 1)) + 2)
    }
}

func elasticIn(time: Double, period: Double) -> Double {
    if time == 0 || time == 1 {
        return time
    } else {
        let s = period / 4
        let rtime = time - 1
        return -(pow(2, 10 * rtime) * sin((rtime - s) * .pi * 2 / period))
    }
}

func elasticOut(time: Double, period: Double) -> Double {
    if time == 0 || time == 1 {
        return time
    } else {
        let s = period / 4
        return pow (2, -10 * time) * sin((time - s) * .pi * 2 / period) + 1
    }
}

func elasticInOut(time: Double, period: Double) -> Double {
    if time == 0 || time == 1 {
        return time
    } else {
        let time = time * 2 - 1
        let period = period == 0 ? 0.3 * 1.5 : period
        let s = period / 4
        
        if time < 0 {
            return (-0.5 * pow(2, 10 * time) * sin((time - s) * .pi * 2 / period))
        } else {
            return pow(2, -10 * time) * sin((time - s) * .pi*2 / period) * 0.5 + 1
        }
    }
}
