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
import net.vis4.map.proj.PseudoCylindricalProjection;

class AitoffProjection extends PseudoCylindricalProjection {

	static var AITOFF : Int = 0;
	static var WINKEL : Int = 1;
	var winkel : Bool;
	var cosphi1 : Float;
	public function new(type : Int = 0, projectionLatitude : Float = 0) {
		winkel = false;
		cosphi1 = 0;
		super();
		winkel = type == WINKEL;
		this.projectionLatitude = projectionLatitude;
	}

	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var c : Float = 0.5 * lplam;
		var d : Float = Math.acos(Math.cos(lpphi) * Math.cos(c));
		if(d != 0)  {
			out.x = 2. * d * Math.cos(lpphi) * Math.sin(c) * (out.y = 1. / Math.sin(d));
			out.y *= d * Math.sin(lpphi);
		}

		else out.x = out.y = 0.0;
		if(winkel)  {
			out.x = (out.x + lplam * cosphi1) * 0.5;
			out.y = (out.y + lpphi) * 0.5;
		}
		return out;
	}

	override public function initialize() : Void {
		super.initialize();
		if(winkel)  {
			cosphi1 = 0.636619772367581343;
		}
	}

	override public function hasInverse() : Bool {
		return false;
	}

	override public function toString() : String {
		return (winkel) ? "Winkel Tripel" : "Aitoff";
	}

	override public function getShortName() : String {
		return (winkel) ? "Winkel III" : "Aitoff";
	}

	override public function getInventor() : String {
		return (winkel) ? "Oswald Winkel" : "David Aitoff";
	}

	override public function getYear() : Int {
		return (winkel) ? 1921 : 1889;
	}

}

