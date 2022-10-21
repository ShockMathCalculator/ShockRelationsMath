//
//  normalShockWaveMath.swift
//  Created by Gregory Manley on 9/22/22.
//  Updated by Gregory Manley on 10/20/22.
//
//  This source code is licensed under the license found in LICENSE file in
//  the root directory of this repo
//  
/*
###############################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGGGGGGGGGGGGGGGGGGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGGGGGGGGGGGGGGGGGGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG@@@@@@@@@@GGGGGGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG@@@@@@@@@@GGGGGGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@GGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGGGGGGGGGGGGGGGGGGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@GGGGGGGGGGGGGGGGGGGG@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMMM@@@@@@@@@@@@MMMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMMMM@@@@@@@@@@MMMMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMMMMM@@@@@@@@MMMMMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@MMM@@@@@@MMM@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@@MMM@@@@MMM@@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@@@MMM@@MMM@@@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@@@@MMMMMM@@@@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@MMM@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
###############################################################################
*/
import Foundation

class normalShockWave {
    var gamma: Double
    var mach1: Double
    var mach2: Double
    var p2p1ratio: Double
    var t2t1ratio: Double
    var rho2rho1ratio: Double
    
    // allow a backup initializer
    convenience init() { self.init(mach1: 0.0, gamma: 0.0) }
    
    // Default initializer 
    init(mach1: Double, gamma: Double) {
        self.gamma = gamma
        
        self.mach1 = mach1
        self.mach2 = sqrt(((gamma - 1.0) * (mach1*mach1) + 2.0) / ((2 *  gamma * (mach1*mach1)) - (gamma - 1)))
        
        self.p2p1ratio = ((2 * gamma * (mach1*mach1)) - (gamma - 1)) / (gamma + 1)
        self.t2t1ratio = (((2 * gamma * (mach1*mach1)) - (gamma - 1)) * (((gamma - 1) * (mach1*mach1)) + 2)) / (((gamma + 1)*(gamma + 1))*(mach1*mach1))
        self.rho2rho1ratio = ((gamma + 1)*(mach1*mach1)) / (((gamma - 1) * (mach1*mach1)) + 2)
    }
    
    // Debug output, shows all variables and values
    var debugDescription: String {
        let mirror = Mirror(reflecting: self)
        var debugString = "---------------------------------------"
        mirror.children.forEach {
            debugString += "\n\($0.label ?? ""): \($0.value)"
        }
        
        debugString += "\n---------------------------------------"
        
        return debugString
    }
    
    // Master reinitialization function, recalculates all values based upon gamma and mach 1
    func reInit(mach1: Double, gamma: Double) {
        self.gamma = gamma
        
        self.mach1 = mach1
        self.mach2 = sqrt(((gamma - 1.0) * (mach1*mach1) + 2.0) / ((2 * gamma * (mach1*mach1)) - (gamma - 1)))

        self.p2p1ratio = ((2 * gamma * (mach1*mach1)) - (gamma - 1)) / (gamma + 1)
        self.t2t1ratio = (((2 * gamma * (mach1*mach1)) - (gamma - 1)) * (((gamma - 1) * (mach1*mach1)) + 2)) / (((gamma + 1)*(gamma + 1))*(mach1*mach1))
        self.rho2rho1ratio = ((gamma + 1)*(mach1*mach1)) / (((gamma - 1) * (mach1*mach1)) + 2)
    }
    
    // Calculate all other values from density ratio
    func reInit(rho2rho1ratio: Double, gamma: Double) {
        self.gamma = gamma
        
        self.mach1 = sqrt(2*rho2rho1ratio/(gamma+1-rho2rho1ratio*(gamma-1)))
        
        reInit(mach1: self.mach1, gamma: self.gamma)
    }

    // Calculate all other values from temperature ratio
    func reInit(t2t1ratio: Double, gamma: Double) {
        self.gamma = gamma
        
        let aa = 2*gamma*(gamma-1)
        let bb = 4*gamma-(gamma-1)*(gamma-1)-t2t1ratio*(gamma+1)*(gamma+1)
        let cc = -2*(gamma-1)
        
        self.mach1 = sqrt((-bb+sqrt(bb*bb-4*aa*cc))/2/aa)
        
        reInit(mach1: self.mach1, gamma: self.gamma)
    }
    
    // Calculate all other values from pressure ratio
    func reInit(p2p1ratio: Double, gamma: Double) {
        self.gamma = gamma
        
        self.mach1 = sqrt((p2p1ratio-1)*(gamma+1)/2/gamma+1)
        
        reInit(mach1: self.mach1, gamma: self.gamma)
    }
    
    // Calculate all other values from mach 2
    func reInit(mach2: Double, gamma: Double) {
        self.gamma = gamma
        
        // TODO: optimize function to calculate mach 1 from mach 2, current best is below
        self.mach1 = calcMachFromOtherValue(f: calcMach2, target: mach2, gamma: gamma, range: 9999999999)
        
        reInit(mach1: self.mach1, gamma: self.gamma)
    }
}

// Calculate density ratio using mach 1 and gamma
func calcRho2Rho1(mach1: Double, gamma: Double) -> Double {
    return (gamma + 1) * pow(mach1, 2) / (2 + (gamma - 1) * pow(mach1, 2))
}

// Calculate temperature ratio using mach 1 and gamma
func calcT2T1(mach1: Double, gamma: Double) -> Double {
    return (((2 * gamma * (mach1*mach1)) - (gamma - 1)) * (((gamma - 1) * (mach1*mach1)) + 2)) / (((gamma + 1)*(gamma + 1))*(mach1*mach1))
}

// Calculate pressure ratio using mach 1 and gamma
func calcP2P1(mach1: Double, gamma: Double) -> Double {
    return ((2 * gamma * (mach1*mach1)) - (gamma - 1)) / (gamma + 1)
}

// Calculate mach 2 ratio using mach 1 and gamma
func calcMach2(mach1: Double, gamma: Double) -> Double {
    return sqrt(((gamma - 1.0) * (mach1*mach1) + 2.0) / ((2 *  gamma * (mach1*mach1)) - (gamma - 1)))
}

// Brute force method, backup method if no other exists
func calcMachFromOtherValue(f: (Double, Double) -> Double, target: Double, gamma: Double, range: Double) -> Double {
    let biggerTol = 1000000.0; let highTol = 100.0; let btol = 1.0; let atol = 0.001; let stol = 0.00001
    var answer = 0.0
    
    for i in stride(from: 1, to: range, by: biggerTol) {
        answer = f(i, gamma)
        if (abs(answer - rho2rho1) < biggerTol) {
            for i in stride(from: 1, to: (i+biggerTol), by: highTol) {
                answer = f(i, gamma)
                if (abs(answer - rho2rho1) < highTol) {
                    for i in stride(from: 1, to: (i+highTol), by: btol) {
                        answer = f(i, gamma)
                        if (abs(answer - rho2rho1) < btol) {
                            for i in stride(from: 1, to: (i+btol), by: atol) {
                                answer = f(i, gamma)
                                if (abs(answer - rho2rho1) < atol) {
                                    for i in stride(from: (i-atol), to: (i+atol), by: stol) {
                                        answer = f(i, gamma)
                                        if (abs(answer - rho2rho1) < stol) {
                                            for i in stride(from: (i-stol), to: (i+stol), by: 0.000000001) {
                                                answer = f(i, gamma)
                                                if (abs(answer - rho2rho1) < 0.000000001) {
                                                    return abs(i)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    return 0.0
}
