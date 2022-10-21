#
# normalShockWave.py
# Created by Grgory Manley on 10/20/2022
# Updated by Gregory Manley on 10/20/2022
#
# This source code is liensed under the license found in the LICENSE file in 
# the root directory of this source tree.
#
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
import math

class normalShockWave:
    # Default initializer
    def __init__(self, mach1, gamma):
        self.gamma = gamma
        
        self.mach1 = mach1
        self.mach2 = math.sqrt(((gamma - 1.0) * (mach1*mach1) + 2.0) / ((2 *  gamma * (mach1*mach1)) - (gamma - 1)))
        
        self.p2p1ratio = ((2 * gamma * (mach1*mach1)) - (gamma - 1)) / (gamma + 1)
        self.t2t1ratio = (((2 * gamma * (mach1*mach1)) - (gamma - 1)) * (((gamma - 1) * (mach1*mach1)) + 2)) / (((gamma + 1)*(gamma + 1))*(mach1*mach1))
        self.rho2rho1ratio = ((gamma + 1)*(mach1*mach1)) / (((gamma - 1) * (mach1*mach1)) + 2)

    # String output for all variables and values
    def __str__(self):
        valueSeparator = "---------------------------------------"

        return f"{valueSeparator}\ngamma: {self.gamma}\nmach1: {self.mach1}\nmach2: {self.mach2}\np2p1ratio: {self.p2p1ratio}\nt2t1ratio: {self.t2t1ratio}\nrho2rho1ratio: {self.rho2rho1ratio}\n{valueSeparator}\n"

    def reInit(self, mach1, gamma):
        self.gamma = gamma
        
        self.mach1 = mach1
        self.mach2 = math.sqrt(((gamma - 1.0) * (mach1*mach1) + 2.0) / ((2 * gamma * (mach1*mach1)) - (gamma - 1)))

        self.p2p1ratio = ((2 * gamma * (mach1*mach1)) - (gamma - 1)) / (gamma + 1)
        self.t2t1ratio = (((2 * gamma * (mach1*mach1)) - (gamma - 1)) * (((gamma - 1) * (mach1*mach1)) + 2)) / (((gamma + 1)*(gamma + 1))*(mach1*mach1))
        self.rho2rho1ratio = ((gamma + 1)*(mach1*mach1)) / (((gamma - 1) * (mach1*mach1)) + 2)

    def reInitRho(self, rho2rho1ratio, gamma):
        self.gamma = gamma
        
        self.mach1 = math.sqrt(2*rho2rho1ratio/(gamma+1-rho2rho1ratio*(gamma-1)))
         
        self.reInit(self.mach1, self.gamma)

    def reInitT(self, t2t1ratio, gamma):
        self.gamma = gamma
        
        aa = 2*gamma*(gamma-1)
        bb = 4*gamma-(gamma-1)*(gamma-1)-t2t1ratio*(gamma+1)*(gamma+1)
        cc = -2*(gamma-1)
        
        self.mach1 = math.sqrt((-bb+sqrt(bb*bb-4*aa*cc))/2/aa)
        
        self.reInit(self.mach1, self.gamma)


    def reInitP(self, p2p1ratio, gamma):
        self.gamma = gamma
        
        self.mach1 = sqrt((p2p1ratio-1)*(gamma+1)/2/gamma+1)
        
        self.reInit(self.mach1, self.gamma)

    def reInitM2(self, mach2, gamma):
        self.gamma = gamma
        
        # TODO: optimize function to calculate mach 1 from mach 2, current best is below
        self.mach1 = calcMachFromOtherValue(calcMach2, mach2, gamma, 9999999999)
        
        self.reInit(self.mach1, self.gamma)

def calcRho2Rho1(mach1, gamma):
    return (gamma + 1) * pow(mach1, 2) / (2 + (gamma - 1) * pow(mach1, 2))

def calcT2T1(mach1, gamma):
    return (((2 * gamma * (mach1*mach1)) - (gamma - 1)) * (((gamma - 1) * (mach1*mach1)) + 2)) / (((gamma + 1)*(gamma + 1))*(mach1*mach1))

def calcP2P1(mach1, gamma):
    return ((2 * gamma * (mach1*mach1)) - (gamma - 1)) / (gamma + 1)

def calcMach2(mach1, gamma):
    return math.sqrt(((gamma - 1.0) * (mach1*mach1) + 2.0) / ((2 *  gamma * (mach1*mach1)) - (gamma - 1)))

def calcMachFromOtherValue(f, target, gamma, range):
    biggerTol = 1000000.0; highTol = 100.0; btol = 1.0; atol= 0.001; stol = 0.00001
    answer = 0.0

    for i in range(1, range, biggerTol):
        answer = f(i, gamma)
        if (abs(answer - target) < biggerTol):
            for i in range(1, i+biggerTol, highTol):
                answer = f(i, gamma)
                if (abs(answer - target) < highTol):
                    for i in range(1, i+highTol, btol):
                        answer = f(i, gamma)
                        if (abs(answer - target) < btol):
                            for i in range(1, i+btol, atol):
                                answer = f(i, gamma)
                                if (abs(answer - target) < atol):
                                    for i in range(i-atol, i+atol, stol):
                                        answer = f(i, gamma)
                                        if (abs(answer - target) < stol):
                                            for i in range(i-stol, i+stol, 0.000000001):
                                                answer = f(i, gamma)
                                                if (abs(answer - target) < 0.000000001):
                                                    return abs(i)

    return 0.0
