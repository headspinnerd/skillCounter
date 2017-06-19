//
//  SettingVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-21.
//  Copyright © 2017 Koki. All rights reserved.
//
// 

import UIKit
import UserNotifications
import GoogleMobileAds

protocol SettingVCDelegate {
    func showLoginFromSetting()
}

class SettingVC: UITableViewController {
    
    @IBOutlet weak var usernameCell: UITableViewCell!
    @IBOutlet weak var changePasswordCell: UITableViewCell!
    @IBOutlet weak var wallPaperCell: UITableViewCell!
    @IBOutlet weak var dayChangeTimeCell: UITableViewCell!
    @IBOutlet weak var notificationCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!
    @IBOutlet weak var dataTransferCell: UITableViewCell!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var skillNameList: [(String, Int)] = []
    var today: String = ""
    //test
    //var adminBtn = UIButton()

    @IBAction func displayAnimation(_ sender: UISwitch) {
        if sender.isOn {
            MyVar.isDisplayAnimation = true
            UserDefaults.standard.set(true, forKey: "isDisplayAnimation")
        } else {
            MyVar.isDisplayAnimation = false
            UserDefaults.standard.set(false, forKey: "isDisplayAnimation")
        }
    }
    @IBOutlet weak var displayAnimationSwitch: UISwitch!
    @IBAction func displayTotal(_ sender: UISwitch) {
        if sender.isOn {
            MyVar.isDisplayTotal = true
            UserDefaults.standard.set(true, forKey: "isDisplayTotal")
        } else {
            MyVar.isDisplayTotal = false
            UserDefaults.standard.set(false, forKey: "isDisplayTotal")
        }
    }
    @IBOutlet weak var displayTotalSwitch: UISwitch!
    
    @IBOutlet weak var serverSyncSwitch: UISwitch!
    @IBAction func serverSync(_ sender: UISwitch) {
        if MyVar.userName == "Trial Member" {
            showAlert(title: "Sorry", message: "Please logout and register first! \n(It's free of charge)")
            sender.isOn = false
            return
        }
        if sender.isOn {
            let alert = UIAlertController(title: "Server Connect", message: "If you don't keep using this app for long, this function is not necessary. Do you wanna turn this on?", preferredStyle: .alert)
            
            let actionOne = UIAlertAction(title: "OK", style: .default) { (action) in
                MyVar.serverConnect = true
                UserDefaults.standard.set(true, forKey: "serverConnect")
                self.showAlert(title: "Little Tip", message: "The data stored in your phone will be synchronized to the web database at the time of: \n1. pressing the \"Search\" button. \n2. Editing button details \n3. Changing username or password." )
            }
            let actionTwo = UIAlertAction(title: "Cancel", style: .default) { (action) in
                MyVar.serverConnect = false
                UserDefaults.standard.set(false, forKey: "serverConnect")
                sender.isOn = false
            }
                
            alert.addAction(actionOne)
            alert.addAction(actionTwo)

            self.present(alert, animated: true, completion: nil)
            
        } else {
            MyVar.serverConnect = false
            UserDefaults.standard.set(false, forKey: "serverConnect")
        }
    }
    
    var delegate: SettingVCDelegate?
    var device: Device {
        let dv = deviceRecognition(width: self.view.frame.width, height: self.view.frame.height)
        return dv
    }
    //var validResult: Bool = true
    var datePicker = UIDatePicker()
    var wallPaperImage = UIImageView()
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if usernameCell.isSelected {
            
            if MyVar.userName == "Trial Member" {
                showAlert(title: "Sorry, but you cannot." , message: "You need to logout and register first!")
                return
            }
            
            if isInternetAvailable() {
                //Server Maintenance Check
                let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/serverMaintenanceMessage.php"
                let contents: [[String : Any]] = HttpRequestController().sendGetRequestSynchronous(urlString: urlString)
                print(contents)
                if contents.count > 0 {
                    guard let info3 = contents[0]["info3"] as? String else {
                        return
                    }
                    if info3 != "NO" {
                        showAlert(title: "Sorry", message: info3)
                    } else {
                        let confirmAlert = UIAlertController(title: "Change Username", message: "Do you really wanna change your username?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            let alert = UIAlertController(title: "Change username", message: "Enter a new username", preferredStyle: .alert)
                            alert.addTextField { (textField) in
                                //textField.text = nil
                            }
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                let text = alert?.textFields?[0].text
                                if text != "" {
                                    if text!.characters.count > 20 {
                                        self.showAlert(title: "Error", message: "The username must be less than 20 characters")
                                        self.usernameCell.isSelected = false
                                    } else {
                                        self.usernameCell.isSelected = false
                                        self.usernameUpdate(newUserName: text!, oldUserName: MyVar.userName)
                                    }
                                } else {
                                    self.showAlert(title: "Error", message: "Enter a username!!")
                                    self.usernameCell.isSelected = false
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }))
                        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                            self.usernameCell.isSelected = false
                        }))
                        
                        present(confirmAlert, animated: true, completion: nil)
                    }
                }
            } else {
                showAlert(title: "Sorry", message: "You need Internet connection." )
            }
        }
        if changePasswordCell.isSelected {
            if MyVar.userName == "Trial Member" {
                showAlert(title: "Sorry, but you cannot." , message: "You need to logout and register first!")
                return
            }
            
            if isInternetAvailable() {
                //Server Maintenance Check
                let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/serverMaintenanceMessage.php"
                let contents: [[String : Any]] = HttpRequestController().sendGetRequestSynchronous(urlString: urlString)
                print(contents)
                if contents.count > 0 {
                    guard let info4 = contents[0]["info4"] as? String else {
                        return
                    }
                    if info4 != "NO" {
                        showAlert(title: "Sorry", message: info4)
                    } else {
                        let confirmAlert = UIAlertController(title: "Username", message: "Do you really wanna change your username?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            let alert = UIAlertController(title: "Change password", message: "Enter your current password and a new password", preferredStyle: .alert)
                            alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
                                text.placeholder = "Current Password"
                                text.leftViewMode = UITextFieldViewMode.always
                                text.isSecureTextEntry = true
                            })
                            alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
                                text.placeholder = "New Password"
                                text.leftViewMode = UITextFieldViewMode.always
                                text.isSecureTextEntry = true
                            })
                            /*alert.addTextField { (textField) in
                             }*/
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                                let text1 = alert?.textFields?[0].text
                                let text2 = alert?.textFields?[1].text
                                if text1 != "" && text2 != "" {
                                    if text2!.characters.count < 4 || text2!.characters.count > 20 {
                                        self.showAlert(title: "Error", message: "The password must be between 4 and 20 characters.")
                                        self.changePasswordCell.isSelected = false
                                    } else {
                                        self.changePasswordCell.isSelected = false
                                        self.passwordUpdate(newPassword: text2!, oldPassword: text1!)
                                    }
                                } else {
                                    self.showAlert(title: "Error", message: "Enter current and new password!!")
                                    self.changePasswordCell.isSelected = false
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }))
                        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                            self.changePasswordCell.isSelected = false
                        }))
                        present(confirmAlert, animated: true, completion: nil)
                    }
                }
            } else {
                showAlert(title: "Sorry", message: "You need Internet connection." )
            }
        }
        if wallPaperCell.isSelected {
            MyVar.previousVC = "SettingVC"
            self.present(WallpaperVC(), animated: false) {
                //self.showAlert(title: "Completed", message: "You have set up the wallpaper.")
                self.wallPaperCell.isSelected = false
            }
        }
        if dayChangeTimeCell.isSelected {
            print("dayChangeTimeCell tapped")
            //dayChangeTimeCell.detailTextLabel?.isUserInteractionEnabled = true
            //dayChangeTimeCell.detailTextLabel?.isHidden = true
            datePicker.datePickerMode = .time
            datePicker.minuteInterval = 30
            datePicker.setDate(Date(), animated: false)
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
            toolbar.setItems([doneButton], animated: false)
            
            let changeTimeField = UITextField(frame: (dayChangeTimeCell.detailTextLabel?.frame)!)
            view.addSubview(changeTimeField)
            changeTimeField.isHidden = true
            
            changeTimeField.inputAccessoryView = toolbar
            changeTimeField.inputView = datePicker
            changeTimeField.becomeFirstResponder()
            datePicker.calendar = Calendar.current
            if let changeTime = UserDefaults.standard.object(forKey: "changeTime") as? Date {
                datePicker.date = changeTime
            }
            dayChangeTimeCell.isSelected = false
        }
        if notificationCell.isSelected {
            //code
            performSegue(withIdentifier: "showNoticeDetail", sender: nil)
            notificationCell.isSelected = false
            
        }
        if dataTransferCell.isSelected {
            //FIXME: Under development
            if MyVar.userName == "headspinnerd" && isInternetAvailable() {
                dataTransfer1()
                return
            }
            
            if let url = URL(string: "http://headspinnerd-com.stackstaging.com/bboying/developmentMessage.php") {
                do {
                    let contents = try String(contentsOf: url)
                    showAlert(title: "Sorry", message: contents)
                } catch {
                    showAlert(title: "Sorry", message: "You need Internet connection." )
                }
            } else {
                print("the wrong URL!!")
                // the URL was bad!
            }
            dataTransferCell.isSelected = false
        }
        if logOutCell.isSelected {
            UserDefaults.standard.removeObject(forKey: "Username")
            userInfo.username = ""
            userInfo.email = ""
            userInfo.name = ""
            MyVar.userName = ""
            
            //try! FIRAuth.auth()?.signOut()
            tabBarController?.selectedIndex = 0
            self.delegate?.showLoginFromSetting()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 30
        case 1: return 40
        default: return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 7
        case 1: return 3
        default: return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inset = UIEdgeInsetsMake(0, 0, 49, 0)
        self.tableView.contentInset = inset
        
        if let changeTime = UserDefaults.standard.object(forKey: "changeTime") as? Date {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            dayChangeTimeCell.detailTextLabel?.text = "\(formatter.string(from: changeTime))"
        }
        
        displayAnimationSwitch.frame.origin = CGPoint(x: device.viewWidth - 70, y: (39.5 - 31) / 2 )
        displayTotalSwitch.frame.origin = CGPoint(x: device.viewWidth - 70, y: (39.5 - 31) / 2 )
        serverSyncSwitch.frame.origin = CGPoint(x: device.viewWidth - 70, y: (39.5 - 31) / 2 )
        
    }
    
    /*func adminAction() {
        print("adminAction")
        if changedDay == "" {
            let timeGotten = getTimeWithSetting()
            today = timeGotten.settingDate
            changedDay = testDateChange(currentDate: today)
            print("changedDay=\(changedDay)")
            adminBtn.setTitle("Date: \(changedDay)", for: .normal)
        } else {
            changedDay = testDateChange(currentDate: changedDay)
            print("changedDay=\(changedDay)")
            adminBtn.setTitle("Date: \(changedDay)", for: .normal)
        }
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        usernameCell.detailTextLabel?.text = MyVar.userName
        if let allowNotification = UserDefaults.standard.object(forKey: "allowNotification") as? Bool, let notificationTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            if allowNotification {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                notificationCell.detailTextLabel?.text = "\(formatter.string(from: notificationTime))"
            } else {
                notificationCell.detailTextLabel?.text = "OFF"
            }
        }
        wallPaperImage.removeFromSuperview()
        wallPaperImage = UIImageView(frame: CGRect(x: device.viewWidth - 70, y: (44 - 40) / 2, width: 20, height: 40))
        if let imageData = CoreDataManager.fetchPhotoObj() {
            wallPaperImage.image = UIImage(data: imageData as Data)
            wallPaperCell.addSubview(wallPaperImage)
        } else {
            wallPaperImage.image = UIImage(named: "background_4.png")
            wallPaperCell.addSubview(wallPaperImage)
        }
        
        if !MyVar.isDisplayTotal {
            displayTotalSwitch.isOn = false
        }
        if !MyVar.isDisplayAnimation {
            displayAnimationSwitch.isOn = false
        }
        if MyVar.serverConnect {
            serverSyncSwitch.isOn = true
        }
        
        //test
        /*if MyVar.userName == "headspinnerd" {
            adminBtn.frame = CGRect(x: 20, y: 50, width: 100, height: 40)
            adminBtn.setTitle("Date:", for: .normal)
            adminBtn.backgroundColor = .red
            adminBtn.titleLabel?.textColor = UIColor.white
            //adminBtn.titleLabel?.textAlignment = .left
            adminBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            adminBtn.addTarget(self, action: #selector(adminAction), for: .touchUpInside)
            view.addSubview(adminBtn)
        }*/
    }
    
    func donePressed() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        dayChangeTimeCell.detailTextLabel?.text = "\(formatter.string(from: datePicker.date))"
        UserDefaults.standard.set(datePicker.date, forKey: "changeTime")
        dayChangeTimeCell.detailTextLabel?.isUserInteractionEnabled = false
        dayChangeTimeCell.detailTextLabel?.isHidden = false
        self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func usernameUpdate(newUserName: String, oldUserName: String) {
        let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/usernameUpdate.php"
        let post: String = "newUserName=\(newUserName)&oldUserName=\(oldUserName)"
        let parsedData: String? = HttpRequestController().sendPostRequestSynchronous2(urlString: urlString, post: post)
        print("parseData=\(String(describing: parsedData))")
        if let _parsedData = parsedData {
            if let updateCheck = updateResVariousCheck(response: _parsedData, checkString: ["Successfully", "Duplicate entry"]) {
                switch updateCheck {
                case 0:
                    self.showAlert(title: "Succeed!", message: "The username successfully changed!!")
                    self.usernameCell.detailTextLabel?.text = newUserName
                    MyVar.userName = newUserName
                    UserDefaults.standard.set(newUserName, forKey: "Username")
                //FIXME: Need to change username in other table as well.
                case 1:
                    self.showAlert(title: "Error!", message: "Sorry, the username is used by other user now.")
                default:
                    break
                }
            } else {
                self.showAlert(title: "Unknown Error", message: "Sorry, please try again later!")
            }
        } else {
            self.showAlert(title: "Unknown Error", message: "Sorry, please try again later!")
        }
    }
    
    func passwordUpdate(newPassword: String, oldPassword: String) {
        let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/passwordUpdate.php"
        let post: String = "newPassword=\(newPassword)&oldPassword=\(oldPassword)&username=\(MyVar.userName)"
        let parsedData: String? = HttpRequestController().sendPostRequestSynchronous2(urlString: urlString, post: post)
        print("parseData=\(String(describing: parsedData))")
        if let _parsedData = parsedData {
            if let updateCheck = updateResVariousCheck(response: _parsedData, checkString: ["Successfully"]) {
                switch updateCheck {
                case 0:
                    self.showAlert(title: "Succeed!", message: "The password successfully changed!!")
                case 1:
                    self.showAlert(title: "Unknown Error", message: "please try again later!")
                default:
                    break
                }
            } else {
                self.showAlert(title: "Wrong Password", message: "The Password you entered is wrong!")
            }
        } else {
            self.showAlert(title: "Unknown Error!", message: "Sorry, please try again later! test")
        }
    }
    
    func dataTransfer1() {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        tableView.addSubview(activityIndicator)
        tableView.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Clear all CoreData
        CoreDataManager.clearAllSkillCoreData()
        CoreDataManager.clearAllCommentCoreData()
        CoreDataManager.clearAllColorCoreData()
        CoreDataManager.clearAllPhotoCoreData()
        
        //FIXME: Have to extract skillcounter table first and then color table.
        
        let url = "http://headspinnerd-com.stackstaging.com/bboying/dataTransfer1.php"
        let postString = "username=\(MyVar.userName)"
        let parsedDatas: [[String : Any]] = HttpRequestController().sendPostRequestSynchronous(urlString: url, post: postString)
        if parsedDatas.count > 0{
            var buttons: [(String, UIColor, UIColor)] = []
            for i in 0...parsedDatas.count-1
            {
                guard let skillname = parsedDatas[i]["skillname"] as? String else { continue }
                guard let btnNum = parsedDatas[i]["btnNum"] as? String else { continue }
                guard let btn1Name = parsedDatas[i]["btn1Name"] as? String else { continue }
                guard let btn1TextColor = parsedDatas[i]["btn1TextColor"] as? String else { continue }
                guard let btn1BkColor = parsedDatas[i]["btn1BkColor"] as? String else { continue }
                guard let btn1TextColorToUIColor = UIColor.init(hexString: btn1TextColor), let btn1BkColorToUIColor = UIColor.init(hexString: btn1BkColor) else { continue }
                buttons.append((btn1Name, btn1TextColorToUIColor, btn1BkColorToUIColor))
                if let _btnNum = Int(btnNum) {
                    if _btnNum >= 2 {
                        guard let btn2Name = parsedDatas[i]["btn2Name"] as? String else { continue }
                        guard let btn2TextColor = parsedDatas[i]["btn2TextColor"] as? String else { continue }
                        guard let btn2BkColor = parsedDatas[i]["btn2BkColor"] as? String else { continue }
                        guard let btn2TextColorToUIColor = UIColor.init(hexString: btn2TextColor), let btn2BkColorToUIColor = UIColor.init(hexString: btn2BkColor) else { continue }
                        buttons.append((btn2Name, btn2TextColorToUIColor, btn2BkColorToUIColor))
                    }
                } else { continue }
                if let _btnNum = Int(btnNum) {
                    if _btnNum >= 3 {
                        guard let btn3Name = parsedDatas[i]["btn3Name"] as? String else { continue }
                        guard let btn3TextColor = parsedDatas[i]["btn3TextColor"] as? String else { continue }
                        guard let btn3BkColor = parsedDatas[i]["btn3BkColor"] as? String else { continue }
                        guard let btn3TextColorToUIColor = UIColor.init(hexString: btn3TextColor), let btn3BkColorToUIColor = UIColor.init(hexString: btn3BkColor) else { continue }
                        buttons.append((btn3Name, btn3TextColorToUIColor, btn3BkColorToUIColor))
                    }
                } else { continue }
                if let _btnNum = Int(btnNum) {
                    if _btnNum >= 4 {
                        guard let btn4Name = parsedDatas[i]["btn4Name"] as? String else { continue }
                        guard let btn4TextColor = parsedDatas[i]["btn4TextColor"] as? String else { continue }
                        guard let btn4BkColor = parsedDatas[i]["btn4BkColor"] as? String else { continue }
                        guard let btn4TextColorToUIColor = UIColor.init(hexString: btn4TextColor), let btn4BkColorToUIColor = UIColor.init(hexString: btn4BkColor) else { continue }
                        buttons.append((btn4Name, btn4TextColorToUIColor, btn4BkColorToUIColor))
                    }
                } else { continue }
                if let _btnNum = Int(btnNum) {
                    if _btnNum >= 5 {
                        guard let btn5Name = parsedDatas[i]["btn5Name"] as? String else { continue }
                        guard let btn5TextColor = parsedDatas[i]["btn5TextColor"] as? String else { continue }
                        guard let btn5BkColor = parsedDatas[i]["btn5BkColor"] as? String else { continue }
                        guard let btn5TextColorToUIColor = UIColor.init(hexString: btn5TextColor), let btn5BkColorToUIColor = UIColor.init(hexString: btn5BkColor) else { continue }
                        buttons.append((btn5Name, btn5TextColorToUIColor, btn5BkColorToUIColor))
                    }
                } else { continue }
                CoreDataManager.storeColors(skillname: skillname, buttons: buttons)
                print("skillname=\(skillname) buttons=\(buttons)")
                if let _btnNum = Int(btnNum) {
                    skillNameList.append((skillname, _btnNum))
                }
            }
            dataTransfer2()
        } else {
            DispatchQueue.main.sync(execute: {
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                if UIApplication.shared.isIgnoringInteractionEvents {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                showAlert(title: "Error", message: "Couldn't get data from web database.")
            })
            return
        }
    }

        
    func dataTransfer2() {
        print("skillNameList=\(skillNameList)")
        let timeGotten = getTimeWithSetting()
        today = timeGotten.settingDate
        for skillList in skillNameList {
            let url = "http://headspinnerd-com.stackstaging.com/bboying/dataTransfer2.php"
            let postString = "username=\(MyVar.userName)&skillname=\(skillList.0)"
            let parsedDatas: [[String : Any]] = HttpRequestController().sendPostRequestSynchronous(urlString: url, post: postString)
            if parsedDatas.count > 0{
                for i in 0...parsedDatas.count-1
                {
                    guard let date = parsedDatas[i]["date"] as? String else { continue }
                    guard let skillName = parsedDatas[i]["skillName"] as? String else { continue }
                    guard let first_count = parsedDatas[i]["first_count"] as? String else { continue }
                    guard let second_count = parsedDatas[i]["second_count"] as? String else { continue }
                    guard let third_count = parsedDatas[i]["third_count"] as? String else { continue }
                    guard let fourth_count = parsedDatas[i]["fourth_count"] as? String else { continue }
                    guard let fifth_count = parsedDatas[i]["fifth_count"] as? String else { continue }
                    guard let comment = parsedDatas[i]["comment"] as? String else {
                        if let first = Int(first_count), let second = Int(second_count),let third = Int(third_count),let fourth = Int(fourth_count),let fifth = Int(fifth_count) {
                            CoreDataManager.storeCountObj(date: date, object: DayActions(number: i, skillname: skillName, count: [first, second, third, fourth, fifth], btnCount: skillList.1 ))
                        }
                        print("skillname=\(skillName) btnNum=\(skillList.1) date=\(date) first_count=\(first_count)")
                        continue
                    }
                    if let first = Int(first_count), let second = Int(second_count),let third = Int(third_count),let fourth = Int(fourth_count),let fifth = Int(fifth_count) {
                        CoreDataManager.storeCountObj(date: date, object: DayActions(number: i, skillname: skillName, count: [first, second, third, fourth, fifth], btnCount: skillList.1 ))
                        CoreDataManager.storeCommentObj(date: date, object: DayActions(number: i, skillname: skillName, btnCount: skillList.1, comments: [comment] ), number: 0)
                    }
                    print("skillname=\(skillName) btnNum=\(skillList.1) date=\(date) first_count=\(first_count) comment= \(comment)")
                }
            } else {
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                if UIApplication.shared.isIgnoringInteractionEvents {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                fetchTodaysData(date: today)
                self.showAlert(title: "Error", message: "Transfer completed! Please check the data.")
            }
        }
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        }
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        fetchTodaysData(date: today)
        self.showAlert(title: "Completed", message: "Transfer completed! Please check the data.")
    }

}


