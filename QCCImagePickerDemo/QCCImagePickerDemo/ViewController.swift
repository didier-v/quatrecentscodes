//
//  ViewController.swift
//  QCCImagePickerDemo
//
//  Created by Didier Vandekerckhove on 03/01/2019.
//  Copyright © 2019 Didier Vandekerckhove. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func presentImagePicker(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("La caméra est accessible")
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
        else {
            print("La caméra n'est pas accessible")
        }
    }
    
    //MARK: UIImagePickerControllerDelegate`
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true) {
            print("dismiss")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
            print("cancel")
        }
    }

}

