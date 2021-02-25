//
//  main.swift
//  MathsWatchFucker
//
//  Created by AW on 05/01/2021.
//

import Foundation

let logins = [
    ""
]

let password = ""

let masterUser = ""
let masterPassword = ""

let mlm = MathsWatchLoginManager()
mlm.id = 1

var buffer = 0
func work() {
    mlm.hahauwufuckyou(username: logins[buffer], password: password, {(success, dict) -> Void in
        if success {
            print("Succesfully scraped the user at \(logins[buffer])")
        } else {
            print(dict!)
        }
        buffer += 1
        if buffer == logins.count  {
            print("User \(logins[buffer - 1]) had the best mark with \(QAP.shared.cachedBestScore)")
            mlm.hahauwucatgirls(username: masterUser, password: masterPassword, {(success, dict) -> Void in
                print("\(masterUser) now has \(QAP.shared.cachedBestScore) marks")
            })
            return
        }
        work()

    })
}

work()
RunLoop.main.run()
