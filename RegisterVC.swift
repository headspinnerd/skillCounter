//
//  RegisterViewController.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-12.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

protocol RegisterVCDelegate {
    func didLoginSuccessfully()
}

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    var delegate: RegisterVCDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_2.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.view.addSubview(self.containerForRegister)
        
        let circleImageForRegister = UIImageView(frame: CGRect(x: self.containerForRegister.frame.midX - 30, y: 10, width: 60 , height: 60 ))
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
        
        let btnRegister = UIButton(frame: CGRect(x: 10, y: 260, width: 280, height: 40))
        btnRegister.setTitle("REGISTER", for: .normal)
        btnRegister.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnRegister.setBackgroundImage(UIImage(color: uiColor(119, 109, 169, 0.9)), for: .normal)
        btnRegister.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        self.containerForRegister.addSubview(btnRegister)
        
        let btnToLogin = UIButton(frame: CGRect(x: 10, y: 310, width: 280, height: 40))
        btnToLogin.setTitle("Already have an account??", for: .normal)
        btnToLogin.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btnToLogin.setBackgroundImage(UIImage(color: uiColor(19, 79, 129, 0.9)), for: .highlighted)
        btnToLogin.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        self.containerForRegister.addSubview(btnToLogin)
        
        self.containerForRegister.center = self.view.center
        
        //dismiss keyboard when touching anywhere outside UITextField and pressing return
        self.hideKeyboard()
        username.delegate = self
        emailForRegister.delegate = self
        passwordForRegister.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: .UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    
    }
    
    
    func keyboardDidShow(_ note: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            let registerBtnBottomEdge = self.containerForRegister.frame.origin.y + 270 + 40
            let moveDistance = registerBtnBottomEdge - MyVar.keyboardTopEdge + 10
            print("loginBtnBottomEdge=\(registerBtnBottomEdge) keyboardTopEdge=\(MyVar.keyboardTopEdge)")
            if moveDistance > 0 {
                self.containerForRegister.frame.origin.y -= moveDistance
            }
        })
    }
    
    func keyboardDidHide(_ note: Notification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerForRegister.center = self.view.center
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
    
    func registerAction() {
        if username.text == "" || emailForRegister.text == "" || passwordForRegister.text == "" {
            showAlert(title: "Error!", message: "Fill in all columns!!", style: .alert)
        } else if (username.text?.characters.count)! > 20 {
            showAlert(title: "Error!", message: "Username must be less than 20 letters")
        } else if username.text == "Trial Member" {
            showAlert(title: "Error!", message: "I'm sorry, but you cannot use the name.")
        } else if (emailForRegister.text?.characters.count)! > 50 {
            showAlert(title: "Error!", message: "Email must be less than 50 letters")
        } else if (passwordForRegister.text?.characters.count)! > 20 || (passwordForRegister.text?.characters.count)! < 4  {
            showAlert(title: "Error!", message: "Password must be between 4 and 20 letters")
        } else if !(emailForRegister.text?.contains("@"))! || !(emailForRegister.text?.contains("."))! {
            showAlert(title: "Error!", message: "Incorrect email format!")
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
                                self.showAlert(title: "Succeed!", message: "Successfully Registerd!")
                                self.dismiss(animated: true, completion: nil)
                            case 1:
                                self.showAlert(title: "Error!", message: "Sorry, the username is used by other user now.")
                            default:
                                break
                            }
                        } else {
                            self.showAlert(title: "Unknown Error", message: "Sorry, please try again later!")
                        }
                    }
                })
            }
            task.resume()
        }
    }
    
    func loginAction() {
        self.dismiss(animated: false, completion: nil)
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
