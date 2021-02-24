//
//  NetworkManager.swift
//  libCentralis
//
//  Created by AW on 18/10/2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias completionHandler = (_ success: Bool, _ error: String?) -> ()

internal class NetworkManager {

    internal typealias rdc = (_ success: Bool, _ dict: [String : Any]) -> ()
    
    internal func generateStringFromDict(_ dict: [String : String]) -> String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return "Error"
    }
    
    class internal func getcsrf() -> String? {
        if let cookies = HTTPCookieStorage.shared.cookies {
            if let cookie = cookies.first(where: { $0.name == "_csrf"}) {
                return cookie.value
            }
        }
        return nil
    }
    
    class internal func requestWithSettingCookies(url: String?, requestMethod: String, headers: [String : String]?, body: [String : Any]?, completion: @escaping rdc) {
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = requestMethod
        if let body = body {
            let jsonData = try! JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        if let headers = headers {
            for header in headers.keys {
                request.setValue(headers[header], forHTTPHeaderField: header)
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(NetworkManager.getcsrf() ?? "V3LBpWIn-ZqeIyqsSydfHUWmbI-SpkeqEhaw", forHTTPHeaderField: "X-CSRF-Token")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                do {
                    let httpUrlResponse = response as! HTTPURLResponse
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: httpUrlResponse.allHeaderFields as NSDictionary as! [String : String], for: (response?.url!)!)
                    HTTPCookieStorage.shared.setCookies(cookies, for: response?.url!, mainDocumentURL: nil)
                    let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] ?? [String : Any]()
                    completion(true, dict)
                } catch {
                    completion(false, [String : Any]())
                }
            } else { completion(false, [String : Any]()) }
        }
        task.resume()
    }
}
