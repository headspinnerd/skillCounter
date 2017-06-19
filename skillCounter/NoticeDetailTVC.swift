//
//  NoticeDetailVCTableViewController.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-18.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import GoogleMobileAds

class PickerDoneButton: UIBarButtonItem {
    var tableViewCell: UITableViewCell?
}

class NoticeDetailTVC: UITableViewController, GADBannerViewDelegate {

    @IBOutlet weak var allowNotificationOutlet: UISwitch!
    @IBOutlet weak var timeCell: UIView!
    @IBOutlet weak var soundCell: UIView!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var selectedSound: UILabel!
    @IBOutlet weak var contentBody: UILabel!
    var soundSelected: (Int, String)?
    var dayOfWeekSelection: [Bool]?
    var backItem = UIBarButtonItem()
    var datePicker = UIDatePicker()
    
    @IBAction func dayOfWeekAction(_ sender: UIButton) {
        if let _dayOfWeekSelection = dayOfWeekSelection {
            if _dayOfWeekSelection[sender.tag-1] {
                dayOfWeekOutlet[sender.tag-1].backgroundColor = uiColor(227, 227, 227, 1.0)
                dayOfWeekOutlet[sender.tag-1].setTitleColor(uiColor(100, 100, 100, 1.0), for: .normal)
                dayOfWeekSelection?[sender.tag-1] = false
                if let _dayOfWeekSelection = dayOfWeekSelection {
                    print("dayOfWeekSelection[\(sender.tag-1)]=\(_dayOfWeekSelection[sender.tag-1])")
                    UserDefaults.standard.set(_dayOfWeekSelection, forKey: "dayOfWeekSelection")
                }
            } else {
                dayOfWeekOutlet[sender.tag-1].backgroundColor = .orange
                dayOfWeekOutlet[sender.tag-1].setTitleColor(uiColor(0, 0, 0, 1.0), for: .normal)
                dayOfWeekSelection?[sender.tag-1] = true
                if let _dayOfWeekSelection = dayOfWeekSelection {
                    print("dayOfWeekSelection[\(sender.tag-1)]=\(_dayOfWeekSelection[sender.tag-1])")
                    UserDefaults.standard.set(_dayOfWeekSelection, forKey: "dayOfWeekSelection")
                }
            }
        }
    }
    @IBOutlet var dayOfWeekOutlet: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let inset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.contentInset = inset
        self.tableView.allowsSelection = true
        dayOfWeekSelection = UserDefaults.standard.object(forKey: "dayOfWeekSelection") as? [Bool]
        for n in 0...(dayOfWeekOutlet.count-1) {
            dayOfWeekOutlet[n].layer.cornerRadius = dayOfWeekOutlet[n].frame.width/2
            if let _dayOfWeekSelection = dayOfWeekSelection {
                if _dayOfWeekSelection[n] {
                    dayOfWeekOutlet[n].backgroundColor = .orange
                    dayOfWeekOutlet[n].setTitleColor(uiColor(0, 0, 0, 1.0), for: .normal)
                } else {
                    dayOfWeekOutlet[n].backgroundColor = uiColor(227, 227, 227, 1.0)
                    dayOfWeekOutlet[n].setTitleColor(uiColor(100, 100, 100, 1.0), for: .normal)
                }
            }
            
            if n == 0 {
                dayOfWeekOutlet[n].center = CGPoint(x: (device.viewWidth-(30*7+13*6))/2 + dayOfWeekOutlet[n].frame.width/2, y: 20)
            } else {
                dayOfWeekOutlet[n].center = CGPoint(x: dayOfWeekOutlet[n-1].center.x + dayOfWeekOutlet[n].frame.width + 13, y: 20)
            }
        }
        if let notificationMessage = UserDefaults.standard.object(forKey: "notificationMessage") as? String {
            contentBody.text = notificationMessage
        }
        
        backItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backItem
        
        allowNotificationOutlet.frame.origin = CGPoint(x: device.viewWidth - 70, y: (39.5 - 31) / 2 )
        
        if let noticeTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            notificationTime.text = "\(formatter.string(from: noticeTime))"
        } else {
            notificationTime.text = ""
        }
        
        if let allowNotification = UserDefaults.standard.object(forKey: "allowNotification") as? Bool {
            allowNotificationOutlet.isOn = allowNotification
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let sound = UserDefaults.standard.object(forKey: "soundSelectedName") as? String {
            selectedSound.text = sound
        }
        BannerManager.shared.setBanner(point: CGPoint(x: (device.viewWidth-320)/2, y: device.viewHeight - 135), viewController: self, centerMove: .fromRight, isRemove: false)
    }
    
    func backTapped() {
        if let _player = player {
            _player.stop()
        }
        if let _notificationTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            let setHour = Calendar.current.component(.hour, from: _notificationTime)
            let setMinute = Calendar.current.component(.minute, from: _notificationTime)
            let content = UNMutableNotificationContent()
            content.title = "SkillCounter"
            content.body = contentBody.text!
            if let soundName = UserDefaults.standard.object(forKey: "soundSelectedName") as? String {
                content.sound = UNNotificationSound(named: soundName + ".aiff")
            }
            // make sure you give each request a unique identifier. (nextTriggerDate description)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            if let _dayOfWeekSelection = dayOfWeekSelection {
                for n in 0...(_dayOfWeekSelection.count-1) {
                    if _dayOfWeekSelection[n] == true && notificationTime.text != "" && allowNotificationOutlet.isOn {
                        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: setHour, minute: setMinute, weekday: n+1), repeats: true)
                        print(trigger.nextTriggerDate() ?? "nil")
                        let request = UNNotificationRequest(identifier: "identify", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print(error)
                                return
                            }
                            print("scheduled")
                        }
                    }
                }
            }
        }
        self.view.endEditing(true)
        if let _dayOfWeekSelection = dayOfWeekSelection {
            if _dayOfWeekSelection.contains(true) {
            } else {
                allowNotificationOutlet.isOn = false
            }
        }
        UserDefaults.standard.set(allowNotificationOutlet.isOn, forKey: "allowNotification")
        
        self.dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected \(indexPath)")
        if indexPath.section == 0 && indexPath.row == 1 {
            datePicker.datePickerMode = .time
            datePicker.setDate(Date(), animated: false)
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            var doneButton = PickerDoneButton()
            doneButton.tableViewCell = tableView.cellForRow(at: indexPath)
            backItem.isEnabled = false
            doneButton = PickerDoneButton(barButtonSystemItem: .done, target: self, action: #selector(datePickDone(_:)))
            toolbar.setItems([doneButton], animated: false)
            let notificationTimeField = UITextField(frame: notificationTime.frame)
            view.addSubview(notificationTimeField)
            notificationTimeField.isHidden = true
            
            notificationTimeField.inputAccessoryView = toolbar
            notificationTimeField.inputView = datePicker
            notificationTimeField.becomeFirstResponder()
            
            datePicker.becomeFirstResponder()
            datePicker.calendar = Calendar.current
            if let notificationTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
                datePicker.date = notificationTime
            }
            tableView.cellForRow(at: indexPath)?.isSelected = false
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let alert = UIAlertController(title: "Message", message: "Enter a message of your notification", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let text = alert?.textFields![0].text
                if text != "" {
                    UserDefaults.standard.set(text, forKey: "notificationMessage")
                    self.contentBody.text = text
                } else {
                    self.showAlert(title: "Error", message: "Enter a message!!")
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        
        } else if indexPath.section == 2 && indexPath.row == 0 {
            //navigationController?.pushViewController(NotificationSoundDetailTVC(), animated: true)
            performSegue(withIdentifier: "showSoundList", sender: nil)
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
        
    }
    
    func datePickDone(_ sender: PickerDoneButton) {
        DispatchQueue.main.async(execute: {
            self.backItem.isEnabled = true
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            self.notificationTime.text = "\(formatter.string(from: self.datePicker.date))"
            UserDefaults.standard.set(self.datePicker.date, forKey: "notificationTime")
            self.view.endEditing(true)
        })
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
            case 0: return 3
            case 1: return 1
            case 2: return 1
            default: return 0
        }
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

class NotificationSoundDetailTVC: UITableViewController {
    
    
    var targetRow: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        let inset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.contentInset = inset
        self.tableView.allowsSelection = true
        
        let backItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem = backItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath)
        cell.textLabel?.text = sounds[indexPath.row].replacingOccurrences(of: "_", with: " ")
        if let soundRow = UserDefaults.standard.object(forKey: "soundSelectedRow") as? Int {
            if indexPath.row == soundRow && targetRow == nil {
                cell.accessoryType = .checkmark
                targetRow = indexPath.row
            }
        }
        if let _targetRow = targetRow {
            if indexPath.row != _targetRow {
                cell.accessoryType = .none
            }
        }
     // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        player = aiffPlay(file: sounds[indexPath.row])
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        targetRow = indexPath.row
        tableView.reloadData()
    }
    
    /*override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }*/
    
    
    func back(sender: UIBarButtonItem) {
        if let _player = player {
            _player.stop()
        }
        print("back button tapped")
        if let _targetRow = targetRow {
            UserDefaults.standard.set(sounds[_targetRow], forKey: "soundSelectedName")
            UserDefaults.standard.set(_targetRow, forKey: "soundSelectedRow")
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
}
