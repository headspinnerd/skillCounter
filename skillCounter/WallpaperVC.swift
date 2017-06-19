//
//  WallpaperVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-09.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

class WallpaperVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var device: Device {
        let dv = deviceRecognition(width: self.view.frame.width, height: self.view.frame.height)
        return dv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var image: UIImage?
    let stepGaussianBlur: Float = 1.0
    let stepBlur: Float = 0.05
    var effectView = UIVisualEffectView()
    var backgroundView1 = UIImageView()
    var backgroundView2 = UIImageView()
    var roundedStepValue: Float = 1.0
    var roundedStepValueGS: Float = 0
    var sliderOfBlur = UISlider()
    var sliderOfGSBlur = UISlider()
    var blurLabel = UIButton()
    var gSblurLabel = UIButton()
    var doneButton = UIButton()
    var cancelButton = UIButton()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if MyVar.previousVC == "SettingVC" {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imgPicker.allowsEditing = false
            MyVar.previousVC = ""
            self.present(imgPicker, animated: true) {
                //After it is complete
                print("complete")
            }
        } else {
            guard let img = image else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            self.backgroundView1 = UIImageView(image: img)
            
            self.backgroundView1.frame = self.view.frame
            //self.view.addSubview(self.backgroundView)
            self.view.insertSubview(self.backgroundView1, at: 0)
            
            let alert = UIAlertController(title: "Edit?", message: "Do you wanna edit the picture?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                self.backgroundView1.removeFromSuperview()
                
                let blurLabelWidth = self.device.spViewWidth/5
                self.blurLabel = UIButton(frame: CGRect(x: self.device.viewWidth/4 - blurLabelWidth/2 - 10, y: self.device.viewHeight*3.2/4, width: blurLabelWidth, height: 30))
                self.blurLabel.setBackgroundImage(#imageLiteral(resourceName: "blurLabel.png"), for: .normal)
                self.blurLabel.setTitle("Brightness", for: .normal)
                self.blurLabel.titleLabel?.font = UIFont(name: "Helvetica", size: self.device.getFontSize(numOfLetters: 27))
                self.blurLabel.titleLabel?.textColor = .white
                
                self.sliderOfBlur = UISlider(frame: CGRect(x: self.device.viewWidth/4 + blurLabelWidth/2, y: self.device.viewHeight*3.2/4, width: self.device.spViewWidth/2, height: 30))
                self.sliderOfBlur.value = 1.0
                self.sliderOfBlur.minimumValue = 0
                self.sliderOfBlur.maximumValue = 1.0
                self.sliderOfBlur.isContinuous = true
                self.sliderOfBlur.tintColor = .blue
                self.sliderOfBlur.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
                
                let blur = UIBlurEffect(style: UIBlurEffectStyle.regular)
                self.effectView = UIVisualEffectView(effect: blur)
                self.effectView.frame = self.view.bounds
                self.view.addSubview(self.effectView)
                
                let gSblurLabelWidth = self.device.spViewWidth/5
                self.gSblurLabel = UIButton(frame: CGRect(x: self.device.viewWidth/4 - gSblurLabelWidth/2 - 10, y: self.device.viewHeight*3.6/4, width:gSblurLabelWidth, height: 30))
                self.gSblurLabel.setBackgroundImage(#imageLiteral(resourceName: "GSBlurLabel.png"), for: .normal)
                self.gSblurLabel.setTitle("Blur", for: .normal)
                self.gSblurLabel.titleLabel?.font = UIFont(name: "Helvetica", size: self.device.getFontSize(numOfLetters: 27))
                self.gSblurLabel.titleLabel?.textColor = .white
                
                self.sliderOfGSBlur = UISlider(frame: CGRect(x: self.device.viewWidth/4 + gSblurLabelWidth/2, y: self.device.viewHeight*3.6/4, width: self.device.spViewWidth/2, height: 30))
                self.sliderOfGSBlur.value = 0
                self.sliderOfGSBlur.minimumValue = 0
                self.sliderOfGSBlur.maximumValue = 30.0
                self.sliderOfGSBlur.isContinuous = false
                self.sliderOfGSBlur.tintColor = .red
                self.sliderOfGSBlur.addTarget(self, action: #selector(self.sliderGSValueDidChange(_:)), for: .valueChanged)
                
                self.doneButton = UIButton(frame: CGRect(x: self.device.spViewWidth*0.83, y: 15, width: self.device.spViewWidth*0.25, height: 30))
                self.doneButton.addTarget(self, action: #selector(self.doneTapped), for: .touchUpInside)
                self.doneButton.setBackgroundImage(UIImage(color: uiColor(0, 0, 0, 0.9)), for: .normal)
                self.doneButton.titleLabel?.font = UIFont(name: "Helvetica", size: self.device.getFontSize(numOfLetters: 27))
                self.doneButton.setTitle("Done", for: .normal)
                
                self.cancelButton = UIButton(frame: CGRect(x: self.device.spViewWidth*0.03, y: 15, width: self.device.spViewWidth*0.25, height: 30))
                self.cancelButton.addTarget(self, action: #selector(self.cancelTapped), for: .touchUpInside)
                self.cancelButton.setBackgroundImage(UIImage(color: uiColor(0, 0, 0, 0.9)), for: .normal)
                self.cancelButton.titleLabel?.font = UIFont(name: "Helvetica", size: self.device.getFontSize(numOfLetters: 27))
                self.cancelButton.setTitle("Cancel", for: .normal)

                
                self.backgroundView2 = UIImageView(image: img)
                
                self.backgroundView2.frame = self.view.frame
                self.effectView.addSubview(self.backgroundView2)
                //self.effectView.insertSubview(self.backgroundView, at: 0)

                self.effectView.addSubview(self.sliderOfBlur)
                self.effectView.addSubview(self.blurLabel)
                self.effectView.addSubview(self.sliderOfGSBlur)
                self.effectView.addSubview(self.gSblurLabel)
                self.effectView.addSubview(self.doneButton)
                self.effectView.addSubview(self.cancelButton)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                let imageData: NSData = UIImageJPEGRepresentation(img, 0)! as NSData
                //UserDefaults.standard.set(imageData, forKey: "wallpaper")
                UserDefaults.standard.removeObject(forKey: "wallpaper")
                CoreDataManager.clearAllPhotoCoreData()
                CoreDataManager.storePhotoObj(image: imageData)
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = img
        } else {
            //Error message
            print("Not selected")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func applyGaussianBlurFilter(inputCIImage: CIImage, value: Float) -> CIImage {
        
        //Apply Gaussian Blur Filter
        /*let affineClampFilter = CIFilter(name: "CIAffineClamp")
        let xform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        affineClampFilter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        affineClampFilter?.setValue(NSValue(cgAffineTransform: xform), forKey: "inputTransform")
        let outputAfterCalmp = affineClampFilter?.outputImage
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(outputAfterCalmp, forKey: kCIInputImageKey)
        filter?.setValue((value), forKey: kCIInputRadiusKey)
        let outputCIImage = filter?.outputImage
        
        guard let _outputCIImage = outputCIImage else {
            fatalError("applyGaussianBlurFilter does not work.")
        }
        
        return _outputCIImage*/
        
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        filter?.setValue((value), forKey: kCIInputRadiusKey)
        let outputCIImage = filter?.outputImage
        
        guard let _outputCIImage = outputCIImage else {
            fatalError("applyGaussianBlurFilter does not work.")
        }
        
        return _outputCIImage
        
    }
    
    func sliderGSValueDidChange(_ sender: UISlider) {
        roundedStepValueGS = round(sender.value / stepGaussianBlur) * stepGaussianBlur
        //Display an Activity Indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        effectView.addSubview(activityIndicator)
        effectView.bringSubview(toFront: activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.blurImageMake(value: self.roundedStepValueGS)
        }
    }
    
    func sliderValueDidChange(_ sender: UISlider) {
        roundedStepValue = round(sender.value / stepBlur) * stepBlur
        backgroundView2.alpha = CGFloat(roundedStepValue)
    }
    
    func blurImageMake(value: Float) {
        print("startConveting")
        guard let img = image else {
            return
        }
        let imageCIImage = CIImage(cgImage: img.fixOrientation().cgImage!)
        let withBlurImage = applyGaussianBlurFilter(inputCIImage: imageCIImage, value: value)
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: img.size)
        print("Conveting")
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(withBlurImage, from: rect)
        let blurImage = UIImage(cgImage: cgImage!)
        print("blurImage.imageOrientation=\(blurImage.imageOrientation)")
        
        
        backgroundView2.removeFromSuperview()
        print("finished conversion")
        backgroundView2 = UIImageView(image: blurImage)
        
        backgroundView2.frame = view.frame
        backgroundView2.alpha = CGFloat(roundedStepValue)
        effectView.addSubview(backgroundView2)
        effectView.addSubview(sliderOfBlur)
        effectView.addSubview(blurLabel)
        effectView.addSubview(sliderOfGSBlur)
        effectView.addSubview(gSblurLabel)
        effectView.addSubview(doneButton)
        effectView.addSubview(cancelButton)
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    func doneTapped(){
        self.sliderOfBlur.removeFromSuperview()
        self.sliderOfGSBlur.removeFromSuperview()
        self.blurLabel.removeFromSuperview()
        self.gSblurLabel.removeFromSuperview()
        self.doneButton.removeFromSuperview()
        self.cancelButton.removeFromSuperview()
        
        let fixFrame = view.frame
        if let snapshot = view.snapshot(of: fixFrame) {
            let imageData: NSData = UIImagePNGRepresentation(snapshot)! as NSData
            //UserDefaults.standard.set(imageData, forKey: "wallpaper")
            CoreDataManager.clearAllPhotoCoreData()
            CoreDataManager.storePhotoObj(image: imageData)
            print("wallpaper saved")
        }
        self.dismiss(animated: true, completion: nil)
    }

    func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}
