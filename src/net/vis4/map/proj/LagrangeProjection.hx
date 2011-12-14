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

class LagrangeProjection extends Projection {
	public var w(getW, setW) : Float;

	// Parameters
	var hrw : Float;
	var rw : Float;
	var a1 : Float;
	var phi1 : Float;
	static var TOL : Float = 1e-10;
	public function getW() : Float {
		return rw;
	}

	public function setW(value : Float) : Float {
		this.rw = value;
		return value;
	}

	override public function project(lplam : Float, lpphi : Float, xy : Point) : Point {
		var v : Float;
		var c : Float;
		if(Math.abs(Math.abs(lpphi) - MapMath.HALFPI) < TOL)  {
			xy.x = 0;
			xy.y = lpphi < (0) ? -2. : 2.;
		}

		else  {
			lpphi = Math.sin(lpphi);
			v = a1 * Math.pow((1. + lpphi) / (1. - lpphi), hrw);
			if((c = 0.5 * (v + 1. / v) + Math.cos(lplam *= rw)) < TOL) throw new ProjectionError();
			xy.x = 2. * Math.sin(lplam) / c;
			xy.y = (v - 1. / v) / c;
		}

		return xy;
	}

	override public function initialize() : Void {
		super.initialize();
		if(rw <= 0) throw new ProjectionError("-27");
		hrw = 0.5 * (rw = 1. / rw);
		phi1 = projectionLatitude1;
		if(Math.abs(Math.abs(phi1 = Math.sin(phi1)) - 1.) < TOL) throw new ProjectionError("-22");
		a1 = Math.pow((1. - phi1) / (1. + phi1), hrw);
	}

	override public function isConformal() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Lagrange";
	}

}

