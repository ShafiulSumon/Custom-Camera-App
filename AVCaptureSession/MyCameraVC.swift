//
//  ViewController.swift
//  AVCaptureSession
//
//  Created by ShafiulAlam-00058 on 3/20/23.
//

import UIKit
import AVFoundation

class MyCameraVC: UIViewController {

//MARK: - Outlets
    @IBOutlet weak var CameraPreview: UIView!
    @IBOutlet weak var TakePictureOutlet: UIButton!
    
//MARK: - Variables
    var delegate: AVCapturePhotoCaptureDelegate?
    var captureSession: AVCaptureSession?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TakePictureOutlet.layer.cornerRadius = 30
        
        //CameraPreview = previewLayer
    }
    
    @IBAction func TakePictureBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoDetails", sender: nil)
    }
    
//MARK: - All functions
    
//    func hi() {
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .photo
//
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
//
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.addInput(input)
//
//            let photoOutput = AVCapturePhotoOutput()
//            photoOutput.isHighResolutionCaptureEnabled = true
//            captureSession.addOutput(photoOutput)
//
//            captureSession.startRunning()
//
//            let settings = AVCapturePhotoSettings()
//            photoOutput.capturePhoto(with: settings, delegate: self)
//        } catch {
//            print(error)
//        }
//    }
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?)->() ) {
        self.delegate = delegate
        
    }
    
    private func checkPermission(completion: @escaping (Error?)->() ) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?)->() ) {
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
                if captureSession.canAddOutput(output) {
                    captureSession.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = captureSession
                
                captureSession.startRunning()
                self.captureSession = captureSession
            }
            catch {
                completion(error)
            }
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
}

