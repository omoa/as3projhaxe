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
import net.vis4.map.proj.PseudoCylindricalProjection;

class RobinsonProjection extends PseudoCylindricalProjection {

	static var X : Array<Dynamic> = [1, -5.67239, e - 12, -7.15511, e - 05, 3.11028, e - 06, 0.9986, -0.000482241, -2.4897, e - 05, -1.33094, e - 06, 0.9954, -0.000831031, -4.4861, e - 05, -9.86588, e - 07, 0.99, -0.00135363, -5.96598, e - 05, 3.67749, e - 06, 0.9822, -0.00167442, -4.4975, e - 06, -5.72394, e - 06, 0.973, -0.00214869, -9.03565, e - 05, 1.88767, e - 08, 0.96, -0.00305084, -9.00732, e - 05, 1.64869, e - 06, 0.9427, -0.00382792, -6.53428, e - 05, -2.61493, e - 06, 0.9216, -0.00467747, -0.000104566, 4.8122, e - 06, 0.8962, -0.00536222, -3.23834, e - 05, -5.43445, e - 06, 0.8679, -0.00609364, -0.0001139, 3.32521, e - 06, 0.835, -0.00698325, -6.40219, e - 05, 9.34582, e - 07, 0.7986, -0.00755337, -5.00038, e - 05, 9.35532, e - 07, 0.7597, -0.00798325, -3.59716, e - 05, -2.27604, e - 06, 0.7186, -0.00851366, -7.0112, e - 05, -8.63072, e - 06, 0.6732, -0.00986209, -0.000199572, 1.91978, e - 05, 0.6213, -0.010418, 8.83948, e - 05, 6.24031, e - 06, 0.5722, -0.00906601, 0.000181999, 6.24033, e - 06, 0.5322, 0., 0., 0.];
	static var Y : Array<Dynamic> = [0, 0.0124, 3.72529, e - 10, 1.15484, e - 09, 0.062, 0.0124001, 1.76951, e - 08, -5.92321, e - 09, 0.124, 0.0123998, -7.09668, e - 08, 2.25753, e - 08, 0.186, 0.0124008, 2.66917, e - 07, -8.44523, e - 08, 0.248, 0.0123971, -9.99682, e - 07, 3.15569, e - 07, 0.31, 0.0124108, 3.73349, e - 06, -1.1779, e - 06, 0.372, 0.0123598, -1.3935, e - 05, 4.39588, e - 06, 0.434, 0.0125501, 5.20034, e - 05, -1.00051, e - 05, 0.4968, 0.0123198, -9.80735, e - 05, 9.22397, e - 06, 0.5571, 0.0120308, 4.02857, e - 05, -5.2901, e - 06, 0.6176, 0.0120369, -3.90662, e - 05, 7.36117, e - 07, 0.6769, 0.0117015, -2.80246, e - 05, -8.54283, e - 07, 0.7346, 0.0113572, -4.08389, e - 05, -5.18524, e - 07, 0.7903, 0.0109099, -4.86169, e - 05, -1.0718, e - 06, 0.8435, 0.0103433, -6.46934, e - 05, 5.36384, e - 09, 0.8936, 0.00969679, -6.46129, e - 05, -8.54894, e - 06, 0.9394, 0.00840949, -0.000192847, -4.21023, e - 06, 0.9761, 0.00616525, -0.000256001, -4.21021, e - 06, 1., 0., 0., 0];
	var NODES : Int;
	static var FXC : Float = 0.8487;
	static var FYC : Float = 1.3523;
	static var C1 : Float = 11.45915590261646417544;
	static var RC1 : Float = 0.08726646259971647884;
	static var ONEEPS : Float = 1.000001;
	static var EPS : Float = 1e-8;
	public function new() {
		NODES = 18;
	}

	function poly(array : Array<Dynamic>, offset : Int, z : Float) : Float {
		return (array[offset] + z * (array[offset + 1] + z * (array[offset + 2] + z * array[offset + 3])));
	}

	override public function project(lplam : Float, lpphi : Float, xy : Point) : Point {
		var phi : Float = Math.abs(lpphi);
		var i : Int = Math.floor(phi * C1);
		if(i >= NODES) i = NODES - 1;
		phi = MapMath.toDegrees(phi - RC1 * i);
		i *= 4;
		xy.x = poly(X, i, phi) * FXC * lplam;
		xy.y = poly(Y, i, phi) * FYC;
		if(lpphi < 0.0) xy.y = -xy.y;
		return xy;
	}

	override public function projectInverse(x : Float, y : Float, lp : Point) : Point {
		var i : Int;
		var t : Float;
		var t1 : Float;
		lp.x = x / FXC;
		lp.y = Math.abs(y / FYC);
		if(lp.y >= 1.0)  {
			if(lp.y > 1.000001)  {
				throw new ProjectionError();
			}

			else  {
				lp.y = y < (0.) ? -MapMath.HALFPI : MapMath.HALFPI;
				lp.x /= X[4 * NODES];
			}

		}

		else  {
			i = 4 * Math.floor(lp.y * NODES);
			while() {
				if(Y[i] > lp.y) i -= 4
				else if(Y[i + 4] <= lp.y) i += 4
				else break;
			}
			t = 5. * (lp.y - Y[i]) / (Y[i + 4] - Y[i]);
			var Tc0 : Float = Y[i];
			var Tc1 : Float = Y[i + 1];
			var Tc2 : Float = Y[i + 2];
			var Tc3 : Float = Y[i + 3];
			t = 5. * (lp.y - Tc0) / (Y[i + 1] - Tc0);
			Tc0 -= lp.y;
						while() {
				// Newton-Raphson
				t -= t1 = (Tc0 + t * (Tc1 + t * (Tc2 + t * Tc3))) / (Tc1 + t * (Tc2 + Tc2 + t * 3. * Tc3));
				if(Math.abs(t1) < EPS) break;
			}
			lp.y = MapMath.toRadians(5 * i + t);
			if(y < 0.) lp.y = -lp.y;
			lp.x /= poly(X, i, t);
		}

		return lp;
	}

	override public function hasInverse() : Bool {
		return true;
	}

	override public function parallelsAreParallel() : Bool {
		return true;
	}

	override public function toString() : String {
		return "Robinson";
	}

}

