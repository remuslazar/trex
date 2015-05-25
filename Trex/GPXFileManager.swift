//
//  GPXFileManager.swift
//  Trex
//
//  Created by Remus Lazar on 25.05.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import Foundation

class GPXFileManager {
    
    init() {
        let fileManager = NSFileManager()
        reloadFiles()
    }
    
    var files: [NSURL] = []
    
    let fileManager = NSFileManager()

    private func reloadFiles() {
        if let contents = fileManager.contentsOfDirectoryAtURL(docRootDir,
            includingPropertiesForKeys: [NSURLCreationDateKey, NSURLLocalizedNameKey, NSURLFileSizeKey],
            options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, error: nil) as? [NSURL] {
                files = contents.filter { $0.pathExtension == "gpx" }
        }
    }
    
    private lazy var docRootDir: NSURL = {
        let fileManager = NSFileManager()
        // intentionally, this will cause a crash if the document directory couldn't be determined
        let docDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        return docDir
    }()
    
    // adds a file to the internal file storage
    func add(url: NSURL) {
        if let name = url.lastPathComponent {
            fileManager.moveItemAtURL(url, toURL: docRootDir.URLByAppendingPathComponent(name), error: nil)
            println("file \(name) saved to \(docRootDir)")
            reloadFiles()
        }
    }
    
    func remove(url: NSURL) {
        fileManager.removeItemAtURL(url, error: nil)
        reloadFiles()
    }
    
}

extension NSURL {
    var created: String? {
        var val: AnyObject?
        if self.getResourceValue(&val, forKey: NSURLCreationDateKey, error: nil) {
            if let created = val as? String {
                return created
            }
        }
        return nil
    }

    var fileSize: NSNumber? {
        var val: AnyObject?
        if self.getResourceValue(&val, forKey: NSURLFileSizeKey, error: nil) {
            if let size = val as? NSNumber {
                return size
            }
        }
        return nil
    }
}