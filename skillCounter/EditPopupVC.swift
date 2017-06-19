//
//  EditPopupVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-04.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

class EditPopupVC: UITableViewController, AlertDelegate, UITextFieldDelegate {
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        print("showAlert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    let step: Float = 1
    
    let colorBoxes: [UIButton] = {
        let boxes = [UIButton(),UIButton(),UIButton(),UIButton(),UIButton()]
        for box in boxes {
            box.translatesAutoresizingMaskIntoConstraints = false
            box.layer.cornerRadius = 3
        }
        return boxes
    }()
    
    var verticalConstraint: [[NSLayoutConstraint]] = [[NSLayoutConstraint()],[NSLayoutConstraint()],[NSLayoutConstraint()],[NSLayoutConstraint()],[NSLayoutConstraint()]]
    var horizontalConstraint: [[NSLayoutConstraint]] = [[NSLayoutConstraint()],[NSLayoutConstraint()],[NSLayoutConstraint()],[NSLayoutConstraint()],[NSLayoutConstraint()]]
    
    var today = ""
    
    var tableViewcell: EditPopupCell?
    var btnNameChangeIndex: Int?
    
    var isExpands: [Bool] = [false,false,false,false,false]
    
    var isFirstload = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeGotten = getTimeWithSetting()
        today = timeGotten.settingDate
        print("today=\(today)")
        
        navigationItem.title = "Detail"
        tableView.register(EditPopupCell.self, forCellReuseIdentifier: "cellId")
        
        let backItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colors = []
        if let buttons = skillList[MyVar.target.row].buttons {
            var buttonCount = 0
            for button in buttons {
                colors.append((button.1.components.red*255, button.1.components.green*255, button.1.components.blue*255))
                colors.append((button.2.components.red*255, button.2.components.green*255, button.2.components.blue*255))
                buttonCount += 1
            }
            if buttonCount != 5 {
                for _ in 1...((5-buttonCount)*2) {
                    let randnum1 = CGFloat(randGenerate(maxnum: 255))
                    let randnum2 = CGFloat(randGenerate(maxnum: 255))
                    let randnum3 = CGFloat(randGenerate(maxnum: 255))
                    colors.append((randnum1, randnum2, randnum3))
                }
            }
            print("colorsArray=\(colors)")
        }
        print("skillList[\(MyVar.target.row)].buttons=\(String(describing: skillList[MyVar.target.row].buttons))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isFirstload = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 50
        case 3...9: if isExpands[0] { return 35 } else { return 0 }
        case 11...17: if isExpands[1] { return 35 } else { return 0 }
        case 19...25: if isExpands[2] { return 35 } else { return 0 }
        case 27...33: if isExpands[3] { return 35 } else { return 0 }
        case 35...41: if isExpands[4] { return 35 } else { return 0 }
        default: return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (2 + (skillList[MyVar.target.row].btnCount*8))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! EditPopupCell
        switch indexPath.row {
        case 0: objectHidden(cell: cell)
                cell.skillLabel.isHidden = false
                cell.skillTextField.isHidden = false
                cell.skillTextField.index = 5
                cell.skillTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
                cell.skillTextField.delegate = self
                tableViewcell = cell
                cell.skillNameChangeButton.addTarget(self, action: #selector(skillChangeAction), for: .touchUpInside)
                cell.backgroundColor = uiColor(220, 220, 220, 0.9)
                cell.selectionStyle = .none
        case 1: objectHidden(cell: cell)
                cell.numberOfButtonLabel.isHidden = false
                cell.numberOfButton.isHidden = false
                cell.stepperPlusButton.isHidden = false
                cell.stepperMinusButton.isHidden = false
                cell.stepperPlusButton.cell = cell
                cell.stepperMinusButton.cell = cell
                cell.stepperPlusButton.addTarget(self, action: #selector(stepperPlus(_:)), for: .touchUpInside)
                cell.stepperMinusButton.addTarget(self, action: #selector(stepperMinus(_:)), for: .touchUpInside)
        case 2: objectHidden(cell: cell)
                if skillList[MyVar.target.row].btnCount >= 1 {
                    cell.expandIcon.isHidden = false
                    cell.expandIcon.index = 0
                    if isExpands[0] {
                        cell.expandIcon.setImage(#imageLiteral(resourceName: "expand.png"), for: .normal)
                    } else {
                        cell.expandIcon.setImage(#imageLiteral(resourceName: "reduction.png"), for: .normal)
                    }
                    cell.expandIcon.addTarget(self, action: #selector(expandReduce(_:)), for: .touchUpInside)
                    cell.settingButtonTitleLabel.isHidden = false
                    cell.settingButtonTitleLabel.text = "Button 1"
                    cell.backgroundColor = uiColor(240, 240, 240, 0.9)
                    var width: CGFloat = 0
                    switch skillList[MyVar.target.row].btnCount {
                        case 1: width = (device.spViewWidth - 20) / 2.5
                        case 2: width = (device.spViewWidth - 20) / 3
                        default: width = (device.spViewWidth - CGFloat(skillList[MyVar.target.row].btnCount-1) * 10) / CGFloat(skillList[MyVar.target.row].btnCount)
                    }
                    cell.addSubview(colorBoxes[0])
                    
                    cell.removeConstraints(verticalConstraint[0])
                    cell.removeConstraints(horizontalConstraint[0])
                    //horizontalConstraint[0] = NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-10-[v0(==\(width))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorBoxes[0],"v1": cell.settingButtonTitleLabel])
                    horizontalConstraint[0] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v1(==25)][v0(==80)]-10-[v2(==\(width))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.settingButtonTitleLabel, "v1": cell.expandIcon, "v2": colorBoxes[0]])
                    verticalConstraint[0] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=2)-[v0(==40)]-(>=2)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorBoxes[0]])
                    cell.addConstraints(horizontalConstraint[0])
                    cell.addConstraints(verticalConstraint[0])
                    print("colorBoxes[0].frame=\(colorBoxes[0].frame)")
                    colorBoxes[0].setTitle("\((skillList[MyVar.target.row].buttons?[0].0)!)", for: .normal)
                    colorBoxes[0].setTitleColor(skillList[MyVar.target.row].buttons?[0].1, for: .normal)
                    colorBoxes[0].backgroundColor = skillList[MyVar.target.row].buttons?[0].2
                    colorBoxes[0].titleLabel?.textAlignment = .center
                }
        case 3: objectHidden(cell: cell)
        if !isExpands[0] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 1 {
            cell.btnName.isHidden = false
            cell.btnNameTextField.isHidden = false
            if let btnName = skillList[MyVar.target.row].buttons?[0].0 {
                cell.btnNameTextField.text = "\(btnName)"
            }
            tableViewcell = cell
            cell.btnNameTextField.index = 0
            cell.btnNameTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
            cell.btnNameTextField.textAlignment = .left
            cell.btnNameTextField.delegate = self
            
            cell.btnNameChangeButtons[0].setTitle("Change", for: .normal)
            cell.btnNameChangeButtons[0].addTarget(self, action: #selector(btnNameChangeAction(_:)), for: .touchUpInside)
            
        }
        
        case 4: objectHidden(cell: cell)
        if !isExpands[0] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 1 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            print("BeforeslideBarChange isFirstload=\(isFirstload)")
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[0].1 {
                    cell.slider.value = Float(color.components.red) * 255
                    print("color.components.red=\(color.components.red)")
                }
            }
            cell.slider.index = 0
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
        case 5: objectHidden(cell: cell)
        if !isExpands[0] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 1 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.numberOfLines = 2
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Text Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[0].1 {
                    cell.slider.value = Float(color.components.green) * 255
                    print("color.components.green=\(color.components.green)")
                }
            }
            cell.slider.index = 0
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
        case 6: objectHidden(cell: cell)
        if !isExpands[0] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 1 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[0].1 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 0
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
        case 7: objectHidden(cell: cell)
        if !isExpands[0] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 1 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[0].2 {
                    cell.slider.value = Float(color.components.red) * 255
                }
            }
            cell.slider.index = 1
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
        case 8: objectHidden(cell: cell)
        if !isExpands[0] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 1 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
            cell.slideCategory.titleLabel?.numberOfLines = 3
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Back ground Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[0].2 {
                    cell.slider.value = Float(color.components.green) * 255
                }
            }
            cell.slider.index = 1
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 9: objectHidden(cell: cell)
        if !isExpands[0] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 1 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[0].2 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 1
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 10: objectHidden(cell: cell)
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.expandIcon.isHidden = false
            cell.expandIcon.index = 1
            if isExpands[1] {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "expand.png"), for: .normal)
            } else {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "reduction.png"), for: .normal)
            }
            cell.expandIcon.addTarget(self, action: #selector(expandReduce(_:)), for: .touchUpInside)
            cell.settingButtonTitleLabel.isHidden = false
            cell.settingButtonTitleLabel.text = "Button 2"
            cell.backgroundColor = uiColor(240, 240, 240, 0.9)
            cell.addSubview(colorBoxes[1])
            
            var width: CGFloat = 0
            switch skillList[MyVar.target.row].btnCount {
            case 1: width = (device.spViewWidth - 20) / 2.5
            case 2: width = (device.spViewWidth - 20) / 3
            default: width = (device.spViewWidth - CGFloat(skillList[MyVar.target.row].btnCount-1) * 10) / CGFloat(skillList[MyVar.target.row].btnCount)
            }
            cell.removeConstraints(verticalConstraint[1])
            cell.removeConstraints(horizontalConstraint[1])
            horizontalConstraint[1] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v1(==25)][v0(==80)]-10-[v2(==\(width))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.settingButtonTitleLabel, "v1": cell.expandIcon, "v2": colorBoxes[1]])
            verticalConstraint[1] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=2)-[v0(==40)]-(>=2)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorBoxes[1]])
            cell.addConstraints(horizontalConstraint[1])
            cell.addConstraints(verticalConstraint[1])
            print("colorBoxes[1].frame=\(colorBoxes[1].frame)")
            colorBoxes[1].setTitle("\((skillList[MyVar.target.row].buttons?[1].0)!)", for: .normal)
            colorBoxes[1].setTitleColor(skillList[MyVar.target.row].buttons?[1].1, for: .normal)
            colorBoxes[1].backgroundColor = skillList[MyVar.target.row].buttons?[1].2
            colorBoxes[1].titleLabel?.textAlignment = .center
        }
        case 11: objectHidden(cell: cell)
        if !isExpands[1] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.btnName.isHidden = false
            cell.btnNameTextField.isHidden = false
            if let btnName = skillList[MyVar.target.row].buttons?[1].0 {
                cell.btnNameTextField.text = "\(btnName)"
            }
            tableViewcell = cell
            cell.btnNameTextField.index = 1
            cell.btnNameTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
            cell.btnNameTextField.textAlignment = .left
            cell.btnNameTextField.delegate = self
            
            cell.btnNameChangeButtons[1].setTitle("Change", for: .normal)
            cell.btnNameChangeButtons[1].addTarget(self, action: #selector(btnNameChangeAction(_:)), for: .touchUpInside)
        }
        case 12: objectHidden(cell: cell)
        if !isExpands[1] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[1].1 {
                    cell.slider.value = Float(color.components.red) * 255
                    print("color.components.red=\(color.components.red)")
                }
            }
            cell.slider.index = 2
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 13: objectHidden(cell: cell)
        if !isExpands[1] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.numberOfLines = 2
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Text Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[1].1 {
                    cell.slider.value = Float(color.components.green) * 255
                    print("color.components.green=\(color.components.green)")
                }
            }
            cell.slider.index = 2
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
        case 14: objectHidden(cell: cell)
        if !isExpands[1] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[1].1 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 2
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 15: objectHidden(cell: cell)
        if !isExpands[1] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[1].2 {
                    cell.slider.value = Float(color.components.red) * 255
                }
            }
            cell.slider.index = 3
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 16: objectHidden(cell: cell)
        if !isExpands[1] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
            cell.slideCategory.titleLabel?.numberOfLines = 3
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Back ground Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[1].2 {
                    cell.slider.value = Float(color.components.green) * 255
                }
            }
            cell.slider.index = 3
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 17: objectHidden(cell: cell)
        if !isExpands[1] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 2 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[1].2 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 3
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
            
        case 18: objectHidden(cell: cell)
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.expandIcon.isHidden = false
            cell.expandIcon.index = 2
            if isExpands[2] {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "expand.png"), for: .normal)
            } else {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "reduction.png"), for: .normal)
            }
            cell.expandIcon.addTarget(self, action: #selector(expandReduce(_:)), for: .touchUpInside)
            cell.settingButtonTitleLabel.isHidden = false
            cell.settingButtonTitleLabel.text = "Button 3"
            cell.backgroundColor = uiColor(240, 240, 240, 0.9)
            cell.addSubview(colorBoxes[2])
            
            var width: CGFloat = 0
            switch skillList[MyVar.target.row].btnCount {
            case 1: width = (device.spViewWidth - 20) / 2.5
            case 2: width = (device.spViewWidth - 20) / 3
            default: width = (device.spViewWidth - CGFloat(skillList[MyVar.target.row].btnCount-1) * 10) / CGFloat(skillList[MyVar.target.row].btnCount)
            }
            cell.removeConstraints(verticalConstraint[2])
            cell.removeConstraints(horizontalConstraint[2])
            horizontalConstraint[2] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v1(==25)][v0(==80)]-10-[v2(==\(width))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.settingButtonTitleLabel, "v1": cell.expandIcon, "v2": colorBoxes[2]])
            verticalConstraint[2] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=2)-[v0(==40)]-(>=2)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorBoxes[2]])
            cell.addConstraints(horizontalConstraint[2])
            cell.addConstraints(verticalConstraint[2])
            colorBoxes[2].setTitle("\((skillList[MyVar.target.row].buttons?[2].0)!)", for: .normal)
            colorBoxes[2].setTitleColor(skillList[MyVar.target.row].buttons?[2].1, for: .normal)
            colorBoxes[2].backgroundColor = skillList[MyVar.target.row].buttons?[2].2
            colorBoxes[2].titleLabel?.textAlignment = .center
        }
        case 19: objectHidden(cell: cell)
        if !isExpands[2] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.btnName.isHidden = false
            cell.btnNameTextField.isHidden = false
            if let btnName = skillList[MyVar.target.row].buttons?[2].0 {
                cell.btnNameTextField.text = "\(btnName)"
            }
            tableViewcell = cell
            cell.btnNameTextField.index = 2
            cell.btnNameTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
            cell.btnNameTextField.textAlignment = .left
            cell.btnNameTextField.delegate = self
            
            cell.btnNameChangeButtons[2].setTitle("Change", for: .normal)
            cell.btnNameChangeButtons[2].addTarget(self, action: #selector(btnNameChangeAction(_:)), for: .touchUpInside)
        }
        case 20: objectHidden(cell: cell)
        if !isExpands[2] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[2].1 {
                    cell.slider.value = Float(color.components.red) * 255
                    print("color.components.red=\(color.components.red)")
                }
            }
            cell.slider.index = 4
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 21: objectHidden(cell: cell)
        if !isExpands[2] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.numberOfLines = 2
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Text Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[2].1 {
                    cell.slider.value = Float(color.components.green) * 255
                    print("color.components.green=\(color.components.green)")
                }
            }
            cell.slider.index = 4
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 22: objectHidden(cell: cell)
        if !isExpands[2] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[2].1 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 4
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 23: objectHidden(cell: cell)
        if !isExpands[2] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[2].2 {
                    cell.slider.value = Float(color.components.red) * 255
                }
            }
            cell.slider.index = 5
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 24: objectHidden(cell: cell)
        if !isExpands[2] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
            cell.slideCategory.titleLabel?.numberOfLines = 3
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Back ground Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[2].2 {
                    cell.slider.value = Float(color.components.green) * 255
                }
            }
            cell.slider.index = 5
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 25: objectHidden(cell: cell)
        if !isExpands[2] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 3 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[2].2 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 5
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
        
        case 26: objectHidden(cell: cell)
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.expandIcon.isHidden = false
            cell.expandIcon.index = 3
            if isExpands[3] {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "expand.png"), for: .normal)
            } else {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "reduction.png"), for: .normal)
            }
            cell.expandIcon.addTarget(self, action: #selector(expandReduce(_:)), for: .touchUpInside)
            cell.settingButtonTitleLabel.isHidden = false
            cell.settingButtonTitleLabel.text = "Button 4"
            cell.backgroundColor = uiColor(240, 240, 240, 0.9)
            cell.addSubview(colorBoxes[3])
            
            var width: CGFloat = 0
            switch skillList[MyVar.target.row].btnCount {
            case 1: width = (device.spViewWidth - 20) / 2.5
            case 2: width = (device.spViewWidth - 20) / 3
            default: width = (device.spViewWidth - CGFloat(skillList[MyVar.target.row].btnCount-1) * 10) / CGFloat(skillList[MyVar.target.row].btnCount)
            }
            cell.removeConstraints(verticalConstraint[3])
            cell.removeConstraints(horizontalConstraint[3])
            horizontalConstraint[3] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v1(==25)][v0(==80)]-10-[v2(==\(width))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.settingButtonTitleLabel, "v1": cell.expandIcon, "v2": colorBoxes[3]])
            verticalConstraint[3] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=2)-[v0(==40)]-(>=2)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorBoxes[3]])
            cell.addConstraints(horizontalConstraint[3])
            cell.addConstraints(verticalConstraint[3])
            colorBoxes[3].setTitle("\((skillList[MyVar.target.row].buttons?[3].0)!)", for: .normal)
            colorBoxes[3].setTitleColor(skillList[MyVar.target.row].buttons?[3].1, for: .normal)
            colorBoxes[3].backgroundColor = skillList[MyVar.target.row].buttons?[3].2
            colorBoxes[3].titleLabel?.textAlignment = .center
        }
        case 27: objectHidden(cell: cell)
        if !isExpands[3] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.btnName.isHidden = false
            cell.btnNameTextField.isHidden = false
            if let btnName = skillList[MyVar.target.row].buttons?[3].0 {
                cell.btnNameTextField.text = "\(btnName)"
            }
            tableViewcell = cell
            cell.btnNameTextField.index = 3
            cell.btnNameTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
            cell.btnNameTextField.textAlignment = .left
            cell.btnNameTextField.delegate = self
            
            cell.btnNameChangeButtons[3].setTitle("Change", for: .normal)
            cell.btnNameChangeButtons[3].addTarget(self, action: #selector(btnNameChangeAction(_:)), for: .touchUpInside)
        }
        case 28: objectHidden(cell: cell)
        if !isExpands[3] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[3].1 {
                    cell.slider.value = Float(color.components.red) * 255
                    print("color.components.red=\(color.components.red)")
                }
            }
            cell.slider.index = 6
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 29: objectHidden(cell: cell)
        if !isExpands[3] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.numberOfLines = 2
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Text Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[3].1 {
                    cell.slider.value = Float(color.components.green) * 255
                    print("color.components.green=\(color.components.green)")
                }
            }
            cell.slider.index = 6
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 30: objectHidden(cell: cell)
        if !isExpands[3] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[3].1 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 6
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 31: objectHidden(cell: cell)
        if !isExpands[3] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[3].2 {
                    cell.slider.value = Float(color.components.red) * 255
                }
            }
            cell.slider.index = 7
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 32: objectHidden(cell: cell)
        if !isExpands[3] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
            cell.slideCategory.titleLabel?.numberOfLines = 3
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Back ground Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[3].2 {
                    cell.slider.value = Float(color.components.green) * 255
                }
            }
            cell.slider.index = 7
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 33: objectHidden(cell: cell)
        if !isExpands[3] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 4 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[3].2 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 7
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
            
        case 34: objectHidden(cell: cell)
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.expandIcon.isHidden = false
            cell.expandIcon.index = 4
            if isExpands[4] {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "expand.png"), for: .normal)
            } else {
                cell.expandIcon.setImage(#imageLiteral(resourceName: "reduction.png"), for: .normal)
            }
            cell.expandIcon.addTarget(self, action: #selector(expandReduce(_:)), for: .touchUpInside)
            cell.settingButtonTitleLabel.isHidden = false
            cell.settingButtonTitleLabel.text = "Button 5"
            cell.backgroundColor = uiColor(240, 240, 240, 0.9)
            cell.addSubview(colorBoxes[4])
            
            var width: CGFloat = 0
            switch skillList[MyVar.target.row].btnCount {
            case 1: width = (device.spViewWidth - 20) / 2.5
            case 2: width = (device.spViewWidth - 20) / 3
            default: width = (device.spViewWidth - CGFloat(skillList[MyVar.target.row].btnCount-1) * 10) / CGFloat(skillList[MyVar.target.row].btnCount)
            }
            cell.removeConstraints(verticalConstraint[4])
            cell.removeConstraints(horizontalConstraint[4])
            horizontalConstraint[4] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v1(==25)][v0(==80)]-10-[v2(==\(width))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.settingButtonTitleLabel, "v1": cell.expandIcon, "v2": colorBoxes[4]])
            verticalConstraint[4] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=2)-[v0(==40)]-(>=2)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorBoxes[4]])
            cell.addConstraints(horizontalConstraint[4])
            cell.addConstraints(verticalConstraint[4])
            colorBoxes[4].setTitle("\((skillList[MyVar.target.row].buttons?[4].0)!)", for: .normal)
            colorBoxes[4].setTitleColor(skillList[MyVar.target.row].buttons?[4].1, for: .normal)
            colorBoxes[4].backgroundColor = skillList[MyVar.target.row].buttons?[4].2
            colorBoxes[4].titleLabel?.textAlignment = .center
        }
        case 35: objectHidden(cell: cell)
        if !isExpands[4] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.btnName.isHidden = false
            cell.btnNameTextField.isHidden = false
            if let btnName = skillList[MyVar.target.row].buttons?[4].0 {
                cell.btnNameTextField.text = "\(btnName)"
            }
            tableViewcell = cell
            cell.btnNameTextField.index = 4
            cell.btnNameTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
            cell.btnNameTextField.textAlignment = .left
            cell.btnNameTextField.delegate = self
            
            cell.btnNameChangeButtons[4].setTitle("Change", for: .normal)
            cell.btnNameChangeButtons[4].addTarget(self, action: #selector(btnNameChangeAction(_:)), for: .touchUpInside)
        }
        case 36: objectHidden(cell: cell)
        if !isExpands[4] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[4].1 {
                    cell.slider.value = Float(color.components.red) * 255
                    print("color.components.red=\(color.components.red)")
                }
            }
            cell.slider.index = 8
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 37: objectHidden(cell: cell)
        if !isExpands[4] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.numberOfLines = 2
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Text Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[4].1 {
                    cell.slider.value = Float(color.components.green) * 255
                    print("color.components.green=\(color.components.green)")
                }
            }
            cell.slider.index = 8
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 38: objectHidden(cell: cell)
        if !isExpands[4] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(100, 255, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[4].1 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 8
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 39: objectHidden(cell: cell)
        if !isExpands[4] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "red:"
            cell.slideName.textColor = .red
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[4].2 {
                    cell.slider.value = Float(color.components.red) * 255
                }
            }
            cell.slider.index = 9
            cell.slider.rgb = .red
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 40: objectHidden(cell: cell)
        if !isExpands[4] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideCategory.setTitleColor(.black, for: .normal)
            cell.slideCategory.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.slideCategory.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
            cell.slideCategory.titleLabel?.numberOfLines = 3
            cell.slideCategory.titleLabel?.textAlignment = .center
            cell.slideCategory.setTitle("Back ground Color", for: .normal)
            cell.slideName.isHidden = false
            cell.slideName.text = "green:"
            cell.slideName.textColor = .green
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[4].2 {
                    cell.slider.value = Float(color.components.green) * 255
                }
            }
            cell.slider.index = 9
            cell.slider.rgb = .green
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            }
        case 41: objectHidden(cell: cell)
        if !isExpands[4] {
            cell.isHidden = true
        }
        if skillList[MyVar.target.row].btnCount >= 5 {
            cell.addSubview(cell.slideCategory)
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(==50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cell.slideCategory]))
            cell.slideCategory.isHidden = false
            cell.slideCategory.backgroundColor = uiColor(255, 100, 255, 1.0)
            cell.slideName.isHidden = false
            cell.slideName.text = "blue:"
            cell.slideName.textColor = .blue
            cell.slider.isHidden = false
            if isFirstload {
                if let color = skillList[MyVar.target.row].buttons?[4].2 {
                    cell.slider.value = Float(color.components.blue) * 255
                }
            }
            cell.slider.index = 9
            cell.slider.rgb = .blue
            cell.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        }
        default:  objectHidden(cell: cell)
        }
        
        return cell
    }
    
    func objectHidden(cell: EditPopupCell) {
        cell.skillLabel.isHidden = true
        cell.skillTextField.isHidden = true
        cell.selectionStyle = .none
        cell.settingButtonTitleLabel.isHidden = true
    }
    
    func skillChangeAction(_ sender: UIButton) {
        print("skillChangeAction")
        skillChange(textField: (tableViewcell?.skillTextField)! )
    }
    
    func skillChange(textField: UITextField) {
        //confirm message after checking Coredata that has 1+ count
        if let fetchIfCount = CoreDataManager.fetchIfCountedObj(skillname: skillList[MyVar.target.row].skillName) {
            if fetchIfCount {
                showAlert(title: "Sorry!", message: "The count data is already registered. Please make a new skill instead to change the skill name. ", style: .alert)
                return
            }
        }
        if let skillText = textField.text {
            if skillText.characters.count > 30 {
                self.showAlert(title: "Error", message: "The name must be less than 31 characters!")
                return
            }
            var skillnameCollection: [String] = []
            for n in 0...(skillList.count-1) {
                skillnameCollection.append(skillList[n].skillName)
            }
            if skillnameCollection.contains(skillText) {
                print("skillnameCollection=\(skillnameCollection) skillText=\(skillText)")
                textField.text = skillList[MyVar.target.row].skillName
                self.showAlert(title: "Error", message: "You already have the same skillname!")
                return
            }
            CoreDataManager.updateSkillNameObj(newSkillname: skillText, oldSkillName: skillList[MyVar.target.row].skillName)
            skillList[MyVar.target.row].skillName = skillText
        } else {
            print("Empty input area")
            self.resignFirstResponder()
            self.showAlert(title: "Error", message: "Input a Skill name!", style: .alert)
        }
    }
    
    func stepperMinus(_ sender: StepperUIButton) {
        //confirm message after checking Coredata that has 1+ count
        if let fetchIfCount = CoreDataManager.fetchIfCountedObj(skillname: skillList[MyVar.target.row].skillName) {
            if fetchIfCount {
                showAlert(title: "Sorry!", message: "The count data is already registered. Please make a new skill instead to change the number of buttons. ", style: .alert)
                return
            }
        }
        
        sender.alpha = 1.0
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.5
        }
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 1.0
        }
        
        skillList[MyVar.target.row].btnCount -= 1
        if skillList[MyVar.target.row].btnCount == 0 {
            showAlert(title: "Error", message: "The skill must have at least one button!")
            skillList[MyVar.target.row].btnCount = 1
        } else {
            sender.cell?.numberOfButton.text = "\(skillList[MyVar.target.row].btnCount)"
            skillList[MyVar.target.row].buttons?.remove(at: skillList[MyVar.target.row].btnCount)
            skillList[MyVar.target.row].actions.remove(at: skillList[MyVar.target.row].btnCount)
            _ = CoreDataManager.updateBtnCountObj(skillname: skillList[MyVar.target.row].skillName, btnCount: skillList[MyVar.target.row].btnCount)
            CoreDataManager.deleteColorCoreData(skillname: skillList[MyVar.target.row].skillName)
            CoreDataManager.storeColors(skillname: skillList[MyVar.target.row].skillName, buttons: skillList[MyVar.target.row].buttons!)
            tableView.reloadData()
        }
    }
    func stepperPlus(_ sender: StepperUIButton) {
        //confirm message after checking Coredata that has 1+ count
        if let fetchIfCount = CoreDataManager.fetchIfCountedObj(skillname: skillList[MyVar.target.row].skillName) {
            if fetchIfCount {
                showAlert(title: "Sorry!", message: "The count data is already registered. Please make a new skill instead to change the number of buttons. ", style: .alert)
                return
            }
        }
        
        sender.alpha = 1.0
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.5
        }
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 1.0
        }
        
        skillList[MyVar.target.row].btnCount += 1
        if skillList[MyVar.target.row].btnCount == 6 {
            showAlert(title: "Sorry", message: "The skill can have at most 5 buttons.")
            skillList[MyVar.target.row].btnCount = 5
        } else {
            sender.cell?.numberOfButton.text = "\(skillList[MyVar.target.row].btnCount)"
            switch skillList[MyVar.target.row].btnCount {
            case 2: skillList[MyVar.target.row].buttons?.append(("button", uiColor(255,255,255,1.0), uiColor(128,128,255,1.0)))
            colors[2] = (255,255,255)
            colors[3] = (128,128,255)
            case 3: skillList[MyVar.target.row].buttons?.append(("button", uiColor(255,255,255,1.0), uiColor(127,84,175,1.0)))
            colors[4] = (255,255,255)
            colors[5] = (127,84,175)
            case 4: skillList[MyVar.target.row].buttons?.append(("button", uiColor(0,0,0,1.0), uiColor(100,255,100,1.0)))
            colors[6] = (0,0,0)
            colors[7] = (100,255,100)
            case 5: skillList[MyVar.target.row].buttons?.append(("button", uiColor(50,125,215,1.0), uiColor(255,150,0,1.0)))
            colors[8] = (50,125,215)
            colors[9] = (255,150,0)
            default: break
            }
            print("skillList[\(MyVar.target.row)].buttons=\(String(describing: skillList[MyVar.target.row].buttons))")
            _ = CoreDataManager.updateBtnCountObj(skillname: skillList[MyVar.target.row].skillName, btnCount: skillList[MyVar.target.row].btnCount)
            CoreDataManager.deleteColorCoreData(skillname: skillList[MyVar.target.row].skillName)
            CoreDataManager.storeColors(skillname: skillList[MyVar.target.row].skillName, buttons: skillList[MyVar.target.row].buttons!)
            skillList[MyVar.target.row].actions.append(0)
            tableView.reloadData()
        }
    }
    
    func sliderValueDidChange(_ sender: CustomUISlider) {
        isFirstload = false
        print("sliderValueDidChange")
        let roundedStepValue = round(sender.value / step) * step
        if let rgb = sender.rgb, let index = sender.index {
            print("rgb=\(rgb) index=\(index) roundedStepValue=\(roundedStepValue)")
            switch rgb {
                case .red: colors[index].red = CGFloat(roundedStepValue)
                case .green: colors[index].green = CGFloat(roundedStepValue)
                case .blue: colors[index].blue = CGFloat(roundedStepValue)
            }
            print("colors[index].red=\(colors[index].red) colors[index].green=\(colors[index].green) colors[index].blue=\(colors[index].blue)")
            print("skillList[MyVar.target.row].buttons=\(String(describing: skillList[MyVar.target.row].buttons))")
            switch index { //FIXME: IS there more efficient way?
                case 0: skillList[MyVar.target.row].buttons?[0].1 = uiColor(Int(colors[0].red), Int(colors[0].green), Int(colors[0].blue), 1.0)
                case 1: skillList[MyVar.target.row].buttons?[0].2 = uiColor(Int(colors[1].red), Int(colors[1].green), Int(colors[1].blue), 1.0)
                case 2: skillList[MyVar.target.row].buttons?[1].1 = uiColor(Int(colors[2].red), Int(colors[2].green), Int(colors[2].blue), 1.0)
                case 3: skillList[MyVar.target.row].buttons?[1].2 = uiColor(Int(colors[3].red), Int(colors[3].green), Int(colors[3].blue), 1.0)
                case 4: skillList[MyVar.target.row].buttons?[2].1 = uiColor(Int(colors[4].red), Int(colors[4].green), Int(colors[4].blue), 1.0)
                case 5: skillList[MyVar.target.row].buttons?[2].2 = uiColor(Int(colors[5].red), Int(colors[5].green), Int(colors[5].blue), 1.0)
                case 6: skillList[MyVar.target.row].buttons?[3].1 = uiColor(Int(colors[6].red), Int(colors[6].green), Int(colors[6].blue), 1.0)
                case 7: skillList[MyVar.target.row].buttons?[3].2 = uiColor(Int(colors[7].red), Int(colors[7].green), Int(colors[7].blue), 1.0)
                case 8: skillList[MyVar.target.row].buttons?[4].1 = uiColor(Int(colors[8].red), Int(colors[8].green), Int(colors[8].blue), 1.0)
                case 9: skillList[MyVar.target.row].buttons?[4].2 = uiColor(Int(colors[9].red), Int(colors[9].green), Int(colors[9].blue), 1.0)
                default: break
            }
        }
        tableView.reloadData()
    }
    
    //Expanding each button's cell
    func expandReduce(_ sender: CustomUIButton) {
        print("expandReduce index=\(String(describing: sender.index))")
        if let index = sender.index {
            if isExpands[index] {
                isExpands[index] = false
            } else {
                for n in 0...4 {
                    if n == index {
                        isExpands[n] = true
                        } else {
                        isExpands[n] = false //FIXME: It can break the layout
                    }
                }
            }
            print("isexpand=\(sender.isExpand)")
            isFirstload = true
            tableView.reloadData()
        }
    }
    
    //When changed the text field, the "Change" button appears.
    func editingChanged(_ sender: CustomUITextField) {
        print("editingChanged sender.index = \(String(describing: sender.index))")
        if let index = sender.index {
            btnNameChangeIndex = index
            switch index {
            case 0...4: tableViewcell?.btnNameChangeButtons[index].isHidden = false
            case 5: tableViewcell?.skillNameChangeButton.isHidden = false
            default: break
            }
        print("sender=\(sender)")
        }
        return
    }
    
    //When pressed "Change" button
    func btnNameChangeAction(_ sender: UIButton) {
        print("btnNameChangeAction")
        if let index = btnNameChangeIndex {
            switch index {
            case 0...4:
                tableViewcell?.btnNameTextField.resignFirstResponder()
                if let textField = tableViewcell?.btnNameTextField {
                    changeAction(textField: textField)
                }
            case 5:
                tableViewcell?.skillTextField.resignFirstResponder()
                if let textField = tableViewcell?.skillTextField {
                    skillChange(textField: textField)
                }
            default: break
            }
        }
    }
    
    //dismiss keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    //When pressed "return" button
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let index = btnNameChangeIndex {
            switch index {
            case 0...4:
                changeAction(textField: textField)
            case 5:
                skillChange(textField: textField)
            default: break
            }
        }
                
    }
    
    func changeAction(textField: UITextField) {
        print("changeAction")
        
        if textField.text != "" {
            
            if let index = btnNameChangeIndex {
                tableViewcell?.btnNameChangeButtons[index].isHidden = true
                if (textField.text?.characters.count)! > 10 {
                    textField.text = skillList[MyVar.target.row].buttons?[index].0
                    showAlert(title: "Error", message: "The name must be less than 11 characters!")
                    return
                }
                skillList[MyVar.target.row].buttons?[index].0 = textField.text!
                CoreDataManager.deleteColorCoreData(skillname: skillList[MyVar.target.row].skillName)
                CoreDataManager.storeColors(skillname: skillList[MyVar.target.row].skillName, buttons: skillList[MyVar.target.row].buttons!)
                tableView.reloadData()
            }
        } else {
            print("Empty input area")
            self.resignFirstResponder()
            showAlert(title: "Error", message: "Input skill name!")
        }
    }
    
    func backTapped() {
        if let buttons = skillList[MyVar.target.row].buttons {
            /*print("MyVar.nameChangeHistory=\(MyVar.nameChangeHistory)")
            if MyVar.nameChangeHistory.count > 0 {
                
                CoreDataManager.deleteSkillCoreData(object: MyVar.nameChangeHistory[0])
                CoreDataManager.deleteSkillCoreData(object: MyVar.nameChangeHistory[0], date: today)
                CoreDataManager.deleteColorCoreData(skillname: MyVar.nameChangeHistory[0])
            } else {
                CoreDataManager.deleteSkillCoreData(object: skillList[MyVar.target.row].skillName)
                CoreDataManager.deleteSkillCoreData(object: skillList[MyVar.target.row].skillName, date: today)
                CoreDataManager.deleteColorCoreData(skillname: skillList[MyVar.target.row].skillName)
            }
            CoreDataManager.storeObj(object: DayActions(number: skillList[MyVar.target.row].number, skillname: skillList[MyVar.target.row].skillName, btnCount: skillList[MyVar.target.row].btnCount))
            //CoreDataManager.dateAddToObjDetail(date: today, object: DayActions(number: skillList[MyVar.target.row].number, skillname: skillList[MyVar.target.row].skillName, btnCount: skillList[MyVar.target.row].btnCount))
            CoreDataManager.storeColors(skillname: skillList[MyVar.target.row].skillName, buttons: buttons)*/
            
            //For changing button colors
            CoreDataManager.deleteColorCoreData(skillname: skillList[MyVar.target.row].skillName)
            CoreDataManager.storeColors(skillname: skillList[MyVar.target.row].skillName, buttons: skillList[MyVar.target.row].buttons!)
            
            CoreDataManager.deleteColorCoreData()   // Delete Color CoreData whose skillname is nil
            
            if isInternetAvailable() && MyVar.serverConnect {
                //Server Maintenance Check
                let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/serverMaintenanceMessage.php"
                let contents: [[String : Any]] = HttpRequestController().sendGetRequestSynchronous(urlString: urlString)
                print(contents)
                if contents.count > 0 {
                    guard let info2 = contents[0]["info2"] as? String else {
                        return
                    }
                    if info2 != "NO" {
                        let alertController = UIAlertController(title: "Sorry", message: info2, preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                        alertController.addAction(okAction)
                   
                        present(alertController, animated: true, completion: nil)
                        
                    } else {
                        let urlString: String = "http://headspinnerd-com.stackstaging.com/bboying/btnUpdate.php"
                        var post: String = "username=\(MyVar.userName)&skillname=\(skillList[MyVar.target.row].skillName)&btnNum=\(skillList[MyVar.target.row].btnCount)"
                        for n in 0...(skillList[MyVar.target.row].btnCount-1) {
                            post = post + "&btnName\(n+1)=\(buttons[n].0)&btnTextColor\(n+1)=\(buttons[n].1.htmlRGBColor)&btnBkColor\(n+1)=\(buttons[n].2.htmlRGBColor)"
                        }
                        print("post=\(post)")
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
            }
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
}

enum Rgb {
    case red
    case green
    case blue
}

class CustomUISlider: UISlider {
    var index: Int?
    var rgb: Rgb?
}

class CustomUIButton: UIButton {
    var index: Int?
    var isExpand: Bool = false
}

class StepperUIButton: UIButton {
    var cell: EditPopupCell?
}

class CustomUITextField: UITextField {
    var index: Int?
}

protocol AlertDelegate { // FIXME: Not necessary??
    func showAlert(title: String, message: String?, style: UIAlertControllerStyle)
}

class EditPopupCell: UITableViewCell, UITextFieldDelegate {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let skillLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        return label
    }()
    let skillTextField: CustomUITextField = {
        let textField = CustomUITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        
        return textField
    }()
    let skillNameChangeButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        return button
    }()
    
    let numberOfButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        return label
    }()
    let numberOfButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        return label
    }()
    let stepperPlusButton: StepperUIButton = {
        let stepper = StepperUIButton()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    let stepperMinusButton: StepperUIButton = {
        let stepper = StepperUIButton()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    let expandIcon: CustomUIButton = {
        let button = CustomUIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let settingButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        return label
    }()
    let btnName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        return label
    }()
    let btnNameTextField: CustomUITextField = {
        let textField = CustomUITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        return textField
    }()
    let btnNameChangeButtons: [UIButton] = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        return [button,button,button,button,button]
    }()
    
    let slideCategory: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        return label
    }()
    let slideName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        return label
    }()
    let slider: CustomUISlider = {
        let slide = CustomUISlider()
        slide.translatesAutoresizingMaskIntoConstraints = false
        return slide
    }()
    
    var delegate: AlertDelegate?
    
    func setupViews() {
        skillNameChangeButton.isHidden = true
        numberOfButtonLabel.isHidden = true
        numberOfButton.isHidden = true
        stepperPlusButton.isHidden = true
        stepperMinusButton.isHidden = true
        btnName.isHidden = true
        btnNameTextField.isHidden = true
        slideName.isHidden = true
        slider.isHidden = true
        expandIcon.isHidden = true
        
        stepperPlusButton.frame.size = CGSize(width: 25, height: 25)
        stepperPlusButton.setImage(#imageLiteral(resourceName: "stepper1.png"), for: .normal)
        stepperPlusButton.contentMode = .scaleToFill
        stepperPlusButton.layer.cornerRadius = 12.5
        //stepperPlusButton.addTarget(self, action: #selector(stepperPlus), for: .touchUpInside)
        stepperPlusButton.clipsToBounds = true
        
        stepperMinusButton.frame.size = CGSize(width: 25, height: 25)
        stepperMinusButton.setImage(#imageLiteral(resourceName: "stepper2.png"), for: .normal)
        stepperMinusButton.contentMode = .scaleToFill
        stepperMinusButton.layer.cornerRadius = 12.5
        //stepperMinusButton.addTarget(self, action: #selector(stepperMinus), for: .touchUpInside)
        stepperMinusButton.clipsToBounds = true
        
        expandIcon.frame.size = CGSize(width: 25, height: 25)
        expandIcon.contentMode = .scaleToFill
        
        skillLabel.text = "Skill:"
        numberOfButtonLabel.text = "Number of counter buttons: "
        numberOfButton.text = "\(skillList[MyVar.target.row].btnCount)"
        skillTextField.text = "\(skillList[MyVar.target.row].skillName)"
        skillTextField.textAlignment = .left
        skillNameChangeButton.setTitle("Change", for: .normal)
        //skillTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        //skillNameChangeButton.addTarget(self, action: #selector(skillNameChangeAction), for: .touchUpInside)
        skillTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        skillTextField.layer.cornerRadius = 3
        
        btnName.text = "Button Name:"
        btnNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        btnNameTextField.layer.cornerRadius = 3
        
        slideName.textAlignment = .right
        
        slider.frame.size = CGSize(width: 300, height: 20)
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.tintColor = .red
        
        addSubview(skillLabel)
        addSubview(skillNameChangeButton)
        addSubview(skillTextField)
        addSubview(numberOfButtonLabel)
        addSubview(numberOfButton)
        addSubview(stepperPlusButton)
        addSubview(stepperMinusButton)
        addSubview(settingButtonTitleLabel)
        addSubview(btnName)
        addSubview(btnNameTextField)
        addSubview(slideName)
        addSubview(slider)
        addSubview(expandIcon)
        
        for btnNameChangeButton in btnNameChangeButtons {
            btnNameChangeButton.isHidden = true
            addSubview(btnNameChangeButton)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btnNameChangeButton]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btnNameChangeButton]))
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(>=200)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": skillLabel, "v1": skillTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": skillNameChangeButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(>=80)][v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberOfButtonLabel, "v1": numberOfButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-1-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": stepperMinusButton, "v0": stepperPlusButton]))
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v1(==25)][v0(>=80)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": settingButtonTitleLabel, "v1": expandIcon]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-48-[v0(==100)][v1(==80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btnName, "v1": btnNameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-8-[v2(==200)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": slideName, "v2": slider]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": skillLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": skillTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": skillNameChangeButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberOfButtonLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberOfButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=9.5)-[v0(==25)]-(>=9.5)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": stepperPlusButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=9.5)-[v0(==25)]-(>=9.5)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": stepperMinusButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=9.5)-[v0(==25)]-(>=9.5)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": expandIcon]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": settingButtonTitleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btnName]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[v0]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btnNameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": slideName]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": slider]))
        
        skillTextField.delegate = self
    }
    
    /*func skillNameChangeAction() {
        skillTextField.resignFirstResponder()
        changeAction()
    }*/
    
    func textFieldDidBeginEditing(_ textField : UITextField)
    {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
    }
    
    /*func textFieldDidEndEditing(_ textField: UITextField) {
        skillNameChangeButton.isHidden = true
        changeAction()
    }*/
    
    /*func changeAction() {
        print("changeAction")
    }*/
    
    /*func editingChanged(_ textField: UITextField) {
        skillNameChangeButton.isHidden = false
        return
    }
    
    //dismiss keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func stepperPlus() {
        print("stepperPlus tapped")
        
    }
    
    func stepperMinus() {
        print("stepperMinus tapped")
        
    }*/

}
