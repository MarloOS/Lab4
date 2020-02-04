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
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var notesView: UITextView!
    var entry: PhotoEntry?
    
    // MARK: - Delegate Functions
    override func viewDidLoad(){
        super.viewDidLoad()
        photoView.image = entry?.photo
        notesView.text = entry?.notes
        notesView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        entry?.notes = textView.text
    }
}
