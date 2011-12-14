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

class MollweideProjection extends PseudoCylindricalProjection {

	static public var MOLLWEIDE : Int = 0;
	static public var WAGNER4 : Int = 1;
	static public var WAGNER5 : Int = 2;
	static var MAX_ITER : Int = 10;
	static var TOLERANCE : Float = 1e-7;
	var type : Int;
	var cx : Float;
	var cy : Float;
	var cp : Float;
	public function new(type : Int = MOLLWEIDE) {
		type = MOLLWEIDE;
		this.type = type;
		switch(type) {
		case MOLLWEIDE:
			init(Math.PI / 2);
		case WAGNER4:
			init(Math.PI / 3);
		case WAGNER5:
			init(Math.PI / 2);
			cx = 0.90977;
			cy = 1.65014;
			cp = 3.00896;
		}
	}

	function init(p : Float) : Void {
		var r : Float;
		var sp : Float;
		var p2 : Float = p + p;
		sp = Math.sin(p);
		r = Math.sqrt(Math.PI * 2.0 * sp / (p2 + Math.sin(p2)));
		cx = 2. * r / Math.PI;
		cy = r / sp;
		cp = p2 + Math.sin(p2);
	}

	/*
	 * work-around for multiple constructors
	 */
	static public function fromP(p : Float) : MollweideProjection {
		var m : MollweideProjection = new MollweideProjection();
		m.init(p);
		return m;
	}

	/*
	 * work-around for multiple constructors
	 */
	static public function fromCxCyCp(cx : Float, cy : Float, cp : Float) : MollweideProjection {
		var m : MollweideProjection = new MollweideProjection();
		m.cx = cx;
		m.cy = cy;
		m.cp = cp;
		return m;
	}

	override public function project(lplam : Float, lpphi : Float, xy : Point) : Point {
		var k : Float;
		var v : Float;
		var i : Int;
		k = cp * Math.sin(lpphi);
		i = MAX_ITER;
		while(i != 0) {
			lpphi -= v = (lpphi + Math.sin(lpphi) - k) / (1. + Math.cos(lpphi));
			if(Math.abs(v) < TOLERANCE) break;
			i--;
		}
		if(i == 0) lpphi = ((lpphi < 0.)) ? -Math.PI / 2 : Math.PI / 2
		else lpphi *= 0.5;
		xy.x = cx * lplam * Math.cos(lpphi);
		xy.y = cy * Math.sin(lpphi);
		return xy;
	}

	override public function projectInverse(x : Float, y : Float, lp : Point) : Point {
		var lat : Float;
		var lon : Float;
		lat = Math.asin(y / cy);
		lon = x / (cx * Math.cos(lat));
		lat += lat;
		lat = Math.asin((lat + Math.sin(lat)) / cp);
		lp.x = lon;
		lp.y = lat;
		return lp;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function isEqualArea() : Bool {
		return type == MOLLWEIDE;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function toString() : String {
		switch(type) {
		case WAGNER4, WAGNER5:
			switch(type) {
			case WAGNER4:
				return "Wagner IV";
			}
			return "Wagner V";
		}
		return "Mollweide";
	}

}

