//
//  QuestionAnswerParser.swift
//  MathsWatchFucker
//
//  Created by AW on 05/01/2021.
//

import Foundation

struct Homework {
    var title: String!
    var due: String!
    var marks: Int!
    var questions = [Question]()
}

struct Question {
    var id: Int!
    var marks: Int!
    var answers = [Answer]()

    init(id: Int) {
        self.id = id
    }
}

struct Answer {
    var marks: Int!
    var answer: String?
    var prefix: String!
}

class QAP {
    
    static let shared = QAP()
    var cachedBestAnswer: [[String : Any]]?
    var cachedBestQuestion: [String : Any]?
    var cachedBestScore = 0
    
    var cachedAnswers = [[[String : Any]]]()
    
    var homework = Homework()

    @discardableResult func parseHomework() -> (Bool, String) {
        guard let dict = self.cachedBestQuestion else { return(false, "Could not parse these questions. Continue? Y | n") }
        self.homework.title = dict["title"] as? String
        self.homework.due = dict["due_at"] as? String
        self.homework.marks = dict["marks"] as? Int ?? -1
        guard let questions = dict["questions"] as? [[String : Any]] else {  return(false, "Could not parse these questions. Continue? Y | n") }
        for question in questions {
            var q = Question(id: question["id"] as? Int ?? -1)
            q.marks = question["marks"] as? Int ?? -1
            self.homework.questions.append(q)
        }
        return (true, "Success parsing questions and homework")
    }
    
    @discardableResult func parseAnswers() -> (Bool, String) {
        guard let cba = self.cachedBestAnswer else { fatalError("Nobody has an answer lol") }
        for a in cba {
            let questionID = a["question_id"] as? Int ?? -1
            guard let answer = a["answer"] as? [[String : Any]] else { return(false, "Could not parse these questions. Continue? Y | n") }
            for b in answer {
                var c = Answer()
                c.prefix = b["prefix"] as? String ?? "Error"
                c.marks = b["marks"] as? Int ?? -1
                if let f = b["text"] as? [String] {
                    if f.isEmpty { c.answer = "null" }
                    var g = ""
                    for h in f { g.append("\(h),") }
                    c.answer = g
                } else {
                    c.answer = b["text"] as? String ?? "null"
                }
                if c.answer != "null" {
                    for (i, d) in self.homework.questions.enumerated() {
                        if d.id == questionID {
                            self.homework.questions[i].answers.append(c)
                        }
                    }
                }
            }
        }
        return (true, "Success parsing answers")
    }
 
    
    func printInfoFancily() {
        print("Homework: \(self.homework.title!) is worth \(self.homework.marks!) marks.")
        for question in self.homework.questions {
            if question.answers.isEmpty { print("Sadly we don't have any answers for question \(question.id!)"); continue }
            var answers = [String]()
            for answer in question.answers {
                answers.append("\(answer.answer!)")
            }
            print("Question \(question.id!) is worth \(question.marks!) marks, and here are the potential answers: \(answers)")
        }
    }
}
