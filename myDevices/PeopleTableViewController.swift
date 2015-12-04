import UIKit
import CoreData

protocol PersonPickerDelegate: class {
    func didSelectPerson(person: Person)
}

class PeopleTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var people = [Person]()
    
    // for person select mode
    weak var pickerDelegate: PersonPickerDelegate?
    var selectedPerson: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "People"
        
        reloadData()
    }
    
    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do {
            if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Person] {
                people = results
                tableView.reloadData()
            }
        } catch {
            fatalError("There was an error fetching the list of people!")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath)
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.name
        
        if let selectedPerson = selectedPerson where selectedPerson == person {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let pickerDelegate = pickerDelegate {
            let person = people[indexPath.row]
            selectedPerson = person
            pickerDelegate.didSelectPerson(person)
            
            tableView.reloadData()
        } else {
            // This instantiates a new viewcontroller and places the devices of that person ito it
            if let deviceTableViewController = storyboard?.instantiateViewControllerWithIdentifier("Devices") as? DevicesTableViewController {
                let person = people[indexPath.row]
                
                deviceTableViewController.managedObjectContext = managedObjectContext
                deviceTableViewController.selectedPerson = person
                navigationController?.pushViewController(deviceTableViewController, animated: true)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
