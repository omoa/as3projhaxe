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

class HatanoProjection extends Projection {

	static var NITER : Int = 20;
	static var EPS : Float = 1e-7;
	static var ONETOL : Float = 1.000001;
	static var CN : Float = 2.67595;
	static var CS : Float = 2.43763;
	static var RCN : Float = 0.37369906014686373063;
	static var RCS : Float = 0.41023453108141924738;
	static var FYCN : Float = 1.75859;
	static var FYCS : Float = 1.93052;
	static var RYCN : Float = 0.56863737426006061674;
	static var RYCS : Float = 0.51799515156538134803;
	static var FXC : Float = 0.85;
	static var RXC : Float = 1.17647058823529411764;
	override public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		var th1 : Float;
		var c : Float;
		var i : Int;
		c = Math.sin(lpphi) * (lpphi < (0.) ? CS : CN);
		i = NITER;
		while(i > 0) {
			lpphi -= th1 = (lpphi + Math.sin(lpphi) - c) / (1. + Math.cos(lpphi));
			if(Math.abs(th1) < EPS) break;
			--i;
		}
		out.x = FXC * lplam * Math.cos(lpphi *= .5);
		out.y = Math.sin(lpphi) * (lpphi < (0.) ? FYCS : FYCN);
		return out;
	}

	override public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		var th : Float;
		th = xyy * (xyy < (0.) ? RYCS : RYCN);
		if(Math.abs(th) > 1.) if(Math.abs(th) > ONETOL) throw new ProjectionError("I")
		else th = th > (0.) ? MapMath.HALFPI : -MapMath.HALFPI
		else th = Math.asin(th);
		out.x = RXC * xyx / Math.cos(th);
		th += th;
		out.y = (th + Math.sin(th)) * (xyy < (0.) ? RCS : RCN);
		if(Math.abs(out.y) > 1.) if(Math.abs(out.y) > ONETOL) throw new ProjectionError("I")
		else out.y = out.y > (0.) ? MapMath.HALFPI : -MapMath.HALFPI
		else out.y = Math.asin(out.y);
		return out;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Hatano Asymmetrical Equal Area";
	}

	override public function getShortName() : String {
		return "Hatano";
	}

}

