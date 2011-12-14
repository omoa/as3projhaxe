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

class TCEAProjection extends Projection {

	var rk0 : Float;
	public function new() {
		initialize();
	}

	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		out.x = rk0 * Math.cos(lpphi) * Math.sin(lplam);
		out.y = scaleFactor * (Math.atan2(Math.tan(lpphi), Math.cos(lplam)) - projectionLatitude);
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var t : Float;
		out.y = xyy * rk0 + projectionLatitude;
		out.x *= scaleFactor;
		t = Math.sqrt(1. - xyx * xyx);
		out.y = Math.asin(t * Math.sin(xyy));
		out.x = Math.atan2(xyx, t * Math.cos(xyy));
		return out;
	}

	override public function initialize() : Void {
		super.initialize();
		rk0 = 1 / scaleFactor;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Transverse Cylindrical Equal Area";
	}

	override public function getShortName() : String {
		return "TCEA";
	}

	override public function isEqualArea() : Bool {
		return true;
	}

}

