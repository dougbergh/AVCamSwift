//
//  BarcodeViewController.swift
//  ShoCard
//
// SHOCARD CONFIDENTIAL
// __________________
// (C) COPYRIGHT 2015 ShoCard, Inc. All Rights Reserved.
// NOTICE: All information contained herein is the property of ShoCard, Inc.
// The intellectual and technical concepts contained herein are proprietary to
// ShoCard, Inc., and may be covered by U.S. and Foreign Patents, patents
// in process, and are protected by trade secret or copyright law.
// Dissemination or reproduction of this material is strictly forbidden unless
// prior written permission is obtained from ShoCard, Inc.
//

import UIKit
import AVFoundation
import LocalAuthentication

class BarcodeViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
//    var shoCardPresenter: ShoCardPresenter? = nil
    
    @IBOutlet var cameraView: UIView!
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var running : Bool = false
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print( "ViewController.viewDidLoad" )
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.cameraView.addSubview(self.highlightView)
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        let error : NSError? = nil
        
        do {
            
            let input : AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: device)
            // If our input is not nil then add it to the session, otherwise we're kind of done!
            if input != nil {
                captureSession.addInput(input)
            }
            else {
                // This is fine for a demo, do something real with this in your app. :)
                print(error)
            }
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureSession.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = self.cameraView.bounds
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.cameraView.layer.addSublayer(previewLayer)
            
            // Start the scanner. You'll have to end it yourself later.
            captureSession.startRunning()
            running = true
            
            let touch = UITapGestureRecognizer(target:self, action:"tappedView")
            cameraView.addGestureRecognizer(touch)
        } catch {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDeviceSettings(focusValue : Float, isoValue : Float) {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                device.setFocusModeLockedWithLensPosition(focusValue, completionHandler: { (time) -> Void in
                    //
                })
                
                // Adjust the iso to clamp between minIso and maxIso based on the active format
                let minISO = device.activeFormat.minISO
                let maxISO = device.activeFormat.maxISO
                let clampedISO = isoValue * (maxISO - minISO) + minISO
                
                device.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, ISO: clampedISO, completionHandler: { (time) -> Void in
                    //
                })
                
                device.unlockForConfiguration()
                
            } catch {
                
            }
        }
    }
    
    func tappedView() {
        if (running) {
            self.captureSession.stopRunning()
            running = false
        } else {
            self.highlightView.frame = CGRectZero
            self.captureSession.startRunning()
            running = true
        }
        // dismiss keyboard if showing
        self.view.endEditing(true)
    }
    
    func touchPercent(touch : UITouch) -> CGPoint {
        // Get the dimensions of the screen in points
        let screenSize = UIScreen.mainScreen().bounds.size
        
        // Create an empty CGPoint object set to 0, 0
        var touchPer = CGPointZero
        
        // Set the x and y values to be the value of the tapped position, divided by the width/height of the screen
        touchPer.x = touch.locationInView(self.view).x / screenSize.width
        touchPer.y = touch.locationInView(self.view).y / screenSize.height
        
        // Return the populated CGPoint
        return touchPer
    }
    
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let touchPer = touchPercent( touches!.first! )
        //focusTo(Float(touchPer.x))
        updateDeviceSettings(Float(touchPer.x), isoValue: Float(touchPer.y))
    }
    
    override func touchesMoved(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let touchPer = touchPercent( touches!.first! )
        //focusTo(Float(touchPer.x))
        updateDeviceSettings(Float(touchPer.x), isoValue: Float(touchPer.y))
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
            
            highlightViewRect = barCodeObject.bounds
            
            detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
            
            if ( metadata.type == AVMetadataObjectTypeQRCode ) {
                print("FOUND QR CODE")
//                shoCardPresenter?.processQRCode(nil, barcodeDisplay: detectionString)
            } else if ( metadata.type == AVMetadataObjectTypePDF417Code ) {
                print("FOUND PDF417")
//                shoCardPresenter?.processPDF417Code(detectionString);
//                driverLicense = (shoCardPresenter?.getDriverLicense())!
            }
            self.highlightView.frame = highlightViewRect
            self.cameraView.bringSubviewToFront(self.highlightView)
            
            self.captureSession.stopRunning()
            running = false
            
            // present the IDViewController, which shows the image and table            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idViewController") as UIViewController
            // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
            
            self.presentViewController(viewController, animated: false, completion: nil)
            
            // only process the first one
            break
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

