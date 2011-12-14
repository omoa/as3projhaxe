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
import net.vis4.map.proj.Projection;

class AugustProjection extends Projection {

	static var M : Float = 1.333333333333333;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var t : Float;
		var c1 : Float;
		var c : Float;
		var x1 : Float;
		var x12 : Float;
		var y1 : Float;
		var y12 : Float;
		t = Math.tan(.5 * lpphi);
		c1 = Math.sqrt(1. - t * t);
		c = 1. + c1 * Math.cos(lplam *= .5);
		x1 = Math.sin(lplam) * c1 / c;
		y1 = t / c;
		out.x = M * x1 * (3. + (x12 = x1 * x1) - 3. * (y12 = y1 * y1));
		out.y = M * y1 * (3. + 3. * x12 - y12);
		return out;
	}

	override public function isConformal() : Bool {
		return true;
	}

	override public function hasInverse() : Bool {
		return false;
	}

	override public function toString() : String {
		return "August Epicycloidal";
	}

	override public function getShortName() : String {
		return "August";
	}

}

