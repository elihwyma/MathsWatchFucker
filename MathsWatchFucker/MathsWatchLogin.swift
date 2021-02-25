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
                    if mark == 0 { return completionHandler(true, "Student has a score of 0, waste of my time")}
                    if QAP.shared.cachedBestQuestion == nil {
                        NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/assignedwork/\(self.id)?id=\(self.id)", requestMethod: "GET", headers: nil, body: nil, completion: {(success, dict) -> Void in
                            QAP.shared.cachedBestQuestion = dict["data"] as? [String : Any] ?? [String : Any]()
                            print("Got the question")
                        })
                    }
                    NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/answers?assignedwork_id=\(self.id)", requestMethod: "GET", headers: nil, body: nil, completion: {(success, dict) -> Void in
                        QAP.shared.cachedAnswers.append(dict["data"] as? [[String : Any]] ?? [[String : Any]]())
                        NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/logout", requestMethod: "GET", headers: nil    , body: nil, completion: {(success, dict) -> Void in
                            return completionHandler(true, "Got everything quite happily from a student :)")
                        })
                    })
                })
            })
        })
    }
    
    public func hahauwucatgirls(username: String, password: String, _ completionHandler: @escaping completionHandler) {
        NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/users/me", requestMethod: "GET", headers: nil, body: nil, completion: {(sucess, dict) -> Void in
            let body: [String : Any] = [
                "username" : username,
                "password" : password
            ]
            NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/login", requestMethod: "POST", headers: nil, body: body, completion: {(success, dict) -> Void in
                if let message = dict["message"] as? String { if message == "You are logged in on too many computers. Please log off your last machine or try again in an hour." { fatalError("You fucking idiot, you're rate limited") } }
                NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/answers?assignedwork_id=\(self.id)", requestMethod: "GET", headers: nil, body: nil, completion: {(success, dict) -> Void in
                    guard let wap = QAP.shared.cachedBestAnswer else { return completionHandler(false, "Failed to parse the answers" )}
                    for bigchungus in wap {
                        guard let question_id = bigchungus["question_id"] as? Int else { return }
                        var dick: [String : Any] = [
                            "correct" : bigchungus["correct"] ?? false,
                            "timeused" : bigchungus["timeused"] ?? 5,
                            "question_id" : question_id,
                            "assignedwork_id" : self.id
                        ]
                        guard let answer = bigchungus["answer"] as? [[String : Any]] else { fatalError("FUCKING JDHKJHHAFKJDASHFDSAB") }
                        dick["answer"] = answer
                        NetworkManager.requestWithSettingCookies(url: "https://vle.mathswatch.co.uk/duocms/api/answers", requestMethod: "POST", headers: nil, body: dick, completion: {(sucess, dict) -> Void in
                            if success {
                                print("Set answer for question \(question_id)")
                            } else {
                                print("Network request failed for setting \(question_id)")
                            }
                        })
                    }
                })
                completionHandler(true, nil)
            })
        })
    }
}
