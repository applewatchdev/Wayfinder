//
//  InterfaceController.swift
//  Wayfinder WatchKit Extension
//
//  Created by Kevin Lieser on 08.09.22.
//

import WatchKit
import Foundation
import CoreLocation
import UIKit
import CoreMotion
import HealthKit


class WatchfaceController: WKInterfaceController, WKCrownDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var compassScene: WKInterfaceSKScene!
    @IBOutlet weak var clockScene: WKInterfaceSKScene!
    var compassSceneSpriteKit: SKScene!
    var compassNode: SKNode!
    var compassNodeSn: SKSpriteNode?
    var compassNodeDeg: SKNode!
    var compassNodeDegSn: SKSpriteNode?
    var compassHeadingLastDegree: Double = 0
    var clockSceneSpriteKit: FaceScene!
    
    var graphicContext: CGContext?
    @IBOutlet weak var latlonTextCircleImage: WKInterfaceImage!
    
    var crownAccumulator = 0.0
    
    var locationManager: CLLocationManager!
    var altimeter: CMAltimeter!
    var healthStore: HKHealthStore!
    
    var lastLat: String = "0.000"
    var lastLon: String = "0.000"
    var lastTime: Date = Date.now
    var lastAltitude: Double = 0
    
    var language = "en"
    
    var colorSet = 0
    var colorSetData = [
        [ // Default orange
            "compassRing": UIColor.black,
            "compassLines": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "compassDeg": UIColor.black,
            "gaugeBackground": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "circleBackground": UIColor(red: 30/255, green: 34/255, blue: 34/255, alpha: 1),
            "battery": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "bpm": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "ring1": UIColor(red: 255/255, green: 0/255, blue: 80/255, alpha: 1),
            "ring2": UIColor(red: 155/255, green: 255/255, blue: 70/255, alpha: 1),
            "ring3": UIColor(red: 0/255, green: 220/255, blue: 250/255, alpha: 1),
            "spo2": UIColor(red: 50/255, green: 171/255, blue: 227/255, alpha: 1),
            "spo2value": UIColor.white,
            "date": UIColor.white,
            "dateday": UIColor(red: 225/255, green: 35/255, blue: 35/255, alpha: 1),
            "altimeter": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "directionMarker": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "ringOuter": UIColor(red: 232/255, green: 224/255, blue: 213/255, alpha: 1),
            "ringInner": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "ringHours": UIColor.white,
            "ringMinutes": UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1),
            "signal1": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal2": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal3": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal4": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "compassDegreeText": UIColor.white,
            "distanceValue": UIColor(red: 155/255, green: 255/255, blue: 70/255, alpha: 1),
            "hourHand": UIColor.white,
            "minuteHand": UIColor.white,
            "secondHand": UIColor.white,
        ],
        [ // Night mode
            "compassRing": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "compassLines": UIColor(red: 125/255, green: 0/255, blue: 10/255, alpha: 1),
            "compassDeg": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "gaugeBackground": UIColor(red: 58/255, green: 10/255, blue: 10/255, alpha: 1),
            "circleBackground": UIColor(red: 58/255, green: 10/255, blue: 10/255, alpha: 1),
            "battery": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "bpm": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "ring1": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "ring2": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "ring3": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "spo2": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "spo2value": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "date": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "dateday": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "altimeter": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "directionMarker": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "ringOuter": UIColor.black,  
            "ringInner": UIColor(red: 58/255, green: 10/255, blue: 10/255, alpha: 1),
            "ringHours": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "ringMinutes": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "signal1": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "signal2": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "signal3": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "signal4": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "compassDegreeText": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "distanceValue": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "hourHand": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "minuteHand": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
            "secondHand": UIColor(red: 255/255, green: 0/255, blue: 33/255, alpha: 1),
        ],
        [ // Yellow/white
            "compassRing": UIColor.black,
            "compassLines": UIColor.black,
            "compassDeg": UIColor.black,
            "gaugeBackground": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "circleBackground": UIColor(red: 30/255, green: 34/255, blue: 34/255, alpha: 1),
            "battery": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "bpm": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "ring1": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "ring2": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "ring3": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "spo2": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "spo2value": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "date": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "dateday": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "altimeter": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "directionMarker": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "ringOuter": UIColor(red: 235/255, green: 225/255, blue: 216/255, alpha: 1),
            "ringInner": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "ringHours": UIColor.white,
            "ringMinutes": UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1),
            "signal1": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "signal2": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "signal3": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "signal4": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "compassDegreeText": UIColor.white,
            "distanceValue": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "hourHand": UIColor.white,
            "minuteHand": UIColor.white,
            "secondHand": UIColor.white,
        ],
        [ // Yellow/colored/white
            "compassRing": UIColor.black,
            "compassLines": UIColor.black,
            "compassDeg": UIColor.black,
            "gaugeBackground": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "circleBackground": UIColor(red: 30/255, green: 34/255, blue: 34/255, alpha: 1),
            "battery": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "bpm": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "ring1": UIColor(red: 255/255, green: 0/255, blue: 80/255, alpha: 1),
            "ring2": UIColor(red: 155/255, green: 255/255, blue: 70/255, alpha: 1),
            "ring3": UIColor(red: 0/255, green: 220/255, blue: 250/255, alpha: 1),
            "spo2": UIColor(red: 50/255, green: 171/255, blue: 227/255, alpha: 1),
            "spo2value": UIColor.white,
            "date": UIColor.white,
            "dateday": UIColor(red: 225/255, green: 35/255, blue: 35/255, alpha: 1),
            "altimeter": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "directionMarker": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "ringOuter": UIColor(red: 235/255, green: 225/255, blue: 216/255, alpha: 1),
            "ringInner": UIColor(red: 255/255, green: 222/255, blue: 8/255, alpha: 1),
            "ringHours": UIColor.white,
            "ringMinutes": UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1),
            "signal1": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal2": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal3": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal4": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "compassDegreeText": UIColor.white,
            "distanceValue": UIColor(red: 155/255, green: 255/255, blue: 70/255, alpha: 1),
            "hourHand": UIColor.white,
            "minuteHand": UIColor.white,
            "secondHand": UIColor.white,
        ],
        [ // Blue/white
            "compassRing": UIColor.black,
            "compassLines": UIColor(red: 82/255, green: 156/255, blue: 196/255, alpha: 1),
            "compassDeg": UIColor.black,
            "gaugeBackground": UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1),
            "circleBackground": UIColor(red: 30/255, green: 34/255, blue: 34/255, alpha: 1),
            "battery": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "bpm": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "ring1": UIColor(red: 255/255, green: 0/255, blue: 80/255, alpha: 1),
            "ring2": UIColor(red: 155/255, green: 255/255, blue: 70/255, alpha: 1),
            "ring3": UIColor(red: 0/255, green: 220/255, blue: 250/255, alpha: 1),
            "spo2": UIColor(red: 50/255, green: 171/255, blue: 227/255, alpha: 1),
            "spo2value": UIColor.white,
            "date": UIColor.white,
            "dateday": UIColor(red: 225/255, green: 35/255, blue: 35/255, alpha: 1),
            "altimeter": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "directionMarker": UIColor(red: 250/255, green: 85/255, blue: 4/255, alpha: 1),
            "ringOuter": UIColor(red: 212/255, green: 217/255, blue: 225/255, alpha: 1),
            "ringInner": UIColor(red: 38/255, green: 152/255, blue: 209/255, alpha: 1),
            "ringHours": UIColor.white,
            "ringMinutes": UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1),
            "signal1": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal2": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal3": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "signal4": UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1),
            "compassDegreeText": UIColor.white,
            "distanceValue": UIColor(red: 155/255, green: 255/255, blue: 70/255, alpha: 1),
            "hourHand": UIColor.white,
            "minuteHand": UIColor.white,
            "secondHand": UIColor.white,
        ],
    ]
    var iconSetData = [
        [
            "iconWalk": UIImage(named: "walkIcon"),
            "iconAlt": UIImage(named: "AltitudeIcon"),
        ],
        [
            "iconWalk": UIImage(named: "walkIconRed"),
            "iconAlt": UIImage(named: "AltitudeIconRed"),
        ],
        [
            "iconWalk": UIImage(named: "walkIcon"),
            "iconAlt": UIImage(named: "AltitudeIcon"),
        ],
        [
            "iconWalk": UIImage(named: "walkIcon"),
            "iconAlt": UIImage(named: "AltitudeIcon"),
        ],
        [
            "iconWalk": UIImage(named: "walkIcon"),
            "iconAlt": UIImage(named: "AltitudeIcon"),
        ],
    ]
    

    @IBOutlet weak var centerCompBottom: WKInterfaceImage!
    @IBOutlet weak var centerCompRight: WKInterfaceImage!
    @IBOutlet weak var centerCompLeft: WKInterfaceImage!
    @IBOutlet weak var compassDegreeText: WKInterfaceLabel!
    @IBOutlet weak var altimeterImage: WKInterfaceImage!
    @IBOutlet weak var batteryImage: WKInterfaceImage!
    @IBOutlet weak var comp3Image: WKInterfaceImage!
    @IBOutlet weak var comp4Image: WKInterfaceImage!
    @IBOutlet weak var comp4ImageIcon: WKInterfaceImage!
    @IBOutlet weak var directionMarkerImage: WKInterfaceImage!
    @IBOutlet weak var ringOuterImage: WKInterfaceImage!
    @IBOutlet weak var ringInnerImage: WKInterfaceImage!
    @IBOutlet weak var ringHours: WKInterfaceImage!
    @IBOutlet weak var ringMinutes: WKInterfaceImage!
    
    @IBOutlet weak var imageWalk: WKInterfaceImage!
    @IBOutlet weak var imageAltmeter: WKInterfaceImage!
    
    @IBOutlet weak var signal1: WKInterfaceGroup!
    @IBOutlet weak var signal2: WKInterfaceGroup!
    @IBOutlet weak var signal3: WKInterfaceGroup!
    @IBOutlet weak var signal4: WKInterfaceGroup!
    
    var handHour: SKSpriteNode?
    var handMinute: SKSpriteNode?
    var handSecond: SKSpriteNode?
    
    override func awake(withContext context: Any?) {
        
        self.clockSceneSpriteKit = FaceScene.init(fileNamed: "FaceScene")
        self.clockSceneSpriteKit.scaleMode = .aspectFit
        self.clockSceneSpriteKit.backgroundColor = UIColor.clear
        
        let faceNode = clockSceneSpriteKit.childNode(withName: "Face")
        let hourHand = faceNode!.childNode(withName: "Hours")
        self.handHour = hourHand as? SKSpriteNode
        let minutesHand = faceNode!.childNode(withName: "Minutes")
        self.handMinute = minutesHand as? SKSpriteNode
        let secondHand = faceNode!.childNode(withName: "Seconds")
        self.handSecond = secondHand as? SKSpriteNode
        
        self.handHour!.colorBlendFactor = 1.0
        self.handHour!.colorBlendFactor = 1.0
        self.handSecond!.colorBlendFactor = 1.0
        self.handHour!.color = self.colorSetData[self.colorSet]["hourHand"]!
        self.handMinute!.color = self.colorSetData[self.colorSet]["minuteHand"]!
        self.handSecond!.color = self.colorSetData[self.colorSet]["secondHand"]!
        
        clockScene.presentScene(self.clockSceneSpriteKit)
        
        self.compassSceneSpriteKit = SKScene.init(fileNamed: "Compass")
        compassSceneSpriteKit.backgroundColor = UIColor.clear
        compassSceneSpriteKit.scaleMode = .aspectFit
        
        self.compassNode = compassSceneSpriteKit.childNode(withName: "Compass")
        self.compassNodeSn = self.compassNode as? SKSpriteNode
        self.compassNodeDeg = compassSceneSpriteKit.childNode(withName: "CompassDeg")
        self.compassNodeDegSn = self.compassNodeDeg as? SKSpriteNode
        
        self.compassNodeSn!.colorBlendFactor = 1.0
        self.compassNodeDegSn!.colorBlendFactor = 1.0
        
        
        compassScene.presentScene(self.compassSceneSpriteKit)
        
        crownSequencer.delegate = self
        
        let app = Dynamic.PUICApplication.sharedPUICApplication()
        app._setStatusBarTimeHidden(true, animated: false, completion: nil)
        
        self.drawTextCircle()
        
        
        self.compassNodeSn!.color = self.colorSetData[self.colorSet]["compassLines"]!
        self.compassNodeDegSn!.color = self.colorSetData[self.colorSet]["compassDeg"]!
        
        self.comp4ImageIcon.setTintColor(self.colorSetData[self.colorSet]["directionMarker"]!)
        self.ringOuterImage.setTintColor(self.colorSetData[self.colorSet]["ringOuter"]!)
        self.ringInnerImage.setTintColor(self.colorSetData[self.colorSet]["ringInner"]!)
        self.signal1.setBackgroundColor(self.colorSetData[self.colorSet]["signal1"]!)
        self.signal2.setBackgroundColor(self.colorSetData[self.colorSet]["signal2"]!)
        self.signal3.setBackgroundColor(self.colorSetData[self.colorSet]["signal3"]!)
        self.signal4.setBackgroundColor(self.colorSetData[self.colorSet]["signal4"]!)
        self.ringHours.setTintColor(self.colorSetData[self.colorSet]["ringHours"]!)
        self.ringMinutes.setTintColor(self.colorSetData[self.colorSet]["ringMinutes"]!)
        self.compassDegreeText.setTextColor(self.colorSetData[self.colorSet]["compassDegreeText"]!)

        self.imageWalk.setImage(self.iconSetData[self.colorSet]["iconWalk"]!)
        self.imageAltmeter.setImage(self.iconSetData[self.colorSet]["iconAlt"]!)
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            self.fetchLocationUpdate()
        } else {
            self.locationManager?.requestAlwaysAuthorization()
        }
        
        
        
        
        

        self.healthStore = HKHealthStore()
        if(self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!) == HKAuthorizationStatus.sharingAuthorized) {
            self.fetchHealthData()
        } else {
            self.healthStore.requestAuthorization(toShare: [], read: [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleMoveTime)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleStandTime)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleStandTime)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!, HKObjectType.activitySummaryType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]) { (success, error) in
                if success {
                    self.fetchHealthData()
                }
            }
        }
        

        
        
        
        
        
        

        

        
        let dateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {  [weak self] _ in
            self!.fetchDate()
        }
        dateTimer.fire()
        
        
        self.initDefaultHrAndBpm()
        

        self.altimeter = CMAltimeter()
        self.altimeter.startAbsoluteAltitudeUpdates(to: OperationQueue.main) {(data,error) in DispatchQueue.main.async {
            if let optData = data {
                self.lastAltitude = optData.altitude
            
                let size = CGSize(width: 210, height: 230)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                self.graphicContext = UIGraphicsGetCurrentContext()
                self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
                self.graphicContext!.scaleBy(x: 1, y: -1)
                
                self.centreArcPerpendicular(text: "\(Int(self.lastAltitude)) M", context: self.graphicContext!, radius: 112, angle: (127.5 * .pi / 180), colour: self.colorSetData[self.colorSet]["altimeter"]!, font: UIFont(name: "RedHatMono-Bold", size: 14)!, clockwise: true)
                let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                self.altimeterImage.setImage(returnImage)
            }
        } }
        
        

        let batteryTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {  [weak self] _ in
            self!.fetchBattery()
        }
        batteryTimer.fire()

        
    }
    
    func initDefaultHrAndBpm() {
        // Init Oxygen
        let sizeCenterCompB = CGSize(width: 42, height: 42)
        let centerCompB = self.drawCenterText(size: sizeCenterCompB, color: (self.colorSetData[self.colorSet]["spo2value"]!).cgColor, string: "–", subcolor: (self.colorSetData[self.colorSet]["spo2"]!).cgColor, substring: "SpO2")
        self.centerCompRight.setImage(centerCompB)
        
        
        // Init HR
        var size = CGSize(width: 210, height: 230)
        let circleGaugeBg = self.drawGaugeCorner(size: size, color: (self.colorSetData[self.colorSet]["gaugeBackground"]!).cgColor, value: 1, rotation: 37.5 + 180)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        circleGaugeBg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.normal, alpha: 1)
        self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
        self.graphicContext!.scaleBy(x: 1, y: -1)
        self.centreArcPerpendicular(text: "100", context: self.graphicContext!, radius: 125, angle: ((52.5 + 3) * .pi / 180), colour: self.colorSetData[self.colorSet]["bpm"]!, font: UIFont(name: "RedHatMono-Bold", size: 16)!, clockwise: true)
        self.centreArcPerpendicular(text: "BPM", context: self.graphicContext!, radius: 122, angle: ((52.5 - 8) * .pi / 180), colour: self.colorSetData[self.colorSet]["bpm"]!, font: UIFont(name: "RedHatMono-Bold", size: 8)!, clockwise: true)
        var returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.comp3Image.setImage(returnImage)
    }
    
    func fetchDate() {
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "eeeeee"
        
        let customFormatter2 = DateFormatter()
        customFormatter2.dateFormat = "d"
        
        var dateStr: String = customFormatter.string(for: Date.now)!
        dateStr = dateStr.replacingOccurrences(of: ".", with: "")
        if(dateStr.count > 3) {
            let index = dateStr.index(dateStr.startIndex, offsetBy:3)
            dateStr = String(dateStr[..<index])
        }

        let sizeCenterCompB = CGSize(width: 42, height: 42)
        let centerCompB = self.drawCenterText(size: sizeCenterCompB, color: (self.colorSetData[self.colorSet]["date"]!).cgColor, string: "\(customFormatter2.string(for: Date.now)!)", subcolor: (self.colorSetData[self.colorSet]["dateday"]!).cgColor, substring: "\(dateStr.uppercased())")
        self.centerCompBottom.setImage(centerCompB)
    }
    
    func fetchBattery() {
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        var batteryLevel = CGFloat(WKInterfaceDevice.current().batteryLevel)
        if(batteryLevel < 0) {
            batteryLevel = 0.5
        }
        
        let size = CGSize(width: 210, height: 230)
        
        var batteryColor = (self.colorSetData[self.colorSet]["battery"] as! UIColor)
        if(batteryLevel < 0.2) {
            batteryColor = UIColor(red: 225/255, green: 35/255, blue: 35/255, alpha: 1)
        }
        let circleGaugeBg = self.drawGaugeCorner(size: size, color: (self.colorSetData[self.colorSet]["gaugeBackground"] as! UIColor).cgColor, value: 1, rotation: 37.5)
        let circleGaugeFg = self.drawGaugeCorner(size: size, color: batteryColor.cgColor, value: batteryLevel, rotation: 37.5)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        circleGaugeBg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.normal, alpha: 1)
        circleGaugeFg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.normal, alpha: 1)
        self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
        self.graphicContext!.scaleBy(x: 1, y: -1)
        //self!.centreArcPerpendicular(text: "——————", context: self!.graphicContext!, radius: 111, angle: (-127.5 * .pi / 180), colour: UIColor(red: 31/255, green: 219/255, blue: 113/255, alpha: 1), font: UIFont(name: "RedHatMono-Bold", size: 14)!, clockwise: false)
        self.centreArcPerpendicular(text: "\(Int(roundf(Float(batteryLevel) * 100)))%", context: self.graphicContext!, radius: 125, angle: (-127.5 * .pi / 180), colour: batteryColor, font: UIFont(name: "RedHatMono-Bold", size: 16)!, clockwise: false)


        let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.batteryImage.setImage(returnImage)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        self.crownAccumulator += rotationalDelta * 1.3
        if(Int(self.crownAccumulator) > (self.colorSetData.count - 1)) {
            self.crownAccumulator = 0
        }
        if(Int(self.crownAccumulator) < 0) {
            self.crownAccumulator = Double(self.colorSetData.count)
        }
        var setColorTheme = Int(self.crownAccumulator)
        if(self.colorSet != setColorTheme && setColorTheme >= 0 && setColorTheme < self.colorSetData.count) {
            self.colorSet = Int(self.crownAccumulator)
            self.updateColors()
        }
    }
    
    
    func updateColors() {
        self.compassNodeSn!.color = self.colorSetData[self.colorSet]["compassLines"]!
        self.compassNodeDegSn!.color = self.colorSetData[self.colorSet]["compassDeg"]!
        
        self.comp4ImageIcon.setTintColor(self.colorSetData[self.colorSet]["directionMarker"]!)
        self.ringOuterImage.setTintColor(self.colorSetData[self.colorSet]["ringOuter"]!)
        self.ringInnerImage.setTintColor(self.colorSetData[self.colorSet]["ringInner"]!)
        self.signal1.setBackgroundColor(self.colorSetData[self.colorSet]["signal1"]!)
        self.signal2.setBackgroundColor(self.colorSetData[self.colorSet]["signal2"]!)
        self.signal3.setBackgroundColor(self.colorSetData[self.colorSet]["signal3"]!)
        self.signal4.setBackgroundColor(self.colorSetData[self.colorSet]["signal4"]!)
        self.ringHours.setTintColor(self.colorSetData[self.colorSet]["ringHours"]!)
        self.ringMinutes.setTintColor(self.colorSetData[self.colorSet]["ringMinutes"]!)
        self.compassDegreeText.setTextColor(self.colorSetData[self.colorSet]["compassDegreeText"]!)
        
        
        self.handHour!.color = self.colorSetData[self.colorSet]["hourHand"]!
        self.handMinute!.color = self.colorSetData[self.colorSet]["minuteHand"]!
        self.handSecond!.color = self.colorSetData[self.colorSet]["secondHand"]!

        self.imageWalk.setImage(self.iconSetData[self.colorSet]["iconWalk"]!)
        self.imageAltmeter.setImage(self.iconSetData[self.colorSet]["iconAlt"]!)
        
        self.initDefaultHrAndBpm()
        self.readOxygenSturation()
        self.readHeartRate()
        self.drawTextCircle()
        self.readStepCount()
        self.readActivitySummary()
        self.fetchBattery()
        self.fetchDate()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            self.fetchLocationUpdate()
        }
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.fetchLocationUpdate()
        }
    }
    
    func fetchLocationUpdate() {
        // self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.activityType = CLActivityType.otherNavigation
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            var changed = false
            if(self.lastLat != location.latitude) {
                self.lastLat = location.latitude
                changed = true
            }
            if(self.lastLon != location.longitude) {
                self.lastLon = location.longitude
                changed = true
            }
            self.lastTime = location.timestamp
            if(changed) {
                self.drawTextCircle()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.compassDegreeText.setText("\(Int(newHeading.magneticHeading))°\(self.compassDirection(for: newHeading.magneticHeading)!)")
        /*
        if(abs(self.compassHeadingLastDegree - newHeading.magneticHeading) > 30) {
            self.compassNode.zRotation = (newHeading.magneticHeading * .pi / 180)
        } else {
            self.compassNode.run(SKAction.rotate(toAngle: (newHeading.magneticHeading * .pi / 180), duration: 0.05))
        }
        */
        self.compassNode.run(SKAction.rotate(toAngle: (newHeading.magneticHeading * .pi / 180), duration: 0.05))
        self.compassNodeDeg.run(SKAction.rotate(toAngle: (newHeading.magneticHeading * .pi / 180), duration: 0.05))
        self.compassHeadingLastDegree = newHeading.magneticHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    func centreArcPerpendicular(text str: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, clockwise: Bool){
        // *******************************************************
        // This draws the String str around an arc of radius r,
        // with the text centred at polar angle theta
        // *******************************************************

        let characters: [String] = str.map { String($0) } // An array of single character strings, each character in str
        let l = characters.count
        let attributes = [NSAttributedString.Key.font: font]

        var arcs: [CGFloat] = [] // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string

        // Calculate the arc subtended by each letter and their total
        for i in 0 ..< l {
            arcs += [chordToArc(characters[i].size(withAttributes: attributes).width, radius: r)]
            totalArc += arcs[i]
        }

        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection: CGFloat = clockwise ? -.pi / 2 : .pi / 2

        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var thetaI = theta - direction * totalArc / 2

        for i in 0 ..< l {
            thetaI += direction * arcs[i] / 2
            // Call centerText with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: characters[i], context: context, radius: r, angle: thetaI, colour: c, font: font, slantAngle: thetaI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            thetaI += direction * arcs[i] / 2
        }
    }

    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        // *******************************************************
        // Simple geometry
        // *******************************************************
        return 2 * asin(chord / (2 * radius))
    }

    func centre(text str: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, colour c: UIColor, font: UIFont, slantAngle: CGFloat) {
        // *******************************************************
        // This draws the String str centred at the position
        // specified by the polar coordinates (r, theta)
        // i.e. the x= r * cos(theta) y= r * sin(theta)
        // and rotated by the angle slantAngle
        // *******************************************************

        // Set the text attributes
        let attributes = [NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: font]
        //let attributes = [NSForegroundColorAttributeName: c, NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: -1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(withAttributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy (x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }

    
    func drawTextCircle() {
        let size = CGSize(width: 180, height: 180)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
        self.graphicContext!.scaleBy(x: 1, y: -1)
        
        var relativeDate = ""
        if(Date.now.timeIntervalSince1970 - self.lastTime.timeIntervalSince1970 < 30) {
            relativeDate = "GERADE AKTUALISIERT"
            if(self.language == "en") {
                relativeDate = "JUST UPDATED"
            }
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            formatter.dateTimeStyle = .named
            formatter.locale = Locale.current
            relativeDate = formatter.localizedString(for: self.lastTime, relativeTo: Date.now).uppercased()
        }
        
        /*
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        */
        
        var laengengrad = "LANGENGRAD"
        var breitengrad = "BREITENGRAD"
        if(self.language == "en") {
            laengengrad = "LONGITUDE"
            breitengrad = "LATITUDE"
        }
        
        
        var radius1: CGFloat = 68
        var radius2: CGFloat = 67.5
        var fontsize: CGFloat = 10
        if(WKInterfaceDevice.currentWatchModel == WatchModel.w44) {
            radius1 = 63
            radius2 = 62.5
            fontsize = 9
        } else if(WKInterfaceDevice.currentWatchModel == WatchModel.w41) {
            radius1 = 60
            radius2 = 60
            fontsize = 9
        } else if(WKInterfaceDevice.currentWatchModel == WatchModel.w40) {
            
        }
        
        self.centreArcPerpendicular(text: "\(breitengrad) \(self.lastLat)   \(laengengrad) \(self.lastLon)", context: self.graphicContext!, radius: radius1, angle: (90 * .pi / 180), colour: self.colorSetData[self.colorSet]["compassRing"]!, font: UIFont(name: "RedHatMono-Bold", size: fontsize)!, clockwise: true)
        self.centreArcPerpendicular(text: "\(relativeDate)", context: self.graphicContext!, radius: radius2, angle: (-90 * .pi / 180), colour: self.colorSetData[self.colorSet]["compassRing"]!, font: UIFont(name: "RedHatMono-Bold", size: fontsize)!, clockwise: false)
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.latlonTextCircleImage.setImage(returnImage)
    }
    
    
    func compassDirection(for heading: CLLocationDirection) -> String? {
        if heading < 0 { return nil }

        var directions = ["N", "NO", "O", "SE", "S", "SW", "W", "NW"]
        if(self.language == "en") {
            var directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        }
        let index = Int((heading + 22.5) / 45.0) & 7
        return directions[index]
    }
    
    

    
    func fetchHealthData() {
        DispatchQueue.main.async {
            let healthTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {  [weak self] _ in
                self!.readOxygenSturation()
                self!.readHeartRate()
            }
            healthTimer.fire()
            
            let activityTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) {  [weak self] _ in
                self!.readActivitySummary()
            }
            activityTimer.fire()
            
            let stepTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) {  [weak self] _ in
                self!.readStepCount()
            }
            stepTimer.fire()
             
        }
    }
    
    var stepCount = 0
    
    func readStepCount() {
        self.getTodaysSteps(completion: { (stepCount) in
            self.stepCount = Int(stepCount)
            self.getTodaysWalkingDistance(completion: { (distance) in
                
                var additionalWord = ""
                if(self.stepCount < 1000) {
                    additionalWord = " STEPS"
                }
                
                var distanceSign = "M"
                var distanceOut = "\(Double(distance))"
                if(distance < 1000) {
                    distanceOut = "\(Int(distance))"
                } else {
                    distanceOut = "\((Double(distance) / 1000).rounded(toPlaces: 1))"
                    distanceSign = "KM"
                }
                
                let size = CGSize(width: 210, height: 230)
                
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                self.graphicContext = UIGraphicsGetCurrentContext()
                self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
                self.graphicContext!.scaleBy(x: 1, y: -1)
                
                //self.centreArcPerpendicular(text: "\(self.stepCount)\(additionalWord)", context: self.graphicContext!, radius: 112, angle: (-52.5 * .pi / 180), colour: UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1), font: UIFont(name: "RedHatMono-Bold", size: 14)!, clockwise: false)
                
                self.centreArcPerpendicular(text: "\(distanceOut) \(distanceSign)", context: self.graphicContext!, radius: 112, angle: (-52.5 * .pi / 180), colour: self.colorSetData[self.colorSet]["distanceValue"]!, font: UIFont(name: "RedHatMono-Bold", size: 14)!, clockwise: false)
                
                //self.centreArcPerpendicular(text: "\(distanceOut) \(distanceSign)", context: self.graphicContext!, radius: 126, angle: (-52.5 * .pi / 180), colour: UIColor(red: 35/255, green: 240/255, blue: 170/255, alpha: 1), font: UIFont(name: "RedHatMono-Bold", size: 16)!, clockwise: false)

                
                let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                self.comp4Image.setImage(returnImage)
                
                
                
            })
        })
    }
    
    var heartRateString: String = "87"
    
    func readOxygenSturation() {
        self.getTodaysOxygenSaturation(completion: { (_, oxygenSaturation, _, _, _) in
            if(oxygenSaturation?.count != 0) {
                if let currData = oxygenSaturation!.last as? HKQuantitySample {
                    let sizeCenterCompB = CGSize(width: 42, height: 42)
                    let centerCompB = self.drawCenterText(size: sizeCenterCompB, color: (self.colorSetData[self.colorSet]["spo2value"]!).cgColor, string: "\("\(currData.quantity)".replacingOccurrences(of: " %", with: ""))", subcolor: (self.colorSetData[self.colorSet]["spo2"]!).cgColor, substring: "SpO2")
                    self.centerCompRight.setImage(centerCompB)
                }
            }
        })
    }
    
    func readActivitySummary() {
        let calendar = Calendar.autoupdatingCurrent
                
        var dateComponents = calendar.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )

        dateComponents.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (query, summaries, error) in

            guard let summaries = summaries, summaries.count > 0
            else {
                print(error)
                return
            }

            let energyUnit   = HKUnit.jouleUnit(with: .kilo)
            let standUnit    = HKUnit.count()
            let exerciseUnit = HKUnit.second()
            
            let energy   = summaries.last!.activeEnergyBurned.doubleValue(for: energyUnit)
            let stand    = summaries.last!.appleStandHours.doubleValue(for: standUnit)
            let exercise = summaries.last!.appleExerciseTime.doubleValue(for: exerciseUnit)
            
            let energyGoal   = summaries.last!.activeEnergyBurnedGoal.doubleValue(for: energyUnit)
            let standGoal    = summaries.last!.appleStandHoursGoal.doubleValue(for: standUnit)
            let exerciseGoal = summaries.last!.appleExerciseTimeGoal.doubleValue(for: exerciseUnit)
            
            var energyProgress   = energyGoal == 0 ? 0 : energy / energyGoal
            var standProgress    = standGoal == 0 ? 0 : stand / standGoal
            var exerciseProgress = exerciseGoal == 0 ? 0 : exercise / exerciseGoal
            
            if(energyProgress == 0) { energyProgress = 0.01 }
            if(standProgress == 0) { standProgress = 0.01 }
            if(exerciseProgress == 0) { exerciseProgress = 0.01 }
            
            let sizeActivity = CGSize(width: 42, height: 42)
            
            let centerComp1Bg = self.drawRing(size: sizeActivity, color: (self.colorSetData[self.colorSet]["gaugeBackground"]!).cgColor, value: 1, radius: 18)
            let centerComp1Fg = self.drawRing(size: sizeActivity, color: (self.colorSetData[self.colorSet]["ring1"]!).cgColor, value: energyProgress, radius: 18)
            let centerComp2Bg = self.drawRing(size: sizeActivity, color: (self.colorSetData[self.colorSet]["gaugeBackground"]!).cgColor, value: 1, radius: 12)
            let centerComp2Fg = self.drawRing(size: sizeActivity, color: (self.colorSetData[self.colorSet]["ring2"]!).cgColor, value: exerciseProgress, radius: 12)
            let centerComp3Bg = self.drawRing(size: sizeActivity, color: (self.colorSetData[self.colorSet]["gaugeBackground"]!).cgColor, value: 1, radius: 6)
            let centerComp3Fg = self.drawRing(size: sizeActivity, color: (self.colorSetData[self.colorSet]["ring3"]!).cgColor, value: standProgress, radius: 6)
            
            UIGraphicsBeginImageContextWithOptions(sizeActivity, false, 0)
            self.graphicContext = UIGraphicsGetCurrentContext()
            centerComp1Bg.draw(in: CGRect(x: 0, y: 0, width: sizeActivity.width, height: sizeActivity.height), blendMode: CGBlendMode.normal, alpha: 1)
            centerComp2Bg.draw(in: CGRect(x: 0, y: 0, width: sizeActivity.width, height: sizeActivity.height), blendMode: CGBlendMode.normal, alpha: 1)
            centerComp3Bg.draw(in: CGRect(x: 0, y: 0, width: sizeActivity.width, height: sizeActivity.height), blendMode: CGBlendMode.normal, alpha: 1)
            centerComp1Fg.draw(in: CGRect(x: 0, y: 0, width: sizeActivity.width, height: sizeActivity.height), blendMode: CGBlendMode.normal, alpha: 1)
            centerComp2Fg.draw(in: CGRect(x: 0, y: 0, width: sizeActivity.width, height: sizeActivity.height), blendMode: CGBlendMode.normal, alpha: 1)
            centerComp3Fg.draw(in: CGRect(x: 0, y: 0, width: sizeActivity.width, height: sizeActivity.height), blendMode: CGBlendMode.normal, alpha: 1)
            let centerCompAct = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.centerCompLeft.setImage(centerCompAct)
            

        }
        
        self.healthStore.execute(query)
    }

    func readHeartRate() {
        self.getTodaysHeartRate(completion: { (_, heartRate, _, _, _) in
            if(heartRate?.count != 0) {
                var lowestRate: CGFloat = 0
                var highestRate: CGFloat = 0
                var currentRate: CGFloat = 0
                if let currData = heartRate!.last as? HKQuantitySample {
                    self.heartRateString = "\(Int(currData.quantity.doubleValue(for: HKUnit(from: "count/min"))))"
                    lowestRate = CGFloat(currData.quantity.doubleValue(for: HKUnit(from: "count/min")))
                    highestRate = CGFloat(currData.quantity.doubleValue(for: HKUnit(from: "count/min")))
                    currentRate = CGFloat(currData.quantity.doubleValue(for: HKUnit(from: "count/min")))
                }
                
                for rate in heartRate! {
                    if let rateData = rate as? HKQuantitySample {
                        let thisRate = CGFloat(rateData.quantity.doubleValue(for: HKUnit(from: "count/min")))
                        if(thisRate < lowestRate) {
                            lowestRate = thisRate
                        }
                        if(thisRate > highestRate) {
                            highestRate = thisRate
                        }
                    }
                }
                

                let diffRate: CGFloat = highestRate - lowestRate
                let percPerRate: CGFloat = 1 / diffRate
                let valueOfActualPerc: CGFloat = (currentRate - lowestRate) * percPerRate
       
                let size = CGSize(width: 210, height: 230)
                
                let circleGaugeBg = self.drawGaugeCorner(size: size, color: (self.colorSetData[self.colorSet]["gaugeBackground"]!).cgColor, value: 1, rotation: 37.5 + 180)
                let circleGaugeFg = self.drawGaugeCornerDot(size: size, color: (self.colorSetData[self.colorSet]["bpm"]!).cgColor, value: (1 - valueOfActualPerc), rotation: 37.5 + 180)
                
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                self.graphicContext = UIGraphicsGetCurrentContext()
                
                circleGaugeBg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.normal, alpha: 1)
                circleGaugeFg.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: CGBlendMode.normal, alpha: 1)
                
                self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
                self.graphicContext!.scaleBy(x: 1, y: -1)
                
                self.centreArcPerpendicular(text: self.heartRateString, context: self.graphicContext!, radius: 125, angle: ((52.5 + 3) * .pi / 180), colour: self.colorSetData[self.colorSet]["bpm"]!, font: UIFont(name: "RedHatMono-Bold", size: 16)!, clockwise: true)
                self.centreArcPerpendicular(text: "BPM", context: self.graphicContext!, radius: 122, angle: ((52.5 - 8) * .pi / 180), colour: self.colorSetData[self.colorSet]["bpm"]!, font: UIFont(name: "RedHatMono-Bold", size: 8)!, clockwise: true)

                let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                self.comp3Image.setImage(returnImage)
                
                
            }
        })
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        self.healthStore.execute(query)
    }
    
    func getTodaysWalkingDistance(completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.meter()))
        }
        
        self.healthStore.execute(query)
    }
    
    func getTodaysOxygenSaturation(completion: @escaping (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let datePredicate = HKQuery.predicateForSamples(withStart: startOfDay, end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])

        let query = HKAnchoredObjectQuery(
            type: HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!,
            predicate: queryPredicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit,
            resultsHandler: completion
        )

        self.healthStore.execute(query)
    }
    
    func getTodaysHeartRate(completion: @escaping (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let datePredicate = HKQuery.predicateForSamples(withStart: startOfDay, end: nil, options: .strictStartDate)
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let queryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate, devicePredicate])

        let query = HKAnchoredObjectQuery(
            type: HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            predicate: queryPredicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit,
            resultsHandler: completion
        )

        self.healthStore.execute(query)
    }
    

    func drawGaugeCorner(size: CGSize, color: CGColor, value: CGFloat, rotation: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
        self.graphicContext!.scaleBy(x: 1, y: -1)
        
        let startAngle = -109° + (38° * value)
        let kThickness = CGFloat(6)
        self.graphicContext!.addArc(center: CGPoint(x: 0, y: 0),
                           radius: (110),
                           startAngle: startAngle - (rotation * .pi / 180),
                           endAngle: -109° - (rotation * .pi / 180),
                           clockwise: true)
        
        self.graphicContext!.setLineWidth(kThickness)
        self.graphicContext!.setLineCap(.round)
        self.graphicContext!.replacePathWithStrokedPath()
        let path = self.graphicContext!.path!
        self.graphicContext!.beginTransparencyLayer(auxiliaryInfo: nil)
        self.graphicContext!.saveGState()

        let rgb = CGColorSpaceCreateDeviceRGB()

        let gradient = CGGradient(
            colorsSpace: rgb,
            colors: [color, color] as CFArray,
            locations: [CGFloat(0), CGFloat(1)])!

        let bbox = path.boundingBox
        let startP = bbox.origin
        var endP = CGPoint(x: bbox.maxX, y: bbox.maxY);
        if (bbox.size.width > bbox.size.height) {
            endP.y = startP.y
        } else {
            endP.x = startP.x
        }

        self.graphicContext!.clip()
        
        self.graphicContext!.drawLinearGradient(gradient, start: startP, end: endP, options: CGGradientDrawingOptions(rawValue: 0))
        
        self.graphicContext!.restoreGState()
        self.graphicContext!.addPath(path)
        self.graphicContext!.setLineJoin(.miter)
        self.graphicContext!.endTransparencyLayer()
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
    func drawGaugeCornerDot(size: CGSize, color: CGColor, value: CGFloat, rotation: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
        self.graphicContext!.scaleBy(x: 1, y: -1)
        
        let startAngle = -109° + (38° * value)
        let kThickness = CGFloat(10)
        let kLineWidth = CGFloat(2)
        self.graphicContext!.addArc(center: CGPoint(x: 0, y: 0),
                           radius: (110),
                           startAngle: startAngle - (rotation * .pi / 180),
                           endAngle: startAngle - (rotation * .pi / 180) - 0.1°,
                           clockwise: true)
        
        self.graphicContext!.setLineWidth(kThickness)
        self.graphicContext!.setLineCap(.round)
        self.graphicContext!.replacePathWithStrokedPath()
        let path = self.graphicContext!.path!
        self.graphicContext!.beginTransparencyLayer(auxiliaryInfo: nil)
        self.graphicContext!.saveGState()

        let rgb = CGColorSpaceCreateDeviceRGB()

        let gradient = CGGradient(
            colorsSpace: rgb,
            colors: [color, color] as CFArray,
            locations: [CGFloat(0), CGFloat(1)])!

        let bbox = path.boundingBox
        let startP = bbox.origin
        var endP = CGPoint(x: bbox.maxX, y: bbox.maxY);
        if (bbox.size.width > bbox.size.height) {
            endP.y = startP.y
        } else {
            endP.x = startP.x
        }

        self.graphicContext!.clip()
        
        self.graphicContext!.drawLinearGradient(gradient, start: startP, end: endP, options: CGGradientDrawingOptions(rawValue: 0))
        
        self.graphicContext!.restoreGState()
        self.graphicContext!.addPath(path)
        
        self.graphicContext!.setLineWidth(kLineWidth)
        UIColor.black.setStroke()
        self.graphicContext!.strokePath()
        
        self.graphicContext!.setLineJoin(.miter)
        self.graphicContext!.endTransparencyLayer()
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
    
    func drawCenterText(size: CGSize, color: CGColor, string: String, subcolor: CGColor, substring: String) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        
        self.graphicContext!.setFillColor((self.colorSetData[self.colorSet]["circleBackground"]!).cgColor)

        let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.graphicContext!.addEllipse(in: rectangle)
        self.graphicContext!.drawPath(using: .fill)
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let font = UIFont(name: "RedHatMono-Bold", size: 14)
        let string = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(cgColor: color), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        string.draw(in: CGRect(x: 0, y: 5, width: size.width, height: 30))
        
        let fontSm = UIFont(name: "RedHatMono-Bold", size: 10)
        let stringSm = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font: fontSm, NSAttributedString.Key.foregroundColor: UIColor(cgColor: subcolor), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        stringSm.draw(in: CGRect(x: 0, y: 22, width: size.width, height: 30))
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
    
    func drawGaugeCenter(size: CGSize, color: CGColor, value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
        self.graphicContext!.scaleBy(x: 1, y: -1)
        
        let startAngle = 240°
        let endAngle = 240° - (300° * value)
        let kThickness = CGFloat(4)
        self.graphicContext!.addArc(center: CGPoint(x: 0, y: 0),
                           radius: (15),
                           startAngle: startAngle,
                           endAngle: endAngle,
                           clockwise: true)
        
        self.graphicContext!.setLineWidth(kThickness)
        self.graphicContext!.setLineCap(.round)
        self.graphicContext!.replacePathWithStrokedPath()
        let path = self.graphicContext!.path!
        self.graphicContext!.beginTransparencyLayer(auxiliaryInfo: nil)
        self.graphicContext!.saveGState()

        let rgb = CGColorSpaceCreateDeviceRGB()

        let gradient = CGGradient(
            colorsSpace: rgb,
            colors: [color, color] as CFArray,
            locations: [CGFloat(0), CGFloat(1)])!

        let bbox = path.boundingBox
        let startP = bbox.origin
        var endP = CGPoint(x: bbox.maxX, y: bbox.maxY);
        if (bbox.size.width > bbox.size.height) {
            endP.y = startP.y
        } else {
            endP.x = startP.x
        }

        self.graphicContext!.clip()
        
        self.graphicContext!.drawLinearGradient(gradient, start: startP, end: endP, options: CGGradientDrawingOptions(rawValue: 0))
        
        self.graphicContext!.restoreGState()
        self.graphicContext!.addPath(path)
        self.graphicContext!.setLineJoin(.miter)
        self.graphicContext!.endTransparencyLayer()
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
    
    
    func drawRing(size: CGSize, color: CGColor, value: CGFloat, radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.graphicContext = UIGraphicsGetCurrentContext()
        self.graphicContext!.translateBy (x: size.width / 2, y: size.height / 2)
        self.graphicContext!.scaleBy(x: 1, y: -1)
        
        let kThickness = CGFloat(5)
        self.graphicContext!.addArc(center: CGPoint(x: 0, y: 0),
                           radius: (radius),
                           startAngle: 90°,
                           endAngle: 90° - (360° * value),
                           clockwise: true)
        
        self.graphicContext!.setLineWidth(kThickness)
        self.graphicContext!.setLineCap(.round)
        self.graphicContext!.replacePathWithStrokedPath()
        let path = self.graphicContext!.path!
        
        
        self.graphicContext!.setShadow(
            offset: CGSize(width: 0, height: 1.5),
            blur: 1.5,
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        )
        
        
        self.graphicContext!.beginTransparencyLayer(auxiliaryInfo: nil)
        self.graphicContext!.saveGState()
        
        let rgb = CGColorSpaceCreateDeviceRGB()

        let gradient = CGGradient(
            colorsSpace: rgb,
            colors: [color, color] as CFArray,
            locations: [CGFloat(0), CGFloat(1)])!

        let bbox = path.boundingBox
        let startP = bbox.origin
        var endP = CGPoint(x: bbox.maxX, y: bbox.maxY);
        if (bbox.size.width > bbox.size.height) {
            endP.y = startP.y
        } else {
            endP.x = startP.x
        }

        self.graphicContext!.clip()
        
        self.graphicContext!.drawLinearGradient(gradient, start: startP, end: endP, options: CGGradientDrawingOptions(rawValue: 0))
        
        self.graphicContext!.restoreGState()
        self.graphicContext!.addPath(path)
        self.graphicContext!.setLineJoin(.miter)
        self.graphicContext!.endTransparencyLayer()
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
    
    
}


extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension BinaryFloatingPoint {
    var dms: (degrees: Int, minutes: Int, seconds: Int) {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        return (degrees, seconds / 60, seconds % 60)
    }
}

extension CLLocation {
    var dms: String { latitude + " " + longitude }
    var latitude: String {
        let (degrees, minutes, seconds) = coordinate.latitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? " N" : " S")
    }
    var longitude: String {
        let (degrees, minutes, seconds) = coordinate.longitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? " O" : " W")
    }
}

postfix operator °

protocol IntegerInitializable: ExpressibleByIntegerLiteral {
  init (_: Int)
}

extension Double: IntegerInitializable {
  postfix public static func °(lhs: Double) -> CGFloat {
    return CGFloat(lhs) * .pi / 180
  }
}


enum WatchModel {
    case w38, w40, w41, w42, w44, w45, unknown
}


extension WKInterfaceDevice {

    static var currentWatchModel: WatchModel {
        switch WKInterfaceDevice.current().screenBounds.size {
        case CGSize(width: 136, height: 170):
            return .w38
        case CGSize(width: 162, height: 197):
            return .w40
        case CGSize(width: 176, height: 215):
            return .w41
        case CGSize(width: 156, height: 195):
            return .w42
        case CGSize(width: 184, height: 224):
            return .w44
        case CGSize(width: 198, height: 242):
            return .w45
        default:
            return .unknown
    }
  }
}


