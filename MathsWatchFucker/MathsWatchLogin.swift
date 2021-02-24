//
//  MathsWatchLogin.swift
//  MathsWatchFucker
//
//  Created by AW on 24/02/2021.
//

import Foundation

class MathsWatchLoginManager {
    
    var id = 0
    
    public func hahauwufuckyou(username: String, password: String, _ completionHandler: @escaping completionHandler) {
        NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/users/me", requestMethod: "GET", headers: nil, body: nil, completion: {(sucess, dict) -> Void in
            let body: [String : Any] = [
                "username" : username,
                "password" : password
            ]
            NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/login", requestMethod: "POST", headers: nil, body: body, completion: {(success, dict) -> Void in

                if let message = dict["message"] as? String { if message == "You are logged in on too many computers. Please log off your last machine or try again in an hour." { fatalError("You fucking idiot, you're rate limited") } }
                NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/assignedwork/student?recent=true", requestMethod: "GET", headers: nil, body: nil, completion: {(sucess, dict) -> Void in
                    let data = dict["data"] as? [[String : Any]] ?? [[String : Any]]()
                    guard let homework: [String : Any] = data.first(where: { $0["id"] as! Int == self.id }) else { return completionHandler(false, "Failed to find homework for \(username)") }
                    guard let mark = homework["student_marks"] as? Int else { return completionHandler(true, "Student has no mark") }
                    if mark > QAP.shared.cachedBestScore {
                        NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/assignedwork/\(self.id)?id=\(self.id)", requestMethod: "GET", headers: nil, body: nil, completion: {(success, dict) -> Void in
                            QAP.shared.cachedBestQuestion = dict["data"] as? [String : Any] ?? [String : Any]()
                            NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/answers?assignedwork_id=\(self.id)", requestMethod: "GET", headers: nil, body: nil, completion: {(success, dict) -> Void in
                                QAP.shared.cachedBestAnswer = dict["data"] as? [[String : Any]] ?? [[String : Any]]()
                                QAP.shared.cachedBestScore = mark
                                NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/logout", requestMethod: "GET", headers: nil	, body: nil, completion: {(success, dict) -> Void in
                                    return completionHandler(true, nil)
                                })
                            })
                        })
                    } else {
                        return completionHandler(true, nil)
                    }
                })
            })
        })
    }
}
