/**
 Lens.swift
 
 Created by Carsten Müller on 01.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Foundation
import SwiftUI

public struct ApertureDescription:Hashable{
  public var label:String
  public var aperture:Double
  public var isStepEnd:Bool = false
  
  public init(label:String="𝒇 1.4",aperture:Double = 1.4, isStepEnd:Bool = false){
    self.label = label
    self.aperture = aperture
    self.isStepEnd = isStepEnd
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(label)
    hasher.combine(aperture)
    hasher.combine(isStepEnd)
  }
}

/// Lens describes a simple Lens in the DoF calculation model
/// The lens is described by its optical parameters as there are:
/// maximum aperture and minimum aperture ( defined as a=2^(i/2) with i⋲ℕ)
/// focal length and
/// minimalFocusDistance
/// As well as the name of the Manufacturer
/// and the model of the lens.

public class Lens : Hashable, Equatable, Codable, Comparable, ObservableObject, Identifiable{
  
  public static var apertureList:[Double] = [1.0, 1.1, 1.2,
                                             1.4, 1.6, 1.8,
                                             2.0, 2.2, 2.5,
                                             2.8, 3.2, 3.5,
                                             4.0, 4.5, 5.0,
                                             5.6, 6.3, 7.1,
                                             8.0, 9.0, 10.0,
                                             11.0, 13.0, 14.0,
                                             16.0, 18.0, 20.0,
                                             22.0, 25.0, 29.0,
                                             32.0, 36.0, 40.0]
  
  /// Name of the Mannufacturer
  @Published public var manufacturer:String = ""
  
  /// an optional model name
  @Published public var modelName:String = ""
  
  /// maximum aperture of the lens
  @Published public var maxAperture:Double = 1.4
  
  /// minmal aperture of the lens
  @Published public var minAperture:Double = 22.0
  
  /// focal length. At the moment we do not support zoom lenses.
  @Published public var focalLength:Double = 50.0.mm
  
  /// the minimal focus distance of this lens
  @Published public var minimalFocalDistance:Double = 35.0.cm
  
  
  public enum apertureFraction:Int{
    case none     = 0
    case third    = 1
    case twoThird = 2
  }

  public static func aperture(for index:Int, frac:apertureFraction) -> Double{
    let index:Int = Int(index*3) + frac.rawValue
    return Lens.apertureList[index]
  }

  public func apertureList() -> [ApertureDescription] {
    var result:[ApertureDescription] = []
    guard let startIndex = Lens.apertureList.firstIndex(of: self.maxAperture) else {return result}
    guard let endIndex = Lens.apertureList.firstIndex(of: self.minAperture) else {return result}
    var k = 1
    for index in startIndex..<endIndex {
      let t = ApertureDescription(label: String(format:"𝒇 / %0.1f",Lens.apertureList[index]),
                                                aperture: Lens.apertureList[index],
                                                isStepEnd: (k % 3) == 0)
      k += 1
      result.append(t)
    }
    return result
  }
//  public static func apertureForIndex(_ index:Int) -> Double{
//    let q = Int(Double(pow(2.0, Double(index)/2.0)) * 10.0)
//    return Double(q)/10.0
//  }
  
//  public static func indexForAperture(_ aperture: Double) -> Int {
//    return Int(round(2*log2(aperture)))
//  }
  
//  public func getMinApertureIndex() -> Int{
//    return Lens.indexForAperture(minAperture)
//  }
//  
//  public func getMaxApertureIndex() -> Int{
//    return Lens.indexForAperture(maxAperture)
//  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(manufacturer)
    hasher.combine(modelName)
    hasher.combine(maxAperture)
    hasher.combine(focalLength)
  }
  
  public static func == (lhs:Lens, rhs:Lens) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
  public static func < (lhs: Lens, rhs: Lens) -> Bool {
    if lhs.manufacturer != rhs.manufacturer{
      return lhs.manufacturer < rhs.manufacturer
    }
    if lhs.modelName != rhs.modelName {
      return lhs.modelName < rhs.modelName
    }
    if lhs.focalLength != rhs.focalLength {
      return lhs.focalLength < rhs.focalLength
    }
    if lhs.maxAperture != rhs.maxAperture {
      return lhs.maxAperture < rhs.maxAperture
    }
    if lhs.minAperture != rhs.minAperture {
      return lhs.minAperture < rhs.minAperture
    }
    return lhs.minimalFocalDistance < rhs.minimalFocalDistance
  }
  public convenience init(){
    self.init(manufacturer: "", modelName: "", maxAperture: 1.4, minAperture: 22, focalLength: 50, minimalFocalDistance: 38.0.cm)
  }
  
  public init(manufacturer:String, modelName:String, maxAperture:Double, minAperture:Double, focalLength:Double, minimalFocalDistance:Double){
    self.manufacturer = manufacturer
    self.modelName = modelName
    self.maxAperture = maxAperture
    self.minAperture = minAperture
    self.focalLength = focalLength
    self.minimalFocalDistance = minimalFocalDistance
  }
  
  public init(another:Lens){
    self.manufacturer = another.manufacturer
    self.modelName = another.modelName
    self.maxAperture = another.maxAperture
    self.minAperture = another.minAperture
    self.focalLength = another.focalLength
    self.minimalFocalDistance = another.minimalFocalDistance
  }
  
  public static func &= (lhs:Lens, rhs:Lens){
    if lhs.manufacturer != rhs.manufacturer {
      lhs.manufacturer = rhs.manufacturer
    }
    
    if lhs.modelName != rhs.modelName {
      lhs.modelName = rhs.modelName
    }
    
    if lhs.maxAperture != rhs.maxAperture {
      lhs.maxAperture = rhs.maxAperture
    }
    
    if lhs.minAperture != rhs.minAperture {
      lhs.minAperture = rhs.minAperture
    }
    
    if lhs.focalLength != rhs.focalLength {
      lhs.focalLength = rhs.focalLength
    }
    
    if lhs.minimalFocalDistance != rhs.minimalFocalDistance {
      lhs.minimalFocalDistance = rhs.minimalFocalDistance
    }
  }
  
  
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    manufacturer = try container.decode(String.self, forKey: .manufacturer)
    modelName = try container.decode(String.self, forKey: .modelName)
    maxAperture = try container.decode(Double.self, forKey: .maxAperture)
    minAperture = try container.decode(Double.self, forKey: .minAperture)
    focalLength = try container.decode(Double.self, forKey: .focalLength)
    minimalFocalDistance = try container.decode(Double.self, forKey: .minimalFocalDistance)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(manufacturer, forKey: .manufacturer)
    try container.encode(modelName, forKey: .modelName)
    try container.encode(maxAperture, forKey: .maxAperture)
    try container.encode(minAperture, forKey: .minAperture)
    try container.encode(focalLength, forKey: .focalLength)
    try container.encode(minimalFocalDistance, forKey: .minimalFocalDistance)
  }
  
  public enum CodingKeys:String, CodingKey{
    case manufacturer = "Manufacturer"
    case modelName = "Model"
    case maxAperture = "MaximumAperture"
    case minAperture = "MinimumAperture"
    case focalLength = "FocalLength"
    case minimalFocalDistance = "MinimalFocalDistance"
  }
  
  
}


public class Lenses : Codable, ObservableObject{
  @Published public var lenses:[Lens] = []
  
  public static func dummyLenses() -> Lenses {
    let json="""
    {
      "Lenses": [
        {
          "Manufacturer": "Sigma",
          "Model": "105mm F2,8 DG DN MACRO | Art",
          "MaximumAperture": 2.8,
          "MinimumAperture": 22,
          "FocalLength": 105,
          "MinimalFocalDistance": 29.5
        },
        {
          "Manufacturer": "Sigma",
          "Model": "150mm F2.8 APO MACRO DG HSM",
          "MaximumAperture": 2.8,
          "MinimumAperture": 22,
          "FocalLength": 150,
          "MinimalFocalDistance": 38.0
        },
        {
          "Manufacturer": "Sigma",
          "Model": "70mm  F2.8 DG MACRO",
          "MaximumAperture": 2.8,
          "MinimumAperture": 22,
          "FocalLength": 70,
          "MinimalFocalDistance": 25.7
        }
      ]
      
    }
    """
    
    let data = json.data(using: .utf8) ?? Data()
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    //
    //
    let newData = try? decoder.decode(Lenses.self, from: data)
    return newData ?? Lenses()
  }
  
  public init(){
  }
  
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    lenses = try container.decode([Lens].self, forKey: .lenses)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(lenses, forKey: .lenses)
  }
  
  public enum CodingKeys:String, CodingKey{
    case lenses = "Lenses"
  }
  
  public func updateFrom(_ other:Lenses){
    self.lenses.removeAll()
    for lens in other.lenses {
      self.lenses.append(lens)
    }
  }
  
  
}

