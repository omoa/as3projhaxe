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

class ObliqueMercatorProjection extends Projection {

	static var TOL : Float = 1.0;
	var alpha : Float;
	var lamc : Float;
	var lam1 : Float;
	var phi1 : Float;
	var lam2 : Float;
	var phi2 : Float;
	var Gamma : Float;
	var al : Float;
	var bl : Float;
	var el : Float;
	var singam : Float;
	var cosgam : Float;
	var sinrot : Float;
	var cosrot : Float;
	var u_0 : Float;
	var ellips : Bool;
	var rot : Bool;
	public function new(ellipsoid : Ellipsoid = null, lon_0 : Float = undefined, lat_0 : Float = undefined, alpha : Float = undefined, k : Float = undefined, x_0 : Float = undefined, y_0 : Float = undefined) {
		if(ellipsoid == null)  {
			setEllipsoid(Ellipsoid.WGS_1984);
			projectionLatitude = MapMath.toRadians(0);
			projectionLongitude = MapMath.toRadians(0);
			minLongitude = MapMath.toRadians(-60);
			maxLongitude = MapMath.toRadians(60);
			minLatitude = MapMath.toRadians(-80);
			maxLatitude = MapMath.toRadians(80);
			alpha = MapMath.toRadians(-45);
			//FIXME
			initialize();
		}

		else  {
			setEllipsoid(ellipsoid);
			lamc = lon_0;
			projectionLatitude = lat_0;
			this.alpha = alpha;
			scaleFactor = k;
			falseEasting = x_0;
			falseNorthing = y_0;
			initialize();
		}

	}

	override public function initialize() : Void {
		super.initialize();
		var con : Float;
		var com : Float;
		var cosphi0 : Float;
		var d : Float;
		var f : Float;
		var h : Float;
		var l : Float;
		var sinphi0 : Float;
		var p : Float;
		var j : Float;
		var azi : Int = 1;
		//FIXME-param
		//FIXME-setup rot, alpha, longc,lon/lat1/2
		rot = true;
		if(azi != 0)  {
			//alpha specified
			if(Math.abs(alpha) <= TOL || Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) <= TOL || Math.abs(Math.abs(alpha) - MapMath.HALFPI) <= TOL) throw new ProjectionError("Obl 1");
		}

		else  {
			if(Math.abs(phi1 - phi2) <= TOL || (con = Math.abs(phi1)) <= TOL || Math.abs(con - MapMath.HALFPI) <= TOL || Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) <= TOL || Math.abs(Math.abs(phi2) - MapMath.HALFPI) <= TOL) throw new ProjectionError("Obl 2");
		}

		com = ((spherical = es == 0.)) ? 1 : Math.sqrt(one_es);
		if(Math.abs(projectionLatitude) > EPS10)  {
			sinphi0 = Math.sin(projectionLatitude);
			cosphi0 = Math.cos(projectionLatitude);
			if(!spherical)  {
				con = 1. - es * sinphi0 * sinphi0;
				bl = cosphi0 * cosphi0;
				bl = Math.sqrt(1. + es * bl * bl / one_es);
				al = bl * scaleFactor * com / con;
				d = bl * com / (cosphi0 * Math.sqrt(con));
			}

			else  {
				bl = 1.;
				al = scaleFactor;
				d = 1. / cosphi0;
			}

			if((f = d * d - 1.) <= 0.) f = 0.
			else  {
				f = Math.sqrt(f);
				if(projectionLatitude < 0.) f = -f;
			}

			el = f += d;
			if(!spherical) el *= Math.pow(MapMath.tsfn(projectionLatitude, sinphi0, e), bl)
			else el *= Math.tan(.5 * (MapMath.HALFPI - projectionLatitude));
		}

		else  {
			bl = 1. / com;
			al = scaleFactor;
			el = d = f = 1.;
		}

		if(azi != 0)  {
			Gamma = Math.asin(Math.sin(alpha) / d);
			projectionLongitude = lamc - Math.asin((.5 * (f - 1. / f)) * Math.tan(Gamma)) / bl;
		}

		else  {
			if(!spherical)  {
				h = Math.pow(MapMath.tsfn(phi1, Math.sin(phi1), e), bl);
				l = Math.pow(MapMath.tsfn(phi2, Math.sin(phi2), e), bl);
			}

			else  {
				h = Math.tan(.5 * (MapMath.HALFPI - phi1));
				l = Math.tan(.5 * (MapMath.HALFPI - phi2));
			}

			f = el / h;
			p = (l - h) / (l + h);
			j = el * el;
			j = (j - l * h) / (j + l * h);
			if((con = lam1 - lam2) < -Math.PI) lam2 -= MapMath.TWOPI
			else if(con > Math.PI) lam2 += MapMath.TWOPI;
			projectionLongitude = MapMath.normalizeLongitude(.5 * (lam1 + lam2) - Math.atan(j * Math.tan(.5 * bl * (lam1 - lam2)) / p) / bl);
			Gamma = Math.atan(2. * Math.sin(bl * MapMath.normalizeLongitude(lam1 - projectionLongitude)) / (f - 1. / f));
			alpha = Math.asin(d * Math.sin(Gamma));
		}

		trace("alpha:", alpha, "f:", f);
		singam = Math.sin(Gamma);
		cosgam = Math.cos(Gamma);
		//		f = MapMath.param(params, "brot_conv").i ? Gamma : alpha;
		f = alpha;
		//FIXME
		sinrot = Math.sin(f);
		cosrot = Math.cos(f);
		//		u_0 = MapMath.param(params, "bno_uoff").i ? 0. :
		u_0 = (false) ? 0. : //FIXME
;
		Math.abs(al * Math.atan(Math.sqrt(d * d - 1.) / cosrot) / bl);
		if(projectionLatitude < 0.) u_0 = -u_0;
	}

	override public function project(lam : Float, phi : Float, xy : Point) : Point {
		var con : Float;
		var q : Float;
		var s : Float;
		var ul : Float;
		var us : Float;
		var vl : Float;
		var vs : Float;
		vl = Math.sin(bl * lam);
		if(Math.abs(Math.abs(phi) - MapMath.HALFPI) <= EPS10)  {
			ul = phi < (0.) ? -singam : singam;
			us = al * phi / bl;
		}

		else  {
			q = el / (!(spherical) ? Math.pow(MapMath.tsfn(phi, Math.sin(phi), e), bl) : Math.tan(.5 * (MapMath.HALFPI - phi)));
			s = .5 * (q - 1. / q);
			ul = 2. * (s * singam - vl * cosgam) / (q + 1. / q);
			con = Math.cos(bl * lam);
			if(Math.abs(con) >= TOL)  {
				us = al * Math.atan((s * cosgam + vl * singam) / con) / bl;
				if(con < 0.) us += Math.PI * al / bl;
			}

			else us = al * bl * lam;
		}

		if(Math.abs(Math.abs(ul) - 1.) <= EPS10) throw new ProjectionError("Obl 3");
		vs = .5 * al * Math.log((1. - ul) / (1. + ul)) / bl;
		us -= u_0;
		if(!rot)  {
			xy.x = us;
			xy.y = vs;
		}

		else  {
			xy.x = vs * cosrot + us * sinrot;
			xy.y = us * cosrot - vs * sinrot;
		}

		return xy;
	}

	override public function projectInverse(x : Float, y : Float, lp : Point) : Point {
		var q : Float;
		var s : Float;
		var ul : Float;
		var us : Float;
		var vl : Float;
		var vs : Float;
		if(!rot)  {
			us = x;
			vs = y;
		}

		else  {
			vs = x * cosrot - y * sinrot;
			us = y * cosrot + x * sinrot;
		}

		us += u_0;
		q = Math.exp(-bl * vs / al);
		s = .5 * (q - 1. / q);
		vl = Math.sin(bl * us / al);
		ul = 2. * (vl * cosgam + s * singam) / (q + 1. / q);
		if(Math.abs(Math.abs(ul) - 1.) < EPS10)  {
			lp.x = 0.;
			lp.y = ul < (0.) ? -MapMath.HALFPI : MapMath.HALFPI;
		}

		else  {
			lp.y = el / Math.sqrt((1. + ul) / (1. - ul));
			if(!spherical)  {
				lp.y = MapMath.phi2(Math.pow(lp.y, 1. / bl), e);
			}

			else lp.y = MapMath.HALFPI - 2. * Math.atan(lp.y);
			lp.x = -Math.atan2((s * cosgam - vl * singam), Math.cos(bl * us / al)) / bl;
		}

		return lp;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Space-oblique Mercator";
	}

	override public function getShortName() : String {
		return "Obl. Mercator";
	}


	static function __init__() {
		e - 7;
	}
}

