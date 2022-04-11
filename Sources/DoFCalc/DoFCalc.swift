/**
 DoFCalc.swift
 
 Implementation of the basic  DoF calculations
 
 
 Created by Carsten Müller on 02.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Darwin
import SwiftUI

/// Error thrown by the DoFCalc
public enum DoFCalcErrors : Error {
  /// thrown if aperture is to large
  case ApertureToBig(maxAperture: Double)
  
  /// thrown if aperture is to low
  case ApertureToSmall(minAperture: Double)
  
  /// thrown in case the given distance is smaller than the minimal focal distance of the lens
  case ObjectDistanceToLow(minObjectDistance: Double)
  
  case LensNotIntialized
  
  case SensorNotInitialized
}

/// provides the basic DoF calculation interface.
public struct DoFCalc{
  public var sensor:Sensor?
  public var lens:Lens?
  
  public init(_ sensor: Sensor? = nil, _ lens:Lens? = nil) {
    self.sensor = sensor
    self.lens = lens
  }
  
  public func hyperFocalDistance(aperture:Double, zeissQuotient:Double) -> Measurement<UnitLength> {
    var distance = 0.0
    do {
      distance = try self.calcHyperfocalDistance(aperture: aperture, zeissQuotient: zeissQuotient)
    }catch{
      distance = 0.0
    }
    
    return Measurement(value: distance, unit: UnitLength.millimeters)
  }
  
  public func nearFocalDistance(objectDistance:Double, aperture:Double,zeissQuotient:Double) -> Measurement<UnitLength> {
    var distance = 0.0
    do {
      distance = try self.calcNearDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: zeissQuotient)
    }catch{
      distance = 0.0
    }
    return Measurement(value: distance, unit: UnitLength.millimeters)
  }
  
  public func farFocalDistance(objectDistance:Double, aperture:Double,zeissQuotient:Double) -> Measurement<UnitLength> {
    var distance = 0.0
    do {
      distance = try self.calcFarDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: zeissQuotient)

    }catch{
      distance = 0.0
    }
    return Measurement(value: distance, unit: UnitLength.millimeters)
  }
  

  public func calcHyperDistance(aperture: Double, zeissQuotient:Double) -> Double {
    do {
      let distance = try self.calcHyperfocalDistance(aperture: aperture, zeissQuotient: zeissQuotient)
      return distance
    }catch{
      return 0.0
    }
  }
  
  public func calcNear(objectDistance:Double, aperture:Double,zeissQuotient:Double) -> Double {
    do {
      let distance = try self.calcNearDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: zeissQuotient)
      return distance
    }catch{
      return 0.0
    }
  }
  
  public func calcFar(objectDistance:Double, aperture:Double,zeissQuotient:Double) -> Double {
    do {
      let distance = try self.calcFarDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: zeissQuotient)
      return distance
    }catch{
      return 0.0
    }
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
    guard let intLens = self.lens else { throw DoFCalcErrors.LensNotIntialized}
    guard let intSensor = self.sensor else {throw DoFCalcErrors.SensorNotInitialized}

    if aperture < intLens.maxAperture {
      throw DoFCalcErrors.ApertureToBig(maxAperture: intLens.maxAperture)
    }
    if aperture > intLens.minAperture {
      throw DoFCalcErrors.ApertureToSmall(minAperture: intLens.minAperture)
    }
    let f = intLens.focalLength
    let coc = intSensor.calcCoC(withCustom: zeissQuotient)
    let h = ( (f*f) / (aperture*coc) )+f
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
    guard let intLens = self.lens else{ throw DoFCalcErrors.LensNotIntialized}
    
    if objectDistance < intLens.minimalFocalDistance{
      throw DoFCalcErrors.ObjectDistanceToLow(minObjectDistance: intLens.minimalFocalDistance)
    }
    let H = try calcHyperfocalDistance(aperture: aperture, zeissQuotient: zeissQuotient)
    let f = intLens.focalLength
    let p = objectDistance*(H-f)
    let q = (H+objectDistance) - (2*f)
    return p/q
  }
  
  public func calcNearDistance(objectDistance:Double, aperture:Double, zeissRatio:Sensor.ZeissRatio) throws -> Double{
    return try calcNearDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: Double(zeissRatio.rawValue))
  }
  
  /// Calculates the far distance of acceptable sharpness in mm for the given values. The object distance is in mm!
  public func calcFarDistance(objectDistance:Double, aperture:Double,zeissQuotient:Double) throws -> Double{
    guard let intLens = self.lens else { throw DoFCalcErrors.LensNotIntialized}

    if objectDistance < intLens.minimalFocalDistance{
      throw DoFCalcErrors.ObjectDistanceToLow(minObjectDistance: intLens.minimalFocalDistance)
    }
    
    let H = try calcHyperfocalDistance(aperture: aperture, zeissQuotient: zeissQuotient)
    let f = intLens.focalLength
    let p = objectDistance*(H-f)
    let q = H - objectDistance
    return p / q
  }

  public func calcFarDistance(objectDistance:Double, aperture:Double, zeissRatio:Sensor.ZeissRatio) throws -> Double{
    return try calcFarDistance(objectDistance: objectDistance, aperture: aperture, zeissQuotient: Double(zeissRatio.rawValue))
  }
  
}
