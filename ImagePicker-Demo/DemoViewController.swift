//
//  ViewController.swift
//  ImagePicker-Demo
//
//  Created by Johan Nyman on 2022-10-20.
//


import UIKit
import AVFoundation //For authorization request


class DemoViewController: UIViewController {
    
    private var pickerController: UIImagePickerController = UIImagePickerController()
    private var permission: Permission = .denied
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup picker
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        
        adjustSliderAppearance(customize: true)
    }
    
    func adjustSliderAppearance(customize: Bool) {
        /* Slider */
        let sliderAppearance = UISlider.appearance()
        
        if customize {
            sliderAppearance.minimumTrackTintColor = .systemGreen
            #warning("Uncomment this line to freeze...")
            //sliderAppearance.maximumTrackTintColor = .systemRed
        } else {
            //reset to defaults???
            sliderAppearance.minimumTrackTintColor = nil
            //sliderAppearance.maximumTrackTintColor = nil
        }
    }
    
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        adjustSliderAppearance(customize: false)
        present(from: sender)
    }
}

extension DemoViewController {
    
    public func present(from sourceView: UIView) {
        
        checkPermissions { granted in
            //We are now coming back on a background thread!
            if granted {
                DispatchQueue.main.async {
                    self.adjustSliderAppearance(customize: false)
                    self.pickerController.sourceType = .camera
                    self.present(self.pickerController, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    print("Image Picker failed")
                }
            }
        }
    }
}

extension DemoViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("Image Picker canceled.")
        adjustSliderAppearance(customize: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let _ = info[.editedImage] as? UIImage {
            print("Photo selected.")
        } else {
            print("No photo selected.")
        }
        picker.dismiss(animated: true, completion: nil)
        adjustSliderAppearance(customize: true)
    }
}

extension DemoViewController: UINavigationControllerDelegate {
    
}

//MARK: - Authorization

public enum PermissionError: Error {
    case denied, restricted
}

private enum Permission {
    case granted, denied, restricted
}

extension DemoViewController {
    
    private func checkPermissions(then:@escaping (_ granted:Bool) ->()) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            permission = .granted
            then(true)
            break
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.permission = .granted
                    then(true)
                } else {
                    self.permission = .denied
                    then(false)
                }
            }
            break
            
        case .denied: // The user has previously denied access.
            permission = .denied
            then(false)
            break
            
        case .restricted: // The user can't grant access due to restrictions.
            permission = .restricted
            then(false)
            break
            
        @unknown default:
            permission = .denied
            then(false)
            break
        }
    }
}
