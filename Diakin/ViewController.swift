//
//  ViewController.swift
//  Diakin
//
//  Created by Vinod Iyer Subramaniam on 12/1/17.
//  Copyright © 2017 Vidya Inc. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var modeControl: UISegmentedControl!
    
    
    @IBOutlet weak var mainSwitch: UISwitch!
    
    @IBOutlet weak var zone6: UISwitch!
    @IBOutlet weak var zone5: UISwitch!
    @IBOutlet weak var zone4: UISwitch!
    @IBOutlet weak var zone3: UISwitch!
    @IBOutlet weak var zone2: UISwitch!
    @IBOutlet weak var zone1: UISwitch!
    
    @IBOutlet weak var autoFanControl: UISegmentedControl!
    @IBOutlet weak var fanControl: UISegmentedControl!
    @IBOutlet weak var outsideTempLabel: UILabel!
    @IBOutlet weak var homeTempLabel: UILabel!
    @IBOutlet weak var targetTeamLabel: UILabel!
  
    @IBOutlet weak var targetTemp: UIStepper!
    
    var queue = Queue<String>()
    
    var mainDataRefreshTimer: Timer!
    
    var updateServerTimer: Timer!
    
    var responseDict: [String: String]!
    
    let acIPPort = ""
    
    let password = ""
    
    
    // Define identifier
    //let notificationName = Notification.Name("UpdateUINotification")
    
    
    override func viewDidLoad() {
         
        super.viewDidLoad()
        
        // Register to receive notification
        //NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI(_:)), name: notificationName, object: nil)
        
        
        self.mainDataRefreshTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: true)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ons
    
    
    
    @IBAction func clickAutoAction(_ sender: Any) {
        
        let unwrappedMode = modeControl.selectedSegmentIndex
        
        var updateURL:String = ""
        
        switch unwrappedMode {
        case 0:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&m=8"
            queue.enqueue(updateURL)
            
        case 1:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&m=2"
            queue.enqueue(updateURL)
            
        case 2:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&m=16"
            queue.enqueue(updateURL)
        
        case 3:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&m=4"
            queue.enqueue(updateURL)
            
        case 4:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&m=1"
            queue.enqueue(updateURL)
            
        default:
            print("Error")
        }
        
        reloadData()

    }
    
    @IBAction func clickMainSwitchAction(_ sender: Any) {
        
        var updateURL:String = ""
        if(mainSwitch.isOn){
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&p=1"
        }
        else{
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&p=0"
        }
        queue.enqueue(updateURL)
        reloadData()
        
    }
    
    
    @IBAction func clickZone1Action(_ sender: Any) {
        queue.enqueue("\(self.acIPPort)/setzone.cgi?pass=\(password)&z=1&s=\((self.zone1.isOn) ? 1 : 0)")
        reloadData()
    }
    
    @IBAction func clickZone2Action(_ sender: Any) {
        queue.enqueue("\(self.acIPPort)/setzone.cgi?pass=\(password)&z=2&s=\((self.zone2.isOn) ? 1 : 0)")
        reloadData()
    }
    
    @IBAction func clickZone3Action(_ sender: Any) {
        queue.enqueue("\(self.acIPPort)/setzone.cgi?pass=\(password)&z=3&s=\((self.zone3.isOn) ? 1 : 0)")
        reloadData()
    }
    
    @IBAction func clickZone4Action(_ sender: Any) {
        queue.enqueue("\(self.acIPPort)/setzone.cgi?pass=\(password)&z=4&s=\((self.zone4.isOn) ? 1 : 0)")
        reloadData()
    }
    
    @IBAction func clickZone5Action(_ sender: Any) {
        queue.enqueue("\(self.acIPPort)/setzone.cgi?pass=\(password)&z=5&s=\((self.zone5.isOn) ? 1 : 0)")
        reloadData()
    }
    
    @IBAction func clickZone6Action(_ sender: Any) {
        queue.enqueue("\(self.acIPPort)/setzone.cgi?pass=\(password)&z=6&s=\((self.zone6.isOn) ? 1 : 0)")
        reloadData()
    }
    
    @IBAction func clickAutoFanAction(_ sender: Any) {
        fanControl.selectedSegmentIndex = -1
        
        let unwrappedFanSpeed = autoFanControl.selectedSegmentIndex
        
        var updateURL:String = ""
        
        switch unwrappedFanSpeed {
        case 0:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&f=5"
            queue.enqueue(updateURL)
            
        case 1:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&f=6"
            queue.enqueue(updateURL)
            
        case 2:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&f=7"
            queue.enqueue(updateURL)
            
        default:
            print("Error")
        }
        
        reloadData()
    }
    
    @IBAction func clickFanAction(_ sender: Any) {
        
        autoFanControl.selectedSegmentIndex = -1
        
        let unwrappedFanSpeed = fanControl.selectedSegmentIndex
        
        var updateURL:String = ""
        
        switch unwrappedFanSpeed {
        case 0:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&f=1"
            queue.enqueue(updateURL)
        
        case 1:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&f=2"
            queue.enqueue(updateURL)
            
        case 2:
            updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&f=3"
            queue.enqueue(updateURL)

        default:
            print("Error")
        }
        
        reloadData()
    }
    
    @IBAction func clickSetTargetTemp(_ sender: UIStepper) {
        print(self.targetTemp.value)
        self.targetTeamLabel.text = "\(self.targetTemp.value) C"
        
        let updateURL = "\(self.acIPPort)/set.cgi?pass=\(password)&t=\(self.targetTemp.value)"
        queue.enqueue(updateURL)
        
        reloadData()
    }
    //MARK: Custom Function
    
    
    func reloadData (){
        let serialQueue = DispatchQueue(label: "reloadDataQueue")
        
        serialQueue.sync {
            //Stuff Here
            if(!queue.isEmpty){
                print("Update queue not empty so trying update first")
                updateTask()
            }
            else{
                print("Update queue empty so refreshing UI")
                reloadData2 ()
            }
        }
    }
    func reloadData2 () {
        
        self.mainDataRefreshTimer.invalidate()
        
        let todoEndpoint: String = "\(self.acIPPort)/ac.cgi?pass=\(password)"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let myCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
            (data, response, error) in
            // this is where the completion handler code goes
            if let response = response {
                
                if let utf8Text = String(data: data!, encoding: .utf8) {
                    //self.responseItems = URLComponents(string: ("http://test.com?"  + utf8Text))?.queryItems
                    print("Data Refresh Response received")
                    var tempDict = [String: String]()
                    var test = utf8Text.components(separatedBy: "&").map {
                        $0.components(separatedBy: "=")
                        }.reduce([:]) {
                            (dict: [String:String], p) in
                            tempDict[p[0]]=p[1]
                            return tempDict
                    }
                    
                    self.responseDict = tempDict
                    
                    self.updateUI()
                }
            }
            if let error = error {
                print(error)
            }
        }
        let task = session.dataTask(with: urlRequest, completionHandler: myCompletionHandler)
        task.resume()
        
        
        self.mainDataRefreshTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: true)
        
    }
    
    
    func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        return try body()
    }
    
    func updateTask () {
        
        print ("\(Date()) : UpdateTask fired")
        
        var isError = true
        
        if(!queue.isEmpty){
            
            let queueURL = self.queue.peek()!
            
            guard let url = URL(string: queueURL ) else {
                print("Error: cannot create URL")
                return
            }
            
            print ("\(Date()) : updateTask : \(url.absoluteString)")
            
            
            let urlRequest = URLRequest(url: url)
            
            let session = URLSession.shared
            
            let myUpdateCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
                (data, response, error) in
                
                if let response = response {
                    if let utf8Text = String(data: data!, encoding: .utf8) {
                        print("Update: utf8Text response received \(utf8Text)")
                        self.queue.dequeue()
                        isError = false
                    }
                }
                
                if let error = error {
                    isError = true
                }
                
                if(self.queue.isEmpty){
                    print("Queue is empty")
                    
                }
                else{
                    
                    if(isError){
                        print("Queue not empty - error")
                        self.updateServerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTask), userInfo: nil, repeats: true)
                        
                        print("\(Date()), Update: Error - resetting timer to 2 seconds , timer fireDate ? \(self.updateServerTimer.fireDate)")
                        
                    }
                    else{
                        print("Queue not empty - not error")
                        self.updateServerTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateTask), userInfo: nil, repeats: true)
                        print("\(Date()), Update:  - resetting timer to 0.5 seconds , timer fireDate ? \(self.updateServerTimer.fireDate)")
                    }
                }
                
                
            }
            let task = session.dataTask(with: urlRequest, completionHandler: myUpdateCompletionHandler)
            task.resume()
            
        }
        
        
        
        
    }
    
    
    
    func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<(toSize - string.characters.count) {
            padded = "0" + padded
        }
        return padded
    }
    
    func stringtoboolean(binaryChar:Character ) -> BooleanLiteralType{
        if(binaryChar=="1"){
            return true
        }
        else{
            return false
        }
        
    }
    
    
    func updateUI(){
        
        // 1. On/Off Switch
        
        
        if(responseDict["opmode"] != nil)
        {
            let switchStatus = responseDict["opmode"]!
            
            switch(switchStatus){
            case "1":
                DispatchQueue.main.async(execute: {
                    self.mainSwitch.setOn(true, animated: true)
                    return
                })
            default:
                DispatchQueue.main.async(execute: {
                    self.mainSwitch.setOn(false, animated: true)
                    return
                })
            }
        }
        
        // 2. Set Zone Info
        
        if(responseDict["zone"] != nil)
        {
            
            let num:Int = Int(responseDict["zone"].unsafelyUnwrapped)!
            var str = String(num, radix: 2)
            print(str)
            str  = pad(string: str, toSize: 8)
            print("Padding : \(str)")
            let zone_details = Array(str.characters)
            
            DispatchQueue.main.async(execute: {
                self.zone1.setOn(self.stringtoboolean(binaryChar: zone_details[0]), animated: true)
                self.zone2.setOn(self.stringtoboolean(binaryChar: zone_details[1]), animated: true)
                self.zone3.setOn(self.stringtoboolean(binaryChar: zone_details[2]), animated: true)
                self.zone4.setOn(self.stringtoboolean(binaryChar: zone_details[3]), animated: true)
                self.zone5.setOn(self.stringtoboolean(binaryChar: zone_details[4]), animated: true)
                self.zone6.setOn(self.stringtoboolean(binaryChar: zone_details[5]), animated: true)
                
            })
            
        }
        
        
        // 3. Set Home Temp
        
        if(responseDict["roomtemp"] != nil)
        {
            
            let unwrappedRoomtemp = responseDict["roomtemp"]!
            
            DispatchQueue.main.async(execute: {
                self.homeTempLabel.text = "\(unwrappedRoomtemp) C"
            })
        }
        
        // 4. Set Outdoor Temp
        
        if(responseDict["outsidetemp"] != nil)
        {
            let unwrappedOutsidetemp = responseDict["outsidetemp"]!
            
            DispatchQueue.main.async(execute: {
                self.outsideTempLabel.text = "\(unwrappedOutsidetemp) C"
            })
        }
        
        // 5. Set Mode
        
        if(responseDict["acmode"] != nil)
        {
            var unwrappedAcmode = responseDict["acmode"]!
            
            if (unwrappedAcmode == "1" || unwrappedAcmode == "3" || unwrappedAcmode == "9"){
                unwrappedAcmode = "0";
            }
            
            switch(unwrappedAcmode){
            case "8":
                DispatchQueue.main.async(execute: {
                    self.modeControl.selectedSegmentIndex = 0
                    return
                })
            case "2":
                DispatchQueue.main.async(execute: {
                    self.modeControl.selectedSegmentIndex = 1
                    return
                })
                
            case "16":
                DispatchQueue.main.async(execute: {
                    self.modeControl.selectedSegmentIndex = 2
                    return
                })
                
            case "4":
                DispatchQueue.main.async(execute: {
                    self.modeControl.selectedSegmentIndex = 3
                    return
                })
                
            case "0":
                DispatchQueue.main.async(execute: {
                    self.modeControl.selectedSegmentIndex = 4
                    return
                })
                
            default:
                print("Error while setting mode")
                
            }
        }
        
        // 6. Set Fan Speed
        
        if(responseDict["fanspeed"] != nil && responseDict["fanflags"] != nil)
        {
            let unwrappedFanspeed = responseDict["fanspeed"]!
            let unwrappedFanflags = responseDict["fanflags"]!
            
            
            switch(unwrappedFanflags){
            case "1":
                DispatchQueue.main.async(execute: {
                    self.autoFanControl.selectedSegmentIndex = -1
                    self.fanControl.selectedSegmentIndex = (Int.init(unwrappedFanspeed)! - 1)
                    return
                })
            case "3":
                DispatchQueue.main.async(execute: {
                    self.fanControl.selectedSegmentIndex = -1
                    self.autoFanControl.selectedSegmentIndex = (Int.init(unwrappedFanspeed)! - 1)
                    
                    return
                })
            default:
                print("Error while setting fan mode")
                
            }
        }
        
        // 7. Set Target Temp
        
        if(responseDict["settemp"] != nil)
        {
            let unwrappedTargettemp = responseDict["settemp"]!
            
            DispatchQueue.main.async(execute: {
                self.targetTeamLabel.text = "\(unwrappedTargettemp) C"
                
                self.targetTemp.value =  Double(unwrappedTargettemp)!
            })
        }
        
        
    }
    
    
}

