//
//  obliqueShockWave.swift
//  Created by Gregory Manley on 11/25/22.
//  Updated by Gregory Manley on 11/30/22.
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

let PI = 3.14159265359
var oSWWarning = ""

class obliqueShockWave {
    var gamma: Double
    
    var mach1: Double
    var mach2: Double
    
    var p2p1ratio: Double
    var t2t1ratio: Double
    var rho2rho1ratio: Double
    var p02p01ratio: Double
    
    var turnAngle: Double
    var waveAngle: Double
    
    var m1n: Double
    var m2n: Double
    
    convenience init() { self.init(mach1: 0.0, gamma: 0.0, angle: 0.0, index: 0) }
    
    init(mach1: Double, gamma: Double, angle: Double, index: Int) {
        oSWWarning = ""

        var delta: Double
        var beta: Double
        
        self.gamma = gamma
        self.mach1 = mach1
        
        if (index == 1 || index == 0) {
            delta = angle * (PI/180)
            
            if (delta >= PI/2) {
                oSWWarning = "Turning angle too large"
            }
            
            if (delta <= 0.0) {
                oSWWarning = "Turning angle must be greater than zero"
            }
            
            beta = mdb(g: self.gamma,m1: self.mach1,d: delta,i: index)
            
            if (beta < 0.0) {
                  oSWWarning = "Shock Detached"
            }
        } else if (index == 2) {
            beta = angle * (PI/180)
            
            if (beta >= PI/2) {
                  oSWWarning = "Wave angle must be less than 90 deg."
            }
            if (beta-asin(1/self.mach1) <= 0.0) {
                  oSWWarning = "Wave angle must be greater than Mach angle"
            }
            
            delta = mbd(g: self.gamma,m1: self.mach1,b: beta)
        } else if (index == 3) {
            self.m1n = angle
    
            if (self.m1n<=1.0 || self.m1n>=self.mach1) {
                oSWWarning = "M1n must be between 1 and M1"
            }
            beta = asin(m1n / self.mach1)
            delta = mbd(g: self.gamma,m1: self.mach1,b: beta)
        } else {
            delta = 0
            beta = 0
        }
        
        self.turnAngle = delta * 180/PI
        self.waveAngle = beta * 180/PI
        self.m1n = self.mach1 * sin(beta)
        self.m2n = sqrt((1 + 0.5 * (self.gamma - 1) * self.m1n * self.m1n) / (self.gamma * self.m1n * self.m1n - 0.5 * (self.gamma - 1)))
        self.mach2 = self.m2n / sin(beta-delta)
        self.p2p1ratio = 1+2*self.gamma/(self.gamma+1)*(self.m1n*self.m1n-1)
        self.p02p01ratio = pp0(g: self.gamma,m: self.m1n)/pp0(g: self.gamma,m: m2(g: self.gamma,m1: self.m1n))*self.p2p1ratio
        self.t2t1ratio = tt0(g: self.gamma,m: m2(g: self.gamma,m1: self.m1n))/tt0(g: self.gamma,m: self.m1n)
        self.rho2rho1ratio = rr0(g: self.gamma,m: m2(g: self.gamma,m1: self.m1n))/rr0(g: self.gamma,m: self.m1n)*self.p02p01ratio
    }
    
    var debugDescription: String {
        let mirror = Mirror(reflecting: self)
        var debugString = "---------------------------------------"
        debugString += "\nAll angles in degrees"
        mirror.children.forEach {
            debugString += "\n\($0.label ?? ""): \($0.value)"
        }
        
        debugString += "\n---------------------------------------"
        
        return debugString
    }
    
    func reInit(mach1: Double, gamma: Double, angle: Double, index: Int) {
        oSWWarning = ""

        var delta: Double
        var beta: Double
        
        self.gamma = gamma
        self.mach1 = mach1
        
        if (index == 1 || index == 0) {
            delta = angle * (PI/180)
            
            if (delta >= PI/2) {
                oSWWarning = "Turning angle too large"
            }
            
            if (delta <= 0.0) {
                oSWWarning = "Turning angle must be greater than zero"
            }
            
            beta = mdb(g: self.gamma,m1: self.mach1,d: delta,i: index)
            
            if (beta < 0.0) {
                  oSWWarning = "Shock Detached"
            }
        } else if (index == 2) {
            beta = angle * (PI/180)
            
            if (beta >= PI/2) {
                  oSWWarning = "Wave angle must be less than 90 deg."
            }
          
            if (beta-asin(1/self.mach1) <= 0.0) {
                  oSWWarning = "Wave angle must be greater than Mach angle"
            }
            
            delta = mbd(g: self.gamma,m1: self.mach1,b: beta)
        } else if (index == 3) {
            self.m1n = angle
    
            if (self.m1n<=1.0 || self.m1n>=self.mach1) {
                oSWWarning = "M1n must be between 1 and M1"
            }
            beta = asin(m1n / self.mach1)
            delta = mbd(g: self.gamma,m1: self.mach1,b: beta)
        } else {
            delta = 0
            beta = 0
        }
        
        self.turnAngle = delta * 180/PI
        self.waveAngle = beta * 180/PI
        self.m1n = self.mach1 * sin(beta)
        self.m2n = sqrt((1 + 0.5 * (self.gamma - 1) * self.m1n * self.m1n) / (self.gamma * self.m1n * self.m1n - 0.5 * (self.gamma - 1)))
        self.mach2 = self.m2n / sin(beta-delta)
        self.p2p1ratio = 1+2*self.gamma/(self.gamma+1)*(self.m1n*self.m1n-1)
        self.p02p01ratio = pp0(g: self.gamma,m: self.m1n)/pp0(g: self.gamma,m: m2(g: self.gamma,m1: self.m1n))*self.p2p1ratio
        self.t2t1ratio = tt0(g: self.gamma,m: m2(g: self.gamma,m1: self.m1n))/tt0(g: self.gamma,m: self.m1n)
        self.rho2rho1ratio = rr0(g: self.gamma,m: m2(g: self.gamma,m1: self.m1n))/rr0(g: self.gamma,m: self.m1n)*self.p02p01ratio

    }
}

func mdb(g: Double,m1: Double,d: Double,i: Int) -> Double {
    let p = -(m1*m1+2)/m1/m1-g*sin(d)*sin(d)
    let q = (2*m1*m1+1)/pow(m1,4)+((g+1)*(g+1)/4+(g-1)/m1/m1)*sin(d)*sin(d)
    let r = -cos(d)*cos(d)/pow(m1,4)
    let a=(3*q-p*p)/3
    let b=(2*p*p*p-9*p*q+27*r)/27
    let test=b*b/4+a*a*a/27
  
    var x1: Double = 0.0
    var x2: Double = 0.0
    var x3: Double = 0.0

    if (test>0.0) {
        return -1.0
    } else {
        if(test==0.0) {
             x1=sqrt(-a/3)
             x2=x1
             x3=2*x1
            if(b>0.0) {
              x1 *= -1
              x2 *= -1
              x3 *= -1
            }
         }
    if(test<0.0) {
        let phi=acos(sqrt(-27*b*b/4/a/a/a))
      x1=2*sqrt(-a/3)*cos(phi/3)
      x2=2*sqrt(-a/3)*cos(phi/3+3.14159265359*2/3)
      x3=2*sqrt(-a/3)*cos(phi/3+3.14159265359*4/3)
      if(b>0.0) {
        x1 *= -1
        x2 *= -1
        x3 *= -1
      }
    }
    
      let s1=x1-p/3
      let s2=x2-p/3
      let s3=x3-p/3
    var t1: Double
    var t2: Double
      
    if(s1<s2 && s1<s3) {
      t1=s2
      t2=s3
    } else if(s2<s1 && s2<s3) {
      t1=s1
      t2=s3
    } else {
      t1=s1
      t2=s2
    }

      let b1=asin(sqrt(t1))
      let b2=asin(sqrt(t2))
    var betas=b1
    var betaw=b2
      
    if (b2>b1) {
      betas=b2
      betaw=b1
    }
    
    if (i==0) {return betaw}
    if (i==1) {return betas}
  }
    return 0.0
}


func tt0(g: Double,m: Double) -> Double {
   return pow((1+(g-1)/2*m*m),-1)
}

func m2(g: Double,m1: Double) -> Double {
    return sqrt((1 + 0.5 * (g - 1) * m1 * m1) / (g * m1 * m1 - 0.5 * (g - 1)))
}

func pp0(g: Double,m: Double) -> Double {
   return pow((1+(g-1)/2*m*m),-g/(g-1))
}

func rr0(g: Double,m: Double) -> Double {
   return pow((1+(g-1)/2*m*m),-1/(g-1))
}

func findIndex(array: [String], value: String) -> Int {
    var count = 0
    
    for str in array {
        if (str == value) {
            return count
        }
        
        count += 1
    }
    
    return -1
}



