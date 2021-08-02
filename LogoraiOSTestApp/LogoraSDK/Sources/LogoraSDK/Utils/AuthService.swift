import Foundation

class AuthService {
    static let sharedInstance = AuthService()
    private var apiClient = APIClient.sharedInstance
    private var assertion: String?
    private var isLoggedIn: Bool = false;
    private var isLoggingIn: Bool = false;
    private var authError: String = "";
    var currentUser: User?

    weak var listener : AuthChangeListener? = nil

    public func authenticate(completion: @escaping () -> Void) {
        if(hasSession()) {
            if(isLoggedInRemotely()) {
                if(isSameUser()) {
                    self.fetchUser(successFetch: {
                        completion()
                    });
                } else {
                    self.logoutUser();
                    self.loginUser(successLogin: {
                        completion()
                    });
                }
            } else {
                self.logoutUser();
            }
        } else {
            if(isLoggedInRemotely()) {
                self.loginUser(successLogin: {
                    completion()
                });
            } else {
                self.logoutUser();
            }
        }
    }

    public func loginUser(successLogin: (() -> Void)?) {
        self.apiClient.userAuth(completion: { token in
            self.fetchUser(successFetch: {
                successLogin!()
            })
        })
    }

    public func fetchUser(successFetch: (() -> Void)?) {
        self.apiClient.getCurrentUser(completion: { user in
            if (user.id != nil) {
                self.setCurrentUser(currentUser: user)
                self.setLoggedIn(loggedIn: true)
                self.setLoggingIn(loggingIn: false)
                self.listener?.authChanged(success: true)
                successFetch!()
            } else {
                self.exitLogin(error: "Error")
            }
        })
    }

    public func logoutUser() {
        self.setLoggedIn(loggedIn: false)
        self.setLoggingIn(loggingIn: false)
        self.currentUser = nil
        self.listener?.authChanged(success: false)
        self.apiClient.deleteUserToken()
    }

    public func exitLogin(error: String) {
        self.setAuthError(authError: error)
        self.setLoggedIn(loggedIn: false)
        self.setLoggingIn(loggingIn: false)
    }

    public func hasSession() -> Bool {
        return (apiClient.getUserTokenObject() != nil)
    }

    public func isLoggedInRemotely() -> Bool {
        let authAssertion: String = self.apiClient.getAuthAssertion()
        return authAssertion != ""
    }

    public func isSameUser() -> Bool {
        return true;
    }

    public func getLoggedIn() -> Bool {
        return isLoggedIn;
    }

    public func setLoggedIn(loggedIn: Bool) {
        isLoggedIn = loggedIn;
    }

    public func getLoggingIn() -> Bool {
        return isLoggingIn;
    }

    public func setLoggingIn(loggingIn: Bool) {
        isLoggingIn = loggingIn;
    }

    public func getCurrentUser() -> User {
        return currentUser!;
    }

    public func setCurrentUser(currentUser: User) {
        self.currentUser = currentUser;
    }

    public func getAuthError() -> String {
        return authError;
    }

    public func setAuthError(authError: String) {
        self.authError = authError;
    }
}

@objc protocol AuthChangeListener: AnyObject {
    func authChanged(success: Bool)
}
