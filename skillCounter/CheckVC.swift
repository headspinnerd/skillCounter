//
//  ViewController2.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-02.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import Charts
import Social
import GoogleMobileAds

class CheckVC: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, ChartViewDelegate, GADBannerViewDelegate {
    
    var searchOutlet = UIButton()
    var textbox = MyTextField()
    var dropdown = UIPickerView()
    var tableViewcell: CheckVCCell?
    var combinedChartView = CombinedChartView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var values: [AnyObject] = []
    var recordCount: Int = 0
    var TableData: [[String]] = []
    var dayweektext: String = "Day"
    var dayweeks: [String]!
    var shareBtn = UIButton()
    var backgroundImage = UIImageView()
    var verticalConstraint: [[[NSLayoutConstraint]]] = []
    var horizontalConstraint: [[NSLayoutConstraint]] = []
    var btnNum = 0
    var spaceOfItems = 0
    var itemWidth: [Int] = []
    var buttons: [[(String, UIColor, UIColor)]]?
    var targetRow = 0
    var today: String = ""
    var isUpdatePastData = false
    var onlyUpdateMode = false
    var borders: [CALayer] = []
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.isHidden || TableData.count <= 1 {
            return 0
        } else {
            return TableData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customFooter")
        footerCell?.isHidden = true
        return footerCell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader")
        headerCell?.addSubview(combinedChartView)
        combinedChartView.frame = CGRect(x: 0, y: textbox.frame.height+3, width: (headerCell?.frame.width)!, height: (headerCell?.frame.height)! - textbox.frame.height)
        if TableData.count > 1 {
            headerCell?.isHidden = false
        } else {
            headerCell?.isHidden = true
        }
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return device.viewHeight*0.4
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! CheckVCCell
        
        print("btnNum=\(btnNum) TableData[\(indexPath.row)]=\(TableData[indexPath.row])")
        //Clear the previous displayed data
        for n in 0...5 {
            if n > btnNum {
                // Clear the previous displayed data
                cell.labels[n].text = ""
            } else {
                print("n=\(n)")
                print("buttons=\(String(describing: buttons))")
                if indexPath.row == 0 {
                    var title: String = ""
                    if let btns = buttons {
                        if btns.count > indexPath.row {
                            switch n {
                            case 0: title = self.dayweektext
                            case 1: title = btnNum == 1 ? "count" : "total"
                            case 2: title = btns[indexPath.row].count > 0 ? "\(btns[indexPath.row][0].0) Ratio" : "1stRatio"
                            case 3: title = btns[indexPath.row].count > 1 ? "\(btns[indexPath.row][1].0)+ Ratio" : "2ndRatio"
                            case 4: title = btns[indexPath.row].count > 2 ? "\(btns[indexPath.row][2].0)+ Ratio" : "3rdRatio"
                            case 5: title = btns[indexPath.row].count > 3 ? "\(btns[indexPath.row][3].0)+ Ratio" : "4thRatio"
                            default: break
                            }
                            cell.labels[n].text = title
                            print("title\(n)=\(title)")
                        }
                    }
                } else {
                    cell.labels[n].text = TableData[indexPath.row].count > n ? TableData[indexPath.row][n] : "Error"
                }
                cell.labels[n].font = UIFont(name: "AvenirNext-DemiBold", size: device.getFontSize(numOfLetters: 22))
                if cell.labels[n].text != "" {
                    cell.labels[n].adjustsFontSizeToFitWidth = true
                    cell.labels[n].minimumScaleFactor = 0.5
                    
                }
                cell.labels[n].textColor = .white
                
                cell.labels[n].textAlignment = .center
                print("labels\(n)=\(cell.labels[n])")
            }
        }
        
        
        if TableData[indexPath.row].count == 8 {
            if TableData[indexPath.row][7] != "" {
                cell.layer.borderColor = uiColor(100,100,255,1.0).cgColor
                cell.layer.borderWidth = 1.0
            }
        }
        

        
        if horizontalConstraint.count >= indexPath.row + 1 {
            view.removeConstraints(horizontalConstraint[indexPath.row])
            print("removed constraint\(indexPath.row) \(horizontalConstraint[indexPath.row])")
        }
        var visualFmtString = ""
        var visualViews: [String : Any] = [:]
        switch btnNum {
        case 1: visualFmtString = "H:|-\(spaceOfItems)-[h0(==\(itemWidth[0]))]-\(spaceOfItems)-[h1(>=\(itemWidth[1]))]-\(spaceOfItems)-|"
        visualViews = ["h0": cell.labels[0], "h1": cell.labels[1]]
        case 2: visualFmtString = "H:|-\(spaceOfItems)-[h0(==\(itemWidth[0]))]-\(spaceOfItems)-[h1(==\(itemWidth[1]))]-\(spaceOfItems)-[h2(>=\(itemWidth[2]))]-\(spaceOfItems)-|"
        visualViews = ["h0": cell.labels[0], "h1": cell.labels[1], "h2": cell.labels[2]]
        case 3: visualFmtString = "H:|-\(spaceOfItems)-[h0(==\(itemWidth[0]))]-\(spaceOfItems)-[h1(==\(itemWidth[1]))]-\(spaceOfItems)-[h2(==\(itemWidth[2]))]-\(spaceOfItems)-[h3(>=\(itemWidth[3]))]-\(spaceOfItems)-|"
                visualViews = ["h0": cell.labels[0], "h1": cell.labels[1], "h2": cell.labels[2],"h3": cell.labels[3]]
        case 4: visualFmtString = "H:|-\(spaceOfItems)-[h0(==\(itemWidth[0]))]-\(spaceOfItems)-[h1(==\(itemWidth[1]))]-\(spaceOfItems)-[h2(==\(itemWidth[2]))]-\(spaceOfItems)-[h3(==\(itemWidth[3]))]-\(spaceOfItems)-[h4(>=\(itemWidth[4]))]-\(spaceOfItems)-|"
        visualViews = ["h0": cell.labels[0], "h1": cell.labels[1], "h2": cell.labels[2],"h3": cell.labels[3], "h4": cell.labels[4]]
        case 5: visualFmtString = "H:|-\(spaceOfItems)-[h0(==\(itemWidth[0]))]-\(spaceOfItems)-[h1(==\(itemWidth[1]))]-\(spaceOfItems)-[h2(==\(itemWidth[2]))]-\(spaceOfItems)-[h3(==\(itemWidth[3]))]-\(spaceOfItems)-[h4(==\(itemWidth[4]))]-\(spaceOfItems)-[h5(>=\(itemWidth[5]))]-\(spaceOfItems)-|"
        visualViews = ["h0": cell.labels[0], "h1": cell.labels[1], "h2": cell.labels[2],"h3": cell.labels[3], "h4": cell.labels[4],"h5": cell.labels[5]]
        default: break
        }
        print("visualFmtString=\(visualFmtString)  visualViews=\(visualViews)")
        horizontalConstraint.append(NSLayoutConstraint.constraints(withVisualFormat: visualFmtString, options: NSLayoutFormatOptions(), metrics: nil, views: visualViews))
        print("horizontalConstraint\(indexPath.row) ->\(horizontalConstraint[indexPath.row])")
        view.addConstraints(horizontalConstraint[indexPath.row])
        
        //NSLayoutConstraint.activate(horizontalConstraint[indexPath.row])
        
        
        if verticalConstraint.count >= indexPath.row + 1 {
            for n in 0...btnNum {
                view.removeConstraints(verticalConstraint[indexPath.row][n])
            }
        }
        var vtConstChild: [[NSLayoutConstraint]] = []
        for n in 0...btnNum {
            vtConstChild.append(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.labels[n]]))
        }
        verticalConstraint.append(vtConstChild)
        for n in 0...btnNum {
            view.addConstraints(verticalConstraint[indexPath.row][n])
        }

        
        if borders.count > 0 {
            for n in 0...(borders.count-1) {
                borders[n].removeFromSuperlayer()
            }
        }
        borders = []
        var xPosition = spaceOfItems/2
        for n in 0...(btnNum-1) {
            xPosition += itemWidth[n] + spaceOfItems
            let border = CALayer()
            border.frame = CGRect(x: CGFloat(xPosition), y: 0, width: 0.5, height: cell.frame.height)
            if ( indexPath.row == 0 ) {
                cell.backgroundColor = uiColor(100, 111, 72, 0.8)
                border.backgroundColor = uiColor(50, 50, 50, 0.5).cgColor
            } else if ( indexPath.row % 2 == 0 ) {
                cell.backgroundColor = uiColor(200, 200, 200, 0.5)
                border.backgroundColor = uiColor(50, 50, 50, 0.5).cgColor
            } else {
                cell.backgroundColor = uiColor(130, 130, 130, 0.5)
                border.backgroundColor = uiColor(30, 30, 30, 0.5).cgColor
            }
            borders.append(border)
            cell.layer.addSublayer(borders[n]) // FIXME: Sometimes displays layer but sometimes not.
        }
        print("indexPath=\(indexPath.row) borders=\(borders) ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyVar.displayComment = ""
        if TableData[indexPath.row].count == 8 {
            if TableData[indexPath.row][7] != "" {
                MyVar.displayComment = TableData[indexPath.row][7]
                targetRow = indexPath.row
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "showPopup") as! PopupVC
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let titleRow = values[row] as? String {
            return titleRow
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if values.count > 0 {
            if values.count >= row {
                self.textbox.text = self.values[row] as? String
            } else {
                self.textbox.text = self.values[0] as? String
            }
            targetRow = row
            self.dropdown.isHidden = true
            self.dropdown.frame.size.height = device.viewHeight * 0.1
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textbox {
            if textbox.text == "No Data Found" {
                textbox.placeholder = "No Data Found"
                textField.resignFirstResponder()
                return
            }
            self.dropdown.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.dropdown.frame.size.height = device.viewHeight * 0.3
                if self.shareBtn.isHidden {
                    self.dropdown.center = self.textbox.center
                } else {
                    self.dropdown.center.x = self.textbox.center.x
                    self.dropdown.frame.origin.y = self.textbox.frame.maxY
                    self.tableView.bringSubview(toFront: self.dropdown)
                }
                self.searchOutlet.alpha = 1.0
            })
            if values.count > 0 {
                self.textbox.text = self.values[0] as? String
                searchOutlet.isEnabled = true
            }
            // Close the keyboard when textfield is tapped
            textField.resignFirstResponder()
            //tableView.isHidden = true
            if textbox.text == "Upload to web database" {
                searchOutlet.setTitle("Upload", for: .normal)
            } else {
                self.searchOutlet.setTitle("Search", for: .normal)
            }
        }
    }
    
    
    
    func searchButton() {
        if textbox.text == "No Data Found" {
            return
        }
        if horizontalConstraint.count > 0 {
            for n in 0...(horizontalConstraint.count-1) {
                print("horizontalConstraint\(n) ->\(horizontalConstraint[n])")
                view.removeConstraints(horizontalConstraint[n])
            }
        }
        if verticalConstraint.count > 0 {
            for n in 0...(verticalConstraint.count-1) {
                for p in 0...(verticalConstraint[n].count-1) {
                    NSLayoutConstraint.deactivate(verticalConstraint[n][p])
                    view.removeConstraints(verticalConstraint[n][p])
                }
            }
        }
        
        verticalConstraint = []
        horizontalConstraint = []
        
        // Close the keyboard
        textbox.endEditing(true)
        self.dropdown.isHidden = true
        
        guard (textbox.text?.characters.count)! > 0 else {
            showAlert(title: "Input Error", message: "Choose the skill name!!")
            return
        }
        
        //Display an Activity Indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        tableView.addSubview(activityIndicator)
        tableView.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if onlyUpdateMode {
            _ = syncCoreDataAndDB()  //FIXME: Need to make "No Data Found" dialog invisible and reflect the screen
            onlyUpdateMode = false
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        
        TableData = [["1/1","1","0%","0%","0%","0%","1"]] // This first index is dummy for the title of each item
        
        MyVar.userName = UserDefaults.standard.object(forKey: "Username") as! String
        
        if MyVar.userName == "Trial Member" || !MyVar.serverConnect {
            print("test21")
            self.dayweektext = "Day"
            setChartFromCoreData(skillname: self.textbox.text!)
            return
        }
        
        if !isInternetAvailable() || textbox.text == "Sample Skill" {
            self.searchOutlet.setTitle("Day", for: .normal)
            self.dayweektext = "Day"
            setChartFromCoreData(skillname: self.textbox.text!)
            return
        }
        
        //Server Maintenance Check
        let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/serverMaintenanceMessage.php"
        let contents: [[String : Any]] = HttpRequestController().sendGetRequestSynchronous(urlString: urlString)
        print(contents)
        if contents.count > 0 {
            guard let info1 = contents[0]["info1"] as? String else {
                return
            }
            if info1 != "NO" {
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                if UIApplication.shared.isIgnoringInteractionEvents {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                self.showAlert(title: "Sorry", message: info1, style: .alert)
            } else {
                self.searchMain()
            }
        }

    }

    func searchMain() {
        isUpdatePastData = false
        _ = syncCoreDataAndDB() // Will always return false. (Lastly no fetch result )
        
        var url = ""
        
        if ( self.searchOutlet.titleLabel?.text == "Search" || self.searchOutlet.titleLabel?.text == "Day")
        {
            self.searchOutlet.setTitle("Week", for: .normal)
            self.dayweektext = "Week"
            url = "http://headspinnerd-com.stackstaging.com/bboying/phpGet2.php"
        } else {
            self.searchOutlet.setTitle("Day", for: .normal)
            self.dayweektext = "Day"
            url = "http://headspinnerd-com.stackstaging.com/bboying/phpGet3.php"
        }
        
        let postString = "username=\(MyVar.userName)&skillname=\(textbox.text!)"
        let mainDatas: [[String : Any]] = HttpRequestController().sendPostRequestSynchronous(urlString: url, post: postString)
        print("mainDatas=\(mainDatas)")
        if mainDatas.count > 0{
            for i in 0...mainDatas.count-1
            {
                guard let dayweek = mainDatas[i]["dayweek"] as? String else { continue }
                guard let total = mainDatas[i]["total"] as? String else { continue }
                guard let first_prop = mainDatas[i]["first_prop"] as? String else { continue }
                guard let second_prop = mainDatas[i]["second_prop"] as? String else { continue }
                guard let third_prop = mainDatas[i]["third_prop"] as? String else { continue }
                guard let fourth_prop = mainDatas[i]["fourth_prop"] as? String else { continue }
                guard let btnNum = mainDatas[i]["btnNum"] as? String else { continue } //FIXME: Could be null
                guard let comment = mainDatas[i]["comment"] as? String else {
                    self.TableData.append([dayweek,total,first_prop,second_prop,third_prop,fourth_prop,btnNum])
                    print("i=\(i) TableData=\(TableData) dayweek=\(dayweek) first_prop=\(first_prop)")
                    continue
                }
                // FIXME: Should btnNum be retrieved from CoreData?? Cuz waste of memory.
                self.TableData.append([dayweek,total,first_prop,second_prop,third_prop,fourth_prop,btnNum,comment])
            }
        } else {
            DispatchQueue.main.async(execute: {
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                if UIApplication.shared.isIgnoringInteractionEvents {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                self.showAlert(title: "Error", message: "No Data Found")
                print("No Data Found2")
                self.searchOutlet.setTitle("Search", for: .normal)
            })
        }
        print("TableData=\(TableData)")
        self.do_table_refresh()
    }
    
    enum SyncPattern {
        case didSynchedSuccessfully
        case isUpdateDBUpdateFailed
        case updateDBFailed
        case unKnownError
    }
    
    func syncCoreDataAndDB() -> SyncPattern {
        //Backup today's data to CoreData just in case
        //print("Backup today's data")
        /*CoreDataManager.deleteCoreData(date: today, object: skillList[MyVar.target.row].skillName)
        CoreDataManager.storeCountObj(date: today, object: DayActions(number: skillList[MyVar.target.row].number, skillname: skillList[MyVar.target.row].skillName, count: skillList[MyVar.target.row].actions, btnCount: skillList[MyVar.target.row].btnCount, comments: skillList[MyVar.target.row].comment))*/ //FIXME: Doesn't work!!
        //print("Backuped today's data")
        
        //Update buttons
        var hitIndex: Int?
        if skillList.count > 0 {
            for n in 0...(skillList.count-1) {
                if skillList[n].skillName == textbox.text! {
                    hitIndex = n
                }
            }
        }
        
        if let _hitIndex = hitIndex {
            let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/btnUpdate.php"
            var post: String = "username=\(MyVar.userName)&skillname=\(skillList[_hitIndex].skillName)&btnNum=\(skillList[_hitIndex].btnCount)"
            if skillList[_hitIndex].btnCount > 0 {
                for n in 0...(skillList[_hitIndex].btnCount-1) {
                    if let btns = skillList[_hitIndex].buttons {
                        if btns.count > n {
                            post = post + "&btnName\(n+1)=\(btns[n].0)&btnTextColor\(n+1)=\(btns[n].1.htmlRGBColor)&btnBkColor\(n+1)=\(btns[n].2.htmlRGBColor)"
                        }
                    }
                }
                print("btnUpdate.php post=\(post)")
                let parsedData: String? = HttpRequestController().sendPostRequestSynchronous2(urlString: urlString, post: post)
                print("parseData=\(String(describing: parsedData))")
                if let _parsedData = parsedData {
                    if updateResCheck(response: _parsedData) {
                    } else {
                        print("Update failed")
                    }
                } else {
                    print("Update failed nil error")
                }
            }
        }
        
        //update today's data
        MyVar.userName = UserDefaults.standard.object(forKey: "Username") as! String
        if updateDB(targetDate: today) {
            print("CoreDataManager.updateIsUpdateDBColumn")
            if CoreDataManager.updateIsUpdateDBColumn(date: today) {
                print("repeatUpdate")
                var repeatUpdateResult: RepeatUpdatePattern? = nil
                repeat {
                    repeatUpdateResult = repeatUpdate()
                    if repeatUpdateResult == .noFetchResult {
                        print("Failed repeatUpdate(Unavoidable process)")
                        if isUpdatePastData {
                            // Get back today's data to skillList class
                            skillList = []
                            fetchTodaysData(date: today)
                        }
                        return .didSynchedSuccessfully
                    }
                } while (repeatUpdateResult == .updateOfOneDaySuccess)
                
                return .unKnownError // Will return when received .updateDBFailed or .issUpdateDBUpdateFailed
            } else {
                print("Failed updating CoreData(updateIsUpdateDBColumn)")
                return .isUpdateDBUpdateFailed
            }
        } else {
            print("Failed updating today's data to DB")
            return .updateDBFailed
        }
    }
    
    func updateDB(targetDate: String) -> Bool {
        let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/allDayUpdate.php"
        let post: String = makePostString(targetDate: targetDate)
        let parsedData: String? = HttpRequestController().sendPostRequestSynchronous2(urlString: urlString, post: post)
        print("targetDate=today parseData=\(String(describing: parsedData))")
        if let _parsedData = parsedData {
            if updateResCheck(response: _parsedData) {
                return true
            } else {
                print("Update failed(targetDate=today)")
                return false
            }
        } else {
            print("Update failed nil error (targetDate=today)")
            return false
        }
    }
    
    enum RepeatUpdatePattern {
        case updateOfOneDaySuccess
        case issUpdateDBUpdateFailed
        case updateDBFailed
        case noFetchResult
    }
    
    
    func repeatUpdate() -> RepeatUpdatePattern {
        //fetchCountForDBObj
        if let fetchResult = CoreDataManager.fetchCountForDBObj() {
            print("Fetch today's data if existing")
            if fetchResult.1.count > 0 {
                skillList = []
                for fetchRes in fetchResult.1 {
                    if let colorObj = CoreDataManager.fetchColorObj(skillname: fetchRes.skillname) {
                        if let actions = fetchRes.count {
                            skillList.append(SkillList(number: fetchRes.number, actions: actions, btnCount: fetchRes.btnCount, skillName: fetchRes.skillname, validity: true, comment: fetchRes.comments, buttons: colorObj))
                        }
                    }
                }
                if updateDB(targetDate: fetchResult.0) {
                    print("CoreDataManager.updateIsUpdateDBColumn date=\(fetchResult.0)")
                    if CoreDataManager.updateIsUpdateDBColumn(date: fetchResult.0) {
                        print("updateOfOneDaySuccess date=\(fetchResult.0)")
                        isUpdatePastData = true
                        return .updateOfOneDaySuccess
                    } else {
                        print("Failed updating CoreData(updateIsUpdateDBColumn) date=\(fetchResult.0)")
                        return .issUpdateDBUpdateFailed
                    }
                } else {
                    print("updateDBFailed date=\(fetchResult.0)")
                    return .updateDBFailed
                }
            } else {
                print("No fetchResult targetDate=\(fetchResult.0)")
                return .noFetchResult
            }
        } else {
            print("fetchResult is nil(fetchCountForDBObj)")
            return .noFetchResult
        }
    }
    
    func makePostString(targetDate: String) -> String {
        var postString : String = ""
        if skillList.count > 0 {
            for n in 1...skillList.count {
                if skillList[n-1].skillName == "Sample Skill" {
                    continue
                }
                if n != 1 {
                    postString = postString + "&"
                } else {
                    postString = "targetDay=\(targetDate)&username=\(MyVar.userName)&count=\(skillList.count)&"
                }
                let l = n - 1
                postString = postString + "name\(n)=\(skillList[l].skillName)"
                if skillList[l].btnCount > 0 {
                    for p in 1...skillList[l].btnCount {
                        let q = p - 1
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
                    if comment.characters.count > 100 {
                        let indexStart = comment.index(comment.startIndex, offsetBy: 0)
                        let indexEnd = comment.index(comment.startIndex, offsetBy: 100)
                        let indexRange = indexStart..<indexEnd
                        comment = comment.substring(with: indexRange)
                    }
                    postString = postString + "&comment" + "\(n)" + "=\(comment)"
                }
            }
            print("targetDate=\(targetDate) postString=\(postString)")
        }
        return postString
    }
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            var dayweeks: [String] = []
            var props: [[Double]] = []
            if self.TableData.count > 1 {
                self.setAllFrames()
                self.combinedChartView.isHidden = false
                BannerManager.shared.setBanner(point: CGPoint(x: (device.viewWidth-320)/2, y: device.viewHeight - 99), viewController: self, centerMove: .nonMove, isRemove: true)
                self.tableView.reloadData()
                self.animateTable()
                guard let btnNum = Int(self.TableData[1][6]) else {
                    self.showAlert(title: "Error", message: "The data is not registered on database properly")
                    return
                }
                for i in 1...(self.TableData.count-1) {
                    dayweeks.append(self.TableData[i][0])
                }
                for j in 2...btnNum {  // TableData = [["2/12",12,80%,60%,40%,21%,5], ["2/13",12,80%,60%,40%,21%,5]]
                    var prop: [Double] = []
                    for i in 1...(self.TableData.count-1) {
                        let index1 = self.TableData[i][j].index(self.TableData[i][j].endIndex, offsetBy: -1)
                        var work = self.TableData[i][j].substring(to: index1)
                        if self.checkIfContainLetters(str: work ) {
                            work = "0"
                        }
                        prop.append(Double(work)!)
                    }
                    props.append(prop)
                }
                var total: [Double] = []
                for i in 1...(self.TableData.count-1) {
                    total.append(Double(self.TableData[i][1])!)
                }
                props.append(total)
                self.setChart(dataPoints: dayweeks, values: props)
            } else {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.showAlert(title: "Error", message: "No Data Found")
                print("No Data Found1")
                self.searchOutlet.setTitle("Search", for: .normal)
            }
            //values: [[8,3,2], [80%,50%,32%], [55%,42%,21%], [32%,21%,10%]]
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        })
    }
    
    func setChartFromCoreData(skillname: String) {
        if let fetchedData = CoreDataManager.fetchChartObj(skillname: textbox.text!) {
            DispatchQueue.main.async(execute: {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                // Set TableData for displaying excel-like chart
                if fetchedData.0.count > 0 && fetchedData.1.count > 0 {
                    self.btnNum = fetchedData.2
                    for n in 0...(fetchedData.0.count-1) {
                        var tableDataWork: [String] = []
                        tableDataWork.append(fetchedData.0[n])
                        let lastIndex = fetchedData.1.count - 1
                        tableDataWork.append("\(Int(fetchedData.1[lastIndex][n]))") //total count
                        if lastIndex > 0 {
                            for m in 0...(lastIndex-1) {
                                tableDataWork.append("\(Int(fetchedData.1[m][n]))%")
                            }
                        }
                        self.TableData.append(tableDataWork)
                    }
                    //self.tableView.isHidden = false
                    self.setAllFrames()
                    self.combinedChartView.isHidden = false
                    print("tableData=\(self.TableData)")
                    BannerManager.shared.setBanner(point: CGPoint(x: (device.viewWidth-320)/2, y: device.viewHeight - 99), viewController: self, centerMove: .nonMove, isRemove: true)
                    self.tableView.reloadData()
                    self.animateTable()
                    self.setChart(dataPoints: fetchedData.0, values: fetchedData.1)
                }
            })
        } else {
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.showAlert(title: "Error", message: "No Data Found")
            print("No Data Found2")
            self.searchOutlet.setTitle("Search", for: .normal)
        }
    }
    
    func setAllFrames() {
        if TableData.count > 1 {
            spaceOfItems = 0
            itemWidth = []
            let latestDataCount = TableData[TableData.count-1].count
            if let bNum = Int(TableData[TableData.count-1][latestDataCount-1]) {
                btnNum = bNum
            }
            itemWidth.append(Int(device.viewWidth * 0.12)) // dayweek
            itemWidth.append(Int(device.viewWidth * 0.133)) //total
            if btnNum >= 2 {
                for n in 0...(btnNum-2) {
                    let space = 10 * btnNum
                    var width = (Int(device.viewWidth)-itemWidth[0]-itemWidth[1]-20-space)/(btnNum - 1)
                    if n == btnNum-2 {
                        width -= 1
                    }
                    itemWidth.append(width)
                }
            }
            spaceOfItems = 10
        }
    }
    
    func animateTable() {
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
        
        shareBtn.frame = CGRect(x: device.spViewWidth/200, y: device.layoutGuideHeight, width: device.spViewHeight/16*1.5, height: device.spViewHeight/16)
        shareBtn.transform = CGAffineTransform(scaleX: 0, y: 1)
        shareBtn.isHidden = false
        textbox.removeFromSuperview()
        shareBtn.removeFromSuperview()
        searchOutlet.removeFromSuperview()
        tableView.headerView(forSection: 0)?.addSubview(textbox)
        tableView.headerView(forSection: 0)?.addSubview(shareBtn)
        tableView.headerView(forSection: 0)?.addSubview(searchOutlet)
        UIView.animate(withDuration: 0.5) {
            self.shareBtn.transform = .identity
            self.textbox.frame.size = CGSize(width: device.spViewWidth * 0.7 , height: device.spViewHeight/16)
            self.textbox.frame.origin = CGPoint(x: self.shareBtn.frame.maxX + device.spViewWidth * 0.02, y: device.layoutGuideHeight)
            self.searchOutlet.frame.origin = CGPoint(x: self.textbox.frame.maxX + device.spViewWidth * 0.01 ,y: device.layoutGuideHeight)
        }
        dropdown.frame.origin.y = textbox.frame.maxY
        
        
    }
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CheckVCHeaderCell.self, forHeaderFooterViewReuseIdentifier: "customHeader")
        // FIXME: Footer should be removed. It's just for letting the last item visible.
        tableView.register(CheckVCCell.self, forCellReuseIdentifier: "searchcell")
        tableView.register(CheckVCFooterCell.self, forHeaderFooterViewReuseIdentifier: "customFooter")
        tableView.frame = UIScreen.main.bounds //CGRect(x:0,y:0,width:view.frame.width, height:200)
        tableView.sectionHeaderHeight = device.viewHeight*0.4
        tableView.separatorStyle = .none
        view.backgroundColor = uiColor(115, 122, 189, 0.5) //necessary?
        
        backgroundImage.removeFromSuperview()
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.isUserInteractionEnabled = false
        if let imageData = CoreDataManager.fetchPhotoObj() {
            backgroundImage.image = UIImage(data: imageData as Data)
            tableView.backgroundView = backgroundImage
            //self.view.insertSubview(backgroundImage, at: 0)
        } else {
            backgroundImage.image = UIImage(named: "background_4.png")
            tableView.backgroundView = backgroundImage
            //self.view.insertSubview(backgroundImage, at: 0)
        }
        self.view.bringSubview(toFront: view)
        textbox.delegate = self
        dropdown.delegate = self
        
        combinedChartView.delegate = self
        combinedChartView.drawBarShadowEnabled = false
        
        shareBtn.backgroundColor = .blue
        shareBtn.setTitle("Share", for: .normal)
        shareBtn.setTitleColor(.white, for: .highlighted)
        shareBtn.layer.cornerRadius = device.spViewHeight/60
        shareBtn.addTarget(self, action: #selector(shareBtnAction), for: .touchUpInside)
        tableView.addSubview(shareBtn)
        shareBtn.isHidden = true
        shareBtn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
        searchOutlet.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        BannerManager.shared.setBanner(point: CGPoint(x: (device.viewWidth-320)/2, y: device.viewHeight - 99), viewController: self, centerMove: .fromLeft, isRemove: false)
        
        let timeGotten = getTimeWithSetting()
        today = timeGotten.settingDate
        
        combinedChartView.isHidden = true // -> for test
    
        //tableView.isHidden = true
        TableData = [["1/1","1","0%","0%","0%","0%","1"]]
        tableView.reloadData()
        shareBtn.isHidden = true
        
        textbox.frame.size = CGSize(width: device.spViewWidth * 0.7 , height: (device.spViewHeight-50)/16)
        textbox.center = CGPoint(x: UIScreen.main.bounds.maxX/2-10, y: (UIScreen.main.bounds.maxY-50)/2)
        //textbox.frame.origin = CGPoint(x: device.layoutGuideWidth-6, y: device.spViewHeight*0.4)
        textbox.backgroundColor = uiColor(255, 255, 255, 0.9)
        textbox.layer.cornerRadius = 5
        textbox.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        textbox.textAlignment = .center
        textbox.placeholder = "Click here"
        
        searchOutlet.frame.size = CGSize(width: device.spViewHeight/16*1.5, height: device.spViewHeight/16)
        searchOutlet.frame.origin = CGPoint(x: textbox.frame.maxX + device.spViewWidth * 0.02 , y: textbox.frame.origin.y)
        searchOutlet.backgroundColor = .blue
        searchOutlet.titleLabel?.textColor = .white
        searchOutlet.addTarget(self, action: #selector(searchButton), for: .touchUpInside)
        searchOutlet.layer.cornerRadius = 5
        searchOutlet.layer.masksToBounds = true
        searchOutlet.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
        if textbox.text == "" {
            searchOutlet.setTitle("", for: .normal)
            searchOutlet.isEnabled = false
        } else if textbox.text == "Upload to web database" {
            searchOutlet.setTitle("Upload", for: .normal)
        } else if textbox.text != "No Data Found" {
            searchOutlet.setTitle("Search", for: .normal)
        }
        
        dropdown.backgroundColor = uiColor(255, 255, 255, 0.7)
        dropdown.frame.size = CGSize( width: textbox.frame.size.width, height: device.viewHeight*0.1)
        dropdown.layer.cornerRadius = 5
        dropdown.isHidden = true
        dropdown.center = textbox.center
        print("values=\(values)")
        
        tableView.addSubview(textbox)
        tableView.addSubview(searchOutlet)
        tableView.addSubview(dropdown)
        
        values = []
        buttons = []
        /*if isInternetAvailable() && MyVar.serverConnect { //-> This results in the shortage of buttons
            //get the values from sql/Json
            let url = NSURL(string: "http://headspinnerd-com.stackstaging.com/bboying/phpGet.php")
            
            let data = NSData(contentsOf: url! as URL)
            let tmpValues = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            //tmpValues = tmpValues.reversed() as NSArray
            reloadInputViews()
            
            for candidate in tmpValues {
                if let cdict = candidate as? NSDictionary {
                    let skillname = cdict["skillname"] as? String
                    if let _skillname = skillname {
                        if let btns = CoreDataManager.fetchColorObj(skillname: _skillname) {
                            self.values.append(skillname as AnyObject)
                            if buttons != nil {
                                buttons?.append(btns)
                            } else {
                                buttons = [btns]
                            }
                        }
                    }
                }
            }
            if values.count == 0 {
                if let fetchResult = CoreDataManager.fetchCountForDBObj() {
                    if fetchResult.1.count > 0 {
                        if fetchResult.1.count == 1 && fetchResult.1[0].skillname == "Sample Skill" {
                            values = ["No Data Found" as AnyObject]
                        } else {
                            print("fetchResult.1.count=\(fetchResult.1.count) fetchResult.1[0].skillname=\(fetchResult.1[0].skillname)")
                            values = ["Upload to web database" as AnyObject]
                        }
                    }
                } else {
                    if !fetchSkillNameList() {
                        values = ["No Data Found" as AnyObject]
                    }
                }
            }
        } else {*/
            _ = fetchSkillNameList()
        //}
    

    }
    
    func fetchSkillNameList() -> Bool {
        var isFound = false
        if let fetchLists = CoreDataManager.fetchObj() {
            if fetchLists.count > 0 {
                for fetchList in fetchLists {
                    print("fetchList=\(fetchList.skillname)")
                    values.append(fetchList.skillname as AnyObject)
                    if let btns = fetchList.buttons {
                        if buttons != nil {
                            buttons?.append(btns)
                        } else {
                            buttons = [btns]
                        }
                    }
                    isFound = true
                }
            }
        }
        print("buttons=\(String(describing: buttons))")
        return isFound
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert2(service: String) {
        
        let alertController = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkIfContainLetters(str: String) -> Bool {
        let letters = CharacterSet.letters
        var isContainLetters = false
        for uni in str.unicodeScalars {
            if letters.contains(uni) {
                isContainLetters = true
            }
        }
        return isContainLetters
    }
    
    func setChart(dataPoints: [String], values: [[Double]]) {
        let format: BarChartFormatter = BarChartFormatter(dayweeks: dataPoints)
        let xaxis: XAxis = XAxis()
        
        combinedChartView.noDataText = "You need to provide data for the chart."
        combinedChartView.chartDescription!.text = ""
        combinedChartView.legend.font = UIFont(name: "AvenirNext-DemiBold", size: 8)!
        combinedChartView.legend.textColor = .white
        combinedChartView.legend.enabled = true
        
        var dataEntries1: [[ChartDataEntry]] = []
        var dataEntries2: [BarChartDataEntry] = []

        for j in 0...(values.count-1) {
            var dataEntry1: [ChartDataEntry] = []
            var dataEntry2 = BarChartDataEntry()
            for i in 0...(dataPoints.count-1) {
                if j != values.count-1 {
                    dataEntry1.append(ChartDataEntry(x: Double(i), y: values[j][i], data: format.stringForValue(Double(i), axis: xaxis) as AnyObject?))
                } else {
                    dataEntry2 = BarChartDataEntry(x: Double(i), y: values[j][i], data: format.stringForValue(Double(i), axis: xaxis) as AnyObject?)
                    dataEntries2.append(dataEntry2)
                }
            }
            dataEntries1.append(dataEntry1)
            
        }
        xaxis.valueFormatter = format
        var colorSet: [UIColor] = []
        switch values.count {
        case 1: colorSet =  [uiColor(100, 50, 255, 1.0)]
        case 2: colorSet =  [uiColor(0, 0, 55, 1.0), uiColor(62, 66, 236, 0.7)]
        case 3: colorSet = [uiColor(255, 255, 255, 1.0), uiColor(180, 255, 255, 0.7), uiColor(180, 120, 255, 0.7)]
        default: colorSet = [uiColor(255, 255, 255, 1.0), uiColor(120, 100, 255, 0.7), uiColor(120, 50, 255, 0.7), uiColor(50, 0, 255, 0.7)]
        }
        var lineDataSet: [LineChartDataSet] = []
        var barDataSet = BarChartDataSet()
        
        var chartDataSet: [IChartDataSet] = []
        for j in 0...(values.count-1) {
            if j != values.count-1 {
                var getColor: UIColor = colorSet[j]
                var chartLabel = ""
                if let btns = buttons {
                    if btns.count > targetRow {
                        if btns[targetRow].count > j {
                            getColor = btns[targetRow][j].2
                            chartLabel = "\(btns[targetRow][j].0)+ Ratio"
                            if j == 0 {
                                chartLabel = "\(btns[targetRow][j].0) Ratio"
                            }
                        }
                    }
                } else {
                    switch j {
                    case 0: chartLabel = "1st Ratio"
                    case 1: chartLabel = "2nd Ratio"
                    case 2: chartLabel = "3rd Ratio"
                    case 3: chartLabel = "4th Ratio"
                    default: break
                    }
                }

                lineDataSet.append(LineChartDataSet(values: dataEntries1[j], label: chartLabel))
                lineDataSet[j].colors = [getColor]
                lineDataSet[j].circleColors = [getColor]
                lineDataSet[j].circleHoleColor = getColor
                lineDataSet[j].valueFont = UIFont(name: "AvenirNext-DemiBold", size: 8)!
                lineDataSet[j].lineWidth = 0.5
                lineDataSet[j].circleRadius = 3
                lineDataSet[j].formLineWidth = 1.0
                chartDataSet.append(lineDataSet[j])
            } else {
                barDataSet = BarChartDataSet(values: dataEntries2, label: "total")
                barDataSet.colors = [uiColor(50, 50, 200, 0.7)]
                barDataSet.valueFont = UIFont(name: "AvenirNext-DemiBold", size: 8)!
                chartDataSet.append(barDataSet)
            }
        }
        
        let lineData = LineChartData(dataSets: lineDataSet)
        let barData = BarChartData(dataSet: barDataSet)
        let lFormatter = NumberFormatter()
        lFormatter.numberStyle = .percent
        lFormatter.maximumFractionDigits = 0
        lFormatter.multiplier = 1.0
        lFormatter.percentSymbol = "%"
        lineData.setValueFormatter(DefaultValueFormatter(formatter : lFormatter ))
        
        let bFormatter = NumberFormatter()
        bFormatter.numberStyle = .none
        bFormatter.maximumFractionDigits = 0
        bFormatter.multiplier = 1.0
        barData.setValueFormatter(DefaultValueFormatter(formatter : bFormatter  ))
        
        let chartData = CombinedChartData(dataSets: chartDataSet)
        chartData.barData = barData
        barData.setValueTextColor(NSUIColor(cgColor: uiColor(200, 200, 255, 1.0).cgColor))
        chartData.lineData = lineData
        lineData.setValueTextColor(NSUIColor(cgColor: uiColor(240, 150, 150, 1.0).cgColor))
            
        combinedChartView.data = chartData
        combinedChartView.xAxis.valueFormatter = xaxis.valueFormatter
        combinedChartView.xAxis.labelPosition = .top
        combinedChartView.xAxis.labelTextColor = .white
        combinedChartView.xAxis.labelFont = UIFont(name: "AvenirNext-DemiBold", size: 10)!
        
        //combinedChartView.data?.setValueTextColor(.yellow)
        
        combinedChartView.backgroundColor = uiColor(115, 122, 189, 0.5)
        combinedChartView.leftAxis.axisMaximum = 100.0
        combinedChartView.rightAxis.axisMaximum = 100.0
        combinedChartView.rightAxis.labelTextColor = .white
        combinedChartView.rightAxis.labelFont = UIFont(name: "AvenirNext-DemiBold", size: 10)!
        combinedChartView.leftAxis.labelTextColor = .white
        combinedChartView.leftAxis.labelFont = UIFont(name: "AvenirNext-DemiBold", size: 10)!
        combinedChartView.leftAxis.axisMinimum = 0.0
        combinedChartView.rightAxis.axisMinimum = 0.0
        combinedChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInCirc)
    }
    
    
    
    func animate(xAxisDuration: TimeInterval, yAxisDuration: TimeInterval) {
    }
    
    func shareBtnAction() {
        if self.textbox.text != "" && self.searchOutlet.titleLabel?.text != "Search" {
            
            let alert = UIAlertController(title: "Share", message: "Share the chart", preferredStyle: .actionSheet)
            
            let actionOne = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
                
                //Checking if the user is connected to Facebook
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                    let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                    self.socialSharing(post: post)
                } else {
                    self.showAlert2(service: "Facebook")
                }
            }
            
            let actionTwo = UIAlertAction(title: "Share on Twitter", style: .default) { (action) in
                
                //Checking if the user is connected to Facebook
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                    let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                    self.socialSharing(post: post)
                } else {
                    self.showAlert2(service: "Facebook")
                }
            }
            
            let actionThree = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(actionOne)
            alert.addAction(actionTwo)
            alert.addAction(actionThree)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func socialSharing(post: SLComposeViewController) {
        let fixFrame = CGRect(x: self.combinedChartView.frame.minX, y: self.combinedChartView.frame.minY + 58, width: self.combinedChartView.frame.width, height: self.combinedChartView.frame.height)
        if let snapshot = view.snapshot(of: fixFrame) {
            
            switch (self.searchOutlet.titleLabel?.text)! {
            case "Week":
                post.setInitialText("My weekly \(self.textbox.text!) Result")
            case "Day":
                post.setInitialText("My daily \(self.textbox.text!) Result")
            default:
                break
            }
            post.add(snapshot)
            self.present(post, animated: true, completion: nil)
        }
    }
    
    //Pending function
    /*override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    func canRotate() -> Void {}*/
}
