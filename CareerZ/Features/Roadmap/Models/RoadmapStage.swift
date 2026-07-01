//
//  RoadmapStage.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// A top-level grouping in the roadmap, e.g. "Foundation",
/// "Intermediate", "Advanced".
struct RoadmapStage: Identifiable, Hashable {
    let id: String
    let title: String
    let milestones: [RoadmapMilestone]

    static func == (lhs: RoadmapStage, rhs: RoadmapStage) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    /// Overall status for the stage badge/indicator: completed if
    /// every milestone is completed, locked if every milestone is
    /// locked, otherwise in progress.
    var status: ProgressStatus {
        if milestones.allSatisfy({ $0.status == .completed }) { return .completed }
        if milestones.allSatisfy({ $0.status == .locked }) { return .locked }
        return .inProgress
    }
}

extension ProgressStatus: Equatable {
    static func == (lhs: ProgressStatus, rhs: ProgressStatus) -> Bool {
        switch (lhs, rhs) {
        case (.completed, .completed), (.inProgress, .inProgress), (.locked, .locked):
            return true
        default:
            return false
        }
    }
}

extension RoadmapStage {
    static let sample: [RoadmapStage] = [
        RoadmapStage(
            id: "foundation",
            title: "Foundation",
            milestones: [
                RoadmapMilestone(
                    id: "product-fundamentals", title: "Product Fundamentals",
                    status: .completed, estimatedMinutes: 120,
                    detail: RoadmapMilestoneDetail(
                        description: "Build a solid foundation in what product management actually is, the core responsibilities, and how PMs work with other teams.",
                        systemImage: "shippingbox",
                        impact: "High",
                        estimatedTimeLabel: "2 hours",
                        lessons: [
                            RoadmapLesson(id: "what-is-product-management", title: "What is Product Management", durationMinutes: 15, status: .completed),
                            RoadmapLesson(id: "the-pm-role-in-practice", title: "The PM Role in Practice", durationMinutes: 20, status: .completed),
                            RoadmapLesson(id: "working-with-cross-functional-teams", title: "Working with Cross-Functional Teams", durationMinutes: 20, status: .completed),
                        ],
                        whatYoullLearn: [
                            "Define what a Product Manager actually owns versus what they don't",
                            "Recognize the core responsibilities of the PM role day to day",
                            "Understand how PMs collaborate with engineering, design, and business teams",
                        ]
                    )
                ),
                RoadmapMilestone(
                    id: "agile-basics", title: "Agile Basics",
                    status: .completed, estimatedMinutes: 90,
                    detail: RoadmapMilestoneDetail(
                        description: "Learn the Agile mindset and core ceremonies that most modern product teams use to plan and ship work.",
                        systemImage: "arrow.triangle.2.circlepath",
                        impact: "Medium",
                        estimatedTimeLabel: "1.5 hours",
                        lessons: [
                            RoadmapLesson(id: "agile-mindset", title: "The Agile Mindset", durationMinutes: 15, status: .completed),
                            RoadmapLesson(id: "scrum-vs-kanban", title: "Scrum vs Kanban", durationMinutes: 20, status: .completed),
                            RoadmapLesson(id: "sprint-ceremonies", title: "Sprint Ceremonies Explained", durationMinutes: 15, status: .completed),
                        ],
                        whatYoullLearn: [
                            "Explain the Agile mindset and why teams adopt it",
                            "Tell the difference between Scrum and Kanban and when each fits",
                            "Participate confidently in standups, planning, and retros",
                        ]
                    )
                ),
                RoadmapMilestone(
                    id: "market-customer-basics", title: "Market & Customer Basics",
                    status: .completed, estimatedMinutes: 100,
                    detail: RoadmapMilestoneDetail(
                        description: "Learn how to size up a market and build a basic understanding of who your customers are before you build anything.",
                        systemImage: "person.2.badge.gearshape",
                        impact: "High",
                        estimatedTimeLabel: "2 hours",
                        lessons: [
                            RoadmapLesson(id: "market-sizing-basics", title: "Market Sizing Basics", durationMinutes: 20, status: .completed),
                            RoadmapLesson(id: "identifying-your-customer", title: "Identifying Your Customer", durationMinutes: 20, status: .completed),
                            RoadmapLesson(id: "competitive-landscape-101", title: "Competitive Landscape 101", durationMinutes: 15, status: .completed),
                        ],
                        whatYoullLearn: [
                            "Estimate a market's size using simple, defensible assumptions",
                            "Describe your target customer in concrete, specific terms",
                            "Map out competitors and identify where you can differentiate",
                        ]
                    )
                ),
            ]
        ),
        RoadmapStage(
            id: "intermediate",
            title: "Intermediate",
            milestones: [
                RoadmapMilestone(
                    id: "user-research", title: "User Research",
                    status: .inProgress, estimatedMinutes: 15,
                    detail: RoadmapMilestoneDetail(
                        description: "Learn how to understand user needs, validate problems, and build solutions users love through rigorous empathetic inquiry.",
                        systemImage: "person.2",
                        impact: "High",
                        estimatedTimeLabel: "4-6 hours",
                        lessons: [
                            RoadmapLesson(id: "intro-to-user-research", title: "Introduction to User Research", durationMinutes: 15, status: .completed),
                            RoadmapLesson(id: "research-methods", title: "Research Methods", durationMinutes: 20, status: .inProgress),
                            RoadmapLesson(id: "synthesizing-insights", title: "Synthesizing Insights", durationMinutes: 25, status: .locked),
                        ],
                        whatYoullLearn: [
                            "Choose the right research methods for different problems",
                            "Conduct interviews and usability tests effectively with unbiased techniques",
                            "Turn raw user insights into actionable product opportunities",
                        ]
                    )
                ),
                RoadmapMilestone(
                    id: "roadmapping", title: "Roadmapping",
                    status: .locked, estimatedMinutes: 180,
                    detail: RoadmapMilestoneDetail(
                        description: "Learn how to translate strategy into a roadmap that aligns your team and stakeholders around what to build next.",
                        systemImage: "map",
                        impact: "High",
                        estimatedTimeLabel: "3-5 hours",
                        lessons: [
                            RoadmapLesson(id: "roadmap-foundations", title: "Roadmap Foundations", durationMinutes: 15, status: .locked),
                            RoadmapLesson(id: "sequencing-and-themes", title: "Sequencing & Themes", durationMinutes: 20, status: .locked),
                            RoadmapLesson(id: "communicating-the-roadmap", title: "Communicating the Roadmap", durationMinutes: 20, status: .locked),
                        ],
                        whatYoullLearn: [
                            "Translate strategy into a sequenced roadmap",
                            "Balance stakeholder requests against long-term priorities",
                            "Communicate roadmap changes clearly to your team",
                        ]
                    )
                ),
                RoadmapMilestone(
                    id: "product-metrics-analytics", title: "Product Metrics & Analytics",
                    status: .locked, estimatedMinutes: 150,
                    detail: RoadmapMilestoneDetail(
                        description: "Learn to define, track, and interpret the metrics that show whether your product is actually working.",
                        systemImage: "chart.bar",
                        impact: "Medium",
                        estimatedTimeLabel: "3-4 hours",
                        lessons: [
                            RoadmapLesson(id: "metrics-fundamentals", title: "Metrics Fundamentals", durationMinutes: 15, status: .locked),
                            RoadmapLesson(id: "choosing-the-right-metrics", title: "Choosing the Right Metrics", durationMinutes: 20, status: .locked),
                            RoadmapLesson(id: "reading-dashboards", title: "Reading Dashboards", durationMinutes: 15, status: .locked),
                        ],
                        whatYoullLearn: [
                            "Define metrics that map to real product goals",
                            "Avoid vanity metrics that don't drive decisions",
                            "Read and question a dashboard like a PM",
                        ]
                    )
                ),
            ]
        ),
        RoadmapStage(
            id: "advanced",
            title: "Advanced",
            milestones: [
                RoadmapMilestone(
                    id: "product-strategy", title: "Product Strategy",
                    status: .locked, estimatedMinutes: 200, detail: nil
                ),
                RoadmapMilestone(
                    id: "stakeholder-management", title: "Stakeholder Management",
                    status: .locked, estimatedMinutes: 150, detail: nil
                ),
                RoadmapMilestone(
                    id: "leadership-influence", title: "Leadership & Influence",
                    status: .locked, estimatedMinutes: 180, detail: nil
                ),
            ]
        ),
    ]
}
