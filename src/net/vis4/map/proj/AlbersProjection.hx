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
import net.vis4.map.proj.Projection;
import flash.errors.ArgumentError;

class AlbersProjection extends Projection {

	static var EPS10 : Float = 1e-10;
	static var TOL7 : Float = 1e-7;
	var ec : Float;
	var n : Float;
	var c : Float;
	var dd : Float;
	var n2 : Float;
	var rho0 : Float;
	var phi1 : Float;
	var phi2 : Float;
	var en : Array<Dynamic>;
	static var N_ITER : Int = 15;
	static var EPSILON : Float = 1e-7;
	static var TOL : Float = 1e-10;
	public function new() {
		super();
		minLatitude = MapMath.toRadians(0);
		maxLatitude = MapMath.toRadians(80);
		projectionLatitude1 = MapMath.degToRad(75.5);
		projectionLatitude2 = MapMath.degToRad(29.5);
		minLongitude = MapMath.toRadians(-135);
		maxLongitude = MapMath.toRadians(135);
		initialize();
	}

	static function phi1_(qs : Float, Te : Float, Tone_es : Float) : Float {
		var i : Int;
		var Phi : Float;
		var sinpi : Float;
		var cospi : Float;
		var con : Float;
		var com : Float;
		var dphi : Float;
		Phi = Math.asin(.5 * qs);
		if(Te < EPSILON) return (Phi);
		i = N_ITER;
		do {
			sinpi = Math.sin(Phi);
			cospi = Math.cos(Phi);
			con = Te * sinpi;
			com = 1. - con * con;
			dphi = .5 * com * com / cospi * (qs / Tone_es - sinpi / com + .5 / Te * Math.log((1. - con) / (1. + con)));
			Phi += dphi;
		}
while((Math.abs(dphi) > TOL && --i != 0));
		return (i != (0) ? Phi : Math.POSITIVE_INFINITY); // Number.MAX_VALUE
	}

	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var rho : Float;
		if((rho = c - (!(spherical) ? n * MapMath.qsfn(Math.sin(lpphi), e, one_es) : n2 * Math.sin(lpphi))) < 0.) throw new ProjectionError("F");
		rho = dd * Math.sqrt(rho);
		out.x = rho * Math.sin(lplam *= n);
		out.y = rho0 - rho * Math.cos(lplam);
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var rho : Float;
		if((rho = MapMath.distance(xyx, xyy = rho0 - xyy)) != 0)  {
			var lpphi : Float;
			var lplam : Float;
			if(n < 0.)  {
				rho = -rho;
				xyx = -xyx;
				xyy = -xyy;
			}
			lpphi = rho / dd;
			if(!spherical)  {
				lpphi = (c - lpphi * lpphi) / n;
				if(Math.abs(ec - Math.abs(lpphi)) > TOL7)  {
					if((lpphi = phi1_(lpphi, e, one_es)) == Math.POSITIVE_INFINITY) throw new ProjectionError("I");
				}

				else lpphi = lpphi < (0.) ? -MapMath.HALFPI : MapMath.HALFPI;
			}

			else if(Math.abs(out.y = (c - lpphi * lpphi) / n2) <= 1.) lpphi = Math.asin(lpphi)
			else lpphi = lpphi < (0.) ? -MapMath.HALFPI : MapMath.HALFPI;
			lplam = Math.atan2(xyx, xyy) / n;
			out.x = lplam;
			out.y = lpphi;
		}

		else  {
			out.x = 0.;
			out.y = n > (0.) ? MapMath.HALFPI : -MapMath.HALFPI;
		}

		return out;
	}

	override public function initialize() : Void {
		super.initialize();
		var cosphi : Float;
		var sinphi : Float;
		var secant : Bool;
		phi1 = projectionLatitude1;
		phi2 = projectionLatitude2;
		if(Math.abs(phi1 + phi2) < EPS10) throw new ArgumentError("-21");
		n = sinphi = Math.sin(phi1);
		cosphi = Math.cos(phi1);
		secant = Math.abs(phi1 - phi2) >= EPS10;
		spherical = es > 0.0;
		if(!spherical)  {
			var ml1 : Float;
			var m1 : Float;
			if((en = MapMath.enfn(es)) == null) throw new ArgumentError("0");
			m1 = MapMath.msfn(sinphi, cosphi, es);
			ml1 = MapMath.qsfn(sinphi, e, one_es);
			if(secant)  {
				//secant cone
				var ml2 : Float;
				var m2 : Float;
				sinphi = Math.sin(phi2);
				cosphi = Math.cos(phi2);
				m2 = MapMath.msfn(sinphi, cosphi, es);
				ml2 = MapMath.qsfn(sinphi, e, one_es);
				n = (m1 * m1 - m2 * m2) / (ml2 - ml1);
			}
			ec = 1. - .5 * one_es * Math.log((1. - e) / (1. + e)) / e;
			c = m1 * m1 + n * ml1;
			dd = 1. / n;
			rho0 = dd * Math.sqrt(c - n * MapMath.qsfn(Math.sin(projectionLatitude), e, one_es));
		}

		else  {
			if(secant) n = .5 * (n + Math.sin(phi2));
			n2 = n + n;
			c = cosphi * cosphi + n2 * sinphi;
			dd = 1. / n;
			rho0 = dd * Math.sqrt(c - n2 * Math.sin(projectionLatitude));
		}

	}

	override public function isEqualArea() : Bool {
		return true;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function isConformal() : Bool {
		return true;
	}

	override public function getEPSGCode() : Int {
		return 9822;
	}

	override public function toString() : String {
		return "Albers Equal Area";
	}

	override public function getShortName() : String {
		return "Albers";
	}

	override public function getInventor() : String {
		return "Christian Albers";
	}

	override public function getYear() : Int {
		return 1805;
	}

}

