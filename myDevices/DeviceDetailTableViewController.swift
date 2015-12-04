import UIKit
import CoreData

class DeviceDetailTableViewController: UITableViewController {
  var device: Device?
  var managedObjectContext: NSManagedObjectContext!

  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var deviceTypeTextField: UITextField!
  @IBOutlet weak var deviceOwnerLabel: UILabel!

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let device = device {
      nameTextField.text = device.name
      deviceTypeTextField.text = device.deviceType

      if let owner = device.owner {
        deviceOwnerLabel.text = "Device owner: \(owner.name)"
      } else {
        deviceOwnerLabel.text = "Set device owner"
      }
    }
  }

  override func viewWillDisappear(animated: Bool) {
    // need to add a device?
    if device == nil {
      if let name = nameTextField.text, deviceType = deviceTypeTextField.text, entity = NSEntityDescription.entityForName("Device", inManagedObjectContext: managedObjectContext) where !name.isEmpty && !deviceType.isEmpty {
        device = Device(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        device?.name = name
        device?.deviceType = deviceType
      }
    }
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 1 && indexPath.row == 0 {
      if let personPicker = storyboard?.instantiateViewControllerWithIdentifier("People") as? PeopleTableViewController {
        personPicker.managedObjectContext = managedObjectContext

        // more personPicker setup code here
        personPicker.pickerDelegate = self
        personPicker.selectedPerson = device?.owner

        navigationController?.pushViewController(personPicker, animated: true)
      }
    }

    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

extension DeviceDetailTableViewController: PersonPickerDelegate {
  func didSelectPerson(person: Person) {
    device?.owner = person

    do {
      try managedObjectContext.save()
    } catch {
      print("Error saving the managed object context!")
    }
  }
}






















