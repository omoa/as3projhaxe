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

class Eckert5Projection extends Projection {

	static var XF : Float = 0.44101277172455148219;
	static var RXF : Float = 2.26750802723822639137;
	static var YF : Float = 0.88202554344910296438;
	static var RYF : Float = 1.13375401361911319568;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		out.x = XF * (1. + Math.cos(lpphi)) * lplam;
		out.y = YF * lpphi;
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		out.x = RXF * xyx / (1. + Math.cos(out.y = RYF * xyy));
		return out;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Eckert V";
	}

}

