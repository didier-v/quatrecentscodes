//
//  ViewController.swift
//  QCCPhotoCapture
//
//  Created by Didier Vandekerckhove on 03/01/2019.
//  Copyright © 2019 Didier Vandekerckhove. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var liveView: UIImageView!
    @IBOutlet weak var captureView: UIImageView!
    
    let photoOutput = AVCapturePhotoOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                }
            })
        case .denied, .restricted:
            break
        }
    }
    
    @IBAction func captureAction(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings()
        
        photoOutput.capturePhoto(with: settings, delegate: self)

    }
 
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()

        captureSession.beginConfiguration()
        
        //input
        let videoDevice = AVCaptureDevice.default(for: .video)
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
        else {return}
        captureSession.addInput(videoDeviceInput)

        //ouput
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = liveView.frame
        liveView.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let cgImage = photo.cgImageRepresentation()?.takeUnretainedValue()
            else { return }
        
        captureView.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        
    }
}

