//
//  FocusArea.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

struct FocusArea: Identifiable {
    let id: String
    let title: String
    let systemImage: String
    let percent: Int

    /// Detail-screen content. Optional during incremental rollout —
    /// grid card view only needs title/icon/percent, so this can stay
    /// nil for areas not yet fleshed out without breaking the grid.
    let detail: FocusAreaDetailContent?

    var status: ReadinessStatus {
        ReadinessStatus(percent: percent)
    }
}

/// Content shown on the Focus Area Detail screen: "what this means",
/// "measured by" sub-metrics, and "why does X matter".
struct FocusAreaDetailContent {
    let whatThisMeans: String
    let measuredBy: [FocusAreaMetric]
    let whyItMatters: String
}

extension FocusArea: Hashable {
    static func == (lhs: FocusArea, rhs: FocusArea) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension FocusArea {
    static let sample: [FocusArea] = [
        FocusArea(
            id: "technical-skills", title: "Technical Skills",
            systemImage: "gearshape", percent: 85,
            detail: FocusAreaDetailContent(
                whatThisMeans: "Your technical foundation is strong, covering the core tools and concepts expected for your target role.",
                measuredBy: [
                    FocusAreaMetric(id: "tool-proficiency", title: "Tool Proficiency", summary: "How comfortable you are with role-relevant tools.", detail: "Based on the tools and platforms you've reported using and your assessment answers about them."),
                    FocusAreaMetric(id: "concept-mastery", title: "Concept Mastery", summary: "Your grasp of core technical concepts.", detail: "Drawn from assessment questions covering fundamentals specific to your target career path."),
                    FocusAreaMetric(id: "applied-practice", title: "Applied Practice", summary: "Hands-on projects or coursework completed.", detail: "Counts roadmap lessons and exercises you've completed that involve applying technical skills directly."),
                ],
                whyItMatters: "Technical skills are often the first filter employers use. A strong score here means you're less likely to be screened out before a human even reviews your application."
            )
        ),
        FocusArea(
            id: "networking", title: "Networking",
            systemImage: "person.2", percent: 48,
            detail: FocusAreaDetailContent(
                whatThisMeans: "Building stronger professional connections can improve your overall career readiness.",
                measuredBy: [
                    FocusAreaMetric(id: "professional-connections", title: "Professional Connections", summary: "The quality and quantity of your connections.", detail: "Looks at how many relevant industry contacts you've added and how active those connections are."),
                    FocusAreaMetric(id: "networking-activities", title: "Networking Activities", summary: "Your participation in events and communities.", detail: "Tracks attendance at meetups, webinars, and community discussions related to your target role."),
                    FocusAreaMetric(id: "industry-engagement", title: "Industry Engagement", summary: "Your interaction and visibility in your industry.", detail: "Measures how often you engage publicly — posts, comments, or contributions — within your industry."),
                ],
                whyItMatters: "Networking helps you discover opportunities, learn from professionals, and build meaningful industry relationships."
            )
        ),
        FocusArea(
            id: "communication", title: "Communication",
            systemImage: "bubble.left.and.bubble.right", percent: 62,
            detail: FocusAreaDetailContent(
                whatThisMeans: "You communicate clearly in most situations, with some room to grow in higher-stakes settings.",
                measuredBy: [
                    FocusAreaMetric(id: "written-clarity", title: "Written Clarity", summary: "How clearly you express ideas in writing.", detail: "Evaluated from written responses in assessments and any documents you've submitted for review."),
                    FocusAreaMetric(id: "verbal-confidence", title: "Verbal Confidence", summary: "Self-reported comfort presenting or speaking up.", detail: "Based on your answers about presenting ideas, leading discussions, or speaking in group settings."),
                    FocusAreaMetric(id: "stakeholder-alignment", title: "Stakeholder Alignment", summary: "Ability to align different audiences.", detail: "Looks at how you've handled scenarios requiring you to align technical and non-technical stakeholders."),
                ],
                whyItMatters: "Strong communication helps you influence decisions, manage expectations, and build trust with both your team and stakeholders."
            )
        ),
        FocusArea(
            id: "data-literacy", title: "Data Literacy",
            systemImage: "chart.bar", percent: 85,
            detail: FocusAreaDetailContent(
                whatThisMeans: "You're confident reading data and using it to support decisions — a strong asset for your target role.",
                measuredBy: [
                    FocusAreaMetric(id: "data-interpretation", title: "Data Interpretation", summary: "Ability to read and interpret data correctly.", detail: "Based on assessment questions involving charts, metrics, and dataset interpretation."),
                    FocusAreaMetric(id: "metric-design", title: "Metric Design", summary: "Skill in choosing the right metrics for a goal.", detail: "Measures how well you can connect a business question to a meaningful, measurable metric."),
                    FocusAreaMetric(id: "decision-making", title: "Data-Driven Decisions", summary: "How often data informs your decisions.", detail: "Tracks how consistently you've used data to justify decisions in your assessment responses."),
                ],
                whyItMatters: "Data literacy lets you back up decisions with evidence rather than opinion, which builds credibility with stakeholders and leadership."
            )
        ),
        FocusArea(
            id: "execution", title: "Execution",
            systemImage: "checkmark.circle", percent: 28,
            detail: FocusAreaDetailContent(
                whatThisMeans: "Your track record of completing and shipping work is below the recommended level for your target role.",
                measuredBy: [
                    FocusAreaMetric(id: "delivery-track-record", title: "Delivery Track Record", summary: "How consistently you complete what you start.", detail: "Based on completion rates of roadmap milestones and any reported project deliveries."),
                    FocusAreaMetric(id: "prioritization", title: "Prioritization", summary: "Ability to focus on what matters most.", detail: "Evaluated from assessment scenarios asking you to prioritize competing tasks or features."),
                    FocusAreaMetric(id: "follow-through", title: "Follow-Through", summary: "Consistency in finishing assigned work.", detail: "Looks at how often in-progress lessons or tasks are completed versus left unfinished."),
                ],
                whyItMatters: "Execution is what turns good ideas into real results — it's often the difference employers notice most between candidates."
            )
        ),
        FocusArea(
            id: "career-assets", title: "Career Assets",
            systemImage: "briefcase", percent: 57,
            detail: FocusAreaDetailContent(
                whatThisMeans: "Your resume and portfolio are partially ready, but could better showcase your strongest work.",
                measuredBy: [
                    FocusAreaMetric(id: "resume-quality", title: "Resume Quality", summary: "How complete and well-structured your resume is.", detail: "Checked against common resume best practices: clarity, relevant keywords, and quantified impact."),
                    FocusAreaMetric(id: "portfolio-strength", title: "Portfolio Strength", summary: "The depth and relevance of your portfolio.", detail: "Looks at whether you've linked work samples relevant to your target role."),
                    FocusAreaMetric(id: "online-presence", title: "Online Presence", summary: "How discoverable and professional your profiles are.", detail: "Based on completeness of linked professional profiles, such as LinkedIn or a personal site."),
                ],
                whyItMatters: "Strong career assets are often what gets you noticed before you ever speak to a recruiter."
            )
        ),
        FocusArea(
            id: "leadership", title: "Leadership",
            systemImage: "person.3", percent: 85,
            detail: FocusAreaDetailContent(
                whatThisMeans: "You show strong leadership instincts, including taking initiative and guiding others effectively.",
                measuredBy: [
                    FocusAreaMetric(id: "initiative", title: "Initiative", summary: "Tendency to take ownership without being asked.", detail: "Based on assessment scenarios where you chose to act rather than wait for direction."),
                    FocusAreaMetric(id: "team-influence", title: "Team Influence", summary: "Your ability to guide and motivate others.", detail: "Looks at reported experience leading projects, mentoring, or facilitating team decisions."),
                    FocusAreaMetric(id: "decision-ownership", title: "Decision Ownership", summary: "Comfort making and standing by decisions.", detail: "Evaluated from how you've handled scenarios requiring a clear, accountable decision."),
                ],
                whyItMatters: "Leadership signals you can be trusted with ambiguity and responsibility — qualities employers look for beyond entry-level roles."
            )
        ),
        FocusArea(
            id: "learning-agility", title: "Learning Agility",
            systemImage: "sparkles", percent: 30,
            detail: FocusAreaDetailContent(
                whatThisMeans: "Your pace of picking up new skills and adapting to change is below the recommended level.",
                measuredBy: [
                    FocusAreaMetric(id: "adaptability", title: "Adaptability", summary: "How well you adjust when priorities shift.", detail: "Based on assessment scenarios testing your response to sudden changes in scope or direction."),
                    FocusAreaMetric(id: "learning-pace", title: "Learning Pace", summary: "How quickly you complete new lessons.", detail: "Tracks the average time between starting and completing roadmap lessons."),
                    FocusAreaMetric(id: "curiosity-signals", title: "Curiosity Signals", summary: "Engagement with optional or advanced content.", detail: "Looks at whether you explore optional lessons and resources beyond what's required."),
                ],
                whyItMatters: "Roles and tools change quickly — being able to learn fast keeps you valuable as requirements evolve."
            )
        ),
    ]
}
