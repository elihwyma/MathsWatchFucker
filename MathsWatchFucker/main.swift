//
//  main.swift
//  MathsWatchFucker
//
//  Created by AW on 05/01/2021.
//

import Foundation

let qap = QAP()
qap.parseHomework(questionResponse: questionsDict)
qap.parseAnswers()
qap.printInfoFancily()
