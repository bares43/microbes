import "dart:html";
import "dart:math";
import "Microbe.dart";

class Renderer {
  CanvasRenderingContext2D ctx;

  int width;
  int height;

  Renderer(CanvasElement canvas){
    ctx = canvas.getContext("2d");

    this.ctx = ctx;
    this.width = canvas.width;
    this.height = canvas.height;
  }

  void clearCanvas(){
    ctx.fillStyle= "#ffffff";
    ctx.fillRect(0,0,width, height);
  }

  void renderMicrobe(Microbe microbe){
    ctx.beginPath();
    ctx.arc(microbe.position.x, microbe.position.y, microbe.size, 0, 2 * PI, false);
    ctx.fillStyle = microbe.dna.color;
    ctx.strokeStyle = "#000";
    ctx.fill();
    ctx.stroke();
    ctx.closePath();
  }
}