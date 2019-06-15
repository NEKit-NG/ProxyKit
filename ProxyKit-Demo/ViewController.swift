//
//  ViewController.swift
//  ProxyKit-Demo
//
//  Created by Dell 7460 on 2019/6/13.
//  Copyright © 2019 NEKit-NG Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var labelProxyDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelProxyDesc.text = ""
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let httpProxy = myDelegate.httpProxy {
                labelProxyDesc.text = labelProxyDesc.text! + httpProxy.description + "\n\n"
            }
            if let socks5Proxy = myDelegate.socks5Proxy {
                labelProxyDesc.text = labelProxyDesc.text! + socks5Proxy.description
            }
        }
    }


}

