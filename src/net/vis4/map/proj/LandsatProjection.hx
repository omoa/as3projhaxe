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

class LandsatProjection extends Projection {

	var a2 : Float;
	var a4 : Float;
	var b : Float;
	var c1 : Float;
	var c3 : Float;
	var q : Float;
	var t : Float;
	var u : Float;
	var w : Float;
	var p22 : Float;
	var sa : Float;
	var ca : Float;
	var xj : Float;
	var rlm : Float;
	var rlm2 : Float;
	static var TOL : Float = 1e-7;
	static var PI_HALFPI : Float = 4.71238898038468985766;
	static var TWOPI_HALFPI : Float = 7.85398163397448309610;
	override public function project(lplam : Float, lpphi : Float, xy : Point) : Point {
		var l : Int;
		var nn : Int;
		var lamt : Float = 0;
		var xlam : Float;
		var sdsq : Float;
		var c : Float;
		var d : Float;
		var s : Float;
		var lamdp : Float = 0;
		var phidp : Float;
		var lampp : Float;
		var tanph : Float;
		var lamtp : Float;
		var cl : Float;
		var sd : Float;
		var sp : Float;
		var fac : Float;
		var sav : Float;
		var tanphi : Float;
		if(lpphi > MapMath.HALFPI) lpphi = MapMath.HALFPI
		else if(lpphi < -MapMath.HALFPI) lpphi = -MapMath.HALFPI;
		lampp = lpphi >= (0.) ? MapMath.HALFPI : PI_HALFPI;
		tanphi = Math.tan(lpphi);
		nn = 0;
		while() {
			sav = lampp;
			lamtp = lplam + p22 * lampp;
			cl = Math.cos(lamtp);
			if(Math.abs(cl) < TOL) lamtp -= TOL;
			fac = lampp - Math.sin(lampp) * (cl < (0.) ? -MapMath.HALFPI : MapMath.HALFPI);
			l = 50;
			while(l > 0) {
				lamt = lplam + p22 * sav;
				if(Math.abs(c = Math.cos(lamt)) < TOL) lamt -= TOL;
				xlam = (one_es * tanphi * sa + Math.sin(lamt) * ca) / c;
				lamdp = Math.atan(xlam) + fac;
				if(Math.abs(Math.abs(sav) - Math.abs(lamdp)) < TOL) break;
				sav = lamdp;
				--l;
			}
			if(l == 0 || ++nn >= 3 || (lamdp > rlm && lamdp < rlm2)) break;
			if(lamdp <= rlm) lampp = TWOPI_HALFPI
			else if(lamdp >= rlm2) lampp = MapMath.HALFPI;
		}
		if(l != 0)  {
			sp = Math.sin(lpphi);
			phidp = MapMath.asin((one_es * ca * sp - sa * Math.cos(lpphi) * Math.sin(lamt)) / Math.sqrt(1. - es * sp * sp));
			tanph = Math.log(Math.tan(MapMath.QUARTERPI + .5 * phidp));
			sd = Math.sin(lamdp);
			sdsq = sd * sd;
			s = p22 * sa * Math.cos(lamdp) * Math.sqrt((1. + t * sdsq) / ((1. + w * sdsq) * (1. + q * sdsq)));
			d = Math.sqrt(xj * xj + s * s);
			xy.x = b * lamdp + a2 * Math.sin(2. * lamdp) + a4 * Math.sin(lamdp * 4.) - tanph * s / d;
			xy.y = c1 * sd + c3 * Math.sin(lamdp * 3.) + tanph * xj / d;
		}

		else xy.x = xy.y = Number.POSITIVE_INFINITY;
		return xy;
	}

	function seraz0(lam : Float, mult : Float) : Void {
		var sdsq : Float;
		var h : Float;
		var s : Float;
		var fc : Float;
		var sd : Float;
		var sq : Float;
		var d__1 : Float;
		lam *= DTR;
		sd = Math.sin(lam);
		sdsq = sd * sd;
		s = p22 * sa * Math.cos(lam) * Math.sqrt((1. + t * sdsq) / ((1. + w * sdsq) * (1. + q * sdsq)));
		d__1 = 1. + q * sdsq;
		h = Math.sqrt((1. + q * sdsq) / (1. + w * sdsq)) * ((1. + w * sdsq) / (d__1 * d__1) - p22 * ca);
		sq = Math.sqrt(xj * xj + s * s);
		b += fc = mult * (h * xj - s * s) / sq;
		a2 += fc * Math.cos(lam + lam);
		a4 += fc * Math.cos(lam * 4.);
		fc = mult * s * (h + xj) / sq;
		c1 += fc * Math.cos(lam);
		c3 += fc * Math.cos(lam * 3.);
	}

	override public function initialize() : Void {
		super.initialize();
		var land : Int;
		var path : Int;
		var lam : Float;
		var alf : Float;
		var esc : Float;
		var ess : Float;
		//FIXME		land = pj_param(params, "ilsat").i;
		land = 1;
		if(land <= 0 || land > 5) throw new ProjectionError("-28");
		path = 120;
		if(path <= 0 || path > (land <= (3) ? 251 : 233)) throw new ProjectionError("-29");
		if(land <= 3)  {
			projectionLongitude = DTR * 128.87 - MapMath.TWOPI / 251. * path;
			p22 = 103.2669323;
			alf = DTR * 99.092;
		}

		else  {
			projectionLongitude = DTR * 129.3 - MapMath.TWOPI / 233. * path;
			p22 = 98.8841202;
			alf = DTR * 98.2;
		}

		p22 /= 1440.;
		sa = Math.sin(alf);
		ca = Math.cos(alf);
		if(Math.abs(ca) < 1e-9) ca = 1e-9;
		esc = es * ca * ca;
		ess = es * sa * sa;
		w = (1. - esc) * rone_es;
		w = w * w - 1.;
		q = ess * rone_es;
		t = ess * (2. - es) * rone_es * rone_es;
		u = esc * rone_es;
		xj = one_es * one_es * one_es;
		rlm = Math.PI * (1. / 248. + .5161290322580645);
		rlm2 = rlm + MapMath.TWOPI;
		a2 = a4 = b = c1 = c3 = 0.;
		seraz0(0., 1.);
		lam = 9.;
		while(lam <= 81.0001) {
			seraz0(lam, 4.);
			lam += 18.;
		}
		lam = 18;
		while(lam <= 72.0001) {
			seraz0(lam, 2.);
			lam += 18.;
		}
		seraz0(90., 1.);
		a2 /= 30.;
		a4 /= 60.;
		b /= 30.;
		c1 /= 15.;
		c3 /= 45.;
	}

	/*
	public Point2D.Double projectInverse(double xyx, double xyy, Point2D.Double out) {
	int nn;
	double lamt, sdsq, s, lamdp, phidp, sppsq, dd, sd, sl, fac, scl, sav, spp;

	lamdp = xy.x / b;
	nn = 50;
	do {
	sav = lamdp;
	sd = Math.sin(lamdp);
	sdsq = sd * sd;
	s = p22 * sa * Math.cos(lamdp) * sqrt((1. + t * sdsq)
	 / ((1. + w * sdsq) * (1. + q * sdsq)));
	lamdp = xy.x + xy.y * s / xj - a2 * Math.sin(
	2. * lamdp) - a4 * Math.sin(lamdp * 4.) - s / xj * (
	c1 * Math.sin(lamdp) + c3 * Math.sin(lamdp * 3.));
	lamdp /= b;
	} while (Math.abs(lamdp - sav) >= TOL && --nn);
	sl = Math.sin(lamdp);
	fac = exp(sqrt(1. + s * s / xj / xj) * (xy.y - 
	c1 * sl - c3 * Math.sin(lamdp * 3.)));
	phidp = 2. * (Math.atan(fac) - FORTPI);
	dd = sl * sl;
	if (Math.abs(Math.cos(lamdp)) < TOL)
	lamdp -= TOL;
	spp = Math.sin(phidp);
	sppsq = spp * spp;
	lamt = Math.atan(((1. - sppsq * rone_es) * Math.tan(lamdp) * 
	ca - spp * sa * sqrt((1. + q * dd) * (
	1. - sppsq) - sppsq * u) / Math.cos(lamdp)) / (1. - sppsq 
	* (1. + u)));
	sl = lamt >= 0. ? 1. : -1.;
	scl = Math.cos(lamdp) >= 0. ? 1. : -1;
	lamt -= HALFPI * (1. - scl) * sl;
	lp.lam = lamt - p22 * lamdp;
	if (Math.abs(sa) < TOL)
	lp.phi = aasin(spp / sqrt(one_es * one_es + es * sppsq));
	else
	lp.phi = Math.atan((Math.tan(lamdp) * Math.cos(lamt) - ca * Math.sin(lamt)) /
	(one_es * sa));
	return lp;
	}
*/
	override public function hasInverse() : Bool {
		return false;
	}

	override public function toString() : String {
		return "Landsat";
	}

}

