//
//  ViewController.swift
//  Engduino App
//
//  Created by The Steez on 03/10/2015.
//  Copyright © 2015 Ovation International. All rights reserved.
//

import Cocoa
import Parse

class ENGViewController: NSViewController, NSTextFieldDelegate {
	
	// UI Elements
	
	var pHPath = NSTextField()
	var pHTitle = ENGViewController.labelWithText("pH Serial Path")
	var pHDetail = ENGViewController.labelWithText("Port closed.")
	
	var tempPath = NSTextField()
	var tempTitle = ENGViewController.labelWithText("Temperature Serial Path")
	var tempDetail = ENGViewController.labelWithText("Port closed.")
	
	var stirPath = NSTextField()
	var stirTitle = ENGViewController.labelWithText("Stirring Serial Path")
	var stirDetail = ENGViewController.labelWithText("Port closed.")
	
	var openPorts = NSButton()
	var closePorts = NSButton()
	
	// Ports
	
	var pH   = ENGSerialPort(subTask: .pH)
	var temp = ENGSerialPort(subTask: .heat)
	var rpm  = ENGSerialPort(subTask: .stir)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let ports = ["pH"  : ["port" : pH  , "path" : pHPath  , "title" : pHTitle  , "detail" : pHDetail  ],
					 "temp": ["port" : temp, "path" : tempPath, "title" : tempTitle, "detail" : tempDetail],
					 "rpm" : ["port" : rpm , "path" : stirPath, "title" : stirTitle, "detail" : stirDetail]]
		
		
		var i : CGFloat = 0
		
		for p in ["pH", "temp", "rpm"] {
			
			let dict = ports[p]!
			let port = dict["port"]! as! ENGSerialPort
			let serialPath   = dict["path"]!   as! NSTextField
			let serialTitle  = dict["title"]!  as! NSTextField
			let serialDetail = dict["detail"]! as! NSTextField
			
			serialPath.stringValue = port.path
			serialPath.delegate = self
			serialPath.usesSingleLineMode = true
			serialPath.target = self
			serialPath.action = "setSerialPathAction"
			
			self.view.addSubview(serialPath)
			self.view.addSubview(serialTitle)
			self.view.addSubview(serialDetail)
			
			serialTitle.frame  = CGRectMake(25, 120 + (i * 90), 200, 20)
			serialPath.frame   = CGRectMake(25, 100 + (i * 90), 200, 20)
			serialDetail.frame = CGRectMake(25,  80 + (i * 90), 200, 20)
			
			i++
			
		}
		
		self.openPorts.title = "Open Serial Ports"
		self.closePorts.title = "Close Serial Ports"
		self.openPorts.target = self
		self.openPorts.action = "openPortsAction"
		self.closePorts.target = self
		self.closePorts.action = "closePortsAction"
		
		self.view.addSubview(self.openPorts)
		self.view.addSubview(self.closePorts)
		
		
//		self.serialTitle.frame  = CGRectMake(430, 160, 200, 20)
//		self.serialPath.frame   = CGRectMake(430, 140, 200, 20)
//		self.serialDetail.frame = CGRectMake(430, 110, 200, 20)
		
		
		
		self.openPorts.frame     = CGRectMake(25,  40, 200, 20)
		self.closePorts.frame    = CGRectMake(25,  10, 200, 20)
		
		
	}

	override var representedObject: AnyObject? {
		didSet {
		}
	}

	func openPortsAction() {
		let ports = ["pH"  : ["port" : pH  , "path" : pHPath  , "title" : pHTitle  , "detail" : pHDetail  ],
			"temp": ["port" : temp, "path" : tempPath, "title" : tempTitle, "detail" : tempDetail],
			"rpm" : ["port" : rpm , "path" : stirPath, "title" : stirTitle, "detail" : stirDetail]]
		
		for p in ["pH", "temp", "rpm"] {
			
			let dict = ports[p]!
			let port = dict["port"]! as! ENGSerialPort
			let serialPath   = dict["path"]!   as! NSTextField
			let serialDetail = dict["detail"]! as! NSTextField
			
			if !port.isOpen() {
				port.openSerialPort()
				
				if port.isOpen() {
					serialPath.enabled = false
					serialDetail.stringValue = "Opened: " + port.path
				} else {
					serialDetail.stringValue = "That port doesn't exist!"
				}
			}
		}
	}
	
	func closePortsAction() {
		let ports = ["pH"  : ["port" : pH  , "path" : pHPath  , "title" : pHTitle  , "detail" : pHDetail  ],
			"temp": ["port" : temp, "path" : tempPath, "title" : tempTitle, "detail" : tempDetail],
			"rpm" : ["port" : rpm , "path" : stirPath, "title" : stirTitle, "detail" : stirDetail]]
		
		for p in ["pH", "temp", "rpm"] {
			
			let dict = ports[p]!
			let port = dict["port"]! as! ENGSerialPort
			let serialPath   = dict["path"]!   as! NSTextField
			let serialDetail = dict["detail"]! as! NSTextField
			
			if port.isOpen() {
				port.closeSerialPort()
				
				if !port.isOpen() {
					serialPath.enabled = true
					serialDetail.stringValue = "Port closed."
				} else {
					serialDetail.stringValue = "Couldn't close: " + port.path
				}
			}
		}
	}
	
	
	func setSerialPathAction() {
		
		if !pH.isOpen() {
			pH.path = pHPath.stringValue
		}
		
		if !temp.isOpen() {
			temp.path = tempPath.stringValue
		}
		
		
		if !rpm.isOpen() {
			rpm.path = stirPath.stringValue
		}
		
	}
	
	override func controlTextDidChange(obj: NSNotification) {
		setSerialPathAction()
	}
	
	
	class func labelWithText(text: String) -> NSTextField {
		let label = NSTextField()
		label.alignment = .Center
		label.font = NSFont.labelFontOfSize(10)
		label.textColor = NSColor.whiteColor()
		label.stringValue = text
		label.editable = false
		label.bezeled = false
		label.bordered = false
		label.backgroundColor = NSColor.clearColor()
		return label
	}
	
}













