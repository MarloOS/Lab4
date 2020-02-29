//
//  DetailViewController.swift
//  Lab4
//
//  Created by MO X02a on 2020-01-27.
//  Copyright © 2020 ics052. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class DetailViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var Camera: UIBarButtonItem!
    @IBOutlet weak var date: UIDatePicker!
    var entry: PhotoEntry?
    static var didChange = false
    let OFFSET: CGFloat = 10
    
    // MARK: - Delegate Functions
    override func viewDidLoad(){
        super.viewDidLoad()
        if entry == nil{
            Camera.isEnabled = false
        }
        photoView.image = entry?.photo
        notesView.text = entry?.notes
        date.date = entry!.date
        notesView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIWindow.keyboardDidHideNotification, object: nil)
    }
    
    // PURPOSE: Changes the shape of the objects on screen if the keyboard appears.
    //
    // PARAMETERS: an NSNotification
    //
    // RETURN VALUES/SIDE EFFECTS: N/A
    //
    // NOTES: N/A
    @objc func keyboardAppeared(_ notification: NSNotification) {
        guard let frameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let frame  = frameValue.cgRectValue
        scrollView.contentInset.bottom = frame.size.height + OFFSET
        scrollView.verticalScrollIndicatorInsets.bottom = frame.size.height + OFFSET
    }
    
    // PURPOSE: Changes the shape of the objects on screen if the keyboard disappears.
    //
    // PARAMETERS: an NSNotification
    //
    // RETURN VALUES/SIDE EFFECTS: N/A
    //
    // NOTES: N/A
    @objc func keyboardDisappeared(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    // PURPOSE: Keeps track of when the text in the notes box changes.
    //
    // PARAMETERS: a UITextView
    //
    // RETURN VALUES/SIDE EFFECTS: N/A
    //
    // NOTES: N/A
    func textViewDidChange(_ textView: UITextView) {
        entry?.notes = textView.text
        DetailViewController.didChange = true
    }
    
    // PURPOSE: Takes a photo if the camera is available and uses that photo as the new entry image.
    // PARAMETERS: any
    // RETURN VALUES/SIDE EFFECTS: entry image is assigned captured photo
    // NOTES: Will not work if device has no camera.
    @IBAction func TakePhoto(_ sender: Any) {
        // Check if the device has a camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let alert = UIAlertController(title: "Camera Error", message: "Camera not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Launch the camera controller
        AVCaptureDevice.requestAccess(for: AVMediaType.video){ response in
            if response {
                DispatchQueue.main.async {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.sourceType = UIImagePickerController.SourceType.camera
                    picker.allowsEditing = true
                    self.present(picker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        photoView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        if let newPhoto = photoView.image {
            entry?.photo = newPhoto
            DetailViewController.didChange = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // PURPOSE: Recognizes a screen tap and opens up the image library to select a new image for the entry.
    // PARAMETERS: a valid UITapGestureRecognizer
    // RETURN VALUES/SIDE EFFECTS: entry image is assigned the selected image.
    // NOTES: Requests authorization to access the photo library to work properly.
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized {
                DispatchQueue.main.async{
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                }
            }
        })
    }
        
    // PURPOSE: Detects when the date has been changed and saves its value to the entries file.
    // PARAMETERS: a valid UIDatePicker
    // RETURN VALUES/SIDE EFFECTS: entry date is assigned the current datepicker value.
    // NOTES: N/A
    
    @objc func dateChanged(_ sender: UIDatePicker){
    date.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    entry?.date = date.date
    DetailViewController.didChange = true
    }
}
