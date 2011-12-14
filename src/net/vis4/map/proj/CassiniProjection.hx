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

class CassiniProjection extends Projection {

	var m0 : Float;
	var n : Float;
	var t : Float;
	var a1 : Float;
	var c : Float;
	var r : Float;
	var dd : Float;
	var d2 : Float;
	var a2 : Float;
	var tn : Float;
	var en : Array<Dynamic>;
	static var EPS10 : Float = 1e-10;
	static var C1 : Float = .16666666666666666666;
	static var C2 : Float = .00833333333333333333;
	static var C3 : Float = .04166666666666666666;
	static var C4 : Float = .33333333333333333333;
	static var C5 : Float = .06666666666666666666;
	public function new() {
		projectionLatitude = MapMath.toRadians(0);
		projectionLongitude = MapMath.toRadians(0);
		minLongitude = MapMath.toRadians(-90);
		maxLongitude = MapMath.toRadians(90);
		initialize();
	}

	override public function project(lplam : Float, lpphi : Float, xy : Point) : Point {
		if(spherical)  {
			xy.x = Math.asin(Math.cos(lpphi) * Math.sin(lplam));
			xy.y = Math.atan2(Math.tan(lpphi), Math.cos(lplam)) - projectionLatitude;
		}

		else  {
			xy.y = MapMath.mlfn(lpphi, n = Math.sin(lpphi), c = Math.cos(lpphi), en);
			n = 1. / Math.sqrt(1. - es * n * n);
			tn = Math.tan(lpphi);
			t = tn * tn;
			a1 = lplam * c;
			c *= es * c / (1 - es);
			a2 = a1 * a1;
			xy.x = n * a1 * (1. - a2 * t * (C1 - (8. - t + 8. * c) * a2 * C2));
			xy.y -= m0 - n * tn * a2 * (.5 + (5. - t + 6. * c) * a2 * C3);
		}

		return xy;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		if(spherical)  {
			out.y = Math.asin(Math.sin(dd = xyy + projectionLatitude) * Math.cos(xyx));
			out.x = Math.atan2(Math.tan(xyx), Math.cos(dd));
		}

		else  {
			var ph1 : Float;
			ph1 = MapMath.inv_mlfn(m0 + xyy, es, en);
			tn = Math.tan(ph1);
			t = tn * tn;
			n = Math.sin(ph1);
			r = 1. / (1. - es * n * n);
			n = Math.sqrt(r);
			r *= (1. - es) * n;
			dd = xyx / n;
			d2 = dd * dd;
			out.y = ph1 - (n * tn / r) * d2 * (.5 - (1. + 3. * t) * d2 * C3);
			out.x = dd * (1. + t * d2 * (-C4 + (1. + 3. * t) * d2 * C5)) / Math.cos(ph1);
		}

		return out;
	}

	override public function initialize() : Void {
		super.initialize();
		if(!spherical)  {
			if((en = MapMath.enfn(es)) == null) throw new ArgumentError();
			m0 = MapMath.mlfn(projectionLatitude, Math.sin(projectionLatitude), Math.cos(projectionLatitude), en);
		}
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function getEPSGCode() : Int {
		return 9806;
	}

	override public function toString() : String {
		return "Cassini";
	}

}

