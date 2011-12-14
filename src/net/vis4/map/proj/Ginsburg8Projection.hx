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

class Ginsburg8Projection extends Projection {

	static var Cl : Float = 0.000952426;
	static var Cp : Float = 0.162388;
	static var C12 : Float = 0.08333333333333333;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var t : Float = lpphi * lpphi;
		out.y = lpphi * (1. + t * C12);
		out.x = lplam * (1. - Cp * t);
		t = lplam * lplam;
		out.x *= (0.87 - Cl * t * t);
		return out;
	}

	override public function toString() : String {
		return "Ginsburg VIII (TsNIIGAiK)";
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function getShortName() : String {
		return "Ginsburg VIII";
	}

}

