//
//  Filter.swift
//  ZoeyApp
//
//  Created by Hien Tran on 7/2/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import Foundation

class FilterZoey {
    private var resonance: Double
    private var frequency: Double
    private var sampleRate: Int
    private var passType: PassType
    
    private var c, a1, a2, a3, b1, b2: Double
    
    //Array of input values, newest is the first one
    private var inputHistory: [Double] = Array(repeating: 0.0, count: 2)
    
    //Array of output values, newest is the first one
    private var outputHistory: [Double] = Array(repeating: 0.0, count: 3)
    
    enum PassType {
        case Highpass
        case Lowpass
    }
    
    init(frequency: Double, sampleRate: Int, passType: PassType, resonance: Double) {
        self.frequency = frequency
        self.sampleRate = sampleRate
        self.passType = passType
        self.resonance = resonance
        
        switch self.passType {
        case .Lowpass:
            c = 1.0 / tan(Double.pi * frequency / Double(sampleRate))
            a1 = 1.0 / (1.0 + resonance * c + c * c)
            a2 = 2.0 * a1
            a3 = a1
            b1 = 2.0 * (1.0 - c * c) * a1
            b2 = (1.0 - resonance * c + c * c) * a1
        default:
            c = tan(Double.pi * frequency / Double(sampleRate))
            a1 = 1.0 / (1.0 + resonance * c + c * c)
            a2 = -2.0 * a1
            a3 = a1
            b1 = 2.0 * (c * c - 1.0) * a1
            b2 = (1.0 - resonance * c + c * c) * a1

        }
    }
    
    func updateValue(newInput: Double) {
        let newOutput = a1 * newInput + a2 * self.inputHistory[0] + a3 * self.inputHistory[1] - b1 * self.outputHistory[0] - b2 * self.outputHistory[1]
        
        self.inputHistory[1] = self.inputHistory[0]
        self.inputHistory[0] = newInput
        
        self.outputHistory[2] = self.outputHistory[1]
        self.outputHistory[1] = self.outputHistory[0]
        self.outputHistory[0] = newOutput
    }
    
    func getValue() -> Double {
        return self.outputHistory[0]
    }
}
