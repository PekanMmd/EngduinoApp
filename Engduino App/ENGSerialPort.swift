//
//  ENGSerialPort.swift
//  Engduino App
//
//  Created by The Steez on 08/10/2015.
//  Copyright © 2015 Ovation International. All rights reserved.
//
// /dev/tty.uart-CAFF49F37B47153E
//
import Cocoa

enum ENGSubTasks: Int {
	
	case pH   = 0
	case heat = 1
	case stir = 2
}

class ENGSerialPort : NSObject, ORSSerialPortDelegate {
	
	var timer : NSTimer!
	let kTimerDuration = 5.0
	
	var path = "/dev/"
	var baud = 9600
	var port : ORSSerialPort!
	var task = ENGSubTasks.pH
	
	init(subTask: ENGSubTasks) {
		super.init()
		self.task = subTask
	}
	
	func isOpen() -> Bool {
		return self.port != nil
	}
	
	func openSerialPort() -> Bool {
		
		if !isOpen() {
			self.port = ORSSerialPort(path: self.path)
			if self.port == nil {
				print("That port doesn't exist")
				return false
			}
			port.baudRate = self.task == .stir ? 4800 : self.baud
			port.delegate = self
			port.open()
			print("opened serial port \(self.path)")
			
			timer = NSTimer.scheduledTimerWithTimeInterval(kTimerDuration, target: self, selector: "sendOptimum", userInfo: nil, repeats: true)
			
			return true
		} else {
			print("There is already an open port")
			return false
		}
	}
	
	func writeData(data : Int) -> Bool {
		
		var sent = false
		
		if self.isOpen() {
			var data = data
			let val = NSData(bytes: &data, length: 4)
			sent = self.port.sendData(val)
		} else {
			print("failed to send \(data) to " + self.path + " (port unavailable)")
			return false
		}
		
		if sent {
			print("successfully sent \(data) to " + self.path)
			return true
		} else {
			print("failed to send \(data) to " + self.path)
			return false
		}
	}
	
	func closeSerialPort() {
		
		if self.isOpen() {
			print("closing serial port \(self.path)")
			self.port.close()
			self.port = nil
			timer.invalidate()
			timer = nil
		}
	}
	
	func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
		var val = 0
		data.getBytes(&val, length: 4)
		print("received \(val) from " + self.path)
		
		switch self.task {
			case .pH   : let val = Int(String(data: data, encoding: NSUTF8StringEncoding)!)!; ENGParseManager.setpH(val)
			case .heat : let val = Int(String(data: data, encoding: NSUTF8StringEncoding)!)!; ENGParseManager.setTemp(val)
			case .stir : let val = Int(String(data: data, encoding: NSUTF8StringEncoding)!)!; ENGParseManager.setRPM(val)
		}
		
	}
	
	func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
		self.closeSerialPort()
	}
	
	func sendOptimum() {
		
		if isOpen() {
			switch self.task {
			case .pH   : updatePH()
			case .heat : updateTemp()
			case .stir : updateRPM()
			}
		}
	}
	
	func updatePH() {
		let temp = ENGParseManager.getCurrentTemp()
		let oPH = ENGParseManager.getpH()
		
		writeData(temp)
		writeData(oPH)
	}
	
	func updateTemp() {
		let temp = ENGParseManager.getTemp()
		writeData(temp)
	}
	
	func updateRPM() {
		let rpm = ENGParseManager.getRPM()
		writeData(rpm)
	}
	
}












