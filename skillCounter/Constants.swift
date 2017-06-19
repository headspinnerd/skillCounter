//
//  SkillList.swift
//  skillCounter
//
//  Created by 田中江樹 on 2016-11-07.
//  Copyright © 2016 Koki. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import SystemConfiguration

enum SkillName: String {
    case Headspin_Total
    case Open_Glide     // Airchair to Jordan to Airchair Hop
    case Ball_Glide     // Ball Glide
    case Onehand_Tap        // One hand tap
    case Peace_Glide      // Glide to Peace
    case Rubiks_Cube        // Rubiks Cube
    case Fast_Glide          // Fast Glide
    case Long_Drill              // Glide to Long Drill
    case AcToHllwbkToAc  // Airchair to Hollow Back to Airchair
    case AcToJdToAc     // Airchair to Jordan to Airchair
    case AcKeep       // Airchair Keep
    case Achop        // Airchair Hop
    case Gld_Wnmd_Gld    // Glide to Windmill to Glide
    case HandStand    // Hand stand keep
}

class SkillList {
    var number: Int
    var skillName: String
    var actions: [Int]
    var btnCount: Int
    var total: Int {
        var ttl: Int = 0
        for action in actions {
            ttl += action
        }
        return ttl
    }
    var validity: Bool
    var comment: [String]?
    var buttons: [(String, UIColor, UIColor)]? //(button name, text color, background color)
    
    init(number: Int, actions: [Int], btnCount: Int, skillName: String, validity: Bool, comment: [String]? = nil, buttons: [(String, UIColor, UIColor)]? = nil) {
        self.number = number
        self.actions = actions
        self.btnCount = btnCount
        self.skillName = skillName
        self.validity = validity
        self.comment = comment
        self.buttons = buttons
    }
}

extension SkillList {
    func addCounter(target: Int, modeFlg: Bool, value: Int) {
        if modeFlg {
            actions[target] += value
        } else {
            actions[target] -= value
            if actions[target] < 0 {
                actions[target] = 0
            }
        }
    }
}

var skillList = [SkillList]()
var rowHeight = 60
var colors: [(red: CGFloat, green: CGFloat, blue: CGFloat)] = []

struct MyVar {
    static var target: IndexPath = []
    static var keyboardTopEdge: CGFloat = 0
    static var userName: String = ""
    static var countBtns: [(String, UIColor)] = []
    static var previousVC = ""
    static var isDisplayAnimation = true
    static var isDisplayTotal = true
    static var player = MPMusicPlayerController()
    static var displayComment = ""
    static var serverConnect = false
}

class MyTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: 10, dy: 0) // Indent
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).insetBy(dx: 10, dy: 0) // Indent
    }
}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width:1, height: 1)){
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}

struct userInfo {
    static var username: String = MyVar.userName
    static var email: String = ""
    static var name: String = ""
}

var isStatusBarUsed = true

struct Device {
    let viewWidth: CGFloat
    let viewHeight: CGFloat
    var layoutGuideWidth: CGFloat{
        if viewWidth > 376 {
            return 20.0
        } else {
            return 16.0
        }
    }
    var spViewWidth: CGFloat {
        let spWidth = viewWidth - (layoutGuideWidth * 2)
        return spWidth
    }
    var layoutGuideHeight: CGFloat {
        if isStatusBarUsed {
            return UIApplication.shared.statusBarFrame.height
        } else {
            return 0.0
        }
    }
    var spViewHeight: CGFloat {
        let spHeight = viewHeight - (layoutGuideHeight * 2)
        return spHeight
    }
    func getFontSize(numOfLetters: Int) -> CGFloat {
        return (spViewWidth/CGFloat(numOfLetters)).rounded(.down)
    }
}

var iPad12 = Device(viewWidth: 1024.0, viewHeight: 1366.0)
var iPad9 = Device(viewWidth: 768.0, viewHeight: 1024.0)
var iPhone7Plus = Device(viewWidth: 414.0, viewHeight: 736.0)
var iPhone6_7 = Device(viewWidth: 375.0, viewHeight: 667.0)
var iPhoneSE = Device(viewWidth: 320.0, viewHeight: 568.0)
var iPhone4 = Device(viewWidth: 320.0, viewHeight: 480.0)
var devices: [Device] = [iPad12, iPad9, iPhone7Plus, iPhone6_7, iPhoneSE, iPhone4]
var device = Device(viewWidth: 0, viewHeight: 0)

func deviceRecognition(width: CGFloat, height: CGFloat) -> Device {
    var hitDevice: Device? = nil
    for device in devices {
        if width == device.viewWidth && height == device.viewHeight {
            hitDevice = device
        }
    }
    
    return hitDevice!
}

var uiColor = {(a:Int, b:Int, c:Int, d:CGFloat) -> UIColor in return UIColor(red: CGFloat(a)/255.0, green: CGFloat(b)/255.0, blue: CGFloat(c)/255.0, alpha: d) }

func fetchTodaysData(date: String) {
    //Fetch today's data if existing
    if let savedSkills = CoreDataManager.fetchCountObj(date: date, noCountsException: false) {
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
            print("fetchLists=\(fetchLists)")
            CoreDataManager.dateAddToObj(fetchLists: fetchLists, date: date)
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
        skillList.sort { (lhs, rhs) in return lhs.number < rhs.number }
    }
}


func randGenerate(maxnum: Int) -> Int{
    let randomNum:UInt32 = arc4random_uniform(UInt32(maxnum))
    let someInt:Int = Int(randomNum) + 1
    return someInt
}

func updateResCheck<T>(response: T) -> Bool {  // Must pass not optional type
    let string = "\(response)"
    if string.characters.count > 12 {
        let indexStart = string.index(string.startIndex, offsetBy: 0)
        let indexEnd = string.index(string.startIndex, offsetBy: 12)
        let indexRange = indexStart..<indexEnd
        print("string.substring=\(string.substring(with: indexRange))")
        if string.substring(with: indexRange) == "Successfully" {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

func updateResVariousCheck<T>(response: T, checkString: [String]) -> Int? { // Must pass not optional type
    let string = "\(response)"
    var checkNum = 0
    for checkStr in checkString{
        if string.characters.count > checkStr.characters.count {
            let indexStart = string.index(string.startIndex, offsetBy: 0)
            let indexEnd = string.index(string.startIndex, offsetBy: checkStr.characters.count)
            let indexRange = indexStart..<indexEnd
            print("string.substring=\(string.substring(with: indexRange)) with \(checkStr)")
            if string.substring(with: indexRange) == checkStr {
                return checkNum
            }
        }
        checkNum += 1
    }
    return nil
}

func getTimeWithSetting() -> (settingDate: String, currentDateTime: String) {
    var today: String = ""
    var now: String = ""
    let date = Date()
    let calendar = Calendar.current
    let formatter = DateFormatter()
    if let changeTime = UserDefaults.standard.object(forKey: "changeTime") as? Date {
        var changeHour = Calendar.current.component(.hour, from: changeTime)
        let changeminute = Calendar.current.component(.minute, from: changeTime)
        var timeDif = DateComponents()
        if changeHour > 13 {
            changeHour -= 24
        }
        timeDif.hour = -changeHour
        
        timeDif.minute = -changeminute
        print("changeTime=\(changeTime) timeDif.hour=\(String(describing: timeDif.hour)) timeDif.minute = \(String(describing: timeDif.minute)) changeHour=\(changeHour)")
        let timeAfter = calendar.date(byAdding: timeDif, to: date)!
        formatter.dateFormat = "yyyyMMdd"
        today = formatter.string(from: timeAfter)
        print("today=\(today)")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        now = formatter.string(from: timeAfter)
        print("now=\(now)")
        
    }
    return (today, now)
}

//test
/*var changedDay = ""
func testDateChange(currentDate: String) -> String {
    
    let calendar = Calendar.current
    let formatter = DateFormatter()
    var changedDay = ""
    formatter.dateFormat = "yyyyMMdd"
    if let today = formatter.date(from: currentDate) {
        var dayDif = DateComponents()
        dayDif.day = +1
        let timeAfter = calendar.date(byAdding: dayDif, to: today)!
        changedDay = formatter.string(from: timeAfter)
        print("currentDate=\(currentDate) today=\(today) dayDif=\(dayDif) timeAfter=\(timeAfter) changedDay=\(changedDay)")
    }
    return changedDay
}*/

var player : AVAudioPlayer?
var sounds: [String] = ["default","Electronic_Alarm1","Electronic_Alarm2","Fire_Alarm","Carbon_Monoxide_Detector","Censor_Beep","Smoke_Detector_Alarm","Sonor_Signal(headlights)","Star_Wars_Blaster"]

func aiffPlay(file: String) -> AVAudioPlayer {
    
    let path = Bundle.main.path(forResource: file, ofType:"aiff")!
    let url = URL(fileURLWithPath: path)
    
    do {
        let sound = try AVAudioPlayer(contentsOf: url)
        player = sound
        sound.numberOfLoops = 0
        sound.prepareToPlay()
        sound.play()
        return sound
    } catch {
        print("error loading file")
        return AVAudioPlayer()
    }
}

func isInternetAvailable() -> Bool {
    print("isInternetAvailable function")
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if let _defaultRouteReachability = defaultRouteReachability {
        if !SCNetworkReachabilityGetFlags(_defaultRouteReachability, &flags) {
            return false
        }
    } else {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}
//dismiss keyboard when touching anywhere outside UITextField
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension UIButton
{
    func setBottomBorder() {
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIView {
    // Source: http://stackoverflow.com/questions/39917917/how-do-i-take-cropped-screenshot-with-retina-image-quality-in-my-snapshot-implem
    /// Create snapshot
    ///
    /// - parameter rect: The `CGRect` of the portion of the view to return. If `nil` (or omitted),
    ///                 return snapshot of the whole view.
    ///
    /// - returns: Returns `UIImage` of the specified portion of the view.
    
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        // otherwise, grab specified `rect` of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}

extension UIColor {
    var coreImageColor: CoreImage.CIColor {
        return CoreImage.CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    var htmlRGBColor:String {
        return String(format: "%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    public convenience init?(hexString: String) {
        let r, g, b: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    //a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        return nil
    }

}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}

// To make specific counting number bigger and outstanding
extension UILabel {
    func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
        
        guard let attributedText = attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0
        
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        
        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}


