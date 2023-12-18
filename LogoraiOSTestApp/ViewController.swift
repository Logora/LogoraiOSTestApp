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
        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIxMjU2NyIsImZpcnN0X25hbWUiOiJTT01BWUEgQVNTQUFESSIsImxhc3RfbmFtZSI6IkFTU0FBRCIsImVtYWlsIjoiYXNzYWFkaUBnbWFpbC5jb20ifQ.d_QglgKdYsiHI2_6SSRjgYdY_mnqz54dp9AR8jiInuY"
        let widgetViewController = WidgetView(applicationName: "logora-demo-app", pageUid: "mon-article", assertion: token)
        self.addChild(widgetViewController)
        widgetViewController.view.frame = CGRect(x: 110, y: 80, width: 200, height: 250)
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(widgetViewController.view)
        widgetViewController.didMove(toParent: self)
    }
}




