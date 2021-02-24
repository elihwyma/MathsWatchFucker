//
//  main.swift
//  MathsWatchFucker
//
//  Created by AW on 05/01/2021.
//

import Foundation

let logins: [String] = [:]
let password = ""

var buffer = 0
let mlm = MathsWatchLoginManager()
mlm.id = 4932106
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
            QAP.shared.parseHomework()
            QAP.shared.parseAnswers()
            QAP.shared.printInfoFancily()
            return
        }
        work()

    })
}

work()
RunLoop.main.run()
