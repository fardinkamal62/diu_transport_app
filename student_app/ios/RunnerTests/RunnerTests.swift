import Flutter
import UIKit
import XCTest

class RunnerTests: XCTestCase {
  func testAppLaunch() {
    let app = XCUIApplication()
    app.launch()
    XCTAssert(app.wait(for: .runningForeground, timeout: 5))
  }
}
