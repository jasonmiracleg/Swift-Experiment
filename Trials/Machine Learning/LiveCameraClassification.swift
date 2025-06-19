//
//  LiveCameraClassification.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 09/06/25.
//

import AVFoundation
import SwiftUI
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let captureSession = AVCaptureSession()
    
    private var requests = [VNRequest]()
    private var vnModel: VNCoreMLModel?
    
    var onResult: ((VNRequest, Error?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        if let vnModel = vnModel {
            setupVision(with: vnModel)
        }
    }
    
    func configure(with model: VNCoreMLModel){
        self.vnModel = model
    }
    
    func setupCamera() {
        captureSession.sessionPreset = .high
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera)
        else {
            print("Failed to access camera")
            return
        }
        
        // Clean old inputs
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession.addInput(input)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        // Clean old outputs
        captureSession.outputs.forEach { captureSession.removeOutput($0) }
        captureSession.addOutput(videoOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func setupVision(with model: VNCoreMLModel) {
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            DispatchQueue.main.async {
                self?.onResult?(request, error)
            }
        }
        request.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
        self.requests = [request]
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        try? handler.perform(self.requests)
    }
}

struct CameraView: UIViewControllerRepresentable {
    let vnModel: VNCoreMLModel
    let onResult: (VNRequest, Error?) -> Void
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVC = CameraViewController()
        cameraVC.configure(with: vnModel)
        cameraVC.onResult = onResult
        return cameraVC
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

struct LiveCameraClassification: View {
    @State private var classificationResult = "No Classification Yet"
    private let model: VNCoreMLModel
    
    init() {
        let config = MLModelConfiguration()
        if let resnetModel = try? VNCoreMLModel(for: Resnet50(configuration: config).model) {
            self.model = resnetModel
        } else {
            fatalError("Failed to load Resnet50")
        }
    }
    
    var body: some View {
        VStack {
            CameraView(vnModel: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let top = results.first {
                    classificationResult = "\(top.identifier): \(String(format: "%.2f", top.confidence))"
                }
            }
            .frame(height: 400)
            .cornerRadius(20)
            .padding()
            
            Text(classificationResult)
                .font(.headline)
                .padding()
        }
    }
}


#Preview {
    LiveCameraClassification()
}
