//
//  LoginViewController.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-11.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit


protocol LoginVCDelegate {
    func didLoginSuccessfully()
}

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var delegate: LoginVCDelegate?
    
    var registerMode = true
    var isRegisterModeDone = false
    
    var containerForLogin: UIView = {
        let v = UIView(frame: CGRect(x:0, y:0, width:300, height:300))
        v.backgroundColor = uiColor(69, 59, 134, 0.5) //before:green=159
        v.layer.cornerRadius = 10
        return v
    }()
    
    lazy var emailForLogin: MyTextField = {
        let lemail = MyTextField(frame: CGRect(x: 10, y: 80, width: 280, height: 40))
        lemail.backgroundColor = .white
        lemail.placeholder = "Email or Username"
        lemail.keyboardType = .emailAddress
        lemail.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        lemail.layer.cornerRadius = 8
        lemail.layer.masksToBounds = true
        lemail.leftViewMode = .always
        lemail.leftView = self.getLeftView(image: #imageLiteral(resourceName: "username"))
        return lemail
    }()
    
    lazy var passwordForLogin: MyTextField = {
        let pass = MyTextField(frame: CGRect(x: 10, y: 140, width: 280, height: 40))
        pass.backgroundColor = .white
        pass.placeholder = "Password"
        pass.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        pass.layer.cornerRadius = 8
        pass.layer.masksToBounds = true
        pass.isSecureTextEntry = true
        pass.leftViewMode = .always
        pass.leftView = self.getLeftView(image: #imageLiteral(resourceName: "password"))
        return pass
    }()
    
    func getLeftView(image: UIImage) -> UIView {
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let img = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        img.image = image
        leftV.backgroundColor = uiColor(39, 109, 169, 0.9) 
        leftV.addSubview(img)
        return leftV
    }
    var circleImageForLogin = UIImageView()
    var btnLogin = UIButton()
    var forgotPassword = UIButton()
    var register = UIButton()
    var nonMember = UIButton()
    var bkImageForLogin = UIImageView()
    
    //Register View
    var containerForRegister: UIView = {
        let v = UIView(frame: CGRect(x:0, y:0, width:300, height:350))
        v.backgroundColor = uiColor(89, 79, 194, 0.5)
        v.layer.cornerRadius = 10
        return v
    }()
    
    var username: MyTextField = {
        let name = MyTextField(frame: CGRect(x: 10, y: 80, width: 280, height: 40))
        name.backgroundColor = .white
        name.placeholder = "Username"
        name.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        name.layer.cornerRadius = 8
        name.layer.masksToBounds = true
        return name
    }()
    
    var emailForRegister: MyTextField = {
        let email = MyTextField(frame: CGRect(x: 10, y: 140, width: 280, height: 40))
        email.backgroundColor = .white
        email.placeholder = "Email"
        email.keyboardType = .emailAddress
        email.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        email.layer.cornerRadius = 8
        email.layer.masksToBounds = true
        return email
    }()
    
    var passwordForRegister: MyTextField = {
        let pass = MyTextField(frame: CGRect(x: 10, y: 200, width: 280, height: 40))
        pass.backgroundColor = .white
        pass.placeholder = "Password"
        pass.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        pass.layer.cornerRadius = 8
        pass.layer.masksToBounds = true
        pass.isSecureTextEntry = true
        return pass
    }()
    var bkImageForRegister = UIImageView()
    var circleImageForRegister = UIImageView()
    var btnRegister = UIButton()
    var btnToLogin = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bkImageForLogin = UIImageView(frame: UIScreen.main.bounds)
        bkImageForLogin.image = UIImage(named: "background_3.jpg")
        self.view.insertSubview(bkImageForLogin, at: 0)
        
        self.view.addSubview(self.containerForLogin)
        
        circleImageForLogin.frame = CGRect(x: self.containerForLogin.frame.midX - 30, y: 10, width: 60 , height: 60 )
        circleImageForLogin.backgroundColor = .white
        circleImageForLogin.layer.cornerRadius = 30
        circleImageForLogin.clipsToBounds = true
        circleImageForLogin.image = #imageLiteral(resourceName: "lock")
        self.containerForLogin.addSubview(circleImageForLogin)
        
        self.containerForLogin.addSubview(self.emailForLogin)
        textFieldDidBeginEditing(emailForLogin)
        self.containerForLogin.addSubview(self.passwordForLogin)
        textFieldDidBeginEditing(passwordForLogin)
        
        btnLogin = UIButton(frame: CGRect(x: 10, y: 190, width: 280, height: 40))
        btnLogin.setTitle("LOGIN", for: .normal)
        btnLogin.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnLogin.setBackgroundImage(UIImage(color: uiColor(39, 109, 169, 0.9)), for: .normal)
        btnLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        self.containerForLogin.addSubview(btnLogin)
        
        forgotPassword.frame = CGRect(x: 10, y: 260, width: 150, height: 40)
        forgotPassword.setTitle("FORGOT PASSWORD?", for: .normal)
        forgotPassword.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        forgotPassword.setTitleColor(uiColor(39, 109, 169, 0.9), for: .highlighted) 
        forgotPassword.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
        
        self.containerForLogin.addSubview(forgotPassword)
        
        register.frame = CGRect(x: 210, y: 260, width: 90, height: 40)
        register.setTitle("REGISTER", for: .normal)
        register.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        register.setTitleColor(uiColor(39, 109, 169, 0.9), for: .highlighted) 
        register.addTarget(self, action: #selector(btnToRegisterAction), for: .touchUpInside)
        self.containerForLogin.addSubview(register)
        
        self.containerForLogin.center = self.view.center
        
        //dismiss keyboard when touching anywhere outside UITextField and pressing return
        self.hideKeyboard()
        emailForLogin.delegate = self
        passwordForLogin.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        if let _ = UserDefaults.standard.object(forKey: "IsfirstRun") as? Bool {
            registerMode = false
        }
        else {
            switchToRegisterMode()
            registerMode = true
            CoreDataManager.clearAllSkillCoreData()
            CoreDataManager.clearAllCommentCoreData()
            CoreDataManager.clearAllColorCoreData()
            CoreDataManager.clearAllPhotoCoreData()
            print("clearAllCoreData")
            UserDefaults.standard.removeObject(forKey: "IsfirstRun")
            CoreDataManager.firstStoreObj()
            print("firstStoreObj")
            UserDefaults.standard.set(false, forKey: "IsfirstRun")
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm"
            let changeTime = formatter.date(from: "04:00")!
            UserDefaults.standard.set(changeTime, forKey: "changeTime")
            UserDefaults.standard.set("default", forKey: "soundSelectedName")
            UserDefaults.standard.set(0, forKey: "soundSelectedRow")
            UserDefaults.standard.set([false,false,false,false,false,false,false], forKey: "dayOfWeekSelection")
            UserDefaults.standard.set("Time to practice my skill!", forKey: "notificationMessage")
        }
    }
    
    func switchToRegisterMode() {
        containerForLogin.isHidden = true
        emailForLogin.isHidden = true
        circleImageForLogin.isHidden = true
        passwordForLogin.isHidden = true
        bkImageForLogin.isHidden = true
        let isHiddenButtons: [UIButton] = [btnLogin, forgotPassword, register]
        for button in isHiddenButtons {
            button.isHidden = true
        }
        
        if !isRegisterModeDone {
        bkImageForRegister = UIImageView(frame: UIScreen.main.bounds)
        bkImageForRegister.image = UIImage(named: "background_2.jpg")
        self.view.insertSubview(bkImageForRegister, at: 0)
        self.view.addSubview(self.containerForRegister)
        
        circleImageForRegister.frame = CGRect(x: self.containerForRegister.frame.midX - 30, y: 10, width: 60 , height: 60 )
        circleImageForRegister.backgroundColor = .white
        circleImageForRegister.layer.cornerRadius = 30
        circleImageForRegister.clipsToBounds = true
        circleImageForRegister.image = #imageLiteral(resourceName: "username")
        self.containerForRegister.addSubview(circleImageForRegister)
        
        self.containerForRegister.addSubview(self.username)
        textFieldDidBeginEditing(username)
        self.containerForRegister.addSubview(self.emailForRegister)
        textFieldDidBeginEditing(emailForRegister)
        self.containerForRegister.addSubview(self.passwordForRegister)
        textFieldDidBeginEditing(passwordForRegister)
        
        btnRegister.frame = CGRect(x: 10, y: 260, width: 280, height: 40)
        btnRegister.setTitle("REGISTER", for: .normal)
        btnRegister.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnRegister.setBackgroundImage(UIImage(color: uiColor(119, 109, 169, 0.9)), for: .normal)
        btnRegister.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        self.containerForRegister.addSubview(btnRegister)
        
        btnToLogin.frame = CGRect(x: 10, y: 310, width: 280, height: 40)
        btnToLogin.setTitle("Already have an account??", for: .normal)
        btnToLogin.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnToLogin.setBackgroundImage(UIImage(color: uiColor(19, 79, 129, 0.9)), for: .highlighted)
        btnToLogin.addTarget(self, action: #selector(switchToLoginMode), for: .touchUpInside)
        self.containerForRegister.addSubview(btnToLogin)
        self.containerForRegister.center = self.view.center
            
        nonMember.frame = CGRect(x: 0, y: device.viewHeight/2+175+20, width: 200, height: 40)
        nonMember.center.x = view.center.x
        nonMember.setTitle("NO NEED TO REGISTER?", for: .normal)
        nonMember.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        nonMember.titleLabel?.textAlignment = .center
        nonMember.setTitleColor(uiColor(100, 100, 255, 0.9), for: .highlighted)
        nonMember.addTarget(self, action: #selector(nonMemberAction), for: .touchUpInside)
        self.view.addSubview(nonMember)
        
        //dismiss keyboard when touching anywhere outside UITextField and pressing return
        self.hideKeyboard()
        username.delegate = self
        emailForRegister.delegate = self
        passwordForRegister.delegate = self
            
        } else {
            containerForRegister.isHidden = false
            emailForRegister.isHidden = false
            circleImageForRegister.isHidden = false
            passwordForRegister.isHidden = false
            bkImageForRegister.isHidden = false
            btnRegister.isHidden = false
            btnToLogin.isHidden = false
            nonMember.isHidden = false
        }
        
        isRegisterModeDone = true
        registerMode = true

    }
    
    func keyboardDidShow(_ note: Notification) {
        if !registerMode {
            UIView.animate(withDuration: 0.2, animations: {
                let loginBtnBottomEdge = self.containerForLogin.frame.origin.y + 190 + 40
                let moveDistance = loginBtnBottomEdge - MyVar.keyboardTopEdge + 10
                print("loginBtnBottomEdge=\(loginBtnBottomEdge) keyboardTopEdge=\(MyVar.keyboardTopEdge)")
                if moveDistance > 0 {
                    self.containerForLogin.frame.origin.y -= moveDistance
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                let registerBtnBottomEdge = self.containerForRegister.frame.origin.y + 270 + 40
                let moveDistance = registerBtnBottomEdge - MyVar.keyboardTopEdge + 10
                print("loginBtnBottomEdge=\(registerBtnBottomEdge) keyboardTopEdge=\(MyVar.keyboardTopEdge)")
                if moveDistance > 0 {
                    self.containerForRegister.frame.origin.y -= moveDistance
                }
            })
        }
    }
    
    func keyboardDidHide(_ note: Notification) {
        if !registerMode {
            UIView.animate(withDuration: 0.2, animations: {
                self.containerForLogin.center = self.view.center
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.containerForRegister.center = self.view.center
            })
        }
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
    
    func loginAction() {
        if emailForLogin.text == "" || passwordForLogin.text == "" {
            showAlert(title: "Error", message: "Please enter an email(or username) and password.", style: .alert)
            return
        }
        if !isInternetAvailable() {
            self.showAlert(title: "Error", message: "The Internet connection appears to be offline.")
            return
        }
        userInfo.username = ""
        userInfo.email = ""
        userInfo.name = ""
        DispatchQueue.main.async(execute: {
            let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/loginGet.php"
            let post: String = "username=\(self.emailForLogin.text!)&password=\(self.passwordForLogin.text!)"
            let parsedDatas: [[String : Any]] = HttpRequestController().sendPostRequestSynchronous(urlString: urlString, post: post)
            print("parseDatas=\(String(describing: parsedDatas))")
            
            if parsedDatas.count > 0 {
                if let username = parsedDatas[0]["username"] as? String
                {
                    userInfo.username = username
                    if let address = parsedDatas[0]["email"] as? String
                    {
                        userInfo.email = address
                        if let name = parsedDatas[0]["name"] as? String
                        {
                            userInfo.name = name
                        }
                    }
                }
                
                print("username=\(userInfo.username)")
                print("email=\(userInfo.email)")
                
                if userInfo.username != "" && userInfo.email != "" {
                    UserDefaults.standard.set(userInfo.username, forKey: "Username")
                    MyVar.userName = userInfo.username
                    self.resignFirstResponder()
                    self.delegate?.didLoginSuccessfully()
                } else {
                    self.showAlert(title: "Error", message: "The username and password combination failed.", style: .alert)
                }
            } else {
                self.showAlert(title: "Error", message: "The username and password combination failed.", style: .alert)
            }
        })
    
    }
    
    func forgotPasswordAction() {
        self.present(ForgotPasswordVC(), animated: false, completion: nil)
    }
    
    func btnToRegisterAction() {
        switchToRegisterMode()
    }
    
    func switchToLoginMode() {
        registerMode = false
        containerForRegister.isHidden = true
        emailForRegister.isHidden = true
        circleImageForRegister.isHidden = true
        passwordForRegister.isHidden = true
        bkImageForRegister.isHidden = true
        btnRegister.isHidden = true
        btnToLogin.isHidden = true
        nonMember.isHidden = true
        
        containerForLogin.isHidden = false
        emailForLogin.isHidden = false
        circleImageForLogin.isHidden = false
        passwordForLogin.isHidden = false
        bkImageForLogin.isHidden = false
        let isHiddenButtons: [UIButton] = [btnLogin, forgotPassword, register]
        for button in isHiddenButtons {
            button.isHidden = false
        }
    }
    
    func nonMemberAction() {
        let alertController = UIAlertController(title: "Are you sure?", message: "You cannot save data in the web server. \n(You can save in your iPhone) Registration is free of charge.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
            UserDefaults.standard.set("Trial Member", forKey: "Username")
            userInfo.username = "Trial Member"
            MyVar.userName = "Trial Member"
            self.resignFirstResponder()
            self.delegate?.didLoginSuccessfully()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func registerAction() {
        if username.text == "" || emailForRegister.text == "" || passwordForRegister.text == "" {
            showAlert(title: "Error", message: "Please fill in all columns.", style: .alert)
        } else if (username.text?.characters.count)! > 20 {
            showAlert(title: "Error", message: "Username must be less than 20 letters")
        } else if username.text == "Trial Member" {
            showAlert(title: "Error", message: "I'm sorry, but you cannot use the name.")
        } else if (emailForRegister.text?.characters.count)! > 50 {
            showAlert(title: "Error", message: "Email must be less than 50 letters")
        } else if (passwordForRegister.text?.characters.count)! > 20 || (passwordForRegister.text?.characters.count)! < 4  {
            showAlert(title: "Error", message: "Password must be between 4 and 20 letters.")
        } else if !(emailForRegister.text?.contains("@"))! || !(emailForRegister.text?.contains("."))! {
            showAlert(title: "Error", message: "Incorrect email format.")
        } else {
            let request = NSMutableURLRequest(url: NSURL(string: "http://headspinnerd-com.stackstaging.com/bboying/register.php")! as URL)
            request.httpMethod = "POST"
            let postString = "username=\(username.text!)&email=\(emailForRegister.text!)&password=\(passwordForRegister.text!)"
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    if error!.localizedDescription == "The Internet connection appears to be offline." {
                        self.showAlert(title: "Error", message: "The Internet connection appears to be offline.")
                    } else {
                        print("error=\(error!.localizedDescription)")
                    }
                    return
                }
                
                print("response = \(String(describing: response))")
                DispatchQueue.main.async(execute: {
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")
                    if let _responseString = responseString {
                        if let updateCheck = updateResVariousCheck(response: _responseString, checkString: ["Successfully", "Duplicate entry"]) {
                            switch updateCheck {
                            case 0:
                                self.showAlert(title: "Succeed", message: "Successfully Registerd!")
                                userInfo.username = self.username.text!
                                userInfo.email = self.emailForRegister.text!
                                MyVar.userName = userInfo.username
                                UserDefaults.standard.set(MyVar.userName, forKey: "Username")
                                self.resignFirstResponder()
                                self.delegate?.didLoginSuccessfully()
                            case 1:
                                self.showAlert(title: "Error", message: "Sorry, the username is used by other user now.")
                            default:
                                break
                            }
                        } else {
                            self.showAlert(title: "Unknown Error", message: "Sorry, please try again later.")
                        }
                    }
                })
            }
            task.resume()
        }
    }
    
    func btnTologinAction() {
        self.dismiss(animated: false, completion: nil)
    }

    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    //dismiss keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
