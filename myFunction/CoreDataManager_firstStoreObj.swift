//
//  CoreDataManager.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-05.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func firstStoreObj() {
        let testSkillList = ["Headspin_Total","Onehand_Tap","Open_Glide","Fast_Glide","Ball_Glide","Peace_Glide","Rubiks_Cube","Long_Drill","Zen","AcKeep","AcToHllwbkToAc","AcToJdToAc","HandStand","Achop","Only_Onehand_Tap","Chest_Press","Diverging_Low_Row","Hllwbk_Stretch","Lat_Pulldown","Leg_Extension","Leg_Press","Seated_Calf_Extension ","Triceps_Extension","Radar_Stretch","Airchair Stretch"]
        
        for testNumber in 0...(testSkillList.count-1) {
            if testNumber >= 15 && testNumber <= 24{
                storeObj(object: DayActions(number: testNumber, skillname: testSkillList[testNumber], btnCount: 1))
                storeColors(skillname: testSkillList[testNumber], buttons: [("Count", uiColor(255, 255, 255, 1.0), uiColor(255, 0, 0, 1.0))])
            } else {
                storeObj(object: DayActions(number: testNumber, skillname: testSkillList[testNumber], btnCount: 3))
                storeColors(skillname: testSkillList[testNumber], buttons: [("Great", uiColor(255, 255, 255, 1.0), uiColor(255, 0, 0, 1.0)),("OK", uiColor(0, 0, 0, 1.0), uiColor(200, 128, 0, 1.0)), ("Bad", .white, uiColor(255, 0, 255, 1.0))])
            }
        }
    }
    
    class func dateAddToObj(fetchLists: [DayActions], date: String) { // You need this for each time the app is run FIXME: need to pull all the skills user set
        
        for fetchList in fetchLists {
            dateAddToObjDetail(date: date, object: fetchList)
        }
    }
    
    class func dateAddToObjDetail(date: String, object: DayActions) {
        let context = getContext()
        
        let entitySkill = NSEntityDescription.entity(forEntityName: "Skills", in: context)
        
        let managedSkillObj = NSManagedObject(entity: entitySkill!, insertInto: context) as! Skills // Added as! Skills
        
        managedSkillObj.setValue(date, forKey: "date")
        managedSkillObj.setValue(object.btnCount, forKey: "btnCount")
        managedSkillObj.setValue(object.number, forKey: "number")
        managedSkillObj.setValue(object.skillname, forKey: "skillname")
        
        do {
            try context.save()
            print("dateAddToObjDetail SAVED")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Store only skillname
    class func storeObj(object: DayActions) {
        let context = getContext()
        
        let entitySkill = NSEntityDescription.entity(forEntityName: "Skills", in: context)
        
        let managedSkillObj = NSManagedObject(entity: entitySkill!, insertInto: context) as! Skills // Added as! Skills
        
        managedSkillObj.setValue(object.number, forKey: "number")
        managedSkillObj.setValue(object.skillname, forKey: "skillname")
        managedSkillObj.setValue(object.btnCount, forKey: "btnCount")
        managedSkillObj.setValue(nil, forKey: "date")
        
        do {
            try context.save()
            print("storeObj SAVED")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Store skillname and colors
    class func storeColors(skillname: String, buttons: [(String, UIColor, UIColor)]) {
        let context = getContext()
        
        let entityColors = NSEntityDescription.entity(forEntityName: "Colors", in: context)
        
        var n = 1
        for button in buttons {
            let managedColorsObj = NSManagedObject(entity: entityColors!, insertInto: context) as! Colors
            
            managedColorsObj.setValue(n, forKey: "number")
            managedColorsObj.setValue(button.0, forKey: "name")
            managedColorsObj.setValue(button.1, forKey: "txtColor")
            managedColorsObj.setValue(button.2, forKey: "bkColor")
            
            let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "date == nil AND skillname == %@", skillname)
            let fetchData = try! context.fetch(fetchRequest)
            if(!fetchData.isEmpty){
                managedColorsObj.skillname = fetchData[0]
            }
            
            do {
                try context.save()
                print("storeColors SAVED")
            } catch {
                print(error.localizedDescription)
            }
            n += 1
        }
    }
    
    // Store comment on its skillname
    class func storeCommentObj(date: String, object: DayActions, number: Int) {
        let context = getContext()
        
        let entityComment = NSEntityDescription.entity(forEntityName: "Comments", in: context)
        let managedCommentObj = NSManagedObject(entity: entityComment!, insertInto: context) as! Comments
        
        managedCommentObj.setValue(number, forKey: "number")
        managedCommentObj.setValue(object.comments?[0], forKey: "comment")
        
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"%K == %@ AND %K == %@",argumentArray:["date", date, "skillname", object.skillname])
        let fetchData = try! context.fetch(fetchRequest)
        if(!fetchData.isEmpty){
            managedCommentObj.date_skillname = fetchData[0]
        }
        
        do {
            try context.save()
            print("storeCommentObj SAVED")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Store skillname and its counts
    class func storeCountObj(date: String, object: DayActions) {
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Skills", in: context)
        
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObj.setValue(date, forKey: "date")
        managedObj.setValue(object.skillname, forKey: "skillname")
        managedObj.setValue(object.btnCount, forKey: "btnCount")
        managedObj.setValue(false, forKey: "isUpdateDB")
        if let counts = object.count {
            var c = 0
            for count in counts {  // counts = [2,4,3]
                var forkey = ""
                switch c {
                    case 0: forkey = "first_count"
                    case 1: forkey = "second_count"
                    case 2: forkey = "third_count"
                    case 3: forkey = "fourth_count"
                    case 4: forkey = "fifth_count"
                    default: break
                }
                managedObj.setValue(count, forKey: forkey)
                c += 1
            }
        }
        managedObj.setValue(object.number, forKey: "number")
        
        do {
            try context.save()
            print("storeCountObj SAVED")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Update isUpdateDB column after updating DB
    class func updateIsUpdateDBColumn(date: String) -> Bool {
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        let predicate = NSPredicate(format:"%K == %@","date", date as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if(!fetchResult.isEmpty){
                for item in fetchResult {
                    print("before item.isUpdateDB=\(item.isUpdateDB) date=\(date)")
                    if item.isUpdateDB != true {
                        item.setValue(true, forKey: "isUpdateDB")
                    }
                    print("after item.isUpdateDB=\(item.isUpdateDB) date=\(date)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return true
    }
    
    // Fetch only skillname without date
    class func fetchObj() -> [DayActions]?{
        var aray = [DayActions]()
        
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        let predicate = NSPredicate(format: "date == nil")
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if let newskill = item.skillname {
                    let buttons = fetchColorObj(skillname: newskill)
                    aray.append(DayActions(number: Int(item.number), skillname: newskill, btnCount: Int(item.btnCount), buttons: buttons))
                } else {
                    print("fetched nil")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    // Fetch color
    class func fetchColorObj(skillname: String) -> [(String, UIColor, UIColor)]?{
        var aray = [(String, UIColor, UIColor)]()
        var workArays = [(Int, String, UIColor, UIColor)]()
        
        let fetchRequest:NSFetchRequest<Colors> = Colors.fetchRequest()
        let predicate = NSPredicate(format: "skillname.skillname == %@", skillname)
         fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                workArays.append((Int(item.number), item.name!, item.txtColor as! UIColor, item.bkColor as! UIColor))
            }
        } catch {
            print(error.localizedDescription)
        }
        workArays.sort { (lhs, rhs) in return lhs.0 < rhs.0 } // FIXME: Is there more effective way sort the number?
        for workAray in workArays {
            aray.append((workAray.1, workAray.2, workAray.3))
        }
        return aray
    }
    
    // Fetch today's skillname and its counts
    class func fetchCountObj(date: String) -> [DayActions]?{
        var aray: [DayActions]? = []
        
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        let predicate = NSPredicate(format:"%K == %@","date", date as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if(!fetchResult.isEmpty){
                for item in fetchResult {
                    if let newskill = item.skillname {
                        let comments = fetchCommentObj2(date: date, skillname: newskill)
                        var counts: [Int] = []
                        let countItems = [item.first_count, item.second_count, item.third_count, item.fourth_count, item.fifth_count]
                        for countItem in countItems {
                            counts.append(Int(countItem))
                        }
                        let buttons = fetchColorObj(skillname: newskill)
                        aray?.append(DayActions(number: Int(item.number), skillname: newskill, count: counts, btnCount: Int(item.btnCount), comments: comments, buttons: buttons))
                    } else {
                        print("fetched nil")
                    }
                }
            } else {
                aray = nil
            }
        } catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    // Fetch today's skillname and its comment with specific index
    class func fetchCommentObj(date: String, skillname: String, index: Int) -> String {
        var aray = [String]()
        
        let fetchRequest:NSFetchRequest<Comments> = Comments.fetchRequest()
        let predicate = NSPredicate(format:"date_skillname.date == %@ AND date_skillname.skillname == %@", date, skillname)
        fetchRequest.predicate = predicate
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if let newcomment = item.comment {
                    aray.append(newcomment)
                } else {
                    print("fetched nil")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return aray[index]
    }
    
    // Fetch today's skillname and its comment
    class func fetchCommentObj2(date: String, skillname: String) -> [String] {
        var aray = [String]()
        
        let fetchRequest:NSFetchRequest<Comments> = Comments.fetchRequest()
        let predicate = NSPredicate(format:"date_skillname.date == %@ AND date_skillname.skillname == %@", date, skillname)
        fetchRequest.predicate = predicate
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            for item in fetchResult {
                if let newcomment = item.comment {
                    aray.append(newcomment)
                } else {
                    print("fetched nil")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    // Fetch necessary data for showing chart
    class func fetchChartObj(skillname: String) -> ([String], [[Double]], Int)? {
        var dayweeks: [String] = []
        var props: [[Double]] = []
        var total: [Double] = []
        var btnCount: Int = 0
        var firstProp: [Double] = []
        var secondProp: [Double] = []
        var thirdProp: [Double] = []
        var fourthProp: [Double] = []
        var n = 0
        
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        // FIXME: Should fetch specific date or last XX months
        let predicate = NSPredicate(format:"date <> nil AND skillname == %@", skillname)
        fetchRequest.predicate = predicate
        /*NSPredicate *predicate = [NSPredicate predicateWithFormat:
        @"(date >= %@) AND (date <= %@)", startDate, endDate];*/
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if(!fetchResult.isEmpty){
                for item in fetchResult {
                    print("fetchedData->\(item)")
                    if item.first_count + item.second_count + item.third_count + item.fourth_count + item.fifth_count == 0 {
                        continue
                    }
                    btnCount = Int(item.btnCount)
                    switch btnCount {
                        case 1: total.append(Double(item.first_count))
                        case 2: total.append(Double(item.first_count) + Double(item.second_count))
                        firstProp.append((Double(item.first_count) / total[n] * 100).rounded())
                        case 3: total.append(Double(item.first_count) + Double(item.second_count) + Double(item.third_count))
                        firstProp.append((Double(item.first_count) / total[n] * 100).rounded())
                        secondProp.append(((Double(item.first_count) + Double(item.second_count)) / total[n] * 100).rounded())
                        case 4: total.append(Double(item.first_count) + Double(item.second_count) + Double(item.third_count) + Double(item.fourth_count))
                        firstProp.append((Double(item.first_count) / total[n] * 100).rounded())
                        secondProp.append(((Double(item.first_count) + Double(item.second_count)) / total[n] * 100).rounded())
                        thirdProp.append(((Double(item.first_count) + Double(item.second_count) + Double(item.third_count)) / total[n] * 100).rounded())
                        case 5: total.append(Double(item.first_count) + Double(item.second_count) + Double(item.third_count) + Double(item.fourth_count) + Double(item.fifth_count))
                        firstProp.append((Double(item.first_count) / total[n] * 100).rounded())
                        secondProp.append(((Double(item.first_count) + Double(item.second_count)) / total[n] * 100).rounded())
                        thirdProp.append(((Double(item.first_count) + Double(item.second_count) + Double(item.third_count)) / total[n] * 100).rounded())
                        fourthProp.append(((Double(item.first_count) + Double(item.second_count) + Double(item.third_count) + Double(item.fourth_count)) / total[n] * 100).rounded())
                        default: break
                    }
                    print("btnCount=\(btnCount)")
                    print("total\(n)=\(total)")
                    print("firstProp\(n)=\(firstProp)")
                    print("secondProp\(n)=\(secondProp)")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMdd"
                    if let date = item.date {
                        if let stringToDate = formatter.date(from: date) {
                            formatter.dateFormat = "M/d"
                            let dateToString = formatter.string(from: stringToDate)
                            dayweeks.append(dateToString)
                        }
                    }
                    n += 1
                }
            } else {
                
            }
        } catch {
            print(error.localizedDescription)
        }
        if firstProp.count > 0 {
            switch btnCount {
                case 1: props = [total]
                case 2: props = [firstProp, total]
                case 3: props = [firstProp, secondProp, total]
                case 4: props = [firstProp, secondProp, thirdProp, total]
                case 5: props = [firstProp, secondProp, thirdProp, fourthProp, total]
            default: break
            }
            return (dayweeks, props, btnCount)
        } else {
            return nil
        }
    }
    
    // Fetch skillname and its counts for updating DB
    class func fetchCountForDBObj() -> (String, [DayActions])? {
        var aray: (String, [DayActions])?
        
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        let predicate = NSPredicate(format:"isUpdateDB == %@ AND date <> nil", false as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if(!fetchResult.isEmpty){
                for item in fetchResult {
                    if let itemDate = item.date {
                        if let fetchCount = fetchCountObj(date: itemDate) {
                            aray = (itemDate, fetchCount)
                        }
                        
                    } else {
                        print("fetched nil")
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return aray
    }
    
    // Check Coredata that has 1+ count(befor updating the number of buttons)
    class func fetchIfCountedObj(skillname: String) -> Bool? {
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        let predicate = NSPredicate(format: "skillname == %@ AND ( first_count > 0 OR second_count > 0 OR third_count > 0 OR fourth_count > 0 OR fifth_count > 0) ", skillname)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if(!fetchResult.isEmpty){
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // Refresh today's data
    class func refreshObj(date: String) {
        for i in 0...(skillList.count-1) {
            deleteCoreData(date: date, object: skillList[i].skillName)
            dateAddToObjDetail(date: date, object: DayActions(number: skillList[i].number, skillname: skillList[i].skillName, btnCount: skillList[i].btnCount))
        }
    }
    
    // Delete today's data that matches specific skillname
    class func deleteCoreData(date: String, object: String) {
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        
        let predicate = NSPredicate(format: "date = %@ AND skillname = %@", argumentArray:[date, object])
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try getContext().execute(deleteRequest)
            print("deleted today's data that matches specific skillname")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Delete the data that matches specific skillname and date
    class func deleteSkillCoreData(object: String, date: String? = nil) {
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        
        var predicate = NSPredicate()
        if date == nil {
            predicate = NSPredicate(format: "date = nil AND skillname = %@", argumentArray:[object])
            print("delete without date")
        } else {
            predicate = NSPredicate(format: "date = %@ AND skillname = %@", argumentArray:[date!, object])
            print("delete with date")
        }
        
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        print("deleteRequest=\(deleteRequest)")
        do {
            try getContext().execute(deleteRequest)
            print("deleted the data that matches specific skillname and nil date")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Delete the color data that matches specific skillname
    class func deleteColorCoreData(skillname: String? = nil) {
        let fetchRequest:NSFetchRequest<Colors> = Colors.fetchRequest()
        
        var predicate = NSPredicate()
        if skillname == nil {
            predicate = NSPredicate(format: "skillname = nil")
        } else {
            predicate = NSPredicate(format: "skillname = %@", skillname!)
        }
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try getContext().execute(deleteRequest)
            print("Delete the color data that matches specific skillname")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Clear Skills Data
    class func clearAllSkillCoreData() {
        let fetchRequest:NSFetchRequest<Skills> = Skills.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all skill data")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Clear Comments Data
    class func clearAllCommentCoreData() {
        let fetchRequest:NSFetchRequest<Comments> = Comments.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all comment data")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Clear Color Data
    class func clearAllColorCoreData() {
        let fetchRequest:NSFetchRequest<Colors> = Colors.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all color data")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // Clear today's Comments Data
    class func clearCommentCoreData(date: String) {
        let fetchRequest:NSFetchRequest<Comments> = Comments.fetchRequest()
        
        let predicate = NSPredicate(format: "date_skillname.date = %@", date)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        print("deleteRequest=\(deleteRequest)")
        
        do {
            print("deleting today's comment data")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Store photo data
    class func storePhotoObj(image: NSData) {
        let context = getContext()
        
        let entityPhoto = NSEntityDescription.entity(forEntityName: "Photos", in: context)
        
        let managedPhotoObj = NSManagedObject(entity: entityPhoto!, insertInto: context) as! Photos
        
        managedPhotoObj.setValue(image, forKey: "photo")
        
        do {
            try context.save()
            print("photo data SAVED")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Fetch photo data
    class func fetchPhotoObj() -> NSData? {
       
        var result: NSData?
        
        let fetchRequest:NSFetchRequest<Photos> = Photos.fetchRequest()

        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            if(!fetchResult.isEmpty){
                for item in fetchResult {
                    result = item.photo
                }
            }
        
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    // Clear photo Data
    class func clearAllPhotoCoreData() {
        let fetchRequest:NSFetchRequest<Photos> = Photos.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("deleting all photo data")
            try getContext().execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}


class DayActions {
    var number: Int
    var skillname: String
    var count: [Int]?
    var btnCount: Int
    var comments: [String]?
    var buttons: [(String, UIColor, UIColor)]?
    
    init(number: Int, skillname: String, count: [Int]? = [0], btnCount: Int, comments: [String]? = [""], buttons: [(String, UIColor, UIColor)]? = nil) {
        self.number = number
        self.skillname = skillname
        self.count = count
        self.btnCount = btnCount
        self.comments = comments
        self.buttons = buttons
    }
}

