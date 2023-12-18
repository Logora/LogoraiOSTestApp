//
//  ViewController.swift
//  ProjectTest
//
//  Created by Logora mac on 22/06/2023.
//

import UIKit
import LogoraSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Page article"
        initLayout()
    }
    
    func initLayout() {
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIxMjM0IiwiZmlyc3RfbmFtZSI6ImxvdWljIiwibGFzdF9uYW1lIjoibG91aWMiLCJlbWFpbCI6ImxvdWljQGdtYWlsLmNvbSJ9.H7hNO7xR-A6SjYFdtyvzFfaV6baW976_2H1qizCt4GA"
        let widgetViewController = WidgetView(applicationName: "logora-demo-app", pageUid: "mon-article", assertion: token)
        self.addChild(widgetViewController)
        widgetViewController.view.frame = CGRect(x: 110, y: 80, width: 200, height: 250)
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(widgetViewController.view)
        widgetViewController.didMove(toParent: self)
    }
}




