//
//  DetailViewController.swift
//  Lab4
//
//  Created by MO X02a on 2020-01-27.
//  Copyright © 2020 ics052. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var notesView: UITextView!
    var entry: PhotoEntry?
    static var didChange = false
    let OFFSET: CGFloat = 10
    
    // MARK: - Delegate Functions
    override func viewDidLoad(){
        super.viewDidLoad()
        photoView.image = entry?.photo
        notesView.text = entry?.notes
        notesView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIWindow.keyboardDidShowNotification, object: nil)
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
}
