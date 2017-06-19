//
//  GoogleLoginVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-21.
//  Copyright © 2017 Koki. All rights reserved.
//


import UIKit

class GoogleLoginVC: UIViewController, UITextFieldDelegate {
    
    var container: UIView = {
        let v = UIView(frame: CGRect(x:0, y:0, width:300, height:350))
        v.backgroundColor = uiColor(89, 79, 194, 0.5)
        v.layer.cornerRadius = 10
        return v
    }()
    
    var email: MyTextField = {
        let email = MyTextField(frame: CGRect(x: 10, y: 130, width: 280, height: 40))
        email.backgroundColor = .white
        email.placeholder = "Email"
        email.keyboardType = .emailAddress
        email.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        email.layer.cornerRadius = 8
        email.layer.masksToBounds = true
        return email
    }()
    
    var password: MyTextField = {
        let pass = MyTextField(frame: CGRect(x: 10, y: 190, width: 280, height: 40))
        pass.backgroundColor = .white
        pass.placeholder = "Password"
        pass.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        pass.layer.cornerRadius = 8
        pass.layer.masksToBounds = true
        pass.isSecureTextEntry = true
        return pass
    }()
    
    var loginSegment: UISegmentedControl = {
        let lgSeg = UISegmentedControl(items: ["Login", "Sign up"])
        lgSeg.frame = CGRect(x: 100, y: 80, width: 100, height: 30)
        lgSeg.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lgSeg.selectedSegmentIndex = 0
        lgSeg.layer.cornerRadius = 10
        return lgSeg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_1.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.view.addSubview(self.container)
        
        let circleImage = UIImageView(frame: CGRect(x: self.container.frame.midX - 30, y: 10, width: 60 , height: 60 ))
        circleImage.backgroundColor = .white
        circleImage.layer.cornerRadius = 30
        circleImage.clipsToBounds = true
        circleImage.image = #imageLiteral(resourceName: "google_icon")
        self.container.addSubview(circleImage)
        
        self.container.addSubview(loginSegment)
        
        self.container.addSubview(self.email)
        textFieldDidBeginEditing(email)
        self.container.addSubview(self.password)
        textFieldDidBeginEditing(password)
        
        let btnLogin = UIButton(frame: CGRect(x: 110, y: 240, width: 80, height: 40))
        btnLogin.setTitle("LOGIN", for: .normal)
        btnLogin.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnLogin.setBackgroundImage(UIImage(color: uiColor(119, 109, 169, 0.9)), for: .normal)
        btnLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        self.container.addSubview(btnLogin)
        
        let btnNormalLogin = UIButton(frame: CGRect(x: 230, y: 300, width: 70, height: 40))
        btnNormalLogin.setTitle("RETURN", for: .normal)
        btnNormalLogin.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnNormalLogin.setBackgroundImage(UIImage(color: uiColor(19, 79, 129, 0.9)), for: .highlighted)
        btnNormalLogin.addTarget(self, action: #selector(normalLoginAction), for: .touchUpInside)
        self.container.addSubview(btnNormalLogin)
        
        self.container.center = self.view.center
        
        //dismiss keyboard when touching anywhere outside UITextField and pressing return
        self.hideKeyboard()
        email.delegate = self
        password.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    
    func keyboardDidShow(_ note: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            let registerBtnBottomEdge = self.container.frame.origin.y + 270 + 40
            let moveDistance = registerBtnBottomEdge - MyVar.keyboardTopEdge + 10
            print("loginBtnBottomEdge=\(registerBtnBottomEdge) keyboardTopEdge=\(MyVar.keyboardTopEdge)")
            if moveDistance > 0 {
                self.container.frame.origin.y -= moveDistance
            }
        })
    }
    
    func keyboardDidHide(_ note: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.container.center = self.view.center
        })
    }
    
    func keyboardWillShow(_ note: NSNotification) {
        let userInfo:NSDictionary = note.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        MyVar.keyboardTopEdge = self.view.frame.height - keyboardHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    
    func normalLoginAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func loginAction() {
        if email.text != "" && password.text != "" {
            if loginSegment.selectedSegmentIndex == 0 { //Login user
                /*FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                    if user != nil{ //Sign in successful
                        self.login()
                    } else {
                        if let myError = error?.localizedDescription{
                            print(myError)
                        } else {
                            print("ERROR")
                        }
                    }
                })*/
            } else { //Sign up user
                /*FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
                    if user != nil {
                        self.login()
                    } else {
                        if let myError = error?.localizedDescription{
                            print(myError)
                        } else {
                            print("ERROR")
                        }
                    }
                })*/
            }
        }
    }
    
    
    //dismiss keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func login() {
        //userInfo.username = (FIRAuth.auth()?.currentUser?.email)!
        let atMark: Character = "@"
        let idx = userInfo.username.characters.index(of: atMark)
        userInfo.username = userInfo.username.substring(to: idx!)
        UserDefaults.standard.set(userInfo.username, forKey: "Username")
        
        let presentingViewController = self.presentingViewController
        self.dismiss(animated: false, completion: {
            presentingViewController!.dismiss(animated: true, completion: {})
        })  // FIXME: Needs to execute didLoginSuccessfully() if possible using delegate

        //self.present(ViewController(), animated: false, completion: nil)
    }
}

