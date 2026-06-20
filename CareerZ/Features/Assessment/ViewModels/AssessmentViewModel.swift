//
//  AssessmentViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class AssessmentViewModel {
    
    let goal: CareerGoalOption
    
    var currentQuestionIndex: Int = 0
    var selectedAnswers: [Int: String] = [:]
    
    let questions: [AssessmentQuestion]
    
    init(goal: CareerGoalOption) {
        self.goal = goal
        self.questions = AssessmentQuestionFactory.questions(for: goal)
    }
    
    var currentQuestion: AssessmentQuestion {
        questions[currentQuestionIndex]
    }
    
    var selectedOption: String? {
        selectedAnswers[currentQuestionIndex]
    }
    
    var questionNumberText: String {
        "Question \(currentQuestionIndex + 1) of \(questions.count)"
    }
    
    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(questions.count)
    }
    
    var progressText: String {
        "\(Int(progress * 100))% Complete"
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
    var buttonTitle: String {
        isLastQuestion ? "Complete" : "Next"
    }
    
    func selectOption(_ option: String) {
        selectedAnswers[currentQuestionIndex] = option
    }
    
    func goNext() {
        guard !isLastQuestion else { return }
        currentQuestionIndex += 1
    }
    
    func goBack() {
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
    }
}
