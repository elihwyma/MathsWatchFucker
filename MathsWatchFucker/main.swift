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
func scrapeEveryone() {
    mlm.hahauwufuckyou(username: logins[buffer], password: password, {(success, dict) -> Void in
        if success {
            print("Succesfully scraped the user at \(logins[buffer])")
        } else {
            print(dict!)
        }
        buffer += 1
        if buffer == logins.count  {
            generateTheBestAnswer()
            applyToMaster()
            return
        }
        scrapeEveryone()
    })
}

func applyToMaster() {
    mlm.hahauwucatgirls(username: masterUser, password: masterPassword, {(success, dict) -> Void in
        print("\(masterUser) now has (in theory) the best answer I could generate")
    })
}

func generateTheBestAnswer() {
    QAP.shared.parseHomework()
    if QAP.shared.cachedAnswers.count == 0 {
        fatalError("Nobody has done any work, fuckers")
    }
    QAP.shared.cachedBestAnswer = QAP.shared.cachedAnswers[0]
    for id in QAP.shared.homework.questions {
        var cum = [[String : Any]]()
        for test in QAP.shared.cachedAnswers {
            guard let question = test.first(where: {$0["question_id"] as? Int == id.id}) else {
                continue
            }
            cum.append(question)
        }
        var chosenAnswer = [String : Any]()
        if let correct = cum.first(where: {$0["correct"] as? Bool ?? false}) {
            chosenAnswer = correct
        } else {
            let ordered = cum.sorted(by: {$0["marks"] as? Int ?? 0 > $1["marks"] as? Int ?? 0})
            if ordered.count == 0 {
                continue
            }
            chosenAnswer = ordered[0]
        }
        guard let answerToSet = chosenAnswer["answer"] as? [[String : Any]] else {
            continue
        }
        var cba = QAP.shared.cachedBestAnswer!
        for (index, uwu) in cba.enumerated() where uwu["question_id"] as? Int == id.id {
            var owo = uwu
            owo["answer"] = answerToSet
            cba[index] = owo
        }
    }
}

scrapeEveryone()

RunLoop.main.run()
