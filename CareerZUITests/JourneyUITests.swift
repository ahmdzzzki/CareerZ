import XCTest

final class JourneyUITests: XCTestCase {
    override func setUpWithError() throws { continueAfterFailure = false }

    private func tap(_ element: XCUIElement, in app: XCUIApplication) {
        for _ in 0..<12 {
            if element.exists && element.isHittable { break }
            app.swipeUp()
        }
        XCTAssertTrue(element.waitForExistence(timeout: 3), "Missing element: \(element)")
        XCTAssertTrue(element.isHittable, "Element cannot be reached: \(element)")
        element.tap()
    }

    private func begin(_ app: XCUIApplication) {
        app.launch()
        let welcome = app.buttons["Start exploring"]
        if welcome.waitForExistence(timeout: 3) { tap(welcome, in: app); return }
        app.tabBars.buttons["Profile"].tap()
        tap(app.buttons["Delete all local data"], in: app)
        app.buttons["Delete permanently"].tap()
        tap(welcome, in: app)
    }

    func testPMJourneyPersistsAfterRelaunch() {
        let app = XCUIApplication()
        begin(app)
        tap(app.buttons["Product Management"], in: app)
        tap(app.buttons["Choose this direction"], in: app)
        app.buttons["Choose direction"].tap()
        tap(app.buttons["Assess my PM skills"], in: app)
        for index in 0..<8 {
            let capability = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "2 · Guided Practice")).firstMatch
            tap(capability, in: app)
            tap(app.buttons["2 · A guided exercise or project"], in: app)
            tap(app.buttons[index == 7 ? "Save my assessment" : "Continue"], in: app)
        }
        XCTAssertTrue(app.staticTexts["Your skill snapshot"].waitForExistence(timeout: 10))
        tap(app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Understand Product Work")).firstMatch, in: app)
        let evidence = app.textFields["Mission evidence"].exists ? app.textFields["Mission evidence"] : app.textViews["Mission evidence"]
        tap(evidence, in: app); evidence.typeText("PM role comparison with examples")
        let reflection = app.textFields["Mission reflection"].exists ? app.textFields["Mission reflection"] : app.textViews["Mission reflection"]
        tap(reflection, in: app); reflection.typeText("I can distinguish product outcomes from project delivery.")
        // Dismiss the keyboard using the navigation bar before reaching the footer.
        app.navigationBars.firstMatch.tap()
        tap(app.buttons["Complete this mission"], in: app)
        XCTAssertTrue(app.staticTexts["Saved on this device"].waitForExistence(timeout: 5))
        app.terminate(); app.launch()
        app.tabBars.buttons["Develop"].tap()
        XCTAssertTrue(app.staticTexts["Your skill snapshot"].waitForExistence(timeout: 10))
        tap(app.buttons["View skill breakdown & history"], in: app)
        XCTAssertTrue(app.staticTexts["Your first skill assessment. This is your baseline—there is no trend to show yet."].waitForExistence(timeout: 5))
        app.navigationBars.buttons.firstMatch.tap()
        tap(app.staticTexts["1 of 10 missions completed · 10%"], in: app)
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
        XCTAssertTrue(app.staticTexts["Your Compass"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Retake Compass"].exists)
    }
}
