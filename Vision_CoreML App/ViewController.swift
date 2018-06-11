//
//  ViewController.swift
//  Vision_CoreML App
//
//  Created by Sayalee on 6/7/18.
//  Copyright © 2018 Assignment. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - IBActions
extension ViewController {
    
    @IBAction func photosButtonTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)  else {
            let alert = UIAlertController(title: "No photos", message: "This device does not support photos.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera)  else {
            let alert = UIAlertController(title: "No camera", message: "This device does not support camera.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension  ViewController:  UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("couldn't load image")
        }
        
        imageView.image = image
        
        // Convert UIImage to CIImage to pass to the image request handler
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        
        detectAge(image: ciImage)
    }
}

// MARK: - Methods
extension ViewController {
    
    func detectAge(image: CIImage) {
        predictionLabel.text = "Detecting age..."
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: AgeNet().model) else {
            fatalError("can't load AgeNet model")
        }
        
        // Create request for Vision Core ML model created
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            // Update UI on main queue
            DispatchQueue.main.async { [weak self] in
                self?.predictionLabel.text = "I think your age is \(topResult.identifier) years!"
            }
        }
        
        // Run the Core ML AgeNet classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}

