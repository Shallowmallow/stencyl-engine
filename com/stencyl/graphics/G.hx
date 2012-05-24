package com.stencyl.graphics;

import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Shape;
import nme.display.BlendMode;

import nme.geom.Rectangle;
import nme.geom.Point;

import com.stencyl.models.Actor;
import com.stencyl.models.Font;

class G 
{
	public var graphics:Graphics;
	public var canvas:BitmapData;
	
	public var x:Float;
	public var y:Float;
	public var scaleX:Float; //[1]
	public var scaleY:Float; //[1]
	public var alpha:Float; // [0,1]
	public var blendMode:BlendMode;
	public var strokeSize:Int;
	public var fillColor:Int;
	public var strokeColor:Int;
	public var font:Font;
	
	//Temp to avoid creating objects
	private var rect:Rectangle;
	private var point:Point;
	
	//Polygon Specific
	private var drawPoly:Bool;
	private var pointCounter:Int;
	private var firstX:Float;
	private var firstY:Float;
	
	public function new() 
	{	
		x = y = 0;
		scaleX = scaleY = 1;
		alpha = 1;
		blendMode = BlendMode.NORMAL;
		
		strokeSize = 0;
		
		fillColor = 0x000000;
		strokeColor = 0x000000;
		
		//
		
		rect = new Rectangle();
		point = new Point();
		
		//
		
		drawPoly = false;
		pointCounter = 0;
		firstX = 0;
		firstY = 0;
		
		//TODO: Default font built in
	}
	
	public inline function startGraphics()
	{
		graphics.lineStyle(strokeSize, strokeColor, alpha);
	}
	
	public inline function endGraphics()
	{
	}
	
	public function translate(x:Float, y:Float)
	{
		this.x += x * scaleX;
		this.y += y * scaleY;
	}
	
	public function moveTo(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}
	
	public function translateToScreen()
	{
		x = 0;
		y = 0;
	}
	
	public function translateToActor(a:Actor)
	{
		x = a.x - a.width * (a.scaleX - 1) / 2;
		y = a.y - a.height * (a.scaleY - 1) / 2;
	}
	
	public function drawString(s:String, x:Float, y:Float)
	{
		font.font.text = s;
		drawImage(font.font.bitmapData, x, y); // this is kinda slow unless we only update when a repaint in requested?
	}
	
	public function drawLine(x1:Float, y1:Float, x2:Float, y2:Float)
	{
		x1 *= scaleX;
		y1 *= scaleY;
		x2 *= scaleX;
		y2 *= scaleY;
		
		startGraphics();
		 
     	graphics.moveTo(this.x + x1, this.y + y1);
     	graphics.lineTo(this.x + x2, this.y + y2);
     	
     	endGraphics();
	}
	
	public function fillPixel(x:Float, y:Float)
	{
		fillRect(x, y, 1, 1);
	}
	
	public function drawRect(x:Float, y:Float, w:Float, h:Float)
	{
		x *= scaleX;
		y *= scaleY;
		w *= scaleX;
		h *= scaleY;
		
		startGraphics();
		 
     	graphics.drawRect(this.x + x, this.y + y, w, h);
     	
     	endGraphics();
	}
	
	public function fillRect(x:Float, y:Float, w:Float, h:Float)
	{
		x *= scaleX;
		y *= scaleY;
		w *= scaleX;
		h *= scaleY;
		
		startGraphics();
	
		graphics.beginFill(fillColor, alpha);
     	graphics.drawRect(this.x + x, this.y + y, w, h);
     	graphics.endFill();
     	
     	endGraphics();
	}
	
	public function drawRoundRect(x:Float, y:Float, w:Float, h:Float, arc:Float)
	{
		x *= scaleX;
		y *= scaleY;
		w *= scaleX;
		h *= scaleY;
	
		startGraphics();
		 
     	graphics.drawRoundRect(this.x + x, this.y + y, w, h, arc, arc);
     	
     	endGraphics();
	}
	
	public function fillRoundRect(x:Float, y:Float, w:Float, h:Float, arc:Float)
	{
		x *= scaleX;
		y *= scaleY;
		w *= scaleX;
		h *= scaleY;
		
		startGraphics();
	
		graphics.beginFill(fillColor, alpha);
     	graphics.drawRoundRect(this.x + x, this.y + y, w, h, arc, arc);
     	graphics.endFill();
     	
     	endGraphics();
	}
	
	public function drawCircle(x:Float, y:Float, r:Float)
	{
		x *= scaleX;
		y *= scaleY;
		r *= scaleX;
		
		startGraphics();
		 
     	graphics.drawCircle(this.x + x, this.y + y, r);
     	
     	endGraphics();
	}
	
	public function fillCircle(x:Float, y:Float, r:Float)
	{
		x *= scaleX;
		y *= scaleY;
		r *= scaleX;
	
		startGraphics();
	
		graphics.beginFill(fillColor, alpha);
     	graphics.drawCircle(this.x + x, this.y + y, r);
     	graphics.endFill();
     	
     	endGraphics();
	}
	
	public function beginFillPolygon()
	{
		drawPoly = false;
		
		startGraphics();
		graphics.moveTo(this.x, this.y);
		pointCounter = 0;
	}
	
	public function endDrawingPolygon()
	{
		if(pointCounter < 2)
		{
			return;	
		}
		
		if(drawPoly)
		{
			graphics.lineTo(this.x + firstX, this.y + firstY);
		}
			
		else
		{
			graphics.lineTo(this.x + firstX, this.y + firstY);
			graphics.endFill();
		}
		
		endGraphics();
	}
	
	public function beginDrawPolygon()
	{
		drawPoly = true;
	
		startGraphics();
		graphics.moveTo(this.x, this.y);
		pointCounter = 0;
	}
	
	public function addPointToPolygon(x:Float, y:Float)
	{
		x *= scaleX;
		y *= scaleY;
		
		if(pointCounter == 0)
		{
			firstX = x;
			firstY = y;
			
			graphics.moveTo(this.x + x, this.y + y);
			
			if(!drawPoly)
			{
				graphics.beginFill(fillColor, alpha);	
			}
		}
		
		pointCounter++;
		
		graphics.lineTo(this.x + x, this.y + y);
	}
	
	public function drawImage(img:BitmapData, x:Float, y:Float)
	{
		x *= scaleX;
		y *= scaleY;
		
		rect.x = 0;
		rect.y = 0;
		rect.width = img.width;
		rect.height = img.height;
		
		point.x = this.x + x;
		point.y = this.y + y;
	
		canvas.copyPixels(img, rect, point);
	}
	
	public function resetFont()
	{
	}
}