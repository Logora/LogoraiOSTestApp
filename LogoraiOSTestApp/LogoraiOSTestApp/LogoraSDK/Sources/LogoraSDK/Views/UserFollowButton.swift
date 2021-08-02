//
//  UserFollowButton.swift
//  LogoraSDK
//
//  Created by Logora mac on 25/05/2021.
//

import Foundation
import UIKit

class UserFollowButton: UIButton {
    let settings: SettingsProvider = SettingsProvider.sharedInstance
    let apiClient: APIClient = APIClient.sharedInstance
    let authService: AuthService = AuthService.sharedInstance
    private var user: User?
    private var active: Bool = false
    
    required init() {
        super.init(frame: .zero)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    func setup() {
        self.setInactive();
    }

    func setActive() {
        self.active = true
        self.isEnabled = true
    }

    func setInactive() {
        self.active = false
        self.isEnabled = false
    }

    func follow() {
        self.setActive()
        self.isEnabled = false
        self.apiClient.followDebate(debateSlug: (self.user?.slug!)!, completion: { debate in
            DispatchQueue.main.async {
            }
        })
    }

    func unfollow() {
        self.setActive()
        self.isEnabled = false
        self.apiClient.unfollowDebate(debateSlug: (self.user?.slug!)!, completion: { debate in
            DispatchQueue.main.async {
            }
        })
    }

    func initView(user: User) {
        self.user = user
        if(self.authService.getLoggedIn()) {
            self.apiClient.getDebateFollow(debateId: (self.user?.id!)!, completion: { following in
                DispatchQueue.main.async {
                    if(following.follow == true) {
                        self.setActive()
                    }
                }
            })
        }
    }
}
