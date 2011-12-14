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
 * This file was manually ported to actionscript by Gregor Aisch, vis4.net
 */
package net.vis4.map.proj;

import flash.geom.Point;
import net.vis4.map.MapMath;
import net.vis4.map.proj.AzimuthalProjection;
import net.vis4.map.proj.Projection;

class EqualAreaAzimuthalProjection extends AzimuthalProjection {

	var sinb1 : Float;
	var cosb1 : Float;
	var xmf : Float;
	var ymf : Float;
	var mmf : Float;
	var qp : Float;
	var dd : Float;
	var rq : Float;
	public var apa : Array<Dynamic>;
	public function new() {
		super();
		initialize();
	}

	/*
	override public function clone() : Projection {
		var p : EqualAreaAzimuthalProjection = try cast(super.clone(), EqualAreaAzimuthalProjection) catch(e:ProjectionError) null;
		p.apa = [];
		for(n : Float in apa)p.apa.push(n);
		return p;
	}
	*/

	override public function initialize() : Void {
		super.initialize();
		if(spherical)  {
			if(mode == AzimuthalProjection.OBLIQUE)  {
				sinphi0 = Math.sin(projectionLatitude);
				cosphi0 = Math.cos(projectionLatitude);
			}
		}

		else  {
			var sinphi : Float;
			qp = MapMath.qsfn(1., e, one_es);
			mmf = .5 / (1. - es);
			apa = MapMath.authset(es);
			switch(mode) {
			case AzimuthalProjection.NORTH_POLE, AzimuthalProjection.SOUTH_POLE:
				dd = 1.;
			case AzimuthalProjection.EQUATOR:
				dd = 1. / (rq = Math.sqrt(.5 * qp));
				xmf = 1.;
				ymf = .5 * qp;
			case AzimuthalProjection.OBLIQUE:
				rq = Math.sqrt(.5 * qp);
				sinphi = Math.sin(projectionLatitude);
				sinb1 = MapMath.qsfn(sinphi, e, one_es) / qp;
				cosb1 = Math.sqrt(1. - sinb1 * sinb1);
				dd = Math.cos(projectionLatitude) / (Math.sqrt(1. - es * sinphi * sinphi) * rq * cosb1);
				ymf = (xmf = rq) / dd;
				xmf *= dd;
			}
		}

	}

	override public function project(lam : Float, phi : Float, xy : Point) : Point {
		if(spherical)  {
			var coslam : Float;
			var cosphi : Float;
			var sinphi : Float;
			var sinphi = Math.sin(phi);
			var cosphi = Math.cos(phi);
			var coslam = Math.cos(lam);
			switch(mode) {
			case AzimuthalProjection.EQUATOR:
				xy.y = 1. + cosphi * coslam;
				if(xy.y <= Projection.EPS10) throw new ProjectionError();
				xy.x = (xy.y = Math.sqrt(2. / xy.y)) * cosphi * Math.sin(lam);
				xy.y *= mode == (AzimuthalProjection.EQUATOR) ? sinphi : cosphi0 * sinphi - sinphi0 * cosphi * coslam;
			case AzimuthalProjection.OBLIQUE:
				xy.y = 1. + sinphi0 * sinphi + cosphi0 * cosphi * coslam;
				if(xy.y <= Projection.EPS10) throw new ProjectionError();
				xy.x = (xy.y = Math.sqrt(2. / xy.y)) * cosphi * Math.sin(lam);
				xy.y *= mode == (AzimuthalProjection.EQUATOR) ? sinphi : cosphi0 * sinphi - sinphi0 * cosphi * coslam;
			case AzimuthalProjection.NORTH_POLE, AzimuthalProjection.SOUTH_POLE:
				switch(mode) {
				case AzimuthalProjection.NORTH_POLE:
					coslam = -coslam;
				}
				if(Math.abs(phi + projectionLatitude) < Projection.EPS10) throw new ProjectionError();
				xy.y = MapMath.QUARTERPI - phi * .5;
				xy.y = 2. * (mode == (AzimuthalProjection.SOUTH_POLE) ? Math.cos(xy.y) : Math.sin(xy.y));
				xy.x = xy.y * Math.sin(lam);
				xy.y *= coslam;
			}
		}

		else  {
			var sinlam : Float;
			var q : Float;
			var sinb : Float = 0;
			var cosb : Float = 0;
			var b : Float = 0;
			var coslam = Math.cos(lam);
			var sinlam = Math.sin(lam);
			var sinphi = Math.sin(phi);
			q = MapMath.qsfn(sinphi, e, one_es);
			if(mode == AzimuthalProjection.OBLIQUE || mode == AzimuthalProjection.EQUATOR)  {
				sinb = q / qp;
				cosb = Math.sqrt(1. - sinb * sinb);
			}
			switch(mode) {
			case AzimuthalProjection.OBLIQUE:
				b = 1. + sinb1 * sinb + cosb1 * cosb * coslam;
			case AzimuthalProjection.EQUATOR:
				b = 1. + cosb * coslam;
			case AzimuthalProjection.NORTH_POLE:
				b = MapMath.HALFPI + phi;
				q = qp - q;
			case AzimuthalProjection.SOUTH_POLE:
				b = phi - MapMath.HALFPI;
				q = qp + q;
			}
			if(Math.abs(b) < Projection.EPS10) throw new ProjectionError();
			switch(mode) {
			case AzimuthalProjection.OBLIQUE:
				xy.y = ymf * (b = Math.sqrt(2. / b)) * (cosb1 * sinb - sinb1 * cosb * coslam);
				xy.x = xmf * b * cosb * sinlam;
			case AzimuthalProjection.EQUATOR:
				xy.y = (b = Math.sqrt(2. / (1. + cosb * coslam))) * sinb * ymf;
				xy.x = xmf * b * cosb * sinlam;
			case AzimuthalProjection.NORTH_POLE, AzimuthalProjection.SOUTH_POLE:
				if(q >= 0.)  {
					xy.x = (b = Math.sqrt(q)) * sinlam;
					xy.y = coslam * (mode == (AzimuthalProjection.SOUTH_POLE) ? b : -b);
				}

				else xy.x = xy.y = 0.;
			}
		}

		return xy;
	}

	override public function projectInverse(x : Float, y : Float, lp : Point) : Point {
		if(spherical)  {
			var cosz : Float = 0;
			var rh : Float;
			var sinz : Float = 0;
			rh = MapMath.distance(x, y);
			if((lp.y = rh * .5) > 1.) throw new ProjectionError();
			lp.y = 2. * Math.asin(lp.y);
			if(mode == AzimuthalProjection.OBLIQUE || mode == AzimuthalProjection.EQUATOR)  {
				sinz = Math.sin(lp.y);
				cosz = Math.cos(lp.y);
			}
			switch(mode) {
			case AzimuthalProjection.EQUATOR:
				lp.y = Math.abs(rh) <= (Projection.EPS10) ? 0. : Math.asin(y * sinz / rh);
				x *= sinz;
				y = cosz * rh;
			case AzimuthalProjection.OBLIQUE:
				lp.y = Math.abs(rh) <= (Projection.EPS10) ? projectionLatitude : Math.asin(cosz * sinphi0 + y * sinz * cosphi0 / rh);
				x *= sinz * cosphi0;
				y = (cosz - Math.sin(lp.y) * sinphi0) * rh;
			case AzimuthalProjection.NORTH_POLE:
				y = -y;
				lp.y = MapMath.HALFPI - lp.y;
			case AzimuthalProjection.SOUTH_POLE:
				lp.y -= MapMath.HALFPI;
			}
			lp.x = ((y == 0. && (mode == AzimuthalProjection.EQUATOR || mode == AzimuthalProjection.OBLIQUE))) ? 0. : Math.atan2(x, y);
		}

		else  {
			var cCe : Float;
			var sCe : Float;
			var q : Float;
			var rho : Float;
			var ab : Float = 0;
			switch(mode) {
			case AzimuthalProjection.EQUATOR, AzimuthalProjection.OBLIQUE:
				if((rho = MapMath.distance(x /= dd, y *= dd)) < Projection.EPS10)  {
					lp.x = 0.;
					lp.y = projectionLatitude;
					return (lp);
				}
				cCe = Math.cos(sCe = 2. * Math.asin(.5 * rho / rq));
				x *= (sCe = Math.sin(sCe));
				if(mode == AzimuthalProjection.OBLIQUE)  {
					q = qp * (ab = cCe * sinb1 + y * sCe * cosb1 / rho);
					y = rho * cosb1 * cCe - y * sinb1 * sCe;
				}

				else  {
					q = qp * (ab = y * sCe / rho);
					y = rho * cCe;
				}

			case AzimuthalProjection.NORTH_POLE, AzimuthalProjection.SOUTH_POLE:
				switch(mode) {
				case AzimuthalProjection.NORTH_POLE:
					y = -y;
				}
				if((q = (x * x + y * y)) == 0)  {
					lp.x = 0.;
					lp.y = projectionLatitude;
					return lp;
				}
				ab = 1. - q / qp;
				if(mode == AzimuthalProjection.SOUTH_POLE) ab = -ab;
			}
			lp.x = Math.atan2(x, y);
			lp.y = MapMath.authlat(Math.asin(ab), apa);
		}

		return lp;
	}

	/*public function getBoundingShape():Ellipsoid
	{
	var r:Number = 1.414 * a;
	return new Ellipse2D.Double( -r, -r, 2*r, 2*r );
	}*/
	override public function isEqualArea() : Bool {
		return true;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Lambert Equal Area Azimuthal";
	}

	override public function getShortName() : String {
		return "Lambert III";
	}

}

