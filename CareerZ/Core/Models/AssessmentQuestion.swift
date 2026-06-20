//
//  AssessmentQuestion.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

struct AssessmentQuestion: Identifiable, Equatable {
    let id = UUID()
    let question: String
    let options: [String]
}
