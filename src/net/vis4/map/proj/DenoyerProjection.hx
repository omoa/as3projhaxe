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

class DenoyerProjection extends Projection {

	static public var C0 : Float = 0.95;
	static public var C1 : Float = -.08333333333333333333;
	static public var C3 : Float = 0.00166666666666666666;
	static public var D1 : Float = 0.9;
	static public var D5 : Float = 0.03;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		out.y = lpphi;
		out.x = lplam;
		var aphi : Float = Math.abs(lplam);
		out.x *= Math.cos((C0 + aphi * (C1 + aphi * aphi * C3)) * (lpphi * (D1 + D5 * lpphi * lpphi * lpphi * lpphi)));
		return out;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function hasInverse() : Bool {
		return false;
	}

	override public function toString() : String {
		return "Denoyer Semi-elliptical";
	}

	override public function getShortName() : String {
		return "Denoyer";
	}

}

