import XCTest
@testable import PlantCareApp

final class FertilizingTests: XCTestCase {
    
    var viewModel: MyPlantsViewModel!
    var testPlant: Plant!

    override func setUp() {
        super.setUp()
        viewModel = MyPlantsViewModel.shared
        viewModel.plants = []
        testPlant = Plant(name: "Test Monstera", botanicalName: "Monstera", location: "Living Room", health: .healthy, imageName: "")
    }

    func testFertilizingIntervals() {
        // Default fertilizing is 14 days
        XCTAssertEqual(viewModel.interval(.fertilizer, for: testPlant), 14)
        
        // Test interval text logic
        XCTAssertEqual(CareKind.fertilizer.intervalText(7), "Every week")
        XCTAssertEqual(CareKind.fertilizer.intervalText(14), "Every 2 weeks")
    }
    
    func testFertilizingStatusText() {
        XCTAssertEqual(CareKind.fertilizer.statusText(days: -1), "Overdue by 1 day")
        XCTAssertEqual(CareKind.fertilizer.statusText(days: 1), "Tomorrow")
    }
    
    func testMarkAsFertilizedResetsTimer() {
        var schedule = viewModel.getSchedule(for: testPlant)
        // Make it overdue by setting last fertilized to 20 days ago
        schedule.lastFertilized = Calendar.current.date(byAdding: .day, value: -20, to: Date())!
        viewModel.schedules[testPlant.name] = schedule
        
        // Mark as fertilized
        viewModel.markDone(.fertilizer, for: testPlant)
        
        // Should now be 0 days since last fertilized
        let updatedSchedule = viewModel.getSchedule(for: testPlant)
        let daysSince = Calendar.current.dateComponents([.day], from: updatedSchedule.lastFertilized, to: Date()).day!
        XCTAssertEqual(daysSince, 0)
    }
}