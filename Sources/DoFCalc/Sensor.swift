/**
 
 Sensor.swift
 
 Created by Carsten Müller on 01.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Foundation
// Simple Sensor model

public struct Sensor: Hashable,Codable,Equatable{

  public enum ZeissFormula:Int {
    case classic 			= 1730
    case traditional 	= 1000
    case modern 			= 1500
  }
  /// Size of the sensor in mm
  public var size:CGSize

  public var diagonal:Double{
    get {
      return Double((size.width*size.width + size.height*size.height)).squareRoot()
    }
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(size.width)
    hasher.combine(size.height)
  }
  
  public static func ==(lhs:Sensor, rhs:Sensor) -> Bool {
    return lhs.size == rhs.size
  }

  public init(width:Double, height:Double){
    self.size = CGSize(width: width, height: height)
  }
  
  public init(_ size: CGSize){
    self.size = size
  }
  
  public func calcCoC(withCustom formula:Double) -> Double {
    return diagonal/Double(formula)
  }
  
  public func calcCoC(withZeiss formula:ZeissFormula) -> Double{
    return calcCoC(withCustom: Double(formula.rawValue))
  }
  
  public func calcCoC() -> Double {
    return calcCoC(withZeiss: ZeissFormula.modern)
  }
  
}
