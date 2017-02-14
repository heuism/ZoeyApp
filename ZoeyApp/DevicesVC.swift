//
//  ViewController.swift
//  ZoeyApp
//
//  Created by Hien Tran on 1/2/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import UIKit
import MetaWear

class DevicesVC: UITableViewController, CBCentralManagerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var metaScanSwitch : UISwitch!
    @IBOutlet weak var metaBootModeSwitch : UISwitch!
    
    var centralManager : CBCentralManager!
    
    var activity : UIActivityIndicatorView!
    
    var devices: [MBLMetaWear]?
    var selected : MBLMetaWear?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activity.center = CGPoint(x: 95, y: 138)
        //        activity.center = CGPoint(x: 0, y: 0)
        tableView.addSubview(activity)
        //        self.view.addSubview(activity)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setScanning(metaScanSwitch.isOn)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        print("CentralManager is initialized")
        
        switch central.state{
        case CBManagerState.unauthorized:
            print("The app is not authorized to use Bluetooth low energy.")
        case CBManagerState.poweredOff:
            print("Bluetooth is currently powered off.")
            let alertView = UIAlertView(title: "Error", message: "Please turn on Bluetooth in Settings", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "Setting")
            //            var alertView = UIAlertController(title: "Error", message: "Please turn on Bluetooth in Settings", preferredStyle: UIAlertControllerStyle.actionSheet)
            tableView.reloadData()
            alertView.show()
        case CBManagerState.poweredOn:
            print("Bluetooth is currently powered on and available to use.")
        default:break
        }
    }
    
    @IBAction func scanningPressed(_ sender: AnyObject) {
        setScanning(sender.isOn)
    }
    
    @IBAction func bootPressed(_ sender: AnyObject) {
        MBLMetaWearManager.shared().stopScan()
        // Wait a split second for any final callbacks to fire before starting up scanning again
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.devices = nil
            self.tableView.reloadData()
            self.setScanning(self.metaScanSwitch.isOn)
        }
    }
    
    func setScanning(_ on: Bool) {
        switch on {
        case true:
            activity.startAnimating()
            switch metaBootModeSwitch.isOn {
            case true:
                MBLMetaWearManager.shared().startScan(forMetaBootsAllowDuplicates: true, handler: {
                    array in
                    self.devices = array
                    self.tableView.reloadData()
                })
                break
            default:
                MBLMetaWearManager.shared().startScan(forMetaWearsAllowDuplicates: true, handler: {
                    array in
                    // list the MTWEAR devices around
                    self.devices = array
                    self.tableView.reloadData()
                })
                break
            }
            break
        default:
            activity.stopAnimating()
            MBLMetaWearManager.shared().stopScan()
            break
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return 0
        return devices?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentDevice = devices?[indexPath.row]
        var signalImg : UIImage?
        if let averageRSSI = currentDevice?.averageRSSI {
            let movingAverage = averageRSSI.doubleValue
            if movingAverage < -80.0 {
                signalImg = #imageLiteral(resourceName: "wifi_d1")
            } else if movingAverage < -70.0 {
                signalImg = #imageLiteral(resourceName: "wifi_d2")
            } else if movingAverage < -60.0 {
                signalImg = #imageLiteral(resourceName: "wifi_d3")
            } else if movingAverage < -50.0 {
                signalImg = #imageLiteral(resourceName: "wifi_d4")
            } else if movingAverage < -40.0 {
                signalImg = #imageLiteral(resourceName: "wifi_d5")
            } else {
                signalImg = #imageLiteral(resourceName: "wifi_d6")
            }
        } else {
            signalImg = #imageLiteral(resourceName: "wifi_not_connected")
        }
        
        //         Configure the cell...
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") as? DeviceCell {
            cell.configureCell(device: currentDevice!, image: signalImg!)
            return cell
        }
        else {
            let cell = DeviceCell()
            cell.configureCell(device: currentDevice!, image: signalImg!)
            return cell
        }
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Devices"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selected = devices?[indexPath.row]
        selected?.connectAsync().success() { _ in
            // Hooray! We connected to a MetaWear board, so flash its LED!
            //                    self.device.led?.flashColorAsync(UIColor.blue, withIntensity: 0.25)
            ////                    print(self.device.deviceInfo)
            // my code !!!!!
            self.performSegue(withIdentifier: "DeviceDetails", sender: nil)
            }.failure() { error in
                // Sorry we couldn't connect
                print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailVC
        destination.device = selected
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

