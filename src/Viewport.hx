package;

import kha.graphics4.Graphics;

class Viewport {
	var pipeline:PipelineState;
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	
	public function new(g4: Graphics) {
		drawContours();
		structure.add("pos", VertexData.Float3);
		structure.add("col", VertexData.Float4);
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.depthWrite = false;
		pipeline.depthMode = CompareMode.Less;
		pipeline.compile();
		rearrageDrawData();
	}

	public function render(g4: Graphics) {
		g4.setVertexBuffer(vertexBuffer);
		g4.setIndexBuffer(indexBuffer);
		g4.setPipeline(pipeline);
	}

	function drawContours() {
		
	}

	function rearrageDrawData() {
		var pen = pen2D;
		var data = pen.arr;
		// triangle length
		totalTriangles = Std.int(data.size / 7);
		bufferLength = Std.int(totalTriangles * 3);
		
		len = Std.int(totalTriangles * structureLength * 3);
		vertexBuffer = new VertexBuffer(bufferLength, structure, Usage.DynamicUsage);
		
		indexBuffer = new IndexBuffer(bufferLength, Usage.StaticUsage);

		var iData = indexBuffer.lock();
		for (i in 0...iData.length ) {
			iData.set(i, i);
		}
		indexBuffer.unlock();
		
		var red = 0.0;
		var green = 0.0;
		var blue = 0.0; 
		var alpha = 0.0;
		var color:Int = 0;
		var j = 0;
		var vbData = vertexBuffer.lock();
		for(i in 0...totalTriangles){
			pen.pos = i;
			color = Std.int(data.color);
			alpha = alphaChannel(color);
			red = redChannel(color);
			green = greenChannel(color);
			blue  = blueChannel(color);
			// populate vbData.
			vbData.set(j, gx(data.ax));
			vbData.set(j + 1, gy(data.ay));
			vbData.set(j + 2, z);
			vbData.set(j + 3, red);
			vbData.set(j + 4, green);
			vbData.set(j + 5, blue);
			vbData.set(j + 6, 1.0);

			vbData.set(j + 7, gx(data.bx));
			vbData.set(j + 8, gy(data.by));
			vbData.set(j + 9, z);
			vbData.set(j + 10, red);
			vbData.set(j + 11, green);
			vbData.set(j + 12, blue);
			vbData.set(j + 13, 1.0);

			vbData.set(j + 14, gx(data.cx));
			vbData.set(j + 15, gy(data.cy));
			vbData.set(j + 16, z);
			vbData.set(j + 17, red);
			vbData.set(j + 18, green);
			vbData.set(j + 19, blue);
			vbData.set(j + 20, 1.0);
			j += Std.int(structureLength * 3);
		}
		vertexBuffer.unlock();
	}
}
