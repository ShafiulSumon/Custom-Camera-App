//
//  TestVC.swift
//  AVCaptureSession
//
//  Created by ShafiulAlam-00058 on 3/21/23.
//

import UIKit
import AVFoundation

class TestVC: UIViewController {
    
//MARK: - Outlets
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureImageView: UIImageView!
    
//MARK: - Variables
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // setup session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        // select input device
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        // prepare input
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            // configure output
            stillImageOutput = AVCapturePhotoOutput()
            
            // attach input and output
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
//MARK: - Action Buttons
    @IBAction func didTakePhoto(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
//MARK: - All functions
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
}

extension TestVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: imageData)
        captureImageView.image = image
    }
}
