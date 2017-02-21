//
//  CameraViewController.swift
//  Face.Smash
//
//  Created by Mark Fernandez on 1/14/17.
//  Copyright © 2017 Mark Fernandez. All rights reserved.
//

import UIKit
import AVFoundation
import ProjectOxfordFace
import Parse
import NVActivityIndicatorView
import LTMorphingLabel



enum PhotoType {
    case login
    case signup
}

var ID = ""
var AGE = ""

@available(iOS 10.0, *)
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, NVActivityIndicatorViewable {
    
    var photoType: PhotoType!
    var personImage: UIImage!
    
    var picArray = [PFFile]()
    var nameArray = [String]()
    var ageArray = [String]()
    var schoolArray = [String]()
    
    var actIdc: UIActivityIndicatorView!



    
    var faceFromPhoto: MPOFace!
    var faceFromFirebase: MPOFace!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    
    @IBOutlet weak var reset_Btn: UIButton!
    
    
    @IBOutlet weak var name_Lbl: LTMorphingLabel!
    @IBOutlet weak var age_Lbl: LTMorphingLabel!
    
    
    
    
    
    
    
    
    
    
    

    @IBOutlet weak var cameraView: UIView!
    
    
    @IBOutlet weak var button: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        let deviceSession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDuoCamera,.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        
        for device in (deviceSession?.devices)! {
            
            if photoType == PhotoType.signup{
                
                if device.position == AVCaptureDevicePosition.front {
                    
                    do {
                        
                        let input = try AVCaptureDeviceInput(device: device)
                        
                        if captureSession.canAddInput(input){
                            captureSession.addInput(input)
                            
                            if captureSession.canAddOutput(sessionOutput){
                                captureSession.addOutput(sessionOutput)
                                
                                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                                previewLayer.connection.videoOrientation = .portrait
                                
                                cameraView.layer.addSublayer(previewLayer)
                                cameraView.addSubview(button)
                                cameraView.addSubview(name_Lbl)
                                cameraView.addSubview(reset_Btn)
                                cameraView.addSubview(age_Lbl)

                                
                                previewLayer.position = CGPoint (x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                                previewLayer.bounds = cameraView.frame
                                
                                captureSession.startRunning()
                                
                                
                                
                            }
                        }
                        
                        
                    } catch let avError {
                        print(avError)
                    }
                    
                    
                }
                
            }else{
                
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
                                
                                cameraView.layer.addSublayer(previewLayer)
                                cameraView.addSubview(button)
                                cameraView.addSubview(name_Lbl)
                                cameraView.addSubview(reset_Btn)
                                cameraView.addSubview(age_Lbl)


                                
                                previewLayer.position = CGPoint (x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                                previewLayer.bounds = cameraView.frame
                                
                                captureSession.startRunning()
                                
                                
                                
                            }
                        }
                        
                        
                    } catch let avError {
                        print(avError)
                    }
                    
                    
                }
                
            }
            
        }
        
    }
    
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            startAnimating(type: NVActivityIndicatorType.ballClipRotateMultiple)
            if photoType == PhotoType.signup{
                
                self.personImage = UIImage(data: dataImage)
                
                let client = MPOFaceServiceClient(subscriptionKey: "cc5e00c58ff9470d846ad216366e18da")!
                
                let data = UIImageJPEGRepresentation(self.personImage!, 0.8)
                
                client.detect(with: data!, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if (faces!.count) > 1 || (faces!.count) == 0 {
                        print("too many or not at all faces")
                        self.stopAnimating()
                        self.failLogin()
                        return
                    }
                    
                    client.createPerson(withPersonGroupId: "people", name: name, userData: age, completionBlock: { (result, error) in
                        client.addPersonFace(withPersonGroupId: "people", personId: result?.personId, data: data!, userData: nil, faceRectangle: nil, completionBlock: { (result, error) in
                            client.trainPersonGroup(withPersonGroupId: "people", completionBlock: { (error) in
                                self.stopAnimating()
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                                self.present(vc, animated: true, completion:  nil)
                            })
                            self.stopAnimating()
                            return
                        })
                    })
                })
                
        
                
            }else if photoType == PhotoType.login {
                
                self.personImage = UIImage(data: dataImage)
                
                let client = MPOFaceServiceClient(subscriptionKey: "cc5e00c58ff9470d846ad216366e18da")!
                
                let data = UIImageJPEGRepresentation(self.personImage!, 0.8)
                
                client.detect(with: data!, returnFaceId: true, returnFaceLandmarks: true, returnFaceAttributes: [], completionBlock: { (faces, error) in
                    
                    if error != nil {
                        return
                    }
                    
                    if (faces!.count) > 1 || (faces!.count) == 0 {
                        print("too many or not at all faces")
                        self.stopAnimating()
                        self.failLogin()
                        return
                    }
                    
                    
                    
                    client.detect(with: data, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (result, error) in
                        let ids = result?.map { $0.faceId }
                        client.identify(withPersonGroupId: "people", faceIds: ids, maxNumberOfCandidates: 3, completionBlock: { (result, error) in
                            
                            if (result?[0].candidates as AnyObject).count == 0{
                                self.failLogin()
                                
                            }else{
                            
                                let top = result?[0].candidates[0] as AnyObject
                                
                                //get person
                                client.getPersonWithPersonGroupId("people", personId: top.personId, completionBlock: { (result, error) in
                                    let userName = result?.name
                                    let userAge = result?.userData
                                    
                                    self.name_Lbl.isHidden = false
                                    self.age_Lbl.isHidden = false
                                    self.name_Lbl.text = "Name: " + userName!
                                    self.age_Lbl.text = "Age: " + userAge!
                                })
                            }
                            self.stopAnimating()
                            
                        })
                    })
                
                
                
                })
                
            }
            
        }
    }
    
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        
        
        self.button.isEnabled = false
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewPixelType, kCVPixelBufferWidthKey as String : 160, kCVPixelBufferHeightKey as String : 160]
        
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
    
    }
    
    func showActivityIndicator(onView: UIView) {
        let container: UIView = UIView()
        container.frame = onView.frame
        container.center = onView.center
        container.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = onView.center
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actIdc = UIActivityIndicatorView()
        actIdc.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actIdc.hidesWhenStopped = true
        actIdc.activityIndicatorViewStyle = .whiteLarge
        actIdc.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(actIdc)
        container.addSubview(loadingView)
        onView.addSubview(container)
        
        actIdc.startAnimating()
    }
    
    func failLogin() {
        // THE PERSON IS NOT THE SAME
        let alert = UIAlertController(title: "Sorry", message: "No Matches Found", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let logvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
            self.present(logvc, animated: false, completion: nil)
        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func overRate(){
    
        // THE PERSON IS NOT THE SAME
        let alert = UIAlertController(title: "Microsoft API Request Limit Reached", message: "Please wait 2 minutes and try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
        let logvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        self.present(logvc, animated: true, completion: nil)
        })

        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
    @IBAction func reset_Click(_ sender: Any) {
        
        ID = ""

        //self.reset_Btn.isHidden = true
        self.button.isHidden = false
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
