//
//  EnumerationClass.swift
//  ZoeyApp
//
//  Created by Hien Tran on 6/2/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import Foundation

class EnumerationClass {
    
    enum Excercise: Int {
        case Heelslide = 0
        case HipAb = 1
        case HipEx = 2
        case HipFlex = 3
        case Inner = 4
        case Knee = 5
        case LegLift = 6
    }
    
    enum MachineLearningAlgorithm: String {
        case SVM = "Support Vector Machine"
        case NN = "Neuron Network"
        case LR = "Logistic Regression"
    }
    
}
