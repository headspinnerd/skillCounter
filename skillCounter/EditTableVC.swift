//
//  EditTableViewController.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-04.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import CoreData

class EditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class EditTableVC: UITableViewController {
    
    var today: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
                
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        //let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.setRightBarButtonItems([add], animated: true)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let timeGotten = getTimeWithSetting()
        today = timeGotten.settingDate
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (skillList.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editcell", for: indexPath) as! EditTableViewCell
        cell.editLabel.text = skillList[indexPath.row].skillName
        
        cell.accessoryType = .disclosureIndicator //UITableViewCellAccessoryDisclosureIndicat

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyVar.target = indexPath
        if let navigator = navigationController {
            //navigator.pushViewController(EditPopupVC(), animated: true)
            navigator.show(EditPopupVC(), sender: nil)
        }
        

    }

    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //delete data from Core data
            print("deleting indexPath.row=\(indexPath.row)")
            print("deleting object="+skillList[indexPath.row].skillName)
            CoreDataManager.deleteSkillCoreData2(object: skillList[indexPath.row].skillName)
            CoreDataManager.deleteColorCoreData(skillname: skillList[indexPath.row].skillName)
            
            // Delete the row from the data source
            skillList.remove(at: indexPath.row)
            
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("insert")
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if fromIndexPath.row < to.row {
            for i in (fromIndexPath.row+1)...to.row {
                skillList[i].number = i - 1
                //print(skillList[i].number)
            }
        } else {
            for i in to.row...(fromIndexPath.row-1) {
                skillList[i].number = i + 1
                //print(skillList[i].number)
            }
        }
        skillList[fromIndexPath.row].number = to.row
        //print("from.row=\(fromIndexPath.row)")
        //print("to.row=\(to.row)")
        
        skillList.sort { (lhs, rhs) in return lhs.number < rhs.number }
        for i in 1...skillList.count {
            print("i=\(i-1) array=\(skillList[i-1].skillName) number=\(skillList[i-1].number)")
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    func addTapped(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add skill", message: "Enter a skill name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0].text
            if textField != "" {
                if (textField?.characters.count)! > 30 {
                    self.showAlert(title: "Error", message: "The name must be less than 31 characters!")
                    return
                }
                var skillnameCollection: [String] = []
                if skillList.count > 0 {
                    for n in 0...(skillList.count-1) {
                        skillnameCollection.append(skillList[n].skillName)
                    }
                    if skillnameCollection.contains(textField!) {
                        self.showAlert(title: "Error", message: "You already have the same skillname!")
                        return
                    }
                }
                print("skillList.count=\(skillList.count)")
                let buttons: [(String, UIColor, UIColor)] = [("Great", uiColor(255, 255, 255, 1.0), uiColor(255, 0, 0, 1.0)),("OK", uiColor(255,255,255,1.0), uiColor(128,128,255,1.0)), ("Bad", uiColor(255,255,255,1.0), uiColor(127,84,175,1.0))]
                skillList.append(SkillList(number: skillList.count + 1, actions: [0,0,0], btnCount: 3, skillName: textField!, validity: true, buttons: buttons)) // set default buttons
                CoreDataManager.storeObj(object: DayActions(number: skillList.count+1, skillname: textField!, btnCount: 3))
                CoreDataManager.storeColors(skillname: textField!, buttons: buttons)
                CoreDataManager.storeCountObj(date: self.today, object: DayActions(number: skillList.count+1, skillname: textField!, count: [0,0,0], btnCount: 3, comments: nil))
                
                self.tableView.reloadData()
            } else {
                self.showAlert(title: "Error", message: "Enter a name!!")
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /*func doneTapped(){
        print("done tapped")
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
