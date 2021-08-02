import Foundation

class APIClient {
    let apiManager = APIManager()
    static let sharedInstance = APIClient()
    let apiUrl: String = "https://staging.logora.fr/api/v1"
    let authUrl: String = "https://staging.logora.fr/oauth"
    let userTokenKey: String = "logora_user_token"
    let userSessionKey: String = "logora_session"
    var authAssertion: String!
    var applicationName: String!
    var userTokenObject: Token?
}

extension APIClient {
    // CLIENT METHODS
    func getSettings(completion handler: @escaping ([String: Any]) -> Void) {
        guard let url = URL(string: self.apiUrl + "/settings") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.urlQueryParameters.add(value: "logora-demo", forKey: "shortname")
        apiManager.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let data = json["data"] as! [String:Any]
                    let resource = data["resource"] as! [String:Any]
                    handler(resource)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func getList<T: Codable>(resourcePath: String, resource: T.Type, page: Int = 1, perPage: Int = 10, sort: String = "-created_at", outset: Int = 0, query: String = "", completion handler: @escaping ([T], Int, Int) -> Void,
            error errorHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: self.apiUrl + "/" + resourcePath) else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.urlQueryParameters.add(value: "\(page)", forKey: "page")
        apiManager.urlQueryParameters.add(value: "\(perPage)", forKey: "per_page")
        apiManager.urlQueryParameters.add(value: "\(outset)", forKey: "outset")
        apiManager.urlQueryParameters.add(value: "\(sort)", forKey: "sort")
        if query != "" {
            apiManager.urlQueryParameters.add(value: "\(query)", forKey: "query")
        }
        if (resourcePath == "notifications") {
            apiManager.makeUserRequest(toURL: url, withHttpMethod: .get, authorizationHeader: self.getUserAuthorizationHeader(), completion: { (results) in
                guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    print("PRINT JSON", json)
                    let decoder = JSONDecoder()
                    let list = try JSONSerialization.data(withJSONObject: json["data"]!)
                    let totalItems = Int(results.response?.headers.value(forKey: "total") ?? "0" )! as Int
                    let totalPages = Int(results.response?.headers.value(forKey: "total-pages") ?? "0" )! as Int
                    let decodedData = try decoder.decode([T].self, from: list)
                    handler(decodedData, totalItems, totalPages)
                } catch {
                    print("error: ", error)
                }
            })
        } else {
            apiManager.makeClientRequest(toURL: url, withHttpMethod: .get, completion: { (results) in
                guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let list = try JSONSerialization.data(withJSONObject: json["data"]!)
                    let totalItems = Int(results.response?.headers.value(forKey: "total") ?? "0" )! as Int
                    let totalPages = Int(results.response?.headers.value(forKey: "total-pages") ?? "0" )! as Int
                    let decodedData = try decoder.decode([T].self, from: list)
                    handler(decodedData, totalItems, totalPages)
                } catch {
                    print("error: ", error)
                }
            }, errorCallback: { (error) in
                guard let data = error.data else { return }
                errorHandler(data)
            })
        }
    }
    
    func getDebate(slug: String, 
                   completion handler: @escaping (Debate) -> Void,
                   error errorHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: self.apiUrl + "/groups/\(slug)") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeClientRequest(toURL: url, withHttpMethod: .get, completion: { (results) in
            guard let data = results.data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let jsonData = json["data"] as! [String:Any]
                let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Debate.self, from: resource)
                handler(decodedData)
            } catch {
                print("error: ", error)
            }
        }, errorCallback: { (error) in
            guard let data = error.data else { return }
            errorHandler(data)
        })
    }

    func getSynthesis(uid: String, applicationName: String, completion handler: @escaping (DebateSynthesis) -> Void,
                      error errorHandler: @escaping (Data) -> Void) {
      guard let url = URL(string: self.apiUrl + "/groups/" + "/\(uid)" + "/synthesis") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.httpBodyParameters.add(value: applicationName, forKey: "application_name")
        apiManager.makeClientRequest(toURL: url, withHttpMethod: .get, completion: { (results) in
            guard let data = results.data else { return }
            do {
              let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
              let decoder = JSONDecoder()
              let data = try JSONSerialization.data(withJSONObject: json["data"]!)
              let decodedData = try decoder.decode(DebateSynthesis.self, from: data)
              handler(decodedData)
            } catch {
              print("error: ", error)
            }
        }, errorCallback: { (error) in
            guard let data = error.data else { return }
            errorHandler(data)
        })
    }
    
    func getUser(slug: String, completion handler: @escaping (User) -> Void, error errorHandler: @escaping (Data) -> Void) {
        guard let url = URL(string: self.apiUrl + "/users/\(slug)") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeClientRequest(toURL: url, withHttpMethod: .get, completion: { (results) in
            guard let data = results.data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let decoder = JSONDecoder()
                let jsonData = json["data"] as! [String:Any]
                let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                let decodedData = try decoder.decode(User.self, from: resource)
                handler(decodedData)
            } catch {
                print("error: ", error)
            }
        }, errorCallback: { (error) in
            guard let data = error.data else { return }
            errorHandler(data)
        })
    }

    // USER METHODS
    func getCurrentUser(completion handler: @escaping (User) -> Void) {
        guard let url = URL(string: self.apiUrl + "/me") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.requestHttpHeaders.add(value: self.getUserAuthorizationHeader(), forKey: "Authorization")
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .get, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(User.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func getDebateVote(id: Int, completion handler: @escaping (DebateVote) -> Void) {
        guard let url = URL(string: self.apiUrl + "/users/group/" + "\(id)" + "/vote") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .get, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
              do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData)
                    let decodedData = try decoder.decode(DebateVote.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func createVote(voteableId: String, voteableType: String, positionId: Int? = nil, completion handler: @escaping (Vote) -> Void) {
        guard let url = URL(string: self.apiUrl + "/votes") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.httpBodyParameters.add(value: voteableId, forKey: "voteable_id")
        apiManager.httpBodyParameters.add(value: voteableType, forKey: "voteable_type")
        if(positionId != nil) {
            apiManager.httpBodyParameters.add(value: String(positionId!), forKey: "position_id")
        }
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .post, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            print("CREATE VOTE RESPONSE", response)
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(Vote.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }    

    func updateVote(voteId: Int, positionId: Int? = nil, completion handler: @escaping (Vote) -> Void) {
        guard let url = URL(string: self.apiUrl + "/votes/" + String(voteId)) else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        if(positionId != nil) {
            apiManager.httpBodyParameters.add(value: String(positionId!), forKey: "position_id")
        }
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .patch, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(Vote.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func updateArgument(argumentId: Int, argumentContent: String, completion handler: @escaping (Decodable) -> Void) {
        guard let url = URL(string: self.apiUrl + "/messages/" + String(argumentId)) else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.httpBodyParameters.add(value: argumentContent, forKey: "content")
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .patch, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(Message.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func deleteVote(voteId: Int, completion handler: @escaping (Vote) -> Void) {
        guard let url = URL(string: self.apiUrl + "/votes/ + voteId") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .delete, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(Vote.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }   

    func deleteArgument(argumentId: Int, completion handler: @escaping (Decodable) -> Void) {
        guard let url = URL(string: self.apiUrl + "/messages/" + "\(argumentId)") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .delete, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return } 
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(Message.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func getDebateFollow(debateId: Int, completion handler: @escaping (Following) -> Void){
      guard let url = URL(string: self.apiUrl + "/group_followings/" + "\(debateId)") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .get, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
              do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData)
                    let decodedData = try decoder.decode(Following.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func followDebate(debateSlug: String, completion handler: @escaping (Following) -> Void){
      guard let url = URL(string: self.apiUrl + "/groups/" + debateSlug + "/follow") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .post, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
              do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData)
                    let decodedData = try decoder.decode(Following.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func unfollowDebate(debateSlug: String, completion handler: @escaping (Following) -> Void){
      guard let url = URL(string: self.apiUrl + "/groups/" + debateSlug + "/unfollow") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .post, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
              do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData)
                    let decodedData = try decoder.decode(Following.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func createReport(reportableId: String, reportableType: String, classification: String, description: String, completion handler: @escaping (Decodable) -> Void) {
        guard let url = URL(string: self.apiUrl + "/reports") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.httpBodyParameters.add(value: reportableId, forKey: "reportable_id")
        apiManager.httpBodyParameters.add(value: reportableType, forKey: "reportable_type")
        apiManager.httpBodyParameters.add(value: classification, forKey: "classification")
        apiManager.httpBodyParameters.add(value: description, forKey: "description")
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .post, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(Debate.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func readNotification(notificationId: Int, completion handler: @escaping (UserNotification) -> Void) {
        guard let url = URL(string: self.apiUrl + "/notifications/read/" + String(notificationId)) else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .post, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(UserNotification.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func readAllNotification(completion handler: @escaping (Success) -> Void) {
        guard let url = URL(string: self.apiUrl + "/notifications/read/all") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .post, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json
                    let resource = try JSONSerialization.data(withJSONObject: jsonData)
                    let decodedData = try decoder.decode(Success.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func createArgument(debateId: Int, messageId: Int? = nil, argumentContent: String, positionId: Int? = nil, isReply: Bool, completion handler: @escaping (Decodable) -> Void) {
        guard let url = URL(string: self.apiUrl + "/messages") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        if(positionId != nil) {
            apiManager.httpBodyParameters.add(value: String(positionId!), forKey: "position_id")
        }
        apiManager.httpBodyParameters.add(value: String(debateId), forKey: "group_id")
        apiManager.httpBodyParameters.add(value: argumentContent, forKey: "content")
        apiManager.httpBodyParameters.add(value: String(isReply), forKey: "is_reply")
        if(messageId != nil) {
            apiManager.httpBodyParameters.add(value: String(messageId!), forKey: "message_id")
        }
        apiManager.makeUserRequest(toURL: url, withHttpMethod: .post, authorizationHeader: self.getUserAuthorizationHeader()) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 || response.httpStatusCode == 201 {
              guard let data = results.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                    let decoder = JSONDecoder()
                    let jsonData = json["data"] as! [String:Any]
                    let resource = try JSONSerialization.data(withJSONObject: jsonData["resource"]!)
                    let decodedData = try decoder.decode(Message.self, from: resource)
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    // AUTH METHODS
    func userAuth(completion handler: @escaping (Token) -> Void) {
        guard let url = URL(string: self.authUrl + "/token") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.httpBodyParameters.add(value: "assertion", forKey: "grant_type")
        apiManager.httpBodyParameters.add(value: self.authAssertion!, forKey: "assertion")
        apiManager.httpBodyParameters.add(value: "form", forKey: "assertion_type")
        apiManager.httpBodyParameters.add(value: self.applicationName!, forKey: "provider")
        apiManager.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        apiManager.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Token.self, from: data)
                    print(decodedData)
                    self.userTokenObject = decodedData
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    func userRefresh(completion handler: @escaping (Token) -> Void) {
        guard let url = URL(string: self.authUrl + "/token") else { return }
        apiManager.requestHttpHeaders.removeAllItems()
        apiManager.urlQueryParameters.removeAllItems()
        apiManager.httpBodyParameters.removeAllItems()
        apiManager.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        apiManager.httpBodyParameters.add(value: "refresh_token", forKey: "grant_type") // settings variable ?
        apiManager.httpBodyParameters.add(value: getUserRefreshToken(), forKey: "refresh_token")
        apiManager.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Token.self, from: data)
                    self.userTokenObject = decodedData
                    handler(decodedData)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
    }

    // TOKEN FUNCTION
    func getUserAuthorizationHeader() -> String {
        if self.userTokenObject != nil {
            return "Bearer \(userTokenObject!.accessToken)"
        } else {
            return ""
        }
    }

    func setUserToken(token: Token) {
      // TO DO
    }

    func getUserTokenObject() -> Token? {
        return self.userTokenObject ?? nil
    }

    func getUserToken() -> String {
        return self.userTokenObject!.accessToken
    }

    func getUserRefreshToken() -> String {
        return self.userTokenObject!.refreshToken
    }
    
    func getAuthAssertion() -> String {
        return self.authAssertion!
    }
    
    func deleteUserToken() {
        self.userTokenObject = nil
    }


    /* STORAGE FUNCTIONS */
    func setStorageItem(key: String, value: String) {
        let defaults = UserDefaults.standard
        do {
            let data = value.data(using: .utf8)!
            let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
            defaults.set(json, forKey: key)
        } catch {
            print("error: ", error)
        }
    }

    func getStorageItem(key: String) -> String {
        let defaults = UserDefaults.standard
        if let value = defaults.string(forKey: key) {
            return value
        }
        return ""
    }

    func deleteStorageItem(key: String) {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: key)
    }
}
