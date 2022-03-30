//
//  CameraViewController.swift
//  Mersegram
//
//  Created by Boleslav Glavatki on 29.03.22.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
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
       
    }
    // METHODE takePhoto - für photo machen (quasi wird auf dem Bildschirm gezeigt(gespechert)  )
    func takePhoto(){
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    //BESCHREIBT WIE PHOTO DARGESTELLT WERDEN MUSS
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            previewPhotoView.image = UIImage(data: imageData)
            saveButton.isHidden = false
            cancelButton.isHidden = false
            
        }
    }
    //MARK: - switch camera
    
    @IBAction func cameraSwitchTaped(_ sender: UIButton) {
        switchCamera()
    print("camera Switched")
    }
    func switchCamera(){
     guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return}
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        var newDevice: AVCaptureDevice?
        
        if input.device.position == .back{
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }
        
        //NEUES IMPUT
        
        var deviceInput: AVCaptureDeviceInput!
        do{
            guard let device = newDevice else { return }
            deviceInput = try AVCaptureDeviceInput (device: device)
        } catch let error {
            ProgressHUD.showError(error.localizedDescription)
        }
        
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
        
        
        
    }
    func captureDevice(with position: AVCaptureDevice.Position) ->AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        for device in devices {
            if device.position == position{
                return device
            }
        }
        return nil
    }
    //MARK: - Save Photo
    
    @IBAction func saveButtonTaped(_ sender: UIButton) {
        savePhoto()
    }
    func savePhoto(){
        let library = PHPhotoLibrary.shared()
        guard let image = previewPhotoView.image else {return}
        
        library.performChanges ({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
                return
            } else {
                ProgressHUD.showSuccess("Fotogespeichert")
            }
            
        }

    }
    //MARK: - Cancle
    @IBAction func cancelButtonTaped(_ sender: UIButton) {
       cancle()
    }
    func cancle(){
        previewPhotoView.image = nil
        cancelButton.isHidden = true
        saveButton.isHidden = true
    }
    
    //MARK: - Dismiss
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    }
    
    
    
}
