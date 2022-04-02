/**
 Lens.swift
 
 Created by Carsten Müller on 01.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 */

import Foundation
/// Lens describes a simple Lens in the DoF calculation model
/// The lens has a maximum aperture a Focal length and a Manufacturer
public struct Lens : Hashable, Equatable, Codable {

  /// Name of the Mannufacturer
  public var manufacturer:String

  /// an optional model name
  public var modelName:String?
  /// maximum aperture of the lens
  public var maxAperture:Double
  
  public var minAperture:Double = 22.0

  /// focal length. At the moment we do not support zoom lenses.
  public var focalLength:Double
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(manufacturer)
    hasher.combine(modelName)
    hasher.combine(maxAperture)
    hasher.combine(focalLength)
  }
  
  public static func == (lhs:Lens, rhs:Lens) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
