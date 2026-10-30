import XCTest
@testable import PlantCareApp

final class WateringTests: XCTestCase {
    
    var viewModel: MyPlantsViewModel!
    var testPlant: Plant!

    override func setUp() {
        super.setUp()
        viewModel = MyPlantsViewModel.shared
        viewModel.plants = []
        testPlant = Plant(name: "Test Rose", botanicalName: "Rosa", location: "Garden", health: .healthy, imageName: "")
    }

    func testWateringIntervals() {
        // Default watering is 5 days
        XCTAssertEqual(viewModel.interval(.watering, for: testPlant), 5)
        
        // Set to 10 days
        viewModel.setInterval(10, .watering, for: testPlant)
        XCTAssertEqual(viewModel.interval(.watering, for: testPlant), 10)
        
        // Test boundaries (min 1, max 30)
        viewModel.setInterval(0, .watering, for: testPlant)
        XCTAssertEqual(viewModel.interval(.watering, for: testPlant), 1)
        
        viewModel.setInterval(50, .watering, for: testPlant)
        XCTAssertEqual(viewModel.interval(.watering, for: testPlant), 30)
    }
    
    func testWateringStatusText() {
        XCTAssertEqual(CareKind.watering.statusText(days: -2), "Overdue by 2 days")
        XCTAssertEqual(CareKind.watering.statusText(days: 0), "Due today")
        XCTAssertEqual(CareKind.watering.statusText(days: 5), "In 5 days")
    }
    
    func testMarkAsWateredResetsTimer() {
        var schedule = viewModel.getSchedule(for: testPlant)
        // Make it overdue by setting last watered to 10 days ago
        schedule.lastWatered = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        viewModel.schedules[testPlant.name] = schedule
        
        // Mark as watered
        viewModel.markDone(.watering, for: testPlant)
        
        // Should now be 0 days since last watered
        let updatedSchedule = viewModel.getSchedule(for: testPlant)
        let daysSince = Calendar.current.dateComponents([.day], from: updatedSchedule.lastWatered, to: Date()).day!
        XCTAssertEqual(daysSince, 0)
    }
}