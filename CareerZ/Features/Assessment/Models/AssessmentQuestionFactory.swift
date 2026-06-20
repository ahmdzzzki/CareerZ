//
//  AssessmentQuestionFactory.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

enum AssessmentQuestionFactory {

    static func questions(
        for goal: CareerGoalOption
    ) -> [AssessmentQuestion] {

        switch goal.title {

        case "Product Manager":
            return productManagerQuestions

        case "Software Engineer":
            return softwareEngineerQuestions

        case "UI/UX Designer":
            return uiuxDesignerQuestions

        case "Data Analyst":
            return dataAnalystQuestions

        case "Business Analyst":
            return businessAnalystQuestions

        case "Project Manager":
            return projectManagerQuestions

        case "Data Scientist":
            return dataScientistQuestions

        case "Digital Marketer":
            return digitalMarketerQuestions

        default:
            return productManagerQuestions
        }
    }
}

private let productManagerQuestions = [
    AssessmentQuestion(
        question: "How familiar are you with Agile methodology?",
        options: [
            "I've never heard of it",
            "I know the theory",
            "I've used it in projects",
            "I can facilitate Agile processes"
        ]
    ),
    AssessmentQuestion(
        question: "Which product management activity are you most confident in?",
        options: [
            "User Research",
            "Product Strategy",
            "Data Analysis",
            "Roadmapping & Prioritization"
        ]
    ),
    AssessmentQuestion(
        question: "Have you ever worked on a product or project with a team?",
        options: [
            "Never",
            "Academic projects only",
            "Personal projects",
            "Professional experience"
        ]
    ),
    AssessmentQuestion(
        question: "How comfortable are you with analyzing data to make decisions?",
        options: [
            "Not comfortable yet",
            "I understand basic metrics",
            "I've analyzed data in projects",
            "I regularly use data"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "Understanding users",
            "Product thinking & strategy",
            "Data & metrics",
            "Stakeholder communication"
        ]
    )
]

private let softwareEngineerQuestions = [
    AssessmentQuestion(
        question: "How confident are you with programming fundamentals?",
        options: [
            "Beginner",
            "Basic understanding",
            "Comfortable building projects",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "Which area are you most experienced in?",
        options: [
            "Frontend",
            "Backend",
            "Mobile Development",
            "Full Stack"
        ]
    ),
    AssessmentQuestion(
        question: "How often do you use Git and version control?",
        options: [
            "Never",
            "Sometimes",
            "Frequently",
            "Every project"
        ]
    ),
    AssessmentQuestion(
        question: "How familiar are you with system design concepts?",
        options: [
            "Not familiar",
            "Basic understanding",
            "Applied in projects",
            "Very confident"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "Algorithms",
            "Backend Architecture",
            "Mobile Development",
            "System Design"
        ]
    )
]

private let uiuxDesignerQuestions = [
    AssessmentQuestion(
        question: "How familiar are you with design principles?",
        options: [
            "Beginner",
            "Basic understanding",
            "Applied in projects",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "Which design activity are you strongest in?",
        options: [
            "User Research",
            "Wireframing",
            "Visual Design",
            "Prototyping"
        ]
    ),
    AssessmentQuestion(
        question: "How often do you conduct usability testing?",
        options: [
            "Never",
            "Rarely",
            "Sometimes",
            "Frequently"
        ]
    ),
    AssessmentQuestion(
        question: "How comfortable are you with design systems?",
        options: [
            "Not familiar",
            "Basic knowledge",
            "Used one before",
            "Created one myself"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "Research Skills",
            "Visual Design",
            "Interaction Design",
            "Design Systems"
        ]
    )
]

private let dataAnalystQuestions = [
    AssessmentQuestion(
        question: "How comfortable are you working with spreadsheets?",
        options: [
            "Beginner",
            "Basic formulas",
            "Advanced formulas",
            "Expert"
        ]
    ),
    AssessmentQuestion(
        question: "Which analytics tool have you used the most?",
        options: [
            "Excel",
            "SQL",
            "Python",
            "BI Tools"
        ]
    ),
    AssessmentQuestion(
        question: "How confident are you in data visualization?",
        options: [
            "Not confident",
            "Basic charts",
            "Dashboard creation",
            "Advanced storytelling"
        ]
    ),
    AssessmentQuestion(
        question: "How familiar are you with statistics?",
        options: [
            "Beginner",
            "Basic concepts",
            "Applied in projects",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "SQL",
            "Data Visualization",
            "Statistics",
            "Business Insights"
        ]
    )
]

private let businessAnalystQuestions = [
    AssessmentQuestion(
        question: "How familiar are you with business process analysis?",
        options: [
            "Beginner",
            "Basic understanding",
            "Project experience",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "Which activity are you most confident in?",
        options: [
            "Requirements Gathering",
            "Process Mapping",
            "Documentation",
            "Stakeholder Communication"
        ]
    ),
    AssessmentQuestion(
        question: "How often do you create business documentation?",
        options: [
            "Never",
            "Sometimes",
            "Frequently",
            "Very often"
        ]
    ),
    AssessmentQuestion(
        question: "How comfortable are you facilitating discussions?",
        options: [
            "Not comfortable",
            "Somewhat comfortable",
            "Comfortable",
            "Very confident"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "Requirements Analysis",
            "Business Processes",
            "Communication",
            "Problem Solving"
        ]
    )
]

private let projectManagerQuestions = [
    AssessmentQuestion(
        question: "How familiar are you with project planning?",
        options: [
            "Beginner",
            "Basic understanding",
            "Applied in projects",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "Which project management activity are you strongest in?",
        options: [
            "Planning",
            "Execution",
            "Risk Management",
            "Team Coordination"
        ]
    ),
    AssessmentQuestion(
        question: "How often do you manage project timelines?",
        options: [
            "Never",
            "Occasionally",
            "Frequently",
            "Every project"
        ]
    ),
    AssessmentQuestion(
        question: "How comfortable are you leading teams?",
        options: [
            "Not comfortable",
            "Somewhat comfortable",
            "Comfortable",
            "Very confident"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "Leadership",
            "Risk Management",
            "Stakeholder Management",
            "Project Planning"
        ]
    )
]

private let dataScientistQuestions = [
    AssessmentQuestion(
        question: "How familiar are you with machine learning?",
        options: [
            "Beginner",
            "Theory only",
            "Project experience",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "Which area are you strongest in?",
        options: [
            "Data Cleaning",
            "Data Analysis",
            "Machine Learning",
            "Model Evaluation"
        ]
    ),
    AssessmentQuestion(
        question: "How often do you work with Python?",
        options: [
            "Never",
            "Sometimes",
            "Frequently",
            "Daily"
        ]
    ),
    AssessmentQuestion(
        question: "How comfortable are you with statistics?",
        options: [
            "Beginner",
            "Basic concepts",
            "Applied in projects",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "Machine Learning",
            "Deep Learning",
            "Statistics",
            "MLOps"
        ]
    )
]

private let digitalMarketerQuestions = [
    AssessmentQuestion(
        question: "How familiar are you with digital marketing channels?",
        options: [
            "Beginner",
            "Basic understanding",
            "Campaign experience",
            "Advanced"
        ]
    ),
    AssessmentQuestion(
        question: "Which area are you strongest in?",
        options: [
            "Content Marketing",
            "SEO",
            "Paid Ads",
            "Social Media"
        ]
    ),
    AssessmentQuestion(
        question: "How often do you analyze campaign performance?",
        options: [
            "Never",
            "Sometimes",
            "Frequently",
            "Every campaign"
        ]
    ),
    AssessmentQuestion(
        question: "How comfortable are you with marketing analytics?",
        options: [
            "Not comfortable",
            "Basic understanding",
            "Applied in campaigns",
            "Very confident"
        ]
    ),
    AssessmentQuestion(
        question: "What would you like to improve the most?",
        options: [
            "SEO",
            "Content Strategy",
            "Paid Advertising",
            "Marketing Analytics"
        ]
    )
]
