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
import net.vis4.map.proj.PseudoCylindricalProjection;

class BoggsProjection extends PseudoCylindricalProjection {

	static var NITER : Int = 20;
	static var EPS : Float = 1e-7;
	static var ONETOL : Float = 1.000001;
	static var FXC : Float = 2.00276;
	static var FXC2 : Float = 1.11072;
	static var FYC : Float = 0.49931;
	static var FYC2 : Float = 1.41421356237309504880;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var theta : Float;
		var th1 : Float;
		var c : Float;
		var i : Int;
		theta = lpphi;
		if(Math.abs(Math.abs(lpphi) - MapMath.HALFPI) < EPS) out.x = 0.
		else  {
			c = Math.sin(theta) * Math.PI;
			i = NITER;
			while(i > 0) {
				theta -= th1 = (theta + Math.sin(theta) - c) / (1. + Math.cos(theta));
				if(Math.abs(th1) < EPS) break;
				--i;
			}
			theta *= 0.5;
			out.x = FXC * lplam / (1. / Math.cos(lpphi) + FXC2 / Math.cos(theta));
		}

		out.y = FYC * (lpphi + FYC2 * Math.sin(theta));
		return out;
	}

	override public function isEqualArea() : Bool {
		return true;
	}

	override public function hasInverse() : Bool {
		return false;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Boggs Eumorphic";
	}

	override public function getShortName() : String {
		return "Boggs";
	}

}

