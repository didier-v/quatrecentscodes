//
//  ViewController.swift
//  QCCVideoCapture
//
//  Created by Didier Vandekerckhove on 03/01/2019.
//  Copyright © 2019 Didier Vandekerckhove. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var liveView: UIImageView!
    @IBOutlet weak var captureView: UIImageView!
    var captureNow = false

    override func viewDidLoad() {
        super.viewDidLoad()

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {granted in
                if granted {
                    self.setupCaptureSession()
                }
            })
        case .denied, .restricted:
            break
        }
    }

    @IBAction func captureAction(_ sender: Any) {
        captureNow = true
    }
    
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        let videoOutput = AVCaptureVideoDataOutput()

        captureSession.beginConfiguration()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else {return}
        captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(videoOutput)
        
        captureSession.commitConfiguration()
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = liveView.frame
        liveView.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
        
    }
    
    //MARK: -- AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if captureNow {
            captureNow = false
            
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            // convertir l'image buffer en CIImage et ajuster l'orientation
            let ciImage = CIImage(cvImageBuffer: imageBuffer).oriented(.right)
            
            // maj captureView dans le main thread
            DispatchQueue.main.async {
                self.captureView.image = UIImage(ciImage: ciImage)
            }
            
        }
        
    }
    
}

