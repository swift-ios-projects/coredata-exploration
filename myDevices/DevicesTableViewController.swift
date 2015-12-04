import UIKit
import CoreData

class DevicesTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var devices = [Device]()
    
    var selectedPerson: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedPerson = selectedPerson {
            title = "\(selectedPerson.name)'s Devices"
        } else {
            title = "Devices"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addDevice:")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        tableView.reloadData()
    }
    
    func reloadData() {
        if let selectedPerson = selectedPerson {
            // allObjects converts the set of devices to an array
            if let personDevices = selectedPerson.devices.allObjects as? [Device] {
                devices = personDevices
            }
            
        } else {
            let fetchRequest = NSFetchRequest(entityName: "Device")
            
            do {
                if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Device] {
                    devices = results
                }
            }
            catch {
                fatalError("There was an error fetching the list of devices!")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell", forIndexPath: indexPath)
        
        let device = devices[indexPath.row]
        
        cell.textLabel?.text = device.deviceDescription
        cell.detailTextLabel?.text = "(owner name goes here)"
        
        return cell
    }
    
    // MARK: - Actions & Segues
    
    func addDevice(sender: AnyObject?) {
        performSegueWithIdentifier("deviceDetail", sender: self)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if selectedPerson != nil && identifier == "deviceDetail" {
            return false
        }
        
        return true
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
