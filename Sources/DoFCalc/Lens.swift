/**
 Lens.swift
 
 Created by Carsten Müller on 01.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Foundation
import SwiftUI

/// Lens describes a simple Lens in the DoF calculation model
/// The lens is described by its optical parameters as there are:
/// maximum aperture and minimum aperture ( defined as a=2^(i/2) with i⋲ℕ)
/// focal length and
/// minimalFocusDistance
/// As well as the name of the Manufacturer
/// and the model of the lens.


public class Lens : Hashable, Equatable, Codable, Comparable, ObservableObject{

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
  
  
  public static func apertureForIndex(_ index:Int) -> Double{
    return Double(pow(2.0, Double(index)/2.0))
  }
  
  public static func indexForAperture(_ aperture: Double) -> Int {
    return Int(round(2*log2(aperture)))
  }
  
  public func getMinApertureIndex() -> Int{
    return Lens.indexForAperture(minAperture)
  }
  
  public func getMaxApertureIndex() -> Int{
    return Lens.indexForAperture(maxAperture)
  }
  
  
  
  
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

public class Lenses : Codable{
  @Published public var lenses:[Lens] = []
  
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
  
  
}

