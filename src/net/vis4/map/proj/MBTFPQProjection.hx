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

class MBTFPQProjection extends Projection {

	static var NITER : Int = 20;
	static var EPS : Float = 1e-7;
	static var ONETOL : Float = 1.000001;
	static var C : Float = 1.70710678118654752440;
	static var RC : Float = 0.58578643762690495119;
	static var FYC : Float = 1.87475828462269495505;
	static var RYC : Float = 0.53340209679417701685;
	static var FXC : Float = 0.31245971410378249250;
	static var RXC : Float = 3.20041258076506210122;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var th1 : Float;
		var c : Float;
		var i : Int;
		c = C * Math.sin(lpphi);
		i = NITER;
		while(i > 0) {
			out.y -= th1 = (Math.sin(.5 * lpphi) + Math.sin(lpphi) - c) / (.5 * Math.cos(.5 * lpphi) + Math.cos(lpphi));
			if(Math.abs(th1) < EPS) break;
			--i;
		}
		out.x = FXC * lplam * (1.0 + 2. * Math.cos(lpphi) / Math.cos(0.5 * lpphi));
		out.y = FYC * Math.sin(0.5 * lpphi);
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var t : Float = 0;
		var lpphi : Float = RYC * xyy;
		if(Math.abs(lpphi) > 1.)  {
			if(Math.abs(lpphi) > ONETOL) throw new ProjectionError("I")
			else if(lpphi < 0.)  {
				t = -1.;
				lpphi = -Math.PI;
			}

			else  {
				t = 1.;
				lpphi = Math.PI;
			}

		}

		else lpphi = 2. * Math.asin(t = lpphi);
		out.x = RXC * xyx / (1. + 2. * Math.cos(lpphi) / Math.cos(0.5 * lpphi));
		lpphi = RC * (t + Math.sin(lpphi));
		if(Math.abs(lpphi) > 1.) if(Math.abs(lpphi) > ONETOL) throw new ProjectionError("I")
		else lpphi = lpphi < (0.) ? -MapMath.HALFPI : MapMath.HALFPI
		else lpphi = Math.asin(lpphi);
		out.y = lpphi;
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function toString() : String {
		return "McBryde-Thomas Flat-Polar Quartic";
	}

	override public function getShortName() : String {
		return "MBTFPQ";
	}

}

