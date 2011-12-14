/**
 * ...
 * @author Sebastian Specht
 */
package src;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import net.vis4.map.proj.LambertEqualAreaConicProjection;
import net.vis4.map.proj.Projection;

class Main extends Sprite {

	var proj : Projection;
	var p : Point;
	public function new() {
		p = new Point();
		if(stage) init()
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function init(e : Event = null) : Void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		proj = new LambertEqualAreaConicProjection();
		proj.initialize();
		proj.project(0.0, 0.0, p);
		trace(p);
		drawGrid();
	}

	function drawGrid() : Void {
		var lamIncrement : Float = Math.PI * 0.5 * 0.1;
		var phiIncrement : Float = Math.PI * 0.5 * 0.1;
		var scale : Float = 100;
		graphics.clear();
		graphics.beginFill(0xff0000);
		var lam : Int = -10;
		while(lam <= 10) {
			var phi : Int = -10;
			while(phi <= 10) {
				proj.project(lam * lamIncrement, phi * phiIncrement, p);
				graphics.drawCircle(p.x * scale, p.y * scale, 1);
				phi++;
			}
			lam++;
		}
		graphics.endFill();
		graphics.lineStyle(2, 0, 0.1);
		proj.project(0, -10 * phiIncrement, p);
		graphics.moveTo(p.x * scale, p.y * scale);
		phi = -9;
		while(phi <= 10) {
			proj.project(0, phi * phiIncrement, p);
			graphics.lineTo(p.x * scale, p.y * scale);
			phi++;
		}
		proj.project(-10 * lamIncrement, 0, p);
		graphics.moveTo(p.x * scale, p.y * scale);
		lam = -9;
		while(lam <= 10) {
			proj.project(lam * lamIncrement, 0, p);
			graphics.lineTo(p.x * scale, p.y * scale);
			lam++;
		}
		this.x = stage.stageWidth * 0.5;
		this.y = stage.stageHeight * 0.5;
		this.scaleY = -1;
	}

}

