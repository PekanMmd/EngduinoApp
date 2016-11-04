//
//  ENGBluetoothManager.swift
//  Engduino App
//
//  Created by The Steez on 08/10/2015.
//  Copyright © 2015 Ovation International. All rights reserved.
//

import Cocoa
import Parse

class ENGParseManager: NSObject {
	
	class func setpH(val: Int) {
		ENGValue(name: "pH", value: val).sendToParse()
	}
	
	class func setTemp(val: Int) {
		ENGValue(name: "temp", value: val).sendToParse()
	}
	
	class func setRPM(val: Int) {
		ENGValue(name: "rpm", value: val).sendToParse()
	}
	
	class func getCurrentTemp() -> Int {
		return ENGParseManager.getValueWithName("temp")
	}
	
	class func getpH() -> Int {
		return ENGParseManager.getValueWithName("opH")
	}
	
	class func getTemp() -> Int {
		return ENGParseManager.getValueWithName("otemp")
	}
	
	class func getRPM() -> Int {
		return ENGParseManager.getValueWithName("orpm")
	}
	
	class func getValueWithName(name: String) -> Int {
		
		let query = PFQuery(className: "ENGValue")
		query.whereKey("name", equalTo: name)
		
		var obj = PFObject(className: "ENGValue", dictionary: ["value" : 0, "name" : name])
		
		do {
			obj = try query.getFirstObject()
		} catch {
			
		}
		
		let val = obj["value"] as? Int
		
		return val ?? 0
	}

}

class ENGValue : NSObject {
	
	var value = 0
	var name = ""
	
	var parseRepresentation : PFObject {
		get {
			return PFObject(className: "ENGValue", dictionary: ["value" : value, "name" : name])
		}
	}
	
	init(name: String, value: Int) {
		super.init()
		
		self.name  = name
		self.value = value
	}
	
	func sendToParse() {
			self.parseRepresentation.saveInBackgroundWithBlock { (success, error) -> Void in
				print("sent \(self.value) to parse with success: \(success) for \(self.name)")
		}
	}
	
	
}




































