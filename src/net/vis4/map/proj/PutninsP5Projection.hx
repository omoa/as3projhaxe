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

class PutninsP5Projection extends Projection {

	var A : Float;
	var B : Float;
	static var C : Float = 1.01346;
	static var D : Float = 1.2158542;
	public function new() {
		A = 2;
		B = 1;
	}

	override public function project(lplam : Float, lpphi : Float, xy : Point) : Point {
		xy.x = C * lplam * (A - B * Math.sqrt(1. + D * lpphi * lpphi));
		xy.y = C * lpphi;
		return xy;
	}

	override public function projectInverse(xyx : Float, xyy : Float, lp : Point) : Point {
		lp.y = xyy / C;
		lp.x = xyx / (C * (A - B * Math.sqrt(1. + D * lp.y * lp.y)));
		return lp;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Putnins P5";
	}

}

