//
//  Util.swift
//  MetawearGuide
//
//  Created by Hien Tran on 24/1/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import Foundation
import AIToolbox

protocol Numberic{}

extension Float: Numberic{}

extension Int: Numberic{}

extension Double: Numberic{}

extension Array where Element : Collection {
    func getColumn(column : Element.Index) -> [ Element.Iterator.Element ] {
        return self.map { $0[ column ] }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Array where Element: FloatingPoint {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

class Util {
    init() {
    }
    
    func getMS(array: [Double]) -> Double {
        let nums = array
        var returnVal = 0.0
        for val in nums {
            returnVal += (val * val)
        }
        returnVal = returnVal/Double(nums.count)
//        let returnVal = Surge.measq(nums)
        print("RMS is: \(returnVal)")
        return returnVal
    }
    
    func initFeatVec(count: Int, val: Numberic) -> [Numberic] {
        return [Numberic](repeating: val, count: count)
    }
    
    
    func avgAxisValue(data: [[Double]]) -> [Double] {
        var returnArr = [Double]()
    
        for axis in 0...2 {
            var col = [Double]()
    
                //get the column
            col = data.getColumn(column: axis)
    
                // get the avg
            let axisAvg = col.average
    
                // round to 4 number after decimal point and assign to vector
            returnArr.append(axisAvg.roundTo(places: 4))
            
            print("The column data is: \(col)")
            print("The avg value is: \(axisAvg))")
            
            }
            
            return returnArr
        }
    
    func rootMeanSquareAxisVals(data: [[Double]]) -> [Double] {
        
        var returnArray = [Double]()
    
        for axis in 0...2 {
            var col = [Double]()
    
                //get the column
            col = data.getColumn(column: axis)
    
                // get root mean square
            let meanS_Axis = getMS(array: col)
    
            let rms_Axis = sqrt(meanS_Axis)
    
                // round to 4 number after decimal point and assign to vector
            returnArray.append(rms_Axis.roundTo(places: 4))
    
            print("The column data is: \(col)")
            print("The avg value is: \(rms_Axis)")
                
            }
            
            return returnArray
        }
    
    func combineToFeatures(accels: [[Double]], gyros: [[Double]]) -> [[Double]] {
        let accel_length: Int = accels.capacity
        let gyro_length: Int = gyros.count
    
        let standard_length: Int!
    
        if accel_length < gyro_length {
            standard_length = accel_length
        } else {
            standard_length = gyro_length
        }
        
        print("Standard Length: \(standard_length)")
    
        var featuresSet: [[Double]] = [[Double]]()
    
        for i in 0...standard_length-1 {
            var singleDataSet = [Double]()
            singleDataSet.append(contentsOf: accels[i])
            singleDataSet.append(contentsOf: gyros[i])
            featuresSet.append(singleDataSet)
        }
        return featuresSet
    }

    
//    func extractFeatures(data : [[Double]], frequency: Double) -> [Double] {
//        // init the feature vector
//        //        var featVec = initFeatVec(count: 66, val: 0.0) as! [Double]
//        var featVec = [Double]()
//        //        featVec[0...2] =
//        
//        //featVect[0...2]
//        // get the average data for x, y, z of accel or gyro
//        featVec.append(contentsOf: (avgAxisValue(data: data)))
//        
//        
//        //doing gravity removal
//        let newData = filterOut(data: data)
//        
//        //featVect[3...5]
//        //do the rms for the value of each axis
//        featVec.append(contentsOf: (rootMeanSquareAxisVals(data: newData)))
//        
//        ////featVect[6...14]
//        ////Autocorrelation features for all three acceleration components (3 each): height of main peak; height and position of second peak
//        //        featVec.append(contentsOf: (autocorrFeatures(data: newData, frequency: frequency)))
//        
//        ////featVect[15...50]
//        ////Spectral peak features (12 each): height and position of first 6 peaks
//        //        featVec.append(contentsOf: (spectralPeaksFeatures(data: newData, frequency: frequency)))
//        
//        ////featVect[51...65]
//        ////Spectral power features (5 each): total power in 5 adjacent
//        //        featVec.append(contentsOf: (spectralPowerFeatures(data: newData, frequency: frequency)))
//        
//        return featVec
//    }
    

//
//    func filterOut(data: [[Double]]) -> [[Double]] {
//        var tempData = data
//        return tempData
//    }
    
    //    func autocorrFeatures(data: [[Double]], frequency: Double) -> [Double] {
    //
    //        var returnArry = [Double]()
    //
    //        var minprom = 0.0005
    //
    //        var mindist_xunits = 0.3
    //
    //        var minpkdist = Surge.floor(mindist_xunits/(1/frequency))
    //
    //        //Separate peak analysis for 3 different channels
    //        for k in 1...3 {
    //
    //        }
    //
    //        return [Double]()
    //    }
    
    //    func spectralPeaksFeatures(data: [[Double]], frequency: Double) -> [Double] {
    //        return [Double]()
    //    }
    //
    //    func spectralPowerFeatures(data: [[Double]], frequency: Double) -> [Double] {
    //        return [Double]()
    //    }
    //
    //    func crossCorr() -> <#return type#> {
    //        <#function body#>
    //    }
    //
    //    func testingRegressionAIToolbox() {
    //
    //        //training part
    //        let trainData = DataSet(dataType: .regression, inputDimension: 1, outputDimension: 1)
    //
    //        do {
    //            try trainData.addDataPoint(input: [1.0], output: [8.3])
    //            try trainData.addDataPoint(input: [2.0], output: [11.0])
    //            try trainData.addDataPoint(input: [3.0], output: [14.7])
    //            try trainData.addDataPoint(input: [4.0], output: [19.7])
    //            try trainData.addDataPoint(input: [5.0], output: [26.7])
    //            try trainData.addDataPoint(input: [6.0], output: [35.2])
    //            try trainData.addDataPoint(input: [7.0], output: [44.4])
    //            try trainData.addDataPoint(input: [8.0], output: [55.9])
    //        } catch {
    //            print("error creating training data")
    //        }
    //
    //        //model creation
    //        let lr = LinearRegressionModel(inputSize: 1, outputSize: 1, polygonOrder: 1)
    //
    //        do{
    //           try lr.trainRegressor(trainData)
    //        } catch {
    //            print("Linear Regression Training Error")
    //        }
    //
    //        //testing part
    //        let testData = DataSet(dataType: .regression, inputDimension: 1, outputDimension: 1)
    //        do {
    //            try testData.addTestDataPoint(input: [-5.0])
    //            try testData.addTestDataPoint(input: [9.0])
    //            try testData.addTestDataPoint(input: [17.0])
    //            try testData.addTestDataPoint(input: [0.0])
    //        }
    //        catch {
    //            print("Invalid test data set created")
    //        }
    //
    ////        getting result
    //
    //        do {
    //            try lr.predict(testData)
    //        }
    //        catch {
    //            print("Error having linear regression calculate results")
    //        }
    //
    //        //  Use the results
    //        do {
    ////            let result = try testData.getOutput(0)  //  Get first result
    //            for index in 0...testData.size-1 {
    //                let result = try testData.getOutput(index)[0].roundTo(places: 4)
    //                print("The result is: \(result)")
    //            }
    //        }
    //        catch {
    //            print("Error getting results from data set")
    //        }
    //    }
    //
        func classificationAIToolbox() {
    
           let trainData = DataSet(dataType: .classification, inputDimension: 2, outputDimension: 1)
            do {
                try trainData.addDataPoint(input: [0.2, 0.9], dataClass:0)
                try trainData.addDataPoint(input: [0.8, 0.3], dataClass:0)
                try trainData.addDataPoint(input: [0.5, 0.6], dataClass:0)
                try trainData.addDataPoint(input: [0.2, 0.7], dataClass:1)
                try trainData.addDataPoint(input: [0.2, 0.3], dataClass:1)
                try trainData.addDataPoint(input: [0.4, 0.5], dataClass:1)
                try trainData.addDataPoint(input: [0.5, 0.4], dataClass:2)
                try trainData.addDataPoint(input: [0.3, 0.2], dataClass:2)
                try trainData.addDataPoint(input: [0.7, 0.2], dataClass:2)
            }
            catch {
                print("error creating training data")
            }
            //  Create a model
            let svm = SVMModel(problemType: .c_SVM_Classification, kernelSettings: KernelParameters(type: .linear, degree: 0, gamma: 0.5, coef0: 0.0))
    
            //  Train the model
            do {
    //            try svm.train(trainData)
                try svm.trainClassifier(trainData)
            }
            catch let error as Error {
                print("SVM Training error is: \(error)")
            }
    
            //  Create a data set with the sequence
            let testData = DataSet(dataType: .classification, inputDimension: 2, outputDimension: 1)
            do {
                try testData.addTestDataPoint(input: [0.7, 0.6])
                try testData.addTestDataPoint(input: [0.5, 0.7])
                try testData.addTestDataPoint(input: [0.1, 0.6])
                try testData.addTestDataPoint(input: [0.1, 0.4])
                try testData.addTestDataPoint(input: [0.3, 0.1])
                try testData.addTestDataPoint(input: [0.7, 0.1])
            }
            catch {
                print("Invalid test data set created")
            }
    
            do {
                try svm.classify(<#T##testData: MLClassificationDataSet##MLClassificationDataSet#>)
//                try svm.classify(testData)
    //            try svm.predictValues(trainData)
            }
            catch let error as Error {
                print("Error having SVM calculate results, with Error is: \(error)")
            }
            
            //  Use the results
            do {
                for index in 0...testData.size-1 {
                    let result = try testData.getClass(index)
                    let input = try testData.getInput(index)
                    print("The value is: \(input) and result is: \(result)")
                }
            } catch {
                print("Error getting results from data set")
            }
    }
    
}
