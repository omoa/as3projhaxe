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
import net.vis4.map.proj.ConicProjection;

class SimpleConicProjection extends ConicProjection {

	var n : Float;
	var rho_c : Float;
	var rho_0 : Float;
	var sig : Float;
	var c1 : Float;
	var c2 : Float;
	var type : Int;
	static public var EULER : Int = 0;
	static public var MURD1 : Int = 1;
	static public var MURD2 : Int = 2;
	static public var MURD3 : Int = 3;
	static public var PCONIC : Int = 4;
	static public var TISSOT : Int = 5;
	static public var VITK1 : Int = 6;
	static public var EPS10 : Float = 1.;
	static public var EPS : Float = 1e-10;
	public function new(type : Int = 0) {
		this.type = type;
		minLatitude = MapMath.toRadians(0);
		maxLatitude = MapMath.toRadians(80);
	}

	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var rho : Float;
		switch(type) {
		case MURD2:
			rho = rho_c + Math.tan(sig - lpphi);
		case PCONIC:
			rho = c2 * (c1 - Math.tan(lpphi));
		default:
			rho = rho_c - lpphi;
		}
		out.x = rho * Math.sin(lplam *= n);
		out.y = rho_0 - rho * Math.cos(lplam);
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var rho : Float;
		rho = MapMath.distance(xyx, out.y = rho_0 - xyy);
		if(n < 0.)  {
			rho = -rho;
			out.x = -xyx;
			out.y = -xyy;
		}
		out.x = Math.atan2(xyx, xyy) / n;
		switch(type) {
		case PCONIC:
			out.y = Math.atan(c1 - rho / c2) + sig;
		case MURD2:
			out.y = sig - Math.atan(rho - rho_c);
		default:
			out.y = rho_c - rho;
		}
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function initialize() : Void {
		super.initialize();
		var del : Float;
		var cs : Float;
		var dummy : Float;
		var p1 : Float;
		var p2 : Float;
		var d : Float;
		var s : Float;
		var err : Int = 0;
		p1 = MapMath.toRadians(30);
		//FIXME
		p2 = MapMath.toRadians(60);
		//FIXME
		del = 0.5 * (p2 - p1);
		sig = 0.5 * (p2 + p1);
		err = ((Math.abs(del) < EPS || Math.abs(sig) < EPS)) ? -42 : 0;
		del = del;
		if(err != 0) throw new ProjectionError("Error " + err);
		switch(type) {
		case TISSOT:
			n = Math.sin(sig);
			cs = Math.cos(del);
			rho_c = n / cs + cs / n;
			rho_0 = Math.sqrt((rho_c - 2 * Math.sin(projectionLatitude)) / n);
		case MURD1:
			rho_c = Math.sin(del) / (del * Math.tan(sig)) + sig;
			rho_0 = rho_c - projectionLatitude;
			n = Math.sin(sig);
		case MURD2:
			rho_c = (cs = Math.sqrt(Math.cos(del))) / Math.tan(sig);
			rho_0 = rho_c + Math.tan(sig - projectionLatitude);
			n = Math.sin(sig) * cs;
		case MURD3:
			rho_c = del / (Math.tan(sig) * Math.tan(del)) + sig;
			rho_0 = rho_c - projectionLatitude;
			n = Math.sin(sig) * Math.sin(del) * Math.tan(del) / (del * del);
		case EULER:
			n = Math.sin(sig) * Math.sin(del) / del;
			del *= 0.5;
			rho_c = del / (Math.tan(del) * Math.tan(sig)) + sig;
			rho_0 = rho_c - projectionLatitude;
		case PCONIC:
			n = Math.sin(sig);
			c2 = Math.cos(del);
			c1 = 1. / Math.tan(sig);
			if(Math.abs(del = projectionLatitude - sig) - EPS10 >= MapMath.HALFPI) throw new ProjectionError("-43");
			rho_0 = c2 * (c1 - Math.tan(del));
			maxLatitude = MapMath.toRadians(60);
			//FIXME
		case VITK1:
			n = (cs = Math.tan(del)) * Math.sin(sig) / del;
			rho_c = del / (cs * Math.tan(sig)) + sig;
			rho_0 = rho_c - projectionLatitude;
		}
	}

	override public function isConformal() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Simple Conic";
	}


	static function __init__() {
		e - 10;
	}
}

