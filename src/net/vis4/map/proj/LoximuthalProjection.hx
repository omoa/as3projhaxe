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

class LoximuthalProjection extends PseudoCylindricalProjection {

	static var FC : Float = .92131773192356127802;
	static var RP : Float = .31830988618379067154;
	static var EPS : Float = 1e-8;
	var phi1 : Float;
	var cosphi1 : Float;
	var tanphi1 : Float;
	public function new() {
		phi1 = MapMath.toRadians(0.1);
		//FIXME - param
		cosphi1 = Math.cos(phi1);
		tanphi1 = Math.tan(MapMath.QUARTERPI + 0.5 * phi1);
		minLatitude = MapMath.degToRad(-89);
		maxLatitude = MapMath.degToRad(89);
	}

	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		out.y = lpphi - phi1;
		if(phi1 == lpphi) out.x = lplam * Math.cos(phi1)
		else out.x = lplam * (lpphi - phi1) / (Math.log(Math.tan(MapMath.QUARTERPI + .5 * lpphi)) - Math.log(Math.tan(MapMath.QUARTERPI + .5 * phi1)));
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		out.y = xyy + phi1;
		if(out.y == phi1) out.x = Math.acos(phi1 / xyx);
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function getInventor() : String {
		return "Karl Siemon";
	}

	override public function getYear() : Int {
		return 1935;
	}

	override public function toString() : String {
		return "Loximuthal";
	}

}

