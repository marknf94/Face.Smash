//
//  ViewController.swift
//  Face.Smash
//
//  Created by Mark Fernandez on 1/14/17.
//  Copyright © 2017 Mark Fernandez. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 10.0, *)
class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraV: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()

    @IBOutlet weak var Find_Btn: UIButton!
    @IBOutlet weak var Add_Btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Find_Btn.backgroundColor = .clear
        Find_Btn.layer.cornerRadius = 5
        Find_Btn.layer.borderWidth = 1
        Find_Btn.layer.borderColor = UIColor.white.cgColor
        
        Add_Btn.backgroundColor = .clear
        Add_Btn.layer.cornerRadius = 5
        Add_Btn.layer.borderWidth = 1
        Add_Btn.layer.borderColor = UIColor.white.cgColor
        
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
                            cameraV.addSubview(Find_Btn)
                            cameraV.addSubview(Add_Btn)
                            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Find_Btn(_ sender: Any) {
        
        if #available(iOS 10.0, *) {
            let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateInitialViewController() as! CameraViewController
            cameraVC.photoType = PhotoType.login
            self.present(cameraVC, animated: false, completion: nil)
        } else {
            // Fallback on earlier versions
        }
        

    }

}

