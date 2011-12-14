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
 * The superclass for all pseudo-cylindrical projections - eg. sinusoidal
 * These are projections where parallels are straight, but meridians aren't
 */
package net.vis4.map.proj;

import net.vis4.map.proj.CylindricalProjection;

class PseudoCylindricalProjection extends CylindricalProjection {

	override public function isRectilinear() : Bool {
		return false;
	}

	override public function toString() : String {
		return "Pseudo Cylindrical";
	}

}

