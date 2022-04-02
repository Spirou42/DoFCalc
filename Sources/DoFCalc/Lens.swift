/**
 Lens.swift
 
 Created by Carsten Müller on 01.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Foundation
/// Lens describes a simple Lens in the DoF calculation model
/// The lens is described by its optical parameters as there are:
/// maximum aperture and minimum aperture ( defined as a=2^(i/2) with i⋲ℕ)
/// focal length and
/// minimalFocusDistance
/// As well as the name of the Manufacturer
/// and the model of the lens.


public struct Lens : Hashable, Equatable, Codable, Comparable{

  /// Name of the Mannufacturer
  public var manufacturer:String

  /// an optional model name
  public var modelName:String
  /// maximum aperture of the lens
  public var maxAperture:Double

  /// minmal aperture of the lens
  public var minAperture:Double = 22.0

  /// focal length. At the moment we do not support zoom lenses.
  public var focalLength:Double

  /// the minimal focus distance of this lens
  public var minimalFocalDistance:Double = 0.0.mm
  
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
  
  public enum CodingKeys:String, CodingKey{
    case manufacturer = "Manufacturer"
    case modelName = "Model"
    case maxAperture = "MaximumAperture"
    case minAperture = "MinimumAperture"
    case focalLength = "FocalLength"
    case minimalFocalDistance = "MinimalFocalDistance"
  }
}
