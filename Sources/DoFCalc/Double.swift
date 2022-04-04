/**
 
 Double.swift
 
 holding some extension to Double and float for simpler convertion to mm
 
 Created by Carsten Müller on 02.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 
 */

import Foundation

public enum LengthConvert:Double{
  case mm = 1.0
  case cm = 10.0
  case dm = 100.0
  case  m = 1000.0
  case km = 1000000.0
}

public extension Double{
  var mm:Double {return self * LengthConvert.mm.rawValue}
  var cm:Double {return self * LengthConvert.cm.rawValue}
  var dm:Double {return self * LengthConvert.dm.rawValue}
  var m:Double  {return self * LengthConvert.m.rawValue}
  var km:Double {return self * LengthConvert.km.rawValue}
}

public extension Float {
  var mm:Float {return self * Float(LengthConvert.mm.rawValue)}
  var cm:Float {return self * Float(LengthConvert.cm.rawValue)}
  var dm:Float {return self * Float(LengthConvert.dm.rawValue)}
  var m:Float  {return self * Float(LengthConvert.m.rawValue)}
  var km:Float {return self * Float(LengthConvert.km.rawValue)}
}
