//
//  CoreML.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 05/06/25.
//

import CoreML
import SwiftUI
import Vision
import UIKit

class CoreMLTrial: ObservableObject {
    @Published var result: String = "No Classification Yet"

    func classifyImage(_ image: UIImage) {
        let config = MLModelConfiguration()
        guard
            let model = try? VNCoreMLModel(
                for: Resnet50(configuration: config).model
            )
        else {
            print("Failed to Load Model")
            return
        }

        let request = VNCoreMLRequest(model: model) {
            [weak self] (request, error) in
            guard
                let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
            else {
                DispatchQueue.main.async {
                    self?.result = "No Classification Yet"
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.result = "Classification: \(topResult.identifier), Confidence: \(topResult.confidence)"
            }
        }

        guard let ciImage = CIImage(image: image) else {
            DispatchQueue.main.async {
                self.result = "Failed to Convert UIImage to CIImage"
            }
            return
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        try? handler.perform([request])
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImagePicked: (UIImage) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator:NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage{
                parent.image = uiImage
                parent.onImagePicked(uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct ContentView: View {
    @State private var isShowingPicker = false
    @State private var inputImage: UIImage?
    @StateObject private var classifier = CoreMLTrial()

    var body: some View {
        VStack(spacing: 20) {
            if let inputImage = inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Text(classifier.result)

            Button("Pick Image") {
                self.isShowingPicker = true
            }
        }
        .sheet(isPresented: $isShowingPicker){
            ImagePicker(image:$inputImage, onImagePicked: {image in
                inputImage = image
                classifier.classifyImage(image)
            })
        }
    }
}

#Preview{
    ContentView()
}
