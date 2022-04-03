/**
 DoFCalc.swift
 
 Implementation of the basic  DoF calculations
 
 
 Created by Carsten Müller on 02.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Darwin


/// Error thrown by the DoFCalc
public enum DoFCalcErrors : Error {
  /// thrown if aperture is to large
  case ApertureToBig(maxAperture: Double)
  
  /// thrown if aperture is to low
  case ApertureToSmall(minAperture: Double)
  
  /// thrown in case the given distance is smaller than the minimal focal distance of the lens
  case ObjectDistanceToLow(minObjectDistance: Double)
}

/// provides the basic DoF calculation interface.
public struct DoFCalc{
  public var sensor:Sensor
  public var lens:Lens
  
  public init(sensor: Sensor, lens:Lens) {
    self.sensor = sensor
    self.lens = lens
  }

  
  
  /// Calulates the hyperfocal distance.
  ///
  /// - Parameters:
  ///   - aperture: the aperture value. Given as 2^(i/2) with i⋲ℕ. i.e. 1.4, 2.0, 2.8 ...
  ///   - zeissQuotient: the Zeiss quotient for calculating the CoC
  ///
  /// - Returns: the hyperfocal distance in mm
  ///
  /// - Throws: `DoFCalcErrors.ApertureToBig` and `DoFCalcError.ApertureToBig` if the aperture value excedes the range defined by the lens
  ///
  public func calcHyperfocalDistance(aperture:Double, zeissQuotient:Double) throws -> Double {
    if aperture < lens.maxAperture {
      throw DoFCalcErrors.ApertureToBig(maxAperture: lens.maxAperture)
    }
    if aperture > lens.minAperture {
      throw DoFCalcErrors.ApertureToSmall(minAperture: lens.minAperture)
    }
    let f = lens.focalLength
    let coc = sensor.calcCoC(withCustom: zeissQuotient)
    let h = (f*f/aperture*coc)+f
    return h
  }
  
  /// Calculates the hyperfocal distance in mm for a given aperture (a=2^(i/2) with i⋲ℕ) and a predefined ZeissRatio.
  /// The return value is in mm!
  public func calcHyperfocalDistance(aperture:Double, zeiss:Sensor.ZeissRatio) throws -> Double {
    return try calcHyperfocalDistance(aperture: aperture, zeissQuotient: Double(zeiss.rawValue))
  }
  
  /// Calculates the near distance of acceptable sharpness in mm for ta given aperture (a=2^(i/2) with i⋲ℕ) and zeiss quotient.
  ///  The Object distance is in mm!
  public func calcNearDistance(objectDistance:Double, aperture:Double, zeissQuotient:Double) throws -> Double {

    if objectDistance < self.lens.minimalFocalDistance{
      throw DoFCalcErrors.ObjectDistanceToLow(minObjectDistance: self.lens.minimalFocalDistance)
    }
    let H = try calcHyperfocalDistance(aperture: aperture, zeissQuotient: zeissQuotient)
    let f = lens.focalLength
    let p = objectDistance*(H-f)
    let q = (H+objectDistance) - (2*f)
    return p/q
  }
  
  public func calcNearDistance(objectDistance:Double, aperture:Double, zeissRatio:Sensor.ZeissRatio) throws -> Double{
    return try calcNearDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: Double(zeissRatio.rawValue))
  }
  
  /// Calculates the far distance of acceptable sharpness in mm for the given values. The object distance is in mm!
  public func calcFarDistance(objectDistance:Double, aperture:Double,zeissQuotient:Double) throws -> Double{
    let H = try calcHyperfocalDistance(aperture: aperture, zeissQuotient: zeissQuotient)
    let f = lens.focalLength
    let p = objectDistance*(H-f)
    let q = H - objectDistance
    return p / q
  }

  public func calcFarDistance(objectDistance:Double, aperture:Double, zeissRatio:Sensor.ZeissRatio) throws -> Double{
    return try calcFarDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: Double(zeissRatio.rawValue))
  }
  
}
