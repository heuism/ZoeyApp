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
//        print("RMS is: \(returnVal)")
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
            print("The RMS value is: \(rms_Axis)")
                
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

    
    func extractFeatures(data : [[Double]], frequency: Double, sampleRate: Int) -> [Double] {
        // init the feature vector
        //        var featVec = initFeatVec(count: 66, val: 0.0) as! [Double]
        var featVec = [Double]()
        //        featVec[0...2] =
        
        //featVect[0...2]
        // get the average data for x, y, z of accel or gyro
        featVec.append(contentsOf: (avgAxisValue(data: data)))
        
        
        //doing gravity removal
        let newData = filterOut(data: data, frequency: frequency, sampleRate: sampleRate)
        
        //featVect[3...5]
        //do the rms for the value of each axis
        featVec.append(contentsOf: (rootMeanSquareAxisVals(data: newData)))
        
        ////featVect[6...14]
        ////Autocorrelation features for all three acceleration components (3 each): height of main peak; height and position of second peak
        //        featVec.append(contentsOf: (autocorrFeatures(data: newData, frequency: frequency)))
        
        ////featVect[15...50]
        ////Spectral peak features (12 each): height and position of first 6 peaks
        //        featVec.append(contentsOf: (spectralPeaksFeatures(data: newData, frequency: frequency)))
        
        ////featVect[51...65]
        ////Spectral power features (5 each): total power in 5 adjacent
        //        featVec.append(contentsOf: (spectralPowerFeatures(data: newData, frequency: frequency)))
        
        return featVec
    }
    
    func transpose<T>(input: [[T]]) -> [[T]] {
        if input.isEmpty { return [[T]]() }
        let count = input[0].count
        var out = [[T]](repeating: [T](), count: count)
        for outer in input {
            for (index, inner) in outer.enumerated() {
                out[index].append(inner)
            }
        }
        
        return out
    }
    
    func filterOutSupport(filter: FilterZoey, data: [Double]) -> [Double] {
        
        var array = data
        
        var filteredArr = Array(repeating: 0.0, count: array.count)
        
        for i in 0..<array.count {
            filter.updateValue(newInput: array[i])
            filteredArr[i] = filter.getValue()
        }
        print("The array afater filter is: \(filteredArr)");
        return filteredArr
    }
    
    func filterOut(data: [[Double]], frequency: Double, sampleRate: Int) -> [[Double]] {
        var tempData = data
        var filterdData = [[Double]]()
        
        let filter = FilterZoey(frequency: frequency, sampleRate: sampleRate, passType: FilterZoey.PassType.Highpass, resonance: 1.0)
       
        for axis in 0...2 {
            var col = [Double]()
            
            //get the column
            col = data.getColumn(column: axis)
            
            filterdData.append(filterOutSupport(filter: filter, data: col))
        }
        
        filterdData = transpose(input: filterdData)
        
        return filterdData
    }
    
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
        func regressionAIToolbox() {
    
            //training part
            let trainData = DataSet(dataType: .regression, inputDimension: 1, outputDimension: 1)
    
            do {
                try trainData.addDataPoint(input: [1.0], output: [8.3])
                try trainData.addDataPoint(input: [2.0], output: [11.0])
                try trainData.addDataPoint(input: [3.0], output: [14.7])
                try trainData.addDataPoint(input: [4.0], output: [19.7])
                try trainData.addDataPoint(input: [5.0], output: [26.7])
                try trainData.addDataPoint(input: [6.0], output: [35.2])
                try trainData.addDataPoint(input: [7.0], output: [44.4])
                try trainData.addDataPoint(input: [8.0], output: [55.9])
            } catch {
                print("error creating training data")
            }
    
            //model creation
            let lr = LinearRegressionModel(inputSize: 1, outputSize: 1, polygonOrder: 1)
    
            do{
               try lr.trainRegressor(trainData)
            } catch {
                print("Linear Regression Training Error")
            }
    
            //testing part
            let testData = DataSet(dataType: .regression, inputDimension: 1, outputDimension: 1)
            do {
                try testData.addTestDataPoint(input: [-5.0])
                try testData.addTestDataPoint(input: [9.0])
                try testData.addTestDataPoint(input: [17.0])
                try testData.addTestDataPoint(input: [0.0])
            }
            catch {
                print("Invalid test data set created")
            }
    
    //        getting result
    
            do {
                try lr.predict(testData)
            }
            catch {
                print("Error having linear regression calculate results")
            }
    
            //  Use the results
            do {
    //            let result = try testData.getOutput(0)  //  Get first result
                for index in 0...testData.size-1 {
                    let result = try testData.getOutput(index)[0].roundTo(places: 4)
                    print("The result is: \(result)")
                }
            }
            catch {
                print("Error getting results from data set")
            }
        }
    //
        func classificationAIToolbox() {
    
            let data = DataSet(dataType: .realAndClass, inputDimension: 2, outputDimension: 1)
            do {
                print("Value of the \(EnumerationClass.Excercise.Heelslide) is \(EnumerationClass.Excercise.Heelslide.rawValue)")
                try data.addDataPoint(input: [0.0, 1.0], dataClass:1)
                try data.addDataPoint(input: [0.0, 0.9], dataClass:1)
                try data.addDataPoint(input: [0.1, 1.0], dataClass:1)
                try data.addDataPoint(input: [1.0, 0.0], dataClass:0)
                try data.addDataPoint(input: [1.0, 0.1], dataClass:0)
                try data.addDataPoint(input: [0.9, 0.0], dataClass:0)
            }
            catch {
                print("Invalid data set created")
            }
            
            //  Create an SVM classifier and train
            let svm = SVMModel(problemType: .c_SVM_Classification, kernelSettings:
                KernelParameters(type: .radialBasisFunction, degree: 0, gamma: 0.5, coef0: 0.0))
            svm.train(data)
            
            //  Create a test dataset
            let testData = DataSet(dataType: .realAndClass, inputDimension: 2, outputDimension: 1)
            do {
                try testData.addTestDataPoint(input: [0.0, 0.1])    //  Expect 1
                try testData.addTestDataPoint(input: [0.1, 0.0])    //  Expect 0
                try testData.addTestDataPoint(input: [1.0, 0.9])    //  Expect 0
                try testData.addTestDataPoint(input: [0.9, 1.0])    //  Expect 1
                try testData.addTestDataPoint(input: [0.5, 0.4])    //  Expect 0
                try testData.addTestDataPoint(input: [0.5, 0.6])    //  Expect 1
            }
            catch {
                print("Invalid data set created")
            }
            
            //  Predict on the test data
            svm.predictValues(testData)
            
            //  See if we matched
            var classLabel : Int
            do {
                for index in 0..<testData.size {
                    try classLabel = testData.getClass(index)
                    try print("Input: \(testData.getInput(index)) has output: \(classLabel)")
                }
            }
            catch {
                print("Error in prediction")
            }
    }
}
