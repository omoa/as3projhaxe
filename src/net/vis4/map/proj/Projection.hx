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
//import net.vis4.map.*;
package net.vis4.map.proj;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.errors.ArgumentError;

class Projection {
	public var shortName(getShortName, never) : String;
	public var inventor(getInventor, never) : String;
	public var year(getYear, never) : Int;

	/**
	 * The minimum latitude of the bounds of this projection
	 */
	var minLatitude : Float;
	/**
	 * The minimum longitude of the bounds of this projection. This is relative to the projection centre.
	 */
	var minLongitude : Float;
	/**
	 * The maximum latitude of the bounds of this projection
	 */
	var maxLatitude : Float;
	/**
	 * The maximum longitude of the bounds of this projection. This is relative to the projection centre.
	 */
	var maxLongitude : Float;
	/**
	 * The latitude of the centre of projection
	 */
	var projectionLatitude : Float;
	/**
	 * The longitude of the centre of projection
	 */
	var projectionLongitude : Float;
	/**
	 * Standard parallel 1 (for projections which use it)
	 */
	var projectionLatitude1 : Float;
	/**
	 * Standard parallel 2 (for projections which use it)
	 */
	var projectionLatitude2 : Float;
	/**
	 * The projection scale factor
	 */
	var scaleFactor : Float;
	/**
	 * The false Easting of this projection
	 */
	var falseEasting : Float;
	/**
	 * The false Northing of this projection
	 */
	var falseNorthing : Float;
	/**
	 * The latitude of true scale. Only used by specific projections.
	 */
	var trueScaleLatitude : Float;
	/**
	 * The equator radius
	 */
	var a : Float;
	/**
	 * The eccentricity
	 */
	var e : Float;
	/**
	 * The eccentricity squared
	 */
	var es : Float;
	/**
	 * 1-(eccentricity squared)
	 */
	var one_es : Float;
	/**
	 * 1/(1-(eccentricity squared))
	 */
	var rone_es : Float;
	/**
	 * The ellipsoid used by this projection
	 */
	var ellipsoid : Ellipsoid;
	/**
	 * True if this projection is using a sphere (es == 0)
	 */
	var spherical : Bool;
	/**
	 * True if this projection is geocentric
	 */
	var geocentric : Bool;
	/**
	 * The name of this projection
	 */
	var name : String;
	/**
	 * Conversion factor from metres to whatever units the projection uses.
	 */
	var fromMetres : Float;
	/**
	 * The total scale factor = Earth radius * units
	 */
	var totalScale : Float;
	/**
	 * falseEasting, adjusted to the appropriate units using fromMetres
	 */
	var totalFalseEasting : Float;
	/**
	 * falseNorthing, adjusted to the appropriate units using fromMetres
	 */
	var totalFalseNorthing : Float;
	// Some useful constants
	static var EPS10 : Float = 1e-10;
	static var RTD : Float = 180.0 / Math.PI;
	static var DTR : Float = Math.PI / 180.0;
	public function new() {
		minLatitude = -Math.PI / 2;
		minLongitude = -Math.PI;
		maxLatitude = Math.PI / 2;
		maxLongitude = Math.PI;
		projectionLatitude = 0.0;
		projectionLongitude = 0.0;
		projectionLatitude1 = 0.0;
		projectionLatitude2 = 0.0;
		scaleFactor = 1.0;
		falseEasting = 0;
		falseNorthing = 0;
		trueScaleLatitude = 0.0;
		a = 0;
		e = 0;
		es = 0;
		one_es = 0;
		rone_es = 0;
		name = "";
		fromMetres = 1;
		totalScale = 0;
		totalFalseEasting = 0;
		totalFalseNorthing = 0;
		setEllipsoid(Ellipsoid.SPHERE);
	}

	public function clone() : Projection {
		// todo
		return null;
	}

	/**
	 * Project a lat/long point (in degrees), producing a result in metres
	 */
	public function transform(src : Point, dst : Point) : Point {
		var x : Float = src.x * DTR;
		if(projectionLongitude != 0) x = MapMath.normalizeLongitude(x - projectionLongitude);
		project(x, src.y * DTR, dst);
		dst.x = totalScale * dst.x + totalFalseEasting;
		dst.y = totalScale * dst.y + totalFalseNorthing;
		return dst;
	}

	/**
	 * Project a lat/long point, producing a result in metres
	 */
	public function transformRadians(src : Point, dst : Point) : Point {
		var x : Float = src.x;
		if(projectionLongitude != 0) x = MapMath.normalizeLongitude(x - projectionLongitude);
		project(x, src.y, dst);
		dst.x = totalScale * dst.x + totalFalseEasting;
		dst.y = totalScale * dst.y + totalFalseNorthing;
		return dst;
	}

	/**
	 * The method which actually does the projection. This should be overridden for all projections.
	 */
	public function project(lplam : Float, lpphi : Float, out : Point) : Point {
		out.x = lplam;
		out.y = lpphi;
		return out;
	}

	/**
	 * Project a number of lat/long points (in degrees), producing a result in metres
	 */
	public function transformMultiple(srcPoints : Array<Dynamic>, srcOffset : Int, dstPoints : Array<Dynamic>, dstOffset : Int, numPoints : Int) : Void {
		var _in : Point = new Point();
		var out : Point = new Point();
		var i : Int = 0;
		while(i < numPoints) {
			_in.x = srcPoints[srcOffset++];
			_in.y = srcPoints[srcOffset++];
			transform(_in, out);
			dstPoints[dstOffset++] = out.x;
			dstPoints[dstOffset++] = out.y;
			i++;
		}
	}

	/**
	 * Project a number of lat/long points (in radians), producing a result in metres
	 */
	public function transformMultipleRadians(srcPoints : Array<Dynamic>, srcOffset : Int, dstPoints : Array<Dynamic>, dstOffset : Int, numPoints : Int) : Void {
		var _in : Point = new Point();
		var out : Point = new Point();
		var i : Int = 0;
		while(i < numPoints) {
			_in.x = srcPoints[srcOffset++];
			_in.y = srcPoints[srcOffset++];
			transform(_in, out);
			dstPoints[dstOffset++] = out.x;
			dstPoints[dstOffset++] = out.y;
			i++;
		}
	}

	/**
	 * Inverse-project a point (in metres), producing a lat/long result in degrees
	 */
	public function inverseTransform(src : Point, dst : Point) : Point {
		var x : Float = (src.x - totalFalseEasting) / totalScale;
		var y : Float = (src.y - totalFalseNorthing) / totalScale;
		projectInverse(x, y, dst);
		if(dst.x < -Math.PI) dst.x = -Math.PI
		else if(dst.x > Math.PI) dst.x = Math.PI;
		if(projectionLongitude != 0) dst.x = MapMath.normalizeLongitude(dst.x + projectionLongitude);
		dst.x *= RTD;
		dst.y *= RTD;
		return dst;
	}

	/**
	 * Inverse-project a point (in metres), producing a lat/long result in radians
	 */
	public function inverseTransformRadians(src : Point, dst : Point) : Point {
		var x : Float = (src.x - totalFalseEasting) / totalScale;
		var y : Float = (src.y - totalFalseNorthing) / totalScale;
		projectInverse(x, y, dst);
		if(dst.x < -Math.PI) dst.x = -Math.PI
		else if(dst.x > Math.PI) dst.x = Math.PI;
		if(projectionLongitude != 0) dst.x = MapMath.normalizeLongitude(dst.x + projectionLongitude);
		return dst;
	}

	/**
	 * The method which actually does the inverse projection. This should be overridden for all projections.
	 */
	public function projectInverse(xyx : Float, xyy : Float, out : Point) : Point {
		out.x = xyx;
		out.y = xyy;
		return out;
	}

	/**
	 * Inverse-project a number of points (in metres), producing a lat/long result in degrees
	 */
	public function inverseTransformMultiple(srcPoints : Array<Dynamic>, srcOffset : Int, dstPoints : Array<Dynamic>, dstOffset : Int, numPoints : Int) : Void {
		var _in : Point = new Point();
		var out : Point = new Point();
		var i : Int = 0;
		while(i < numPoints) {
			_in.x = srcPoints[srcOffset++];
			_in.y = srcPoints[srcOffset++];
			inverseTransform(_in, out);
			dstPoints[dstOffset++] = out.x;
			dstPoints[dstOffset++] = out.y;
			i++;
		}
	}

	/**
	 * Inverse-project a number of points (in metres), producing a lat/long result in radians
	 */
	public function inverseTransformMultipleRadians(srcPoints : Array<Dynamic>, srcOffset : Int, dstPoints : Array<Dynamic>, dstOffset : Int, numPoints : Int) : Void {
		var _in : Point = new Point();
		var out : Point = new Point();
		var i : Int = 0;
		while(i < numPoints) {
			_in.x = srcPoints[srcOffset++];
			_in.y = srcPoints[srcOffset++];
			inverseTransformRadians(_in, out);
			dstPoints[dstOffset++] = out.x;
			dstPoints[dstOffset++] = out.y;
			i++;
		}
	}

	/**
	 * Finds the smallest lat/long rectangle wholly inside the given view rectangle.
	 * This is only a rough estimate.
	 */
	public function inverseTransformRectangle(r : Rectangle) : Rectangle {
		var _in : Point = new Point();
		var out : Point = new Point();
		var bounds : Rectangle = r;
		var ix : Int;
		var iy : Int;
		var x : Float;
		var y : Float;
		if(isRectilinear())  {
			ix = 0;
			while(ix < 2) {
				x = r.x + r.width * ix;
				iy = 0;
				while(iy < 2) {
					y = r.y + r.height * iy;
					_in.x = x;
					_in.y = y;
					inverseTransform(_in, out);
					if(ix == 0 && iy == 0) bounds = new Rectangle(out.x, out.y, 0, 0)
					else bounds.offset(out.x, out.y);
					iy++;
				}
				ix++;
			}
		}

		else  {
			ix = 0;
			while(ix < 7) {
				x = r.x + r.width * ix / 6;
				iy = 0;
				while(iy < 7) {
					y = r.y + r.height * iy / 6;
					_in.x = x;
					_in.y = y;
					inverseTransform(_in, out);
					if(ix == 0 && iy == 0) bounds = new Rectangle(out.x, out.y, 0, 0)
					else bounds.offset(out.x, out.y);
					iy++;
				}
				ix++;
			}
		}

		return bounds;
	}

	/**
	 * Transform a bounding box. This is only a rough estimate.
	 */
	public function transformRectangle(r : Rectangle) : Rectangle {
		var _in : Point = new Point();
		var out : Point = new Point();
		var bounds : Rectangle = r;
		var ix : Int;
		var iy : Int;
		var x : Float;
		var y : Float;
		if(isRectilinear())  {
			ix = 0;
			while(ix < 2) {
				x = r.x + r.width * ix;
				iy = 0;
				while(iy < 2) {
					y = r.y + r.height * iy;
					_in.x = x;
					_in.y = y;
					transform(_in, out);
					if(ix == 0 && iy == 0) bounds = new Rectangle(out.x, out.y, 0, 0)
					else bounds.offset(out.x, out.y);
					iy++;
				}
				ix++;
			}
		}

		else  {
			ix = 0;
			while(ix < 7) {
				x = r.x + r.width * ix / 6;
				iy = 0;
				while(iy < 7) {
					y = r.y + r.height * iy / 6;
					_in.x = x;
					_in.y = y;
					transform(_in, out);
					if(ix == 0 && iy == 0) bounds = new Rectangle(out.x, out.y, 0, 0)
					else bounds.offset(out.x, out.y);
					iy++;
				}
				ix++;
			}
		}

		return bounds;
	}

	/**
	 * Returns true if this projection is conformal
	 */
	public function isConformal() : Bool {
		return isRectilinear();
	}

	/**
	 * Returns true if this projection is equal area
	 */
	public function isEqualArea() : Bool {
		return false;
	}

	/**
	 * Returns true if this projection has an inverse
	 */
	public function hasInverse() : Bool {
		return false;
	}

	/**
	 * Returns true if lat/long lines form a rectangular grid for this projection
	 */
	public function isRectilinear() : Bool {
		return false;
	}

	/**
	 * Returns true if latitude lines are parallel for this projection
	 */
	public function parallelsAreParallel() : Bool {
		return isRectilinear();
	}

	/**
	 * Returns true if the given lat/long point is visible in this projection
	 */
	public function inside(x : Float, y : Float) : Bool {
		x = normalizeLongitude(x * DTR - projectionLongitude);
		return minLongitude <= x && x <= maxLongitude && minLatitude <= y && y <= maxLatitude;
	}

	/**
	 * Set the name of this projection.
	 */
	public function setName(name : String) : Void {
		this.name = name;
	}

	public function getName() : String {
		if(name != null) return name;
		return toString();
	}

	/**
	 * Get a string which describes this projection in PROJ.4 format.
	 */
	/*public function getPROJ4Description():String {
	AngleFormat format = new AngleFormat( AngleFormat.ddmmssPattern, false );
	StringBuffer sb = new StringBuffer();
	sb.append(
	"+proj="+getName()+
	" +a="+a
	);
	if ( es != 0 )
	sb.append( " +es="+es );
	sb.append( " +lon_0=" );
	format.format( projectionLongitude, sb, null );
	sb.append( " +lat_0=" );
	format.format( projectionLatitude, sb, null );
	if ( falseEasting != 1 )
	sb.append( " +x_0="+falseEasting );
	if ( falseNorthing != 1 )
	sb.append( " +y_0="+falseNorthing );
	if ( scaleFactor != 1 )
	sb.append( " +k="+scaleFactor );
	if ( fromMetres != 1 )
	sb.append( " +fr_meters="+fromMetres );
	return sb.toString();
	}
	*/
	public function toString() : String {
		return "None";
	}

	/**
	 * Set the minimum latitude. This is only used for Shape clipping and doesn't affect projection.
	 */
	public function setMinLatitude(minLatitude : Float) : Void {
		this.minLatitude = minLatitude;
	}

	public function getMinLatitude() : Float {
		return minLatitude;
	}

	/**
	 * Set the maximum latitude. This is only used for Shape clipping and doesn't affect projection.
	 */
	public function setMaxLatitude(maxLatitude : Float) : Void {
		this.maxLatitude = maxLatitude;
	}

	public function getMaxLatitude() : Float {
		return maxLatitude;
	}

	public function getMaxLatitudeDegrees() : Float {
		return maxLatitude * RTD;
	}

	public function getMinLatitudeDegrees() : Float {
		return minLatitude * RTD;
	}

	public function setMinLongitude(minLongitude : Float) : Void {
		this.minLongitude = minLongitude;
	}

	public function getMinLongitude() : Float {
		return minLongitude;
	}

	public function setMinLongitudeDegrees(minLongitude : Float) : Void {
		this.minLongitude = DTR * minLongitude;
	}

	public function getMinLongitudeDegrees() : Float {
		return minLongitude * RTD;
	}

	public function setMaxLongitude(maxLongitude : Float) : Void {
		this.maxLongitude = maxLongitude;
	}

	public function getMaxLongitude() : Float {
		return maxLongitude;
	}

	public function setMaxLongitudeDegrees(maxLongitude : Float) : Void {
		this.maxLongitude = DTR * maxLongitude;
	}

	public function getMaxLongitudeDegrees() : Float {
		return maxLongitude * RTD;
	}

	/**
	 * Set the projection latitude in radians.
	 */
	public function setProjectionLatitude(projectionLatitude : Float) : Void {
		this.projectionLatitude = projectionLatitude;
	}

	public function getProjectionLatitude() : Float {
		return projectionLatitude;
	}

	/**
	 * Set the projection latitude in degrees.
	 */
	public function setProjectionLatitudeDegrees(projectionLatitude : Float) : Void {
		this.projectionLatitude = DTR * projectionLatitude;
	}

	public function getProjectionLatitudeDegrees() : Float {
		return projectionLatitude * RTD;
	}

	/**
	 * Set the projection longitude in radians.
	 */
	public function setProjectionLongitude(projectionLongitude : Float) : Void {
		this.projectionLongitude = normalizeLongitudeRadians(projectionLongitude);
	}

	public function getProjectionLongitude() : Float {
		return projectionLongitude;
	}

	/**
	 * Set the projection longitude in degrees.
	 */
	public function setProjectionLongitudeDegrees(projectionLongitude : Float) : Void {
		this.projectionLongitude = DTR * projectionLongitude;
	}

	public function getProjectionLongitudeDegrees() : Float {
		return projectionLongitude * RTD;
	}

	/**
	 * Set the latitude of true scale in radians. This is only used by certain projections.
	 */
	public function setTrueScaleLatitude(trueScaleLatitude : Float) : Void {
		this.trueScaleLatitude = trueScaleLatitude;
	}

	public function getTrueScaleLatitude() : Float {
		return trueScaleLatitude;
	}

	/**
	 * Set the latitude of true scale in degrees. This is only used by certain projections.
	 */
	public function setTrueScaleLatitudeDegrees(trueScaleLatitude : Float) : Void {
		this.trueScaleLatitude = DTR * trueScaleLatitude;
	}

	public function getTrueScaleLatitudeDegrees() : Float {
		return trueScaleLatitude * RTD;
	}

	/**
	 * Set the projection latitude in radians.
	 */
	public function setProjectionLatitude1(projectionLatitude1 : Float) : Void {
		this.projectionLatitude1 = projectionLatitude1;
	}

	public function getProjectionLatitude1() : Float {
		return projectionLatitude1;
	}

	/**
	 * Set the projection latitude in degrees.
	 */
	public function setProjectionLatitude1Degrees(projectionLatitude1 : Float) : Void {
		this.projectionLatitude1 = DTR * projectionLatitude1;
	}

	public function getProjectionLatitude1Degrees() : Float {
		return projectionLatitude1 * RTD;
	}

	/**
	 * Set the projection latitude in radians.
	 */
	public function setProjectionLatitude2(projectionLatitude2 : Float) : Void {
		this.projectionLatitude2 = projectionLatitude2;
	}

	public function getProjectionLatitude2() : Float {
		return projectionLatitude2;
	}

	/**
	 * Set the projection latitude in degrees.
	 */
	public function setProjectionLatitude2Degrees(projectionLatitude2 : Float) : Void {
		this.projectionLatitude2 = DTR * projectionLatitude2;
	}

	public function getProjectionLatitude2Degrees() : Float {
		return projectionLatitude2 * RTD;
	}

	/**
	 * Set the false Northing in projected units.
	 */
	public function setFalseNorthing(falseNorthing : Float) : Void {
		this.falseNorthing = falseNorthing;
	}

	public function getFalseNorthing() : Float {
		return falseNorthing;
	}

	/**
	 * Set the false Easting in projected units.
	 */
	public function setFalseEasting(falseEasting : Float) : Void {
		this.falseEasting = falseEasting;
	}

	public function getFalseEasting() : Float {
		return falseEasting;
	}

	/**
	 * Set the projection scale factor. This is set to 1 by default.
	 */
	public function setScaleFactor(scaleFactor : Float) : Void {
		this.scaleFactor = scaleFactor;
	}

	public function getScaleFactor() : Float {
		return scaleFactor;
	}

	public function getEquatorRadius() : Float {
		return a;
	}

	/**
	 * Set the conversion factor from metres to projected units. This is set to 1 by default.
	 */
	public function setFromMetres(fromMetres : Float) : Void {
		this.fromMetres = fromMetres;
	}

	public function getFromMetres() : Float {
		return fromMetres;
	}

	public function setEllipsoid(ellipsoid : Ellipsoid) : Void {
		this.ellipsoid = ellipsoid;
		a = ellipsoid.equatorRadius;
		e = ellipsoid.eccentricity;
		es = ellipsoid.eccentricity2;
	}

	public function getEllipsoid() : Ellipsoid {
		return ellipsoid;
	}

	/**
	 * Returns the ESPG code for this projection, or 0 if unknown.
	 */
	public function getEPSGCode() : Int {
		return 0;
	}

	/**
	 * Initialize the projection. This should be called after setting parameters and before using the projection.
	 * This is for performance reasons as initialization may be expensive.
	 */
	public function initialize() : Void {
		spherical = e == 0.0;
		one_es = 1 - es;
		rone_es = 1.0 / one_es;
		totalScale = a * fromMetres;
		totalFalseEasting = falseEasting * fromMetres;
		totalFalseNorthing = falseNorthing * fromMetres;
	}

	static public function normalizeLongitude(angle : Float) : Float {
		if(!Math.isFinite(angle) || Math.isNaN(angle)) throw new ArgumentError("Infinite longitude");
		while(angle > 180)angle -= 360;
		while(angle < -180)angle += 360;
		return angle;
	}

	static public function normalizeLongitudeRadians(angle : Float) : Float {
		if(!Math.isFinite(angle) || Math.isNaN(angle)) throw new ArgumentError("Infinite longitude");
		while(angle > Math.PI)angle -= MapMath.TWOPI;
		while(angle < -Math.PI)angle += MapMath.TWOPI;
		return angle;
	}

	public function getShortName() : String {
		return toString();
	}

	public function getInventor() : String {
		return "unknown";
	}

	public function getYear() : Int {
		return -1;
	}

}

