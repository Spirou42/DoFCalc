import XCTest
@testable import DoFCalc

final class DoFCalcTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
      var sensor = Sensor.FullFrame
      //let Lens = Lens(manufacturer: "Sigma", modelName: "105mm F2,8 DG DN MACRO | Art", maxAperture: 2.8, focalLength: 105.mm)
      //let DoFCalc = DoFCalc(sensor:Sensor , lens: Lens )
      let q = String(format: "%0.06f",sensor.calcCoC(withZeiss: .modern))
      XCTAssertEqual(q, "0.028844","CalcCoC Failed" )
      XCTAssertEqual(sensor.size,CGSize(width: 36.mm, height: 24.mm),"FullFrame Size failed")

      sensor = Sensor.ASPH
      XCTAssertEqual(sensor.size,CGSize(width: 28.7.mm, height: 19.mm),"ASPH Size Failed")

      sensor = Sensor.ASPC
      XCTAssertEqual(sensor.size,CGSize(width: 23.6.mm, height: 15.7.mm),"ASPC Size Failed")

      sensor = Sensor.ASPCanon
      XCTAssertEqual(sensor.size,CGSize(width: 22.2.mm, height: 14.8.mm),"ASPCanon Size Failed")

      sensor = Sensor.Foveon
      XCTAssertEqual(sensor.size,CGSize(width: 20.7.mm, height: 13.8.mm),"Foveon Size Failed")

      sensor = Sensor.MicroFourThird
      XCTAssertEqual(sensor.size,CGSize(width: 17.3.mm, height: 13.0.mm),"Micro Four Third Size Failed")

      sensor = Sensor.OneInch
      XCTAssertEqual(sensor.size,CGSize(width: 13.2.mm, height: 8.8.mm),"OneInch Size Failed")

      sensor = Sensor.TwoThird
      XCTAssertEqual(sensor.size,CGSize(width: 8.6.mm, height: 6.6.mm),"TwoThird Size Failed")
      
      XCTAssertEqual(Sensor.ZeissFormula.traditional.rawValue, 1000,"Zeiss Traditional failed")
      XCTAssertEqual(Sensor.ZeissFormula.modern.rawValue, 1500,"Zeiss Modern failed")
      XCTAssertEqual(Sensor.ZeissFormula.classic.rawValue, 1730,"Zeiss classic failed")
    }
}
