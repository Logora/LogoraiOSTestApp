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
        /*let logoraApp = LogoraApp(applicationName: "logora-demo-app", routeName: "INDEX", routeParam: nil)
        addChild(logoraApp)
        view.addSubview(logoraApp.view)
        logoraApp.didMove(toParent: self)*/
    }
    
func initLayout() {
    /*let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIxMjM0NTY1NDYiLCJmaXJzdF9uYW1lIjoiSm9obiIsImxhc3RfbmFtZSI6IkRvZSIsImVtYWlsIjoiam9obkBnbWFpbC5jb20ifQ.DVIBD06B5JYa6wi96IvDDdGtMtaPbWR3gCF06qElAcQ"*/
   /* let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIxMjMiLCJmaXJzdF9uYW1lIjoiTmF0aGFsaWUiLCJsYXN0X25hbWUiOiJOYXRoYWxpZSIsImVtYWlsIjoibmF0aGFsaWVAZ21haWwuY29tIn0.x0NvHdAP7Mri0c6wlDaZJeJFOgCU0yOi85xVQLFA63E"*/
    let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIxMjM0IiwiZmlyc3RfbmFtZSI6ImxvdWljIiwibGFzdF9uYW1lIjoibG91aWMiLCJlbWFpbCI6ImxvdWljQGdtYWlsLmNvbSJ9.H7hNO7xR-A6SjYFdtyvzFfaV6baW976_2H1qizCt4GA"
  
    let widgetViewController = WidgetView(applicationName: "logora-demo-app", pageUid: "mon-article", assertion: token)
    self.addChild(widgetViewController)
    widgetViewController.view.frame = CGRect(x: 110, y: 80, width: 200, height: 250)
    self.view.backgroundColor = UIColor.white
    self.view.addSubview(widgetViewController.view)
    widgetViewController.didMove(toParent: self)
     }
}




