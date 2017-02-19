//
//  ViewController.swift
//  WYCDynamicTextController
//
//  Created by neycwang@gmail.com on 02/19/2017.
//  Copyright (c) 2017 neycwang@gmail.com. All rights reserved.
//

import WYCDynamicTextController

class ViewController: WYCDynamicTextController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .red
        textField.placeholder = "Tap to edit"
    }
}
