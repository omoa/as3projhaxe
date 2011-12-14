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

class AiryProjection extends Projection {

	var p_halfpi : Float;
	var sinph0 : Float;
	var cosph0 : Float;
	var Cb : Float;
	var mode : Int;
	var no_cut : Bool;
	// do not cut at hemisphere limit
	static var EPS : Float = 1.;
	static var N_POLE : Int = 0;
	static var S_POLE : Int = 1;
	static var EQUIT : Int = 2;
	static var OBLIQ : Int = 3;
	public function new() {
		no_cut = true;
		minLatitude = MapMath.toRadians(-60);
		maxLatitude = MapMath.toRadians(60);
		minLongitude = MapMath.toRadians(-90);
		maxLongitude = MapMath.toRadians(90);
		initialize();
	}

	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var sinlam : Float;
		var coslam : Float;
		var cosphi : Float;
		var sinphi : Float;
		var t : Float;
		var s : Float;
		var Krho : Float;
		var cosz : Float;
		sinlam = Math.sin(lplam);
		coslam = Math.cos(lplam);
		switch(mode) {
		case EQUIT, OBLIQ:
			sinphi = Math.sin(lpphi);
			cosphi = Math.cos(lpphi);
			cosz = cosphi * coslam;
			if(mode == OBLIQ) cosz = sinph0 * sinphi + cosph0 * cosz;
			if(!no_cut && cosz < -EPS) throw new ProjectionError("F");
			s = 1. - cosz;
			if(Math.abs(s) > EPS)  {
				t = 0.5 * (1. + cosz);
				Krho = -Math.log(t) / s - Cb / t;
			}

			else Krho = 0.5 - Cb;
			out.x = Krho * cosphi * sinlam;
			if(mode == OBLIQ) out.y = Krho * (cosph0 * sinphi - sinph0 * cosphi * coslam)
			else out.y = Krho * sinphi;
		case S_POLE, N_POLE:
			out.y = Math.abs(p_halfpi - lpphi);
			if(!no_cut && (lpphi - EPS) > MapMath.HALFPI) throw new ProjectionError("F");
			if((out.y *= 0.5) > EPS)  {
				t = Math.tan(lpphi);
				Krho = -2. * (Math.log(Math.cos(lpphi)) / t + t * Cb);
				out.x = Krho * sinlam;
				out.y = Krho * coslam;
				if(mode == N_POLE) out.y = -out.y;
			}

			else out.x = out.y = 0.;
		}
		return out;
	}

	override public function initialize() : Void {
		super.initialize();
		var beta : Float = 0;
		//		no_cut = pj_param(params, "bno_cut").i;
		//		beta = 0.5 * (MapMath.HALFPI - pj_param(params, "rlat_b").f);
		no_cut = false;
		//FIXME
		beta = 0.5 * (MapMath.HALFPI - 0);
		//FIXME
		if(Math.abs(beta) < EPS) Cb = -0.5
		else  {
			Cb = 1. / Math.tan(beta);
			Cb *= Cb * Math.log(Math.cos(beta));
		}

		if(Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) < EPS) if(projectionLatitude < 0.)  {
			p_halfpi = -MapMath.HALFPI;
			mode = S_POLE;
		}

		else  {
			p_halfpi = MapMath.HALFPI;
			mode = N_POLE;
		}

		else  {
			if(Math.abs(projectionLatitude) < EPS) mode = EQUIT
			else  {
				mode = OBLIQ;
				sinph0 = Math.sin(projectionLatitude);
				cosph0 = Math.cos(projectionLatitude);
			}

		}

	}

	override public function toString() : String {
		return "Airy's Minimum-Error Azimuthal";
	}

	override public function getShortName() : String {
		return "Airy";
	}

	override public function getInventor() : String {
		return "Sir George Biddell Airy";
	}

	override public function getYear() : Int {
		return 1861;
	}


	static function __init__() {
		e - 10;
	}
}

