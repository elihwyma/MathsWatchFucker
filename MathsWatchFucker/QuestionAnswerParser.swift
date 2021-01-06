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

func dictUwu(uwu: String) -> [String : Any] {
    do {
        let safe = uwu.replacingOccurrences(of: "\\", with: "")
        guard let data = safe.data(using: .utf8) else { fatalError("fucks") }
        return try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any] ?? [String : Any]()
    } catch {
        print(error)
        fatalError("fucks")
    }
}


class QAP {
    var homework = Homework()

    @discardableResult func parseHomework(questionResponse: String!) -> (Bool, String) {
        let d = dictUwu(uwu: questionResponse)
        guard let dict = d["data"] as? [String : Any] else { return(false, "Could not parse these questions. Continue? Y | n") }
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
        for answer in answers {
            let d = dictUwu(uwu: answer)
            guard let dict = d["data"] as? [[String : Any]] else { return(false, "Could not parse these questions. Continue? Y | n") }
            for a in dict {
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
        print("Hope this helps :)")
    }
}

let questionsDict =
    """
    
    """

let answers: [String] = [a1, a2,]

let a1 =
    """
   
    """

let a2 =
    """

    """
