//
//  AddFaceViewController.swift
//  Face.Smash
//
//  Created by Mark Fernandez on 1/14/17.
//  Copyright © 2017 Mark Fernandez. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation



var name = "No Name"
var age = "No Age"

@available(iOS 10.0, *)
class AddFaceViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var next_Btn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    @IBOutlet weak var cancel_Btn: UIButton!
    @IBOutlet weak var cameraV: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancel_Btn.backgroundColor = .clear
        cancel_Btn.layer.cornerRadius = 5
        cancel_Btn.layer.borderWidth = 1
        cancel_Btn.layer.borderColor = UIColor.white.cgColor
        
        next_Btn.backgroundColor = .clear
        next_Btn.layer.cornerRadius = 5
        next_Btn.layer.borderWidth = 1
        next_Btn.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let deviceSession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDuoCamera,.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        
        for device in (deviceSession?.devices)! {
            
            if device.position == AVCaptureDevicePosition.back {
                
                do {
                    
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = .portrait
                            
                            cameraV.layer.addSublayer(previewLayer)
                            cameraV.addSubview(next_Btn)
                            cameraV.addSubview(cancel_Btn)
                            cameraV.addSubview(nameField)
                            cameraV.addSubview(ageField)
                            
                            previewLayer.position = CGPoint (x: self.cameraV.frame.width / 2, y: self.cameraV.frame.height / 2)
                            previewLayer.bounds = cameraV.frame
                            
                            captureSession.startRunning()
                            
                        }
                    }
                    
                    
                } catch let avError {
                    print(avError)
                }
            }
            
        }
    }


    
    @IBAction func next_Btn(_ sender: AnyObject) {
        
        
        if (nameField.text?.isEmpty)! || (ageField.text?.isEmpty)!{
            self.emtpyfields()
        }else{
        
            if #available(iOS 10.0, *) {
                
                name = nameField.text!
                age = ageField.text!
                
                let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateInitialViewController() as! CameraViewController
                
                cameraVC.photoType = .signup
                self.present(cameraVC, animated: true, completion: nil)
                
                
                
            
            } else {
                // Fallback on earlier versions
            }
        }
    
    }
    
    func emtpyfields(){
        
        // THE PERSON IS NOT THE SAME
        let alert = UIAlertController(title: "Not Done!", message: "Please fill in all fields", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in

        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
