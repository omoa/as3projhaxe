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

class LaskowskiProjection extends Projection {

	static var a10 : Float = 0.975534;
	static var a12 : Float = -0.119161;
	static var a32 : Float = -0.0143059;
	static var a14 : Float = -0.0547009;
	static var b01 : Float = 1.00384;
	static var b21 : Float = 0.0802894;
	static var b03 : Float = 0.0998909;
	static var b41 : Float = 0.000199025;
	static var b23 : Float = -0.0285500;
	static var b05 : Float = -0.0491032;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var l2 : Float;
		var p2 : Float;
		l2 = lplam * lplam;
		p2 = lpphi * lpphi;
		out.x = lplam * (a10 + p2 * (a12 + l2 * a32 + p2 * a14));
		out.y = lpphi * (b01 + l2 * (b21 + p2 * b23 + l2 * b41) + p2 * (b03 + p2 * b05));
		return out;
	}

	override public function toString() : String {
		return "Laskowski Tri-Optimal";
	}

	override public function getShortName() : String {
		return "Laskowski";
	}

	override public function getInventor() : String {
		return "P.H. Laskowski";
	}

	override public function getYear() : Int {
		return 1991;
	}

}

