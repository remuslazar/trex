//
//  GPXFilesViewController.swift
//  Trex
//
//  Created by Remus Lazar on 25.05.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit

class GPXFilesViewController: UITableViewController {

    let gpxFileManager = GPXFileManager()
    
    private func handleReceivedGPXURL(url: NSURL) {
        gpxFileManager.add(url)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        
        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue) { notification in
            if let url = notification?.userInfo?[GPXURL.Key] as? NSURL {
                self.handleReceivedGPXURL(url)
            }
        }
    }

    
    // MARK: - Table view data source
    
    struct Storyboard {
        static let CellReuseIdentifier = "GPX File Cell"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return gpxFileManager.files.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        if indexPath.row < gpxFileManager.files.count { // just to be safe
            let url = gpxFileManager.files[indexPath.row]
            if let size = url.fileSize {
                cell.detailTextLabel?.text = NSByteCountFormatter.stringFromByteCount(Int64(size.intValue),
                    countStyle: NSByteCountFormatterCountStyle.File)
            }
            cell.textLabel?.text = url.lastPathComponent
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let url = gpxFileManager.files[indexPath.row]
            gpxFileManager.remove(url)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
