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
    
    var onClassification: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
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
        
        captureSession.startRunning()
    }
    
    func setupVision() {
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: Resnet50(configuration: config).model)
        else {
            print("Failed to load model")
            return
        }
        
        let request = VNCoreMLRequest(model: model){
            [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                return
            }
            
            DispatchQueue.main.async {
                let text = "Classification: \(topResult.identifier), Confidence: \(topResult.confidence)"
                self?.onClassification?(text)
            }
        }
        
        request.imageCropAndScaleOption = .centerCrop
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
    @Binding var classificationResult: String
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVC = CameraViewController()
        cameraVC.onClassification = { result in
            self.classificationResult = result
        }
        return cameraVC
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

struct LiveCameraClassification: View {
    @State private var classificationResult = "No Classification Yet"
    
    var body: some View {
        VStack {
            CameraView(classificationResult: $classificationResult)
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
