import Darwin
public enum DoFCalcErrors : Error {
  case ApertureToBig(maxAperture: Double)
  case ApertureToSmall(minAperture: Double)
}

public struct DoFCalc{
  public var sensor:Sensor
  public var lens:Lens
  
  public init(sensor: Sensor, lens:Lens) {
    self.sensor = sensor
    self.lens = lens
  }
  
  public func calc_hyperfocal(aperture:Double, zeissValue:Double) throws -> Double {
    if aperture < lens.maxAperture {
      throw DoFCalcErrors.ApertureToBig(maxAperture: lens.maxAperture)
    }
    if aperture > lens.minAperture {
      throw DoFCalcErrors.ApertureToSmall(minAperture: lens.minAperture)
    }
    return pow(lens.focalLength, 2) / (aperture * sensor.calcCoC(withCustom: zeissValue))
  }
  
  public func calc_hyperfocal(aperture:Double, zeiss:Sensor.ZeissFormula) throws -> Double {
    return try calc_hyperfocal(aperture: aperture, zeissValue: Double(zeiss.rawValue))
  }
  
  public func calc_near(distance:Double, aperture:Double, zeissValue:Double) throws -> Double {
    
  }
}
