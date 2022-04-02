/**
 DoFCalc.swift
 
 Implementation fo the basic calculator for DoF calculations
 Created by Carsten Müller on 02.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Darwin

public enum DoFCalcErrors : Error {
  case ApertureToBig(maxAperture: Double)
  case ApertureToSmall(minAperture: Double)
  case ObjectDistanceToLow(minObjectDistance: Double)
}

public struct DoFCalc{
  public var sensor:Sensor
  public var lens:Lens
  
  public init(sensor: Sensor, lens:Lens) {
    self.sensor = sensor
    self.lens = lens
  }
  /// Calulates the hyperfocal distance for a given aperture and zeiss Value
  /// the return value is in mm

  public func calcHyperfocalDistance(aperture:Double, zeissValue:Double) throws -> Double {
    if aperture < lens.maxAperture {
      throw DoFCalcErrors.ApertureToBig(maxAperture: lens.maxAperture)
    }
    if aperture > lens.minAperture {
      throw DoFCalcErrors.ApertureToSmall(minAperture: lens.minAperture)
    }
    let f = lens.focalLength
    let coc = sensor.calcCoC(withCustom: zeissValue)
    let h = (f*f/aperture*coc)+f
    return h
  }
  
  /// Calculates the hyperfocal distance in mm for a given aperture and ZeissFormula
  public func calcHyperfocalDistance(aperture:Double, zeiss:Sensor.ZeissFormula) throws -> Double {
    return try calcHyperfocalDistance(aperture: aperture, zeissValue: Double(zeiss.rawValue))
  }
  
  /// Calculates the near distance of acceptable sharpness in mm for the given values. The Object distance is in mm!
  public func calcNearDistance(objectDistance:Double, aperture:Double, zeissValue:Double) throws -> Double {

    if objectDistance < self.lens.minimalFocalDistance{
      throw DoFCalcErrors.ObjectDistanceToLow(minObjectDistance: self.lens.minimalFocalDistance)
    }
    let H = try calcHyperfocalDistance(aperture: aperture, zeissValue: zeissValue)
    let f = lens.focalLength
    let p = objectDistance*(H-f)
    let q = (H+objectDistance) - (2*f)
    return p/q
  }
  
  public func calcNearDistance(objectDistance:Double, aperture:Double, zeiss:Sensor.ZeissFormula) throws -> Double{
    return try calcNearDistance(objectDistance: objectDistance, aperture: aperture, zeissValue: Double(zeiss.rawValue))
  }
  
  /// Calculates the far distance of acceptable sharpness in mm for the given values. The object distance is in mm!
  public func calcFarDistance(objectDistance:Double, aperture:Double,zeissValue:Double) throws -> Double{
    let H = try calcHyperfocalDistance(aperture: aperture, zeissValue: zeissValue)
    let f = lens.focalLength
    let p = objectDistance*(H-f)
    let q = H - objectDistance
    return p / q
  }

  public func calcFarDistance(objectDistance:Double, aperture:Double, zeiss:Sensor.ZeissFormula) throws -> Double{
    return try calcFarDistance(objectDistance: objectDistance, aperture: aperture, zeissValue: Double(zeiss.rawValue))
  }
  
}
