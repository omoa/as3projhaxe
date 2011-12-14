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

class VanDerGrintenProjection extends Projection {

	static var TOL : Float = 1.;
	static var THIRD : Float = .33333333333333333333;
	static var TWO_THRD : Float = .66666666666666666666;
	static var C2_27 : Float = .07407407407407407407;
	static var PI4_3 : Float = 4.18879020478639098458;
	static var PISQ : Float = 9.86960440108935861869;
	static var TPISQ : Float = 19.73920880217871723738;
	static var HPISQ : Float = 4.93480220054467930934;
	public function new() {
		minLatitude = MapMath.degToRad(-80);
		maxLatitude = MapMath.degToRad(80);
	}

	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var al : Float;
		var al2 : Float;
		var g : Float;
		var g2 : Float;
		var p2 : Float;
		p2 = Math.abs(lpphi / MapMath.HALFPI);
		if((p2 - TOL) > 1.) throw new ProjectionError("F " + p2);
		if(p2 > 1.) p2 = 1.;
		if(Math.abs(lpphi) <= TOL)  {
			out.x = lplam;
			out.y = 0.;
		}

		else if(Math.abs(lplam) <= TOL || Math.abs(p2 - 1.) < TOL)  {
			out.x = 0.;
			out.y = Math.PI * Math.tan(.5 * Math.asin(p2));
			if(lpphi < 0.) out.y = -out.y;
		}

		else  {
			al = .5 * Math.abs(Math.PI / lplam - lplam / Math.PI);
			al2 = al * al;
			g = Math.sqrt(1. - p2 * p2);
			g = g / (p2 + g - 1.);
			g2 = g * g;
			p2 = g * (2. / p2 - 1.);
			p2 = p2 * p2;
			out.x = g - p2;
			g = p2 + al2;
			out.x = Math.PI * (al * out.x + Math.sqrt(al2 * out.x * out.x - g * (g2 - p2))) / g;
			if(lplam < 0.) out.x = -out.x;
			out.y = Math.abs(out.x / Math.PI);
			out.y = 1. - out.y * (out.y + 2. * al);
			if(out.y < -TOL) throw new ProjectionError("F");
			if(out.y < 0.) out.y = 0.
			else out.y = Math.sqrt(out.y) * (lpphi < (0.) ? -Math.PI : Math.PI);
		}

		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var t : Float;
		var c0 : Float;
		var c1 : Float;
		var c2 : Float;
		var c3 : Float;
		var al : Float;
		var r2 : Float;
		var r : Float;
		var m : Float;
		var d : Float;
		var ay : Float;
		var x2 : Float;
		var y2 : Float;
		x2 = xyx * xyx;
		if((ay = Math.abs(xyy)) < TOL)  {
			out.y = 0.;
			t = x2 * x2 + TPISQ * (x2 + HPISQ);
			out.x = Math.abs(xyx) <= (TOL) ? 0. : .5 * (x2 - PISQ + Math.sqrt(t)) / xyx;
			return out;
		}
		y2 = xyy * xyy;
		r = x2 + y2;
		r2 = r * r;
		c1 = -Math.PI * ay * (r + PISQ);
		c3 = r2 + MapMath.TWOPI * (ay * r + Math.PI * (y2 + Math.PI * (ay + MapMath.HALFPI)));
		c2 = c1 + PISQ * (r - 3. * y2);
		c0 = Math.PI * ay;
		c2 /= c3;
		al = c1 / c3 - THIRD * c2 * c2;
		m = 2. * Math.sqrt(-THIRD * al);
		d = C2_27 * c2 * c2 * c2 + (c0 * c0 - THIRD * c2 * c1) / c3;
		if(((t = Math.abs(d = 3. * d / (al * m))) - TOL) <= 1.)  {
			d = t > (1.) ? (d > (0.) ? 0. : Math.PI) : Math.acos(d);
			out.y = Math.PI * (m * Math.cos(d * THIRD + PI4_3) - THIRD * c2);
			if(xyy < 0.) out.y = -out.y;
			t = r2 + TPISQ * (x2 - y2 + HPISQ);
			out.x = Math.abs(xyx) <= (TOL) ? 0. : .5 * (r - PISQ + (t <= (0.) ? 0. : Math.sqrt(t))) / xyx;
		}

		else throw new ProjectionError("I");
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function toString() : String {
		return "van der Grinten (I)";
	}

	override public function getShortName() : String {
		return "VanDerGrinten";
	}


	static function __init__() {
		e - 10;
	}
}

