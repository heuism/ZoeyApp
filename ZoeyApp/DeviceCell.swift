//
//  DeviceCell.swift
//  ZoeyApp
//
//  Created by Hien Tran on 1/2/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import UIKit
import MetaWear

class DeviceCell: UITableViewCell {
    
    @IBOutlet weak var deviceName : UILabel!
    @IBOutlet weak var deviceStatus : UILabel!
    @IBOutlet weak var deviceAddr : UILabel!
    @IBOutlet weak var deviceConnSigImg : UIImageView!
    @IBOutlet weak var deviceConnSigStr : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(device: MBLMetaWear, image: UIImage) {
        deviceName.text = device.name
        deviceStatus.text = nameForState(device: device)
        deviceAddr.text = device.identifier.uuidString
        deviceConnSigImg.image = image
        deviceConnSigStr.text = device.discoveryTimeRSSI?.stringValue
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    
}
