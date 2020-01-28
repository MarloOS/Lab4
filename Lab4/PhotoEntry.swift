//
//  PhotoEntry.swift
//  Lab4
//
//  Created by MO X02a on 2020-01-27.
//  Copyright © 2020 ics052. All rights reserved.
//

import UIKit

class PhotoEntry: NSObject {
    // MARK: - Properties
    var photo: UIImage
    var notes: String
    
    // MARK: - Initializers
    init(photo: UIImage, notes: String) {
        self.photo = photo
        self.notes = notes
    }    
}
