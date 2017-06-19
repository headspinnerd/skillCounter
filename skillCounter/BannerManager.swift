//
//  BannerManager.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-18.
//  Copyright © 2017 Koki. All rights reserved.
//

import Foundation
import GoogleMobileAds

class BannerManager: NSObject {
    static let shared = BannerManager()
    var bannerView:GADBannerView!
    var timer = Timer()
    var bannerViewCenter: CGPoint = CGPoint.zero
    
    enum MoveCategory {
        case fromTop
        case fromLeft
        case fromRight
        case fromBottom
        case nonMove
    }
    
    func setBanner<T>(point: CGPoint, viewController: T, centerMove: MoveCategory, isRemove: Bool) where T:GADBannerViewDelegate, T:UIViewController{
        
        if isRemove {
            bannerView.removeFromSuperview()
            return
        }
        
        if bannerView == nil {
            bannerView = GADBannerView()
            bannerView.frame.size = CGSize(width: 320, height: 50)
            bannerView.adUnitID = "ca-app-pub-7854903923018969/9957643139"
            bannerView.delegate = viewController
            bannerView.rootViewController = viewController
            let request = GADRequest()
            //request.testDevices = [kGADSimulatorID]
            bannerView.load(request)
        }
        
        bannerView.frame.origin = point
        viewController.view.addSubview(bannerView)
        
        
        bannerViewCenter = bannerView.center
        
        /*let rand = randGenerate(maxnum: 10)
        if rand == 1 && centerMove != .nonMove { // Special Move occasionally
            bannerView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            bannerView.center = CGPoint(x: bannerView.center.x - 100, y: bannerView.center.y - 100)
            bannerView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        } else {*/
            switch centerMove {
                case .fromTop: bannerView.center = CGPoint(x: bannerView.center.x, y: bannerView.center.y - 50)
                case .fromBottom: bannerView.center = CGPoint(x: bannerView.center.x, y: bannerView.center.y + 50)
                case .fromLeft: bannerView.center = CGPoint(x: bannerView.center.x - 100, y: bannerView.center.y)
                case .fromRight: bannerView.center = CGPoint(x: bannerView.center.x + 100, y: bannerView.center.y)
                case .nonMove: break
            }
        //}
        
        UIView.animate(withDuration: 1.0) {
            self.bannerSwitch(sw: false)
        }
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(myBannerShow), userInfo: nil, repeats: false)
    }
    
    func myBannerShow() {
        UIView.animate(withDuration: 1.0) {
            self.bannerSwitch(sw: true)
            //self.bannerView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5) //for special move
            //self.bannerView.transform = .identity //for special move
            self.bannerView.center = self.bannerViewCenter
        }
    }
    
    func bannerSwitch(sw: Bool) {
        bannerView.isHidden = sw ? false : true
        bannerView.isUserInteractionEnabled = sw ? true : false
        bannerView.alpha = sw ? 1.0 : 0
        bannerView.isMultipleTouchEnabled = sw ? true : false
        bannerView.isAccessibilityElement = sw ? true : false
    }
}


