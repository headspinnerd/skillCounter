//
//  ViewController.swift
//  skillCounter
//
//  Created by 田中江樹 on 2016-11-07.
//  Copyright © 2016 Koki. All rights reserved.
//

import UIKit
import CoreData
import Parse
import GoogleMobileAds

class TabBarController: UITabBarController {
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
}


class CountVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, LoginVCDelegate, SettingVCDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var modeFlg: Bool = true
    @IBOutlet weak var myBanner: GADBannerView!
    var today: String = ""
    var buttons: [UIButton] = []
    var timer = Timer()
    var date = Date()
    var calendar = Calendar.current
    let formatter = DateFormatter()
    var animationIndex: Int?
    
    var backgroundImage = UIImageView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let username = UserDefaults.standard.object(forKey: "Username") as? String {
            //username label FIXME: needs to change position neatly
            print("username=\(username)")
            MyVar.userName = username
        } else {
            performSegue(withIdentifier: "showLogin", sender: nil)
        }
        print("device=\(device)")
    }
    
    func didLoginSuccessfully() {
        print("didLoginSuccessfully")
        dismiss(animated: true, completion: nil)
    }
    
    func showLoginFromSetting() {
        print("showLoginFromSetting")
        performSegue(withIdentifier: "showLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLogin" {
            let loginVC = segue.destination as! LoginVC
            loginVC.delegate = self
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (skillList.count)
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountVCCell
        
        cell.skillOutlet.text = skillList[indexPath.row].skillName
        //Display the number of comments
        if let count = skillList[indexPath.row].comment?.count {
            if count > 0 {
                let numberOfSpace = 30 - (cell.skillOutlet.text?.characters.count)!
                var spaces: String = ""
                    if numberOfSpace > 0 {
                    for _ in 1...numberOfSpace {
                        spaces = spaces + " "
                    }
                }
                cell.skillOutlet.text = cell.skillOutlet.text! + spaces + "\(count)COMS"
                //skillList[indexPath.row].comment?[n]
            }
        }
        cell.skillOutlet.textColor = .white
        //cell.skillOutlet.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        var countString: String = ""
        var startingIndex = 0
        var targetString: String = ""
        var targetRange = 0
        if skillList[indexPath.row].btnCount > 0 {
            for n in 0...(skillList[indexPath.row].btnCount-1) {
                if skillList[indexPath.row].btnCount == 1 {
                    countString = countString + "\(skillList[indexPath.row].actions[n])"
                } else {
                    if indexPath == MyVar.target, let index = animationIndex {
                        if n == index {
                            startingIndex = countString.characters.count
                            targetString = "\(skillList[indexPath.row].actions[n])"
                            targetRange = targetString.characters.count
                        }
                    }
                    countString = countString + "\(skillList[indexPath.row].actions[n])/"
                }
            }
        }
        
        if skillList[indexPath.row].btnCount != 1 {
            countString = countString + "\(skillList[indexPath.row].total)"
        }
        cell.skillCounter.text = countString
        
        if indexPath == MyVar.target, let index = animationIndex {
            print("startingIndex=\(startingIndex)")
            print("targetString=\(targetString)")
            print("animationIndex=\(index)")
            
            let openingRange = NSMakeRange(startingIndex, targetRange)
            
            print("openingRange=\(openingRange)")
            
            let openingFrame = cell.skillCounter.boundingRectForCharacterRange(range: openingRange)
            
            //openingFrame?.origin.y += openingLabel.textContainerInset.top
            let openingLabel = UILabel(frame: openingFrame!)
            openingLabel.text = targetString
            openingLabel.font = UIFont(name: "AvenirNext-BoldItalic", size: 17)
            openingLabel.textColor = .yellow
            openingLabel.backgroundColor = .red
            openingLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.6)
            openingLabel.frame.size = CGSize(width: 17 * Double(targetRange) / 1.4, height: 17)
            
            
            cell.skillCounter.addSubview(openingLabel)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                openingLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.01, delay: 0.4, options: .autoreverse, animations: {
                openingLabel.transform = .identity
                openingLabel.alpha = 0
            }, completion: { finished in
                openingLabel.removeFromSuperview()
            })
            
            animationIndex = nil
        }

        
        cell.skillCounter.textColor = .white
        //cell.skillCounter.font = UIFont.boldSystemFont(ofSize: 16.0)
        if ( indexPath.row % 2 == 0 ) {
            cell.backgroundColor = uiColor(200, 200, 200, 0.2)
        } else {
            cell.backgroundColor = uiColor(150, 150, 150, 0.2)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        myBanner.isHidden = false
        myBanner.alpha = 1.0
        myBanner.isMultipleTouchEnabled = true
        myBanner.isAccessibilityElement = true
        UIView.animate(withDuration: 2.0) {
            self.myBanner.isHidden = true
            self.myBanner.alpha = 0
            self.myBanner.isMultipleTouchEnabled = false
            self.myBanner.isAccessibilityElement = false
        }
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(myBannerShow), userInfo: nil, repeats: false)
    }
    
    func myBannerShow() {
        UIView.animate(withDuration: 1.0) {
            self.myBanner.isHidden = false
            self.myBanner.alpha = 1.0
            self.myBanner.isMultipleTouchEnabled = true
            self.myBanner.isAccessibilityElement = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        device = deviceRecognition(width: self.view.frame.width, height: self.view.frame.height)
        print("device=\(device)")
        //If it's the first time to run the app, initiate data using CoreData
        //UserDefaults.standard.removeObject(forKey: "IsfirstRun") //-> Uncomment when deleting all Core Data
        if let _ = UserDefaults.standard.object(forKey: "IsfirstRun") as? Bool
        {
        } else {
            CoreDataManager.clearAllSkillCoreData()
            CoreDataManager.clearAllCommentCoreData()
            CoreDataManager.clearAllColorCoreData()
            CoreDataManager.clearAllPhotoCoreData()
            print("clearAllCoreData")
            UserDefaults.standard.removeObject(forKey: "IsfirstRun")
            CoreDataManager.firstStoreObj()
            UserDefaults.standard.set(false, forKey: "IsfirstRun")
            formatter.dateFormat = "hh:mm"
            let changeTime = formatter.date(from: "04:00")!
            UserDefaults.standard.set(changeTime, forKey: "changeTime")
        }
        
        let timeGotten = getTimeWithSetting()
        today = timeGotten.settingDate
        
        print("today=\(timeGotten.settingDate) now=\(timeGotten.currentDateTime)")
        
        //Fetch today's data if existing
        if let savedSkills = CoreDataManager.fetchCountObj(date: today) {
            print("Fetch today's data if existing")
            if savedSkills.count > 0 {
                for savedSkill in savedSkills {
                    if let savedSkillCount = savedSkill.count {
                        if let colorObj = CoreDataManager.fetchColorObj(skillname: savedSkill.skillname) {
                            skillList.append(SkillList(number: savedSkill.number, actions: savedSkillCount, btnCount: savedSkill.btnCount, skillName: savedSkill.skillname, validity: true, comment: savedSkill.comments, buttons: colorObj))
                        }
                    } else {
                        print("savedSkill.count is null")
                    }
                }
            }
            skillList.sort { (lhs, rhs) in return lhs.number < rhs.number }
        //If not existing
        } else {
            //Fetch coredata that has no date
            print("Fetch coredata that has no date")
            if let fetchLists = CoreDataManager.fetchObj() {
                CoreDataManager.dateAddToObj(fetchLists: fetchLists, date: today)
                if fetchLists.count > 0 {
                    for fetchList in fetchLists {
                        var count: [Int] = []
                        for _ in 0...(fetchList.btnCount-1) {
                            count.append(0)
                        }
                        
                        skillList.append(SkillList(number: fetchList.number, actions: count, btnCount: fetchList.btnCount, skillName: fetchList.skillname, validity: true, buttons: fetchList.buttons))
                    }
                }
            }
        }
        
        //The function of long press on every tableView
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        let testObject = PFObject(className: "TestObject2")
        
        testObject["foo"] = "bar"
        
        /*testObject.saveInBackground { (success, error) -> Void in
            
            // added test for success 11th July 2016
            
            if success {
                
                print("Object has been saved.")
                
            } else {
                
                if error != nil {
                    
                    print (error!)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
            
        }*/
        
        let request = GADRequest()
        
        request.testDevices = [kGADSimulatorID]
        
        //Set up ad
        myBanner.adUnitID = "ca-app-pub-7854903923018969/9957643139"
        myBanner.rootViewController = self
        myBanner.delegate = self
        
        myBanner.load(request)
        
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyVar.target = indexPath
        let cell = tableView.cellForRow(at: indexPath)
        cell!.backgroundColor = .red
        if buttons.count > 0 {
            for button in buttons {
                button.removeFromSuperview()
            }
        }
        buttons = []
        buttons = createCountBtn(btns: skillList[indexPath.row].buttons!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundImage.removeFromSuperview()
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        if let imageData = CoreDataManager.fetchPhotoObj() {
            backgroundImage.image = UIImage(data: imageData as Data)
            self.view.insertSubview(backgroundImage, at: 0)
        } else {
            backgroundImage.image = UIImage(named: "background_4.png")
            self.view.insertSubview(backgroundImage, at: 0)
        }
        
        animateTable()
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func normalTap(_ sender: UIButton) {
        if MyVar.target != [] {
            skillList[MyVar.target.row].addCounter(target: sender.tag, modeFlg: self.modeFlg, value: 1)
            let number = skillList[MyVar.target.row].number
            CoreDataManager.deleteCoreData(date: today, object: skillList[MyVar.target.row].skillName)
            CoreDataManager.storeCountObj(date: today, object: DayActions(number: number, skillname: skillList[MyVar.target.row].skillName, count: skillList[MyVar.target.row].actions, btnCount: skillList[MyVar.target.row].btnCount, comments: skillList[MyVar.target.row].comment))
            animationIndex = sender.tag
            tableView.reloadData()
            //Select row again because selection is disabled when reloadData
            tableView.selectRow(at: MyVar.target, animated: false, scrollPosition: .none)
            let cell = tableView.cellForRow(at: MyVar.target)
            cell!.backgroundColor = .red
            startEndTime()
        }
    }
    
    func longTap(sender : UIGestureRecognizer){
        if sender.state == .began {
            guard let tag = sender.view?.tag else {
                fatalError("could not get the button attached to the gesturerecognizer")
            }
            let alert = UIAlertController(title: "Numeric Input", message: "Enter a specific number of counts you wanna add", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.keyboardType = .numberPad
                textField.text = ""
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                //let textField = alert?.textFields![0].text
                let text = alert?.textFields![0].text
                if text != "" {
                    skillList[MyVar.target.row].addCounter(target: tag, modeFlg: self.modeFlg, value: Int(text!)!)
                    let number = skillList[MyVar.target.row].number
                    CoreDataManager.deleteCoreData(date: self.today, object: skillList[MyVar.target.row].skillName)
                    CoreDataManager.storeCountObj(date: self.today, object: DayActions(number: number, skillname: skillList[MyVar.target.row].skillName, count: skillList[MyVar.target.row].actions, btnCount: skillList[MyVar.target.row].btnCount, comments: skillList[MyVar.target.row].comment))
                    self.tableView.reloadData()
                    self.tableView.selectRow(at: MyVar.target, animated: false, scrollPosition: .none)
                    let cell = self.tableView.cellForRow(at: MyVar.target)
                    cell!.backgroundColor = .red
                    self.startEndTime()
                } else {
                    self.showAlert(title: "Error", message: "Enter a number!!")
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func modeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            modeFlg = true
        } else {
            modeFlg = false
        }
    }
    
    @IBAction func update(_ sender: Any) {
        
        var isPracticed: Bool = false
        var postString : String = ""
        MyVar.userName = UserDefaults.standard.object(forKey: "Username") as! String
        if skillList.count > 0 {
            for n in 1...skillList.count {
                let startTime = UserDefaults.standard.object(forKey: "startTime") as! String
                let endTime = UserDefaults.standard.object(forKey: "endTime") as! String
                if n != 1 {
                    postString = postString + "&"
                } else {
                    postString = "today=\(self.today)&startTime=\(startTime)&endTime=\(endTime)&username=\(MyVar.userName)&count=\(skillList.count)&"
                }
                let l = n - 1
                postString = postString + "name\(n)=\(skillList[l].skillName)"
                if skillList[l].btnCount > 0 {
                    for p in 1...skillList[l].btnCount {
                        let q = p - 1
                        if skillList[l].actions[q] > 0 {
                            isPracticed = true
                        }
                        postString = postString + "&count\(n)\(p)=\(skillList[l].actions[q])" //FIXME: should be \(n)-\(p) etc. ?
                    }
                }
                postString = postString + "&btnCount\(n)=\(skillList[l].btnCount)"
                
                if let comments = skillList[l].comment {
                    var comment = ""
                    if comments.count > 0 {
                        for m in 0...(comments.count-1) {
                            comment = comment + comments[m]
                            if m != (comments.count-1) {
                                comment = comment + "/"
                            }
                        }
                    }
                    postString = postString + "&comment" + "\(n)" + "=\(comment)"
                }
            }
        }
        print("postString=\(postString)")
        
        if isPracticed == false {
            let refreshAlert2 = UIAlertController(title: "Skip?", message: "No counts. Do you really wanna skip today's practice?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert2.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let alert = UIAlertController(title: "Post comment", message: "Enter a comment(up to 20 bytes)", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.text = "skip for " //FIXME: Neet to check whether the number of characters is under 20 bytes
                }
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0].text
                    if textField != "" {
                        postString = postString + "&comment=\(textField!)"
                        self.sqlUpdate(postString: postString)
                    } else {
                        self.showAlert(title: "Error", message: "Enter a comment!!")
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }))
            
            refreshAlert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert2, animated: true, completion: nil)
            
        } else {
            sqlUpdate(postString: postString)
        }
 
    }
    
    //This function is split from update() cuz there are two parts where mysql should be executed inside the alert action.
    func sqlUpdate(postString: String) {
        let request = NSMutableURLRequest(url: NSURL(string: "http://headspinnerd-com.stackstaging.com/bboying/oneDayUpdate.php")! as URL)
        request.httpMethod = "POST"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            if let checkResponse = responseString {
                if updateResCheck(response: checkResponse) {
                    self.showAlert(title: "Update", message: "Successfully Updated")
                } else {
                    self.showAlert(title: "Update", message: "Update Failed") //FIXME: Better to add more error case
                }
            } else {
                self.showAlert(title: "Update", message: "Update Failed")
            }
            
        }
        task.resume()
        
    }
    
    @IBAction func refresh(_ sender: Any) { //FIXME : Crashed!!!
        let refreshAlert = UIAlertController(title: "Refresh", message: "Do you really wanna refresh all counts?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            CoreDataManager.refreshObj(date: self.today)
            CoreDataManager.clearCommentCoreData(date: self.today)
            if skillList.count > 0 {
                for i in 0...(skillList.count-1) {
                    if skillList[i].actions.count > 0 {
                        for r in 0...(skillList[i].actions.count-1) {
                            skillList[i].actions[r] = 0
                        }
                    }
                    skillList[i].comment = nil
                }
            }
            UserDefaults.standard.removeObject(forKey: "startTime")
            UserDefaults.standard.removeObject(forKey: "endTime")
            self.tableView.reloadData()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                MyVar.target = indexPath
                let refreshAlert = UIAlertController(title: "Comments", message: "ADD or SHOW?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { (action: UIAlertAction!) in
                    let alert = UIAlertController(title: "Post comment", message: "Enter a comment)", preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.text = ""
                    }
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields![0].text
                        if textField != "" {
                            if let count = skillList[MyVar.target.row].comment?.count {
                                //if the comment(s) is already registered
                                CoreDataManager.storeCommentObj(date: self.today, object: DayActions(number: skillList[MyVar.target.row].number, skillname: skillList[MyVar.target.row].skillName, btnCount: skillList[MyVar.target.row].btnCount, comments: ["\(textField!)"]), number: count )
                                if (skillList[MyVar.target.row].comment?.append(CoreDataManager.fetchCommentObj(date: self.today, skillname: skillList[MyVar.target.row].skillName, index: count))) == nil {
                                    skillList[MyVar.target.row].comment = [CoreDataManager.fetchCommentObj(date: self.today, skillname: skillList[MyVar.target.row].skillName, index: count)]
                                }
                                self.tableView.reloadData()
                            } else {
                                //if no comment(s) is registered yet
                                CoreDataManager.storeCommentObj(date: self.today, object: DayActions(number: skillList[MyVar.target.row].number, skillname: skillList[MyVar.target.row].skillName, btnCount: skillList[MyVar.target.row].btnCount, comments: ["\(textField!)"]), number: 0 )
                                if (skillList[MyVar.target.row].comment?.append(CoreDataManager.fetchCommentObj(date: self.today, skillname: skillList[MyVar.target.row].skillName, index: 0))) == nil {
                                    skillList[MyVar.target.row].comment = [CoreDataManager.fetchCommentObj(date: self.today, skillname: skillList[MyVar.target.row].skillName, index: 0)]
                                }
                                self.tableView.reloadData()
                            }
                        } else {
                            self.showAlert(title: "Error", message: "Enter a comment!!")
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }))
                refreshAlert.addAction(UIAlertAction(title: "SHOW", style: .default, handler: { (action: UIAlertAction!) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "showPopup") as! PopupVC
                    self.present(vc, animated: true, completion: nil)
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    func startEndTime() {
        //2017-02-19 03:52:23
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTime = formatter.string(from: date)
        
        if let _ = UserDefaults.standard.object(forKey: "startTime") as? String {
            //comparing hour in order to avoid miscalculation of practice time
            if let lastdate = UserDefaults.standard.object(forKey: "lastdate") as? Date {
                var oneHour = DateComponents()
                oneHour.hour = 1
                let oneHourAfter = calendar.date(byAdding: oneHour, to: lastdate)!
                
                if oneHourAfter < date {
                    UserDefaults.standard.set(currentTime, forKey: "startTime")
                }
            }
        } else {
            UserDefaults.standard.set(currentTime, forKey: "startTime")
        }
        
        UserDefaults.standard.set(currentTime, forKey: "endTime")
        UserDefaults.standard.set(date, forKey: "lastdate")
    }
    
    func createCountBtn(btns: [(String, UIColor, UIColor)]) -> [UIButton] {
        var btnWidth: CGFloat
        var btnHorizontalSpace: CGFloat
        switch btns.count {
            case 1: btnWidth = (device.spViewWidth - 20) / 2.5
            btnHorizontalSpace = (device.spViewWidth - btnWidth) / 2
            case 2: btnWidth = (device.spViewWidth - 20) / 3
            btnHorizontalSpace = (device.spViewWidth - btnWidth * 2) / 3
            default: btnHorizontalSpace = 10.0
            btnWidth = (device.spViewWidth - CGFloat(btns.count-1) * btnHorizontalSpace) / CGFloat(btns.count)
        }
        
        let btnHeight: CGFloat = 42.0
        var btnCount = 0
        var createdBtns: [UIButton] = []
        
        for btn in btns {
            var xPosition: CGFloat
            switch btns.count {
                case 1: xPosition = device.layoutGuideWidth + btnHorizontalSpace
                case 2: xPosition = device.layoutGuideWidth + btnHorizontalSpace + CGFloat(btnCount) * btnWidth
                default: xPosition = device.layoutGuideWidth + CGFloat(btnCount) * btnWidth
            }
            if btnCount != 0 {
                xPosition += CGFloat(btnCount) * btnHorizontalSpace
            }
            let yPosition: CGFloat = 55.0
            let newBtn = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: btnWidth, height: btnHeight))
            newBtn.setTitle(btn.0, for: .normal)
            newBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            newBtn.setTitleColor(btn.1, for: .normal)
            newBtn.backgroundColor = btn.2
            newBtn.layer.cornerRadius = 3
            newBtn.tag = btnCount
            newBtn.addTarget(self, action: #selector(normalTap(_:)), for: .touchUpInside)
            newBtn.alpha = 0
            newBtn.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            newBtn.center.x = newBtn.center.x - newBtn.frame.width/2
            newBtn.frame.size.width = 0
            //newBtn.frame.origin.x = newBtn.frame.origin.x - device.viewWidth
            self.view.addSubview(newBtn)
            let longGes1 = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:))) //(sender:)
            newBtn.addGestureRecognizer(longGes1)
            createdBtns.append(newBtn)
            btnCount += 1
            UIView.animate(withDuration: 0.2, animations: {
                newBtn.alpha = 1
                newBtn.transform = .identity
                newBtn.center.x = newBtn.center.x + newBtn.frame.width/2
                newBtn.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                newBtn.frame.size.width = btnWidth
                //newBtn.frame.origin.x = newBtn.frame.origin.x + self.device.viewWidth
            })
        }
        return createdBtns
    }
    

}
