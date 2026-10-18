import XCTest

final class JourneyUITests: XCTestCase {
    override func setUpWithError() throws { continueAfterFailure = false }

    private func tap(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<12 {
            if element.exists && element.isHittable { break }
            // A full-screen swipe can start on the keyboard instead of the content.
            let done = app.buttons["Done"]
            if app.keyboards.firstMatch.exists && done.exists && done.isHittable { done.tap() }
            app.swipeUp()
        }
        XCTAssertTrue(element.waitForExistence(timeout: 3), "Missing element: \(element)")
        XCTAssertTrue(element.isHittable, "Element cannot be reached: \(element)")
        element.tap()
    }

    private func selectTab(_ name: String, in app: XCUIApplication) {
        let tab = app.tabBars.buttons[name]
        if tab.exists { tab.tap() }
        else { app.buttons[name].firstMatch.tap() } // iPad presents native tabs in its top toolbar.
    }

    private func begin(_ app: XCUIApplication) {
        app.launch()
        let welcome = app.buttons["Get Started"]
        if welcome.waitForExistence(timeout: 3) { tap(welcome, in: app); selectTab("Discover", in: app); return }
        selectTab("Profile", in: app)
        tap(app.buttons["Delete all progress"], in: app)
        app.buttons["Delete permanently"].tap()
        tap(welcome, in: app)
        selectTab("Discover", in: app)
    }

    func testAppleConnectionIsOptionalAndSimulatorSyncIsDisclosed() {
        let app = XCUIApplication()
        app.launch()
        if app.buttons["Get Started"].waitForExistence(timeout: 3) { app.buttons["Get Started"].tap() }
        selectTab("Profile", in: app)
        XCTAssertTrue(app.buttons["apple-sign-in"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Sync is available in a signed device build. Simulator progress stays local."].exists)
        let capture = XCTAttachment(screenshot: app.screenshot())
        capture.name = "Optional Apple connection"; capture.lifetime = .keepAlways; add(capture)
        selectTab("Home", in: app)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Skill Snapshot")).firstMatch.waitForExistence(timeout: 5))
    }

    func testDeleteConfirmationIsCenteredAndCancelKeepsData() {
        let app = XCUIApplication()
        app.launch()
        if app.buttons["Get Started"].waitForExistence(timeout: 3) { app.buttons["Get Started"].tap() }
        selectTab("Profile", in: app)
        tap(app.buttons["Delete all progress"], in: app)
        let alert = app.alerts["Delete all CareerZ progress?"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertEqual(alert.frame.midX, app.frame.midX, accuracy: 20)
        XCTAssertEqual(alert.frame.midY, app.frame.midY, accuracy: 120)
        let capture = XCTAttachment(screenshot: app.screenshot())
        capture.name = "Centered delete confirmation"; capture.lifetime = .keepAlways; add(capture)
        alert.buttons["Cancel"].tap()
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].isSelected)
    }

    func testCaptureStoreScreenshots() {
        verifyJourney(domain: "Product Management", shortTitle: "PM", firstMission: "Understand Product Work")
        let app = XCUIApplication()
        func capture(_ name: String) {
            let image = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            image.name = "App Store — \(name)"; image.lifetime = .keepAlways; add(image)
        }
        capture("Roadmap")
        selectTab("Home", in: app)
        capture("Home")
        selectTab("Discover", in: app)
        capture("Discover")
        tap(app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Mobile Development")).firstMatch, in: app)
        capture("Explore Mobile")
    }

    func testPMJourneyPersistsAfterRelaunch() {
        verifyJourney(domain: "Product Management", shortTitle: "PM", firstMission: "Understand Product Work")
    }

    func testSoftwareJourneyPersistsAfterRelaunch() {
        verifyJourney(domain: "Software Engineering", shortTitle: "Software", firstMission: "Define a Small Software Problem")
    }

    func testAllSixCareerDirectionsOpenTheirOwnSkillCheck() {
        let app = XCUIApplication()
        begin(app)
        let domains = [("Software Engineering", "Software"), ("Mobile Development", "Mobile"), ("Product Design", "Design"), ("Product Management", "PM"), ("Data & Analytics", "Data"), ("AI & Machine Learning", "AI & ML")]
        for (name, short) in domains {
            selectTab("Discover", in: app)
            let option = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", name)).firstMatch
            tap(option, in: app)
            tap(app.buttons["Choose this direction"], in: app)
            app.alerts.buttons["Choose direction"].tap()
            XCTAssertTrue(app.staticTexts[name].waitForExistence(timeout: 5))
            XCTAssertTrue(app.staticTexts["You chose"].isHittable, "A new career should start at the top of its roadmap")
            XCTAssertTrue(app.buttons["Assess my \(short) skills"].exists)
            let capture = XCTAttachment(screenshot: app.screenshot()); capture.name = "\(short) Skill Check"; capture.lifetime = .keepAlways; add(capture)
        }
    }

    private func verifyJourney(domain: String, shortTitle: String, firstMission: String) {
        let app = XCUIApplication()
        begin(app)
        tap(app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", domain)).firstMatch, in: app)
        tap(app.buttons["Choose this direction"], in: app)
        app.buttons["Choose direction"].tap()
        tap(app.buttons["Assess my \(shortTitle) skills"], in: app)
        for index in 0..<8 {
            let capability = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "2 · Guided Practice")).firstMatch
            tap(capability, in: app)
            XCTAssertTrue(app.buttons["Continue"].isEnabled, "Selecting capability must enable Continue")
            tap(app.buttons["Continue"], in: app)
            tap(app.buttons["2 · A guided exercise or project"], in: app)
            tap(app.buttons[index == 7 ? "Save my assessment" : "Continue"], in: app)
        }
        XCTAssertTrue(app.staticTexts["Your skill snapshot"].waitForExistence(timeout: 10))
        let roadmapImage = XCTAttachment(screenshot: app.screenshot()); roadmapImage.name = "\(shortTitle) Roadmap"; roadmapImage.lifetime = .keepAlways; add(roadmapImage)
        tap(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", firstMission)).firstMatch, in: app)
        let evidence = app.textFields["Mission evidence"].exists ? app.textFields["Mission evidence"] : app.textViews["Mission evidence"]
        tap(evidence, in: app); evidence.typeText("\(shortTitle) project artifact with reviewed decisions")
        let reflection = app.textFields["Mission reflection"].exists ? app.textFields["Mission reflection"] : app.textViews["Mission reflection"]
        tap(reflection, in: app); reflection.typeText("I recorded my decisions, limitations, and next improvement.")
        // Use the explicit keyboard action on both iPhone and iPad.
        let done = app.buttons["Done"]
        if done.exists { done.tap() }
        else { app.navigationBars.firstMatch.tap() }
        tap(app.buttons["Complete this mission"], in: app)
        XCTAssertTrue(app.staticTexts["Saved on this device"].waitForExistence(timeout: 5))
        app.terminate(); app.launch()
        selectTab("Roadmap", in: app)
        XCTAssertTrue(app.staticTexts["Your skill snapshot"].waitForExistence(timeout: 10))
        tap(app.buttons["View skill breakdown & history"], in: app)
        XCTAssertTrue(app.staticTexts["Your first skill assessment. This is your baseline—there is no trend to show yet."].waitForExistence(timeout: 5))
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["1 of 10 missions completed · 10%"].exists)
    }

    func testRefinedDashboardAndRoadmapNavigation() {
        let app = XCUIApplication()
        app.launch()
        selectTab("Home", in: app)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Skill Snapshot")).firstMatch.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Next Step"].exists)
        let home = XCTAttachment(screenshot: app.screenshot())
        home.name = "Refined Home"; home.lifetime = .keepAlways; add(home)
        selectTab("Roadmap", in: app)
        XCTAssertTrue(app.staticTexts["Product Manager Roadmap"].waitForExistence(timeout: 5))
        let roadmap = XCTAttachment(screenshot: app.screenshot())
        roadmap.name = "Refined Roadmap"; roadmap.lifetime = .keepAlways; add(roadmap)
        selectTab("Home", in: app)
    }

    func testCompassShowsExplainableMatchesAndPersists() {
        let app = XCUIApplication()
        begin(app)
        tap(app.buttons["Take CareerZ Compass"], in: app)
        for index in 0..<40 {
            tap(app.buttons["Sometimes like me"], in: app)
            tap(app.buttons[index == 39 ? "Save my assessment" : "Continue"], in: app)
        }
        XCTAssertTrue(app.staticTexts["Your Compass"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Your leading directions are close. Explore both before making a choice."].exists)
        tap(app.buttons["Compare leading directions"], in: app)
        XCTAssertTrue(app.staticTexts["A match is an invitation, not a verdict."].waitForExistence(timeout: 5))
        app.terminate(); app.launch()
        selectTab("Discover", in: app)
        XCTAssertTrue(app.staticTexts["Your Compass"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Retake Compass"].exists)
    }
}
