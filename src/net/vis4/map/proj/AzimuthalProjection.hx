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
/**
 * The superclass for all azimuthal map projections
 */
package net.vis4.map.proj;

import net.vis4.map.MapMath;
import net.vis4.map.proj.Projection;

class AzimuthalProjection extends Projection {

	static public var NORTH_POLE : Int = 1;
	static public var SOUTH_POLE : Int = 2;
	static public var EQUATOR : Int = 3;
	static public var OBLIQUE : Int = 4;
	var mode : Int;
	var sinphi0 : Float;
	var cosphi0 : Float;
	var mapRadius : Float;
	public function new(projectionLatitude : Dynamic = null, projectionLongitude : Dynamic = null) {
		super();
		mapRadius = 90.0;
		this.projectionLatitude = projectionLatitude != (null) ? projectionLatitude : MapMath.toRadians(45.0);
		this.projectionLongitude = projectionLongitude != (null) ? projectionLongitude : MapMath.toRadians(45.0);
		initialize();
	}

	override public function initialize() : Void {
		super.initialize();
		if(Math.abs(Math.abs(projectionLatitude) - MapMath.HALFPI) < Projection.EPS10) mode = projectionLatitude < (0.) ? SOUTH_POLE : NORTH_POLE
		else if(Math.abs(projectionLatitude) > Projection.EPS10)  {
			mode = OBLIQUE;
			sinphi0 = Math.sin(projectionLatitude);
			cosphi0 = Math.cos(projectionLatitude);
		}

		else mode = EQUATOR;
	}

	override public function inside(lon : Float, lat : Float) : Bool {
		return MapMath.greatCircleDistance(MapMath.toRadians(lon), MapMath.toRadians(lat), projectionLongitude, projectionLatitude) < MapMath.toRadians(mapRadius);
	}

	/**
	 * Set the map radius (in degrees). 180 shows a hemisphere, 360 shows the whole globe.
	 */
	public function setMapRadius(mapRadius : Float) : Void {
		this.mapRadius = mapRadius;
	}

	public function getMapRadius() : Float {
		return mapRadius;
	}

}

