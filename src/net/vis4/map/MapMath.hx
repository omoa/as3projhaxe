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

Ported to ActionScript by Gregor Aisch (vis4.net)

*/
package net.vis4.map;

import flash.geom.Point;
import flash.geom.Rectangle;
import net.vis4.map.proj.ProjectionError;

class MapMath {

	static public var HALFPI : Float = Math.PI / 2.0;
	static public var QUARTERPI : Float = Math.PI / 4.0;
	static public var TWOPI : Float = Math.PI * 2.0;
	static public var RTD : Float = 180.0 / Math.PI;
	static public var DTR : Float = Math.PI / 180.0;
	static public var WORLD_BOUNDS_RAD : Rectangle = new Rectangle(-Math.PI, -Math.PI / 2, Math.PI * 2, Math.PI);
	static public var WORLD_BOUNDS : Rectangle = new Rectangle(-180, -90, 360, 180);
	/**
	 * Degree versions of trigonometric functions
	 */
	static public function sind(v : Float) : Float {
		return Math.sin(v * DTR);
	}

	static public function cosd(v : Float) : Float {
		return Math.cos(v * DTR);
	}

	static public function tand(v : Float) : Float {
		return Math.tan(v * DTR);
	}

	static public function asind(v : Float) : Float {
		return Math.asin(v) * RTD;
	}

	static public function acosd(v : Float) : Float {
		return Math.acos(v) * RTD;
	}

	static public function atand(v : Float) : Float {
		return Math.atan(v) * RTD;
	}

	static public function atan2d(y : Float, x : Float) : Float {
		return Math.atan2(y, x) * RTD;
	}

	static public function asin(v : Float) : Float {
		if(Math.abs(v) > 1.) return v < (0.0) ? -Math.PI / 2 : Math.PI / 2;
		return Math.asin(v);
	}

	static public function acos(v : Float) : Float {
		if(Math.abs(v) > 1.) return v < (0.0) ? Math.PI : 0.0;
		return Math.acos(v);
	}

	static public function sqrt(v : Float) : Float {
		return v < (0.0) ? 0.0 : Math.sqrt(v);
	}

	static public function distance(dx : Float, dy : Float) : Float {
		return Math.sqrt(dx * dx + dy * dy);
	}

	static public function distancePoint(a : Point, b : Point) : Float {
		return distance(a.x - b.x, a.y - b.y);
	}

	static public function hypot(x : Float, y : Float) : Float {
		if(x < 0.0) x = -x
		else if(x == 0.0) return y < (0.0) ? -y : y;
		if(y < 0.0) y = -y
		else if(y == 0.0) return x;
		if(x < y)  {
			x /= y;
			return y * Math.sqrt(1.0 + x * x);
		}

		else  {
			y /= x;
			return x * Math.sqrt(1.0 + y * y);
		}

	}

	static public function atan2(y : Float, x : Float) : Float {
		return Math.atan2(y, x);
	}

	static public function trunc(v : Float) : Float {
		return v < (0.0) ? Math.ceil(v) : Math.floor(v);
	}

	static public function frac(v : Float) : Float {
		return v - trunc(v);
	}

	static public function degToRad(v : Float) : Float {
		return v * Math.PI / 180.0;
	}

	static public function radToDeg(v : Float) : Float {
		return v * 180.0 / Math.PI;
	}

	// For negative angles, d should be negative, m & s positive.
	static public function dmsToRad(d : Float, m : Float, s : Float) : Float {
		if(d >= 0) return (d + m / 60 + s / 3600) * Math.PI / 180.0;
		return (d - m / 60 - s / 3600) * Math.PI / 180.0;
	}

	// For negative angles, d should be negative, m & s positive.
	static public function dmsToDeg(d : Float, m : Float, s : Float) : Float {
		if(d >= 0) return (d + m / 60 + s / 3600);
		return (d - m / 60 - s / 3600);
	}

	static public function normalizeLatitude(angle : Float) : Float {
		if(!Math.isFinite(angle) || Math.isNaN(angle)) throw new ProjectionError("Infinite latitude");
		while(angle > MapMath.HALFPI)angle -= Math.PI;
		while(angle < -MapMath.HALFPI)angle += Math.PI;
		return angle;
		//		return Math.IEEEremainder(angle, Math.PI);
	}

	static public function normalizeLongitude(angle : Float) : Float {
		if(!Math.isFinite(angle) || Math.isNaN(angle)) throw new ProjectionError("Infinite longitude");
		while(angle > Math.PI)angle -= TWOPI;
		while(angle < -Math.PI)angle += TWOPI;
		return angle;
		//		return Math.IEEEremainder(angle, Math.PI);
	}

	static public function normalizeAngle(angle : Float) : Float {
		if(!Math.isFinite(angle) || Math.isNaN(angle)) throw new ProjectionError("Infinite angle");
		while(angle > TWOPI)angle -= TWOPI;
		while(angle < 0)angle += TWOPI;
		return angle;
	}

	/*
	public static void latLongToXYZ(Point ll, Point3D xyz) {
	double c = Math.cos(ll.y);
	xyz.x = c * Math.cos(ll.x);
	xyz.y = c * Math.sin(ll.x);
	xyz.z = Math.sin(ll.y);
	}

	public static void xyzToLatLong(Point3D xyz, Point ll) {
	ll.y = MapMath.asin(xyz.z);
	ll.x = MapMath.atan2(xyz.y, xyz.x);
	}
	*/
	static public function greatCircleDistance(lon1 : Float, lat1 : Float, lon2 : Float, lat2 : Float) : Float {
		var dlat : Float = Math.sin((lat2 - lat1) / 2);
		var dlon : Float = Math.sin((lon2 - lon1) / 2);
		var r : Float = Math.sqrt(dlat * dlat + Math.cos(lat1) * Math.cos(lat2) * dlon * dlon);
		return 2.0 * Math.asin(r);
	}

	static public function sphericalAzimuth(lat0 : Float, lon0 : Float, lat : Float, lon : Float) : Float {
		var diff : Float = lon - lon0;
		var coslat : Float = Math.cos(lat);
		return Math.atan2(coslat * Math.sin(diff), (Math.cos(lat0) * Math.sin(lat) - Math.sin(lat0) * coslat * Math.cos(diff)));
	}

	static public function sameSigns(a : Float, b : Float) : Bool {
		return (a < 0) == (b < 0);
	}

	static public function sameSignsInt(a : Int, b : Int) : Bool {
		return (a < 0) == (b < 0);
	}

	static public function takeSign(a : Float, b : Float) : Float {
		a = Math.abs(a);
		if(b < 0) return -a;
		return a;
	}

	static public function takeSignInt(a : Int, b : Int) : Int {
		a = Math.round(Math.abs(a));
		if(b < 0) return -a;
		return a;
	}

	static public var DONT_INTERSECT : Int = 0;
	static public var DO_INTERSECT : Int = 1;
	static public var COLLINEAR : Int = 2;
	static public function intersectSegments(aStart : Point, aEnd : Point, bStart : Point, bEnd : Point, p : Point) : Int {
		var a1 : Float;
		var a2 : Float;
		var b1 : Float;
		var b2 : Float;
		var c1 : Float;
		var c2 : Float;
		var r1 : Float;
		var r2 : Float;
		var r3 : Float;
		var r4 : Float;
		var denom : Float;
		var offset : Float;
		var num : Float;
		a1 = aEnd.y - aStart.y;
		b1 = aStart.x - aEnd.x;
		c1 = aEnd.x * aStart.y - aStart.x * aEnd.y;
		r3 = a1 * bStart.x + b1 * bStart.y + c1;
		r4 = a1 * bEnd.x + b1 * bEnd.y + c1;
		if(r3 != 0 && r4 != 0 && sameSigns(r3, r4)) return DONT_INTERSECT;
		a2 = bEnd.y - bStart.y;
		b2 = bStart.x - bEnd.x;
		c2 = bEnd.x * bStart.y - bStart.x * bEnd.y;
		r1 = a2 * aStart.x + b2 * aStart.y + c2;
		r2 = a2 * aEnd.x + b2 * aEnd.y + c2;
		if(r1 != 0 && r2 != 0 && sameSigns(r1, r2)) return DONT_INTERSECT;
		denom = a1 * b2 - a2 * b1;
		if(denom == 0) return COLLINEAR;
		offset = denom < (0) ? -denom / 2 : denom / 2;
		num = b1 * c2 - b2 * c1;
		p.x = (num < (0) ? num - offset : num + offset) / denom;
		num = a2 * c1 - a1 * c2;
		p.y = (num < (0) ? num - offset : num + offset) / denom;
		return DO_INTERSECT;
	}

	static public function dot(a : Point, b : Point) : Float {
		return a.x * b.x + a.y * b.y;
	}

	static public function perpendicular(a : Point) : Point {
		return new Point(-a.y, a.x);
	}

	static public function add(a : Point, b : Point) : Point {
		return new Point(a.x + b.x, a.y + b.y);
	}

	static public function subtract(a : Point, b : Point) : Point {
		return new Point(a.x - b.x, a.y - b.y);
	}

	static public function multiply(a : Point, b : Point) : Point {
		return new Point(a.x * b.x, a.y * b.y);
	}

	static public function crossPoint(a : Point, b : Point) : Float {
		return a.x * b.y - b.x * a.y;
	}

	static public function cross(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		return x1 * y2 - x2 * y1;
	}

	static public function normalize(a : Point) : Void {
		var d : Float = distance(a.x, a.y);
		a.x /= d;
		a.y /= d;
	}

	static public function negate(a : Point) : Void {
		a.x = -a.x;
		a.y = -a.y;
	}

	static public function longitudeDistance(l1 : Float, l2 : Float) : Float {
		return Math.min(Math.abs(l1 - l2), (((l1 < 0)) ? l1 + Math.PI : Math.PI - l1) + (((l2 < 0)) ? l2 + Math.PI : Math.PI - l2));
	}

	static public function geocentricLatitude(lat : Float, flatness : Float) : Float {
		var f : Float = 1.0 - flatness;
		return Math.atan((f * f) * Math.tan(lat));
	}

	static public function geographicLatitude(lat : Float, flatness : Float) : Float {
		var f : Float = 1.0 - flatness;
		return Math.atan(Math.tan(lat) / (f * f));
	}

	static public function tsfn(phi : Float, sinphi : Float, e : Float) : Float {
		sinphi *= e;
		return (Math.tan(.5 * (MapMath.HALFPI - phi)) / Math.pow((1. - sinphi) / (1. + sinphi), .5 * e));
	}

	static public function msfn(sinphi : Float, cosphi : Float, es : Float) : Float {
		return cosphi / Math.sqrt(1.0 - es * sinphi * sinphi);
	}

	static var N_ITER : Int = 15;
	static public function phi2(ts : Float, e : Float) : Float {
		var eccnth : Float;
		var phi : Float;
		var con : Float;
		var dphi : Float;
		var i : Int;
		eccnth = .5 * e;
		phi = MapMath.HALFPI - 2. * Math.atan(ts);
		i = N_ITER;
		do {
			con = e * Math.sin(phi);
			dphi = MapMath.HALFPI - 2. * Math.atan(ts * Math.pow((1. - con) / (1. + con), eccnth)) - phi;
			phi += dphi;
		}
while((Math.abs(dphi) > 1e-10 && --i != 0));
		if(i <= 0) throw new ProjectionError();
		return phi;
	}

	static var C00 : Float = 1.0;
	static var C02 : Float = .25;
	static var C04 : Float = .046875;
	static var C06 : Float = .01953125;
	static var C08 : Float = .01068115234375;
	static var C22 : Float = .75;
	static var C44 : Float = .46875;
	static var C46 : Float = .01302083333333333333;
	static var C48 : Float = .00712076822916666666;
	static var C66 : Float = .36458333333333333333;
	static var C68 : Float = .00569661458333333333;
	static var C88 : Float = .3076171875;
	static var MAX_ITER : Int = 10;
	static public function enfn(es : Float) : Array<Dynamic> {
		var t : Float;
		var en : Array<Dynamic> = [0, 0, 0, 0, 0];
		en[0] = C00 - es * (C02 + es * (C04 + es * (C06 + es * C08)));
		en[1] = es * (C22 - es * (C04 + es * (C06 + es * C08)));
		en[2] = (t = es * es) * (C44 - es * (C46 + es * C48));
		en[3] = (t *= es) * (C66 - es * C68);
		en[4] = t * es * C88;
		return en;
	}

	static public function mlfn(phi : Float, sphi : Float, cphi : Float, en : Array<Dynamic>) : Float {
		cphi *= sphi;
		sphi *= sphi;
		return en[0] * phi - cphi * (en[1] + sphi * (en[2] + sphi * (en[3] + sphi * en[4])));
	}

	static public function inv_mlfn(arg : Float, es : Float, en : Array<Dynamic>) : Float {
		var s : Float;
		var t : Float;
		var phi : Float;
		var k : Float = 1. / (1. - es);
		phi = arg;
		var i : Int = MAX_ITER;
		while(i != 0) {
			s = Math.sin(phi);
			t = 1. - es * s * s;
			phi -= t = (mlfn(phi, s, Math.cos(phi), en) - arg) * (t * Math.sqrt(t)) * k;
			if(Math.abs(t) < 1e-11) return phi;
			i--;
		}
		return phi;
	}

	static var P00 : Float = .33333333333333333333;
	static var P01 : Float = .17222222222222222222;
	static var P02 : Float = .10257936507936507936;
	static var P10 : Float = .06388888888888888888;
	static var P11 : Float = .06640211640211640211;
	static var P20 : Float = .01641501294219154443;
	static public function authset(es : Float) : Array<Dynamic> {
		var t : Float;
		var APA : Array<Dynamic> = [0, 0, 0];
		APA[0] = es * P00;
		t = es * es;
		APA[0] += t * P01;
		APA[1] = t * P10;
		t *= es;
		APA[0] += t * P02;
		APA[1] += t * P11;
		APA[2] = t * P20;
		return APA;
	}

	static public function authlat(beta : Float, APA : Array<Dynamic>) : Float {
		var t : Float = beta + beta;
		return (beta + APA[0] * Math.sin(t) + APA[1] * Math.sin(t + t) + APA[2] * Math.sin(t + t + t));
	}

	static public function qsfn(sinphi : Float, e : Float, one_es : Float) : Float {
		var con : Float;
		//if (e >= 1.0e-7) {
		if(e >= 0.0000001)  {
			con = e * sinphi;
			return (one_es * (sinphi / (1. - con * con) - (.5 / e) * Math.log((1. - con) / (1. + con))));
		}

		else return (sinphi + sinphi);
	}

	/*
	 * Java translation of "Nice Numbers for Graph Labels"
	 * by Paul Heckbert
	 * from "Graphics Gems", Academic Press, 1990
	 */
	static public function niceNumber(x : Float, round : Bool) : Float {
		var expv : Int;
		// exponent of x
		var f : Float;
		// fractional part of x
		var nf : Float;
		// nice, rounded fraction
		expv = Math.floor(Math.log(x) / Math.log(10));
		f = x / Math.pow(10., expv);
		// between 1 and 10
		if(round)  {
			if(f < 1.5) nf = 1.
			else if(f < 3.) nf = 2.
			else if(f < 7.) nf = 5.
			else nf = 10.;
		}

		else if(f <= 1.) nf = 1.
		else if(f <= 2.) nf = 2.
		else if(f <= 5.) nf = 5.
		else nf = 10.;
		return nf * Math.pow(10., expv);
	}

	static public function toRadians(d : Float) : Float {
		return degToRad(d);
	}

	static public function toDegrees(r : Float) : Float {
		return radToDeg(r);
	}

}

