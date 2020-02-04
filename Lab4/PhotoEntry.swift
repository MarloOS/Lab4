//
//  PhotoEntry.swift
//  Lab4
//
//  Created by MO X02a on 2020-01-27.
//  Copyright © 2020 ics052. All rights reserved.
//

import UIKit

import os

class PropertyKey {
    static let photo = "photo"
    static let notes = "notes"
}
    
class PhotoEntry: NSObject, NSCoding {
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("entries")
    
    // MARK: - Properties
    var photo: UIImage
    var notes: String
    
    // MARK: - Initializers
    init(photo: UIImage, notes: String) {
        self.photo = photo
        self.notes = notes
    }
    
    // MARK: - Load/Save
    required convenience init?(coder aDecoder: NSCoder) {
        guard let newPhoto = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage else {
            os_log("Missing image", log:OSLog.default, type: .debug)
            return nil
        }
        guard let newNotes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String else {
            os_log("Missing notes", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(photo: newPhoto, notes: newNotes)
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
}
