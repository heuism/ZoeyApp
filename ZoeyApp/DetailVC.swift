//
//  DetailVC.swift
//  ZoeyApp
//
//  Created by Hien Tran on 1/2/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import UIKit
import MetaWear
import MessageUI

class DetailVC: UIViewController {
    
//    var util = Util()
    
    
    //    var navigationController: UINavigationController?
    
    @IBOutlet weak var start_stopLoggingBtn : UIBarButtonItem!
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var stackViewMain : UIStackView!
    
    @IBOutlet weak var connectBtn : UIButton!
    @IBOutlet weak var connectLbl : UILabel!
    @IBOutlet weak var redBtn : UIButton!
    @IBOutlet weak var greenBtn : UIButton!
    @IBOutlet weak var blueBtn : UIButton!
    @IBOutlet weak var disconnctBtn : UIButton!
    @IBOutlet weak var resetBtn : UIButton!
    
    //@IBOutlet weak var accGraphView : APLGraphView!
    @IBOutlet weak var startAccBtn : UIButton!
    @IBOutlet weak var stopAccBtn : UIButton!
    private var accelerometerDataArray = [MBLAccelerometerData]()
    @IBOutlet weak var accScale : UISegmentedControl!
    @IBOutlet weak var accFrequency : UISegmentedControl!
    @IBOutlet weak var tapStyle : UISegmentedControl!
    @IBOutlet weak var shareAccData : UIButton!
    
    //    @IBOutlet weak var gyroGraphView : APLGraphView!
    @IBOutlet weak var startGyroBtn : UIButton!
    @IBOutlet weak var stopGyroBtn : UIButton!
    @IBOutlet weak var gyroScale : UISegmentedControl!
    @IBOutlet weak var gyroFrequency : UISegmentedControl!
    var gyroscopeDataArray = [MBLGyroData]()
    @IBOutlet weak var shareGyroData : UIButton!
    
    //    @IBOutlet weak var magGraphView : APLGraphView!
    //    @IBOutlet weak var startMagBtn : UIButton!
    //    @IBOutlet weak var stopMagBtn : UIButton!
    //    var magnetometerDataArray = [MBLMagnetometerData]()
    
    //@IBOutlet weak var tableView : UITableView!
    
    //    var streamingEvents: Set<NSObject> = [] // Can't use proper type due to compiler seg fault
    var streamingEvents : [NSObject]!
    var isObserving = false {
        didSet {
            if self.isObserving {
                if !oldValue {
                    self.device.addObserver(self, forKeyPath: "state", options: .new, context: nil)
                }
            } else {
                if oldValue {
                    self.device.removeObserver(self, forKeyPath: "state")
                }
            }
        }
    }
    
    var isConnected : Bool!
    
    var device : MBLMetaWear!
    
    var controller: UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isConnected = false
        enableBtns(enable: isConnected)
        //        self.enableBtn(btn: self.stopAccBtn, enable: !self.isConnected)
        isObserving = true
        //        streamingEvents = []
        streamingEvents = [NSObject]()
        //        tableView.dataSource = self
        //        tableView.delegate = self
        updateScrollSize()
        //        print(device.deviceInfo)
    }
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 1
    //    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        return UITableViewCell()
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("The Value Is: \(self.isMovingFromParentViewController)")
        //        device.waitForDisconnect()
        
        if self.isMovingFromParentViewController {
            device.disconnectAsync().success(){_ in
                self.isConnected = false
                self.connectLbl.text = self.nameForState(device: self.device)
                self.enableBtns(enable: self.isConnected)
                print("Disconnect Device")
                }.failure() {
                    error in
                    print(error)
            }
            
            isObserving = false
            for obj in streamingEvents {
                if let event = obj as? MBLEvent<AnyObject> {
                    event.stopNotificationsAsync()
                }
            }
            streamingEvents.removeAll()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        isConnected = false
        enableBtns(enable: isConnected)
        if let connected = device {
            connectLbl.text = nameForState(device: connected)
            isConnected = true
            enableBtns(enable: isConnected)
        }
        enableBtn(btn: connectBtn, enable: !isConnected)
        updateScrollSize()
        
        start_stopLoggingBtn.title = "Start"
        
        //update share button design
        updateButtonsDesign()
    }
    
    func updateScrollSize() {
        let contentViewHeight = stackViewMain.bounds.height
        //        let offsetY = contentViewHeight - scrollView.bounds.height
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: contentViewHeight)
        
    }
    
    func updateButtonsDesign() {
        updateBtn(btn: shareAccData)
        updateBtn(btn: shareGyroData)
    }
    
    func updateBtn(btn : UIButton) {
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func connectDevice(_sender: AnyObject){
        if let dev = device {
            dev.connectAsync().success() { _ in
                // Hooray! We connected to a MetaWear board, so flash its LED!
                //                    self.device.led?.flashColorAsync(UIColor.blue, withIntensity: 0.25)
                ////                    print(self.device.deviceInfo)
                // my code !!!!!
                self.connectLbl.text = self.nameForState(device: self.device)
                self.isConnected = true
                self.enableBtns(enable: self.isConnected)
                self.enableBtn(btn: self.connectBtn, enable: !self.isConnected)
                //                self.enableBtn(btn: self.stopAccBtn, enable: !self.isConnected)
                }.failure() { error in
                    // Sorry we couldn't connect
                    print(error)
            }
        }
    }
    
    @IBAction func disconnectDevice(_sender: AnyObject) {
        print("Disconnect Device")
        device.disconnectAsync()
        //        device.waitForDisconnect()
        device.disconnectAsync().success(){_ in
            self.isConnected = false
            self.connectLbl.text = self.nameForState(device: self.device)
            self.enableBtns(enable: self.isConnected)
            self.enableBtn(btn: self.connectBtn, enable: !self.isConnected)
            }.failure() {
                error in
                print(error)
        }
    }
    
    @IBAction func resetDevice(_sender: AnyObject) {
        print("Reset Device!!!! - Warning")
        device.resetDevice()
    }
    
    @IBAction func ledToRed(_sender: AnyObject){
        print("Change LED to RED")
        print(device.deviceInfo)
        device.led?.flashColorAsync(UIColor.red, withIntensity: 0.5)
        
        //        util.testms()
        //        util.testingRegressionAIToolbox()
    }
    
    @IBAction func ledToGreen(_sender: AnyObject){
        print("Change LED to GREEN")
        print(device.deviceInfo)
        device.led?.flashColorAsync(UIColor.green, withIntensity: 0.5)
        
        //        util.testingClassificationAIToolbox()
    }
    
    @IBAction func ledToBlue(_sender: AnyObject){
        print("Change LED to BLUE")
        print(device.deviceInfo)
        device.led?.flashColorAsync(UIColor.blue, withIntensity: 0.5)
    }
    
    @IBAction func startAccelerationPressed(_ sender: Any) {
        startAccBtn.isEnabled = false
        stopAccBtn.isEnabled = true
        //        startLog.isEnabled = false
        //        stopLog.isEnabled = false
        updateAccelerometerBMI160Settings()
        // These variables are used for data recording
        //var array = [MBLAccelerometerData]() /* capacity: 1000 */
        //accelerometerDataArray = array
        //        streamingEvents.insert(device.accelerometer!.dataReadyEvent)
        streamingEvents.append(device.accelerometer!.dataReadyEvent)
        device.accelerometer!.dataReadyEvent.startNotificationsAsync { (acceleration, error) in
            if let acceleration = acceleration {
                //                self.accGraphView.addX(acceleration.x, y: acceleration.y, z: acceleration.z)
                // Add data to data array for saving
                print("-----> \(acceleration)")
                self.accelerometerDataArray.append(acceleration)
            }
        }
    }
    
    @IBAction func stopAccelerationPressed(_ sender: Any) {
        startAccBtn.isEnabled = true
        stopAccBtn.isEnabled = false
        //        startLog.isEnabled = true
        print("final data set is : ===> \(accelerometerDataArray.count)")
        //        streamingEvents.remove(device.accelerometer!.dataReadyEvent)
        streamingEvents.remove(at: streamingEvents.index(of: device.accelerometer!.dataReadyEvent)!)
        device.accelerometer!.dataReadyEvent.stopNotificationsAsync()
        accelerometerDataArray.removeAll()
    }
    
    @IBAction func startGyroPressed(_ sender: Any) {
        startGyroBtn.isEnabled = false
        stopGyroBtn.isEnabled = true
        //        startLog.isEnabled = false
        //        stopLog.isEnabled = false
        updateGyroBMI160Settings()
        // These variables are used for data recording
        //var array = [MBLAccelerometerData]() /* capacity: 1000 */
        //accelerometerDataArray = array
        //        streamingEvents.insert(device.gyro!.dataReadyEvent)
        streamingEvents.append(device.gyro!.dataReadyEvent)
        device.gyro!.dataReadyEvent.startNotificationsAsync { (obj, error) in
            if let obj = obj {
                //                self.gyroGraphView.addX(obj.x * 0.008, y: obj.y * 0.008, z: obj.z * 0.008)
                // Add data to data array for saving
                //                print("-----> \(obj)")
                self.gyroscopeDataArray.append(obj)
            }
        }
    }
    
    @IBAction func stopGyroPressed(_ sender: Any) {
        startGyroBtn.isEnabled = true
        stopGyroBtn.isEnabled = false
        //        startLog.isEnabled = true
        print("final data set is : ===> \(gyroscopeDataArray.count)")
        //        streamingEvents.remove(device.gyro!.dataReadyEvent)
        streamingEvents.remove(at: streamingEvents.index(of: device.gyro!.dataReadyEvent)!)
        device.gyro!.dataReadyEvent.stopNotificationsAsync()
        //        gyroscopeDataArray.removeAll()
    }
    
    //    @IBAction func startMagPressed(_ sender: Any) {
    //        startMagBtn.isEnabled = false
    //        stopMagBtn.isEnabled = true
    //        //        startLog.isEnabled = false
    //        //        stopLog.isEnabled = false
    ////        updateAccelerometerBMI160Settings()
    //        // These variables are used for data recording
    //        //var array = [MBLAccelerometerData]() /* capacity: 1000 */
    //        //accelerometerDataArray = array
    //        magGraphView.fullScale = 4
    //        let magnetometer = device.magnetometer as! MBLMagnetometerBMM150
    //        streamingEvents.insert(magnetometer.periodicMagneticField)
    //        magnetometer.periodicMagneticField.startNotificationsAsync { (obj, error) in
    //            if let obj = obj {
    //                self.accGraphView.addX(obj.x * 20000.0, y: obj.y * 20000.0, z: obj.z * 20000.0)
    //                // Add data to data array for saving
    ////                print("-----> \(obj)")
    //                self.magnetometerDataArray.append(obj)
    //            }
    //        }
    //    }
    //
    //    @IBAction func stopMagPressed(_ sender: Any) {
    //        startMagBtn.isEnabled = true
    //        stopMagBtn.isEnabled = false
    //        //        startLog.isEnabled = true
    //        let magnetometer = device.magnetometer as! MBLMagnetometerBMM150
    //        streamingEvents.remove(magnetometer.periodicMagneticField)
    //        print("final data set is : ===> \(magnetometerDataArray.count)")
    //        magnetometer.periodicMagneticField.stopNotificationsAsync()
    //        magnetometerDataArray.removeAll()
    //    }
    
    func updateAccelerometerBMI160Settings() {
        let accelerometerBMI160 = self.device.accelerometer as! MBLAccelerometerBMI160
        switch self.accScale.selectedSegmentIndex {
        case 0:
            accelerometerBMI160.fullScaleRange = .range2G
        //            self.accGraphView.fullScale = 2
        case 1:
            accelerometerBMI160.fullScaleRange = .range4G
        //            self.accGraphView.fullScale = 4
        case 2:
            accelerometerBMI160.fullScaleRange = .range8G
        //            self.accGraphView.fullScale = 8
        case 3:
            accelerometerBMI160.fullScaleRange = .range16G
        //            self.accGraphView.fullScale = 16
        default:
            print("Unexpected accelerometerBMI160Scale value")
        }
        
        accelerometerBMI160.sampleFrequency = Double(self.accFrequency.titleForSegment(at: self.accFrequency.selectedSegmentIndex)!)!
        accelerometerBMI160.tapType = MBLAccelerometerTapType(rawValue: UInt8(self.tapStyle.selectedSegmentIndex))!
    }
    
    func updateGyroBMI160Settings() {
        let gyroBMI160 = self.device.gyro as! MBLGyroBMI160
        switch self.gyroScale.selectedSegmentIndex {
        case 0:
            gyroBMI160.fullScaleRange = .range125
        //            self.gyroGraphView.fullScale = 1
        case 1:
            gyroBMI160.fullScaleRange = .range250
        //            self.gyroGraphView.fullScale = 2
        case 2:
            gyroBMI160.fullScaleRange = .range500
        //            self.gyroGraphView.fullScale = 4
        case 3:
            gyroBMI160.fullScaleRange = .range1000
        //            self.gyroGraphView.fullScale = 8
        case 4:
            gyroBMI160.fullScaleRange = .range2000
        //            self.gyroGraphView.fullScale = 16
        default:
            print("Unexpected gyroBMI160Scale value")
        }
        
        gyroBMI160.sampleFrequency = Double(self.gyroFrequency.titleForSegment(at: self.gyroFrequency.selectedSegmentIndex)!)!
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        OperationQueue.main.addOperation {
            //self.connectionStateLabel.text! = self.nameForState()
            if self.device.state == .disconnected {
                //self.deviceDisconnected()
            }
        }
    }
    
    func send(data: Data, title: String) {
        // Get current Time/Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM_dd_yyyy-HH_mm_ss"
        let dateString = dateFormatter.string(from: Date())
        let name = "\(title)_\(dateString).csv"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        do {
            try data.write(to: fileURL, options: .atomic)
            // Popup the default share screen
            self.controller = UIDocumentInteractionController(url: fileURL)
            if !self.controller.presentOptionsMenu(from: view.bounds, in: view, animated: true) {
                self.showAlertTitle("Error", message: "No programs installed that could save the file")
            }
        } catch let error {
            self.showAlertTitle("Error", message: error.localizedDescription)
        }
    }
    
    func showAlertTitle(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func nameForState(device: MBLMetaWear) -> String {
        switch device.state {
        case .connected:
            return device.programedByOtherApp ? "Connected (LIMITED)" : "Connected"
        case .connecting:
            return "Connecting"
        case .disconnected:
            return "Disconnected"
        case .disconnecting:
            return "Disconnecting"
        case .discovery:
            return "Discovery"
        }
    }
    
    func enableBtns(enable : Bool) {
        enableBtn(btn: redBtn, enable: enable)
        enableBtn(btn: greenBtn, enable: enable)
        enableBtn(btn: blueBtn, enable: enable)
        enableBtn(btn: disconnctBtn, enable: enable)
        enableBtn(btn: resetBtn, enable: enable)
        enableBtn(btn: shareAccData, enable: enable)
        enableBtn(btn: shareGyroData, enable: enable)
        enableBtn(btn: startAccBtn, enable: enable)
        enableBtn(btn: stopAccBtn, enable: enable)
        enableBtn(btn: shareAccData, enable: enable)
        enableBtn(btn: shareGyroData, enable: enable)
        enableSegment(segment: accScale, enable: enable)
        enableSegment(segment: accFrequency, enable: enable)
        enableSegment(segment: tapStyle, enable: enable)
        enableSegment(segment: gyroScale, enable: enable)
        enableSegment(segment: gyroFrequency, enable: enable)
    }
    
    func enableBtn(btn: UIButton, enable: Bool) {
        btn.isEnabled = enable
        btn.isUserInteractionEnabled = enable
        btn.isOpaque = !enable
        //        btn.isHidden = enable
    }
    
    func enableSegment(segment: UISegmentedControl, enable: Bool) {
        segment.isEnabled = enable
        segment.isOpaque = !enable
        segment.isUserInteractionEnabled = enable
    }
    
    @IBAction func start_stopLogging(_ sender : UIBarButtonItem) {
        if sender.title == "Start" {
            sender.title = "Stop"
            startAccBtn.sendActions(for: .touchUpInside)
            startGyroBtn.sendActions(for: .touchUpInside)
        } else {
            sender.title = "Start"
            stopAccBtn.sendActions(for: .touchUpInside)
            stopGyroBtn.sendActions(for: .touchUpInside)
        }
    }
    
    @IBAction func shareDataAcc(_ sender: AnyObject) {
        var accelerometerData = Data()
        for dataElement in accelerometerDataArray {
            accelerometerData.append("\(dataElement.timestamp.timeIntervalSince1970),\(dataElement.x),\(dataElement.y),\(dataElement.z)\n".data(using: String.Encoding.utf8)!)
        }
        send(data: accelerometerData, title: "AccData")
        accelerometerDataArray.removeAll()
    }
    
    @IBAction func shareDataGyro(_ sender: AnyObject) {
        var gyroscopeData = Data()
        for dataElement in gyroscopeDataArray {
            gyroscopeData.append("\(dataElement.timestamp.timeIntervalSince1970),\(dataElement.x),\(dataElement.y),\(dataElement.z)\n".data(using: String.Encoding.utf8)!)
        }
        send(data: gyroscopeData, title: "AccData")
        gyroscopeDataArray.removeAll()
    }
}
