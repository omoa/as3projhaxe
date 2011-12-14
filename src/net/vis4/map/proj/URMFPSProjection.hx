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

class URMFPSProjection extends Projection {
	public var n(getN, setN) : Float;

	static var C_x : Float = 0.8773826753;
	static var Cy : Float = 1.139753528477;
	var _n : Float;
	// wag1
	var C_y : Float;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		out.y = MapMath.asin(n * Math.sin(lpphi));
		out.x = C_x * lplam * Math.cos(lpphi);
		out.y = C_y * lpphi;
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		xyy /= C_y;
		out.x = xyx / (C_x * Math.cos(xyy));
		out.y = MapMath.asin(Math.sin(xyy) / n);
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function initialize() : Void {
		super.initialize();
		if(n <= 0. || n > 1.) throw new ProjectionError("-40");
		C_y = Cy / n;
	}

	override public function toString() : String {
		return "Urmaev Flat-Polar Sinusoidal";
	}

	override public function getShortName() : String {
		return "Urmaev";
	}

	public function getN() : Float {
		return _n;
	}

	public function setN(value : Float) : Float {
		_n = value;
		return value;
	}

}

