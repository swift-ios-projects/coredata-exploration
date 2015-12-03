/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData

class DevicesTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var devices = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Devices"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addDevice:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        tableView.reloadData()
    }
    
    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "Device")
        
        do {
            if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Device] {
                devices = results
            }
        } catch {
            fatalError("There was an error fetching the list of devices!")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    // Setting the cells for each device using Core Data Values from the app delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell", forIndexPath: indexPath)
        
        let device = devices[indexPath.row]
        
        // The next 2 lines simplifies the setting of table cell variables. This is possible because we created subclasses for both Person and Device in Core Data and added those subclasses to the application. 
        // > Person.swift & Device.swift
        // It replaces the code block that is commented out below.
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.deviceType
        
        /* Depricated Code -->
        if let deviceName = device.valueForKey("name") as? String, deviceType = device.valueForKey("deviceType") as? String {
            cell.textLabel?.text = deviceName
            cell.detailTextLabel?.text = deviceType
        }
        */
        
        return cell
    }
    
    // MARK: - Actions & Segues
    
    func addDevice(sender: AnyObject?) {
        performSegueWithIdentifier("deviceDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? DeviceDetailTableViewController {
            dest.managedObjectContext = managedObjectContext
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let device = devices[selectedIndexPath.row]
                dest.device = device
            }
        }
    }
    
}
