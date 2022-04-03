/**
 
 Sensor.swift
 
 Created by Carsten Müller on 01.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Foundation
// Simple Sensor model

public struct Sensor: Hashable,Codable,Equatable{

  public static var FullFrame:Sensor{ get { return Sensor(width: 36.mm, height: 24.mm) } }
  public static var ASPH:Sensor{ get {return Sensor(width: 28.7.mm, height: 19.mm)}}
  public static var ASPC:Sensor{get {return Sensor(width: 23.6.mm, height: 15.7.mm)}}
  public static var ASPCanon:Sensor{get{return Sensor(width: 22.2.mm, height: 14.8.mm)}}
  public static var Foveon:Sensor{get{return Sensor(width: 20.7.mm, height: 13.8.mm)}}
  public static var MicroFourThird:Sensor{get{return Sensor(width: 17.3.mm, height: 13.0.mm)}}
  public static var OneInch:Sensor{get{return Sensor(width: 13.2.mm, height: 8.8.mm)}}
  public static var TwoThird:Sensor{get{return Sensor(width: 8.6.mm, height: 6.6.mm)}}
   
  
  public enum ZeissRatio:Int {
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
  
  public func calcCoC(withZeiss formula:ZeissRatio) -> Double{
    return calcCoC(withCustom: Double(formula.rawValue))
  }
  
  public func calcCoC() -> Double {
    return calcCoC(withZeiss: ZeissRatio.modern)
  }
  
}
