//
//  FruitObjectDetection.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 18/06/25.
//

import CoreML
import SwiftUI
import AVFoundation
import Vision

class FruitCameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let captureSession = AVCaptureSession()
    private var requests = [VNRequest()]
    
    var onDetected: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    private func setupCamera(){
        captureSession.sessionPreset = .high
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Failed to access camera")
            return
        }
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.outputs.forEach { captureSession.removeOutput($0) }
        captureSession.addOutput(output)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    private func setupVision() {
        guard let modelURL = Bundle.main.url(forResource: "best", withExtension: "mlmodelc"),
              let compiledModel = try? MLModel(contentsOf: modelURL),
              let vnModel = try? VNCoreMLModel(for: compiledModel) else {
            print("Failed to load compiled model")
            return
        }

        let request = VNCoreMLRequest(model: vnModel) { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("No recognized objects")
                return
            }

            DispatchQueue.main.async {
                self?.clearBoundingBoxes()
                print("Detected objects: \(results.count)")
                for obj in results {
                    let label = obj.labels.first?.identifier ?? "Unknown"
                    let conf = obj.labels.first?.confidence ?? 0
                    print("Label: \(label), Confidence: \(conf)")
                    self?.drawBoundingBox(obj.boundingBox, label: "\(label) \(String(format: "%.2f", conf))")
                    self?.onDetected?("\(label) (\(String(format: "%.2f", conf)))")
                }
            }
        }

        request.imageCropAndScaleOption = .scaleFill
        self.requests = [request]
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        try? handler.perform(self.requests)
    }

    private func drawBoundingBox(_ bbox: CGRect, label: String) {
        let convertedRect = previewLayer.layerRectConverted(fromMetadataOutputRect: bbox)

        // Main box layer
        let boxLayer = CAShapeLayer()
        boxLayer.frame = convertedRect
        boxLayer.borderColor = UIColor.red.cgColor
        boxLayer.borderWidth = 2.0
        boxLayer.cornerRadius = 4
        boxLayer.masksToBounds = true
        boxLayer.zPosition = 1

        // Label background
        let textBackgroundLayer = CALayer()
        let textHeight: CGFloat = 18
        textBackgroundLayer.frame = CGRect(x: 0, y: 0, width: convertedRect.width, height: textHeight)
        textBackgroundLayer.backgroundColor = UIColor.red.withAlphaComponent(0.8).cgColor
        textBackgroundLayer.zPosition = 2

        // Label text
        let textLayer = CATextLayer()
        textLayer.string = label
        textLayer.fontSize = 12
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.frame = textBackgroundLayer.bounds
        textLayer.zPosition = 3

        textBackgroundLayer.addSublayer(textLayer)
        boxLayer.addSublayer(textBackgroundLayer)

        // Add box layer to preview
        previewLayer.addSublayer(boxLayer)
    }


    private func clearBoundingBoxes() {
        previewLayer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
    }

}

struct FruitCameraView: UIViewControllerRepresentable {
    @Binding var detectionResult: String
    
    func makeUIViewController(context: Context) -> FruitCameraViewController {
        let controller = FruitCameraViewController()
        controller.onDetected = { result in
            self.detectionResult = result
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: FruitCameraViewController, context: Context) {}
}

struct FruitObjectDetectionView: View {
    @State private var detectionResult = "Nothing Detected"

    var body: some View {
        VStack {
            FruitCameraView(detectionResult: $detectionResult)
                .frame(height: 400)
                .cornerRadius(20)
                .padding()
            
            Text(detectionResult)
                .font(.headline)
                .padding()
        }
    }
}
