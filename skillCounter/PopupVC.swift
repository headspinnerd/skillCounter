//
//  PopupVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-11.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PopupVC: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
    
        if MyVar.displayComment != "" { // From CheckVC.swift
            textView.text = MyVar.displayComment
        } else {
            if let comments = skillList[MyVar.target.row].comment { // From CountVC.swift
                var comment = ""
                if comments.count > 0 {
                    for n in 0...(comments.count-1) {
                        comment = comment + comments[n]
                        if n != (comments.count-1) {
                            comment = comment + "\n"
                        }
                    }
                }
                textView.text = comment
            }
        }
        BannerManager.shared.setBanner(point: CGPoint(x: (device.viewWidth-320)/2, y: device.viewHeight - 99), viewController: self, centerMove: .fromRight, isRemove: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
