/*
Copyright 2006 Jerry Huxtable

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
/*
 * This file was semi-automatically converted from the public-domain USGS PROJ source.
 */
/*
 * This file was manually ported to actionscript by Gregor Aisch, vis4.net
 */
package net.vis4.map.proj;

import flash.geom.Point;

class CrasterProjection extends Projection {

	static var XM : Float = 0.97720502380583984317;
	static var RXM : Float = 1.02332670794648848847;
	static var YM : Float = 3.06998012383946546542;
	static var RYM : Float = 0.32573500793527994772;
	static var THIRD : Float = 0.333333333333333333;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		lpphi *= THIRD;
		out.x = XM * lplam * (2. * Math.cos(lpphi + lpphi) - 1.);
		out.y = YM * Math.sin(lpphi);
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		out.y = 3. * Math.asin(xyy * RYM);
		out.x = xyx * RXM / (2. * Math.cos((out.y + out.y) * THIRD) - 1);
		return out;
	}

	override public function isEqualArea() : Bool {
		return true;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Craster Parabolic (Putnins P4)";
	}

	override public function getShortName() : String {
		return "Craster";
	}

	override public function getInventor() : String {
		return "John Evelyn Edmund Craster";
	}

	override public function getYear() : Int {
		return 1929;
	}

}

