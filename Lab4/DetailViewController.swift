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
    
    @objc func keyboardAppeared(_ notification: NSNotification) {
        guard let frameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let frame  = frameValue.cgRectValue
        scrollView.contentInset.bottom = frame.size.height + OFFSET
        scrollView.verticalScrollIndicatorInsets.bottom = frame.size.height + OFFSET
    }
    
    @objc func keyboardDisappeared(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        entry?.notes = textView.text
        DetailViewController.didChange = true
    }
}
