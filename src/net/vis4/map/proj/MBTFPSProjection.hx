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
import net.vis4.map.MapMath;

class MBTFPSProjection extends Projection {

	static var MAX_ITER : Int = 10;
	static var LOOP_TOL : Float = 1e-7;
	static var C1 : Float = 0.45503;
	static var C2 : Float = 1.36509;
	static var C3 : Float = 1.41546;
	static var C_x : Float = 0.22248;
	static var C_y : Float = 1.44492;
	static var C1_2 : Float = 0.33333333333333333333333333;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var k : Float;
		var V : Float;
		var t : Float;
		var i : Int;
		k = C3 * Math.sin(lpphi);
		i = MAX_ITER;
		while(i > 0) {
			t = lpphi / C2;
			out.y -= V = (C1 * Math.sin(t) + Math.sin(lpphi) - k) / (C1_2 * Math.cos(t) + Math.cos(lpphi));
			if(Math.abs(V) < LOOP_TOL) break;
			i--;
		}
		t = lpphi / C2;
		out.x = C_x * lplam * (1. + 3. * Math.cos(lpphi) / Math.cos(t));
		out.y = C_y * Math.sin(t);
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var t : Float;
		var s : Float;
		out.y = C2 * (t = MapMath.asin(xyy / C_y));
		out.x = xyx / (C_x * (1. + 3. * Math.cos(out.y) / Math.cos(t)));
		out.y = MapMath.asin((C1 * Math.sin(t) + Math.sin(out.y)) / C3);
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function toString() : String {
		return "McBryde-Thomas Flat-Polar Sine II";
	}

	override public function getShortName() : String {
		return "MBTFPS II";
	}

}

