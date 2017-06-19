//
//  ChartsSettingVC.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-04-11.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit

class ChartsSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
    }

    func goBack(){
        dismiss(animated: true, completion: nil)
    }


}
