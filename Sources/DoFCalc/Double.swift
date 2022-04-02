/**
 
 Double.swift
 
 holding some extension to Double and float for simpler convertion to mm
 
 Created by Carsten Müller on 02.04.22.
 Copyright © 2022 Carsten Müller. All rights reserved.
 
 */

import Foundation

extension Double{
  var mm:Double {return self * 1.0}
  var cm:Double {return self * 10.0}
  var dm:Double {return self * 100.0}
  var m:Double  {return self * 1000.0}
  var km:Double { return self * 100000.0}
}

extension Float {
  var mm:Float {return self * 1.0}
  var cm:Float {return self * 10.0}
  var dm:Float {return self * 100.0}
  var m:Float  {return self * 1000.0}
  var km:Float { return self * 100000.0}
}
