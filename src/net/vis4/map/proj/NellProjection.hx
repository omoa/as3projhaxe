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

class NellProjection extends Projection {

	static var MAX_ITER : Int = 10;
	static var LOOP_TOL : Float = 1e-7;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var k : Float;
		var d : Float;
		var x : Float;
		var i : Int;
		//rho + Math.sin(rho) = 2 * Math.sin(lpphi);
		k = 2. * Math.sin(lpphi);
		x = .34;
		i = MAX_ITER;
		while(i > 0) {
			x = x - (x + Math.sin(x) - k) / (1 + Math.cos(x));
			// thanks to newton
			d = (x + Math.sin(x) - k);
			// calc difference
			if(Math.abs(d) < LOOP_TOL) break;
			--i;
		}
		out.x = 0.5 * lplam * (1. + Math.cos(lpphi));
		out.y = x;
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var th : Float;
		var s : Float;
		// unneeded vars?
		out.x = 2. * xyx / (1. + Math.cos(xyy));
		out.y = MapMath.asin(0.5 * (xyy + Math.sin(xyy)));
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function isEqualArea() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Nell";
	}

	override public function getInventor() : String {
		return "A.M. Nell";
	}

	override public function getYear() : Int {
		return 1890;
	}

}

