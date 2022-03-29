//
//  CameraViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 29.03.22.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    //MARK: - Outlet
    
    @IBOutlet weak var previewPhotoView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - var
    var captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()

        // Do any additional setup after loading the view.
    }
    //MARK: - Kamera erstellen
    func setupCaptureSession(){
        // 1. CaptureSession
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // 2. Input erstellen
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            guard let device = captureDevice else {return}
            let input = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
                
        }catch let error {
            ProgressHUD.showError(error.localizedDescription)
        }
        // 3. Output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput){
            captureSession.addOutput(photoOutput)
        }
        // 4. Previewlayer - Kamera anzeigen lassen
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill //Wie der Bildschirm ausgefühllt werden soll
        cameraPreviewLayer.connection?.videoOrientation = .portrait //WIE haltet man der IPhone
        cameraPreviewLayer.frame = view.frame // Wie breit soll sein / ganze view nehmen soll
        
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        
        // 5. Starten
        
        captureSession.startRunning()
    }
    

    //MARK: - Take Photo
    
    
    @IBAction func cameraButtonTaped(_ sender: UIButton) {
        print("Photo gemacht")
        
        saveButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    @IBAction func cameraSwitchTaped(_ sender: UIButton) {
    print("camera Switched")
    }
    
    @IBAction func saveButtonTaped(_ sender: UIButton) {
        print("save")
    }
    
    @IBAction func cancelButtonTaped(_ sender: UIButton) {
        print("cancel")
    }
    
    //MARK: - Dismiss
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        print("dismiss")
    }
    
    
}
