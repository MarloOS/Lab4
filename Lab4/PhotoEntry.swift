//
//  PhotoEntry.swift
//  Lab4
//
//  Created by MO X02a on 2020-01-27.
//  Copyright © 2020 ics052. All rights reserved.
//

import UIKit

import os // this begins where we are trying to save and load data.

class PropertyKey { // contains some String variables to help us identify the properties of a PhotoEntry
    static let photo = "photo"
    static let notes = "notes"
}
    
class PhotoEntry: NSObject, NSCoding { // PhotoEntry is a subclass of these two classes.
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first! // Determines where our directory will be.
    static let archiveURL = documentsDirectory.appendingPathComponent("entries") // archiveURL must be the path where we will store our photo entries
    
    // MARK: - Properties
    var photo: UIImage
    var notes: String
    
    // MARK: - Initializers
    
    // PURPOSE: Initializes a new PhotoEntry with the given UIImage and notes String
    //
    // PARAMETERS: valid UIImage and String
    //
    // RETURN VALUES/SIDE EFFECTS: N/A
    //
    // NOTES: N/A
    init(photo: UIImage, notes: String) {
        self.photo = photo
        self.notes = notes
    }
    
    // MARK: - Load/Save
    
    // PURPOSE: Initializes a new PhotoEntry with the given NSCoder that loads an appropriate UIImage and String for the PhotoEntry.
    //
    // PARAMETERS: Valid NSCoder
    //
    // RETURN VALUES/SIDE EFFECTS: N/A
    //
    // NOTES:
    required convenience init?(coder aDecoder: NSCoder) { //
        guard let newPhoto = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage else { // guard assigns newPhoto to whatever UIImage is returned,
            os_log("Missing image", log:OSLog.default, type: .debug) // else the missing image message is logged.
            return nil
        }
        guard let newNotes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String else { // assigns newNotes to whatever String is returned, or else
            os_log("Missing notes", log: OSLog.default, type: .debug) // writes out "missing notes"
            return nil
        }
        self.init(photo: newPhoto, notes: newNotes) // Initializes the photoEntry object with these two new values.
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(photo, forKey: PropertyKey.photo) // encodes the photo data
        aCoder.encode(notes, forKey: PropertyKey.notes) // encodes the notes data
    }
    
}
