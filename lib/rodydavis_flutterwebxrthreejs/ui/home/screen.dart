@JS('THREE')
library three_js;

import 'dart:html';
import 'dart:js' as js;
import 'dart:math' as Math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// Minimal JS interop definitions for the Three.js facade.
// These definitions provide the members used in this file and are
// deliberately kept simple to avoid altering runtime behaviour.

// Define a minimal @JS annotation and @anonymous constant to avoid external package dependency.
class JS {
  final String? name;
  const JS([this.name]);
}

class _Anonymous {
  const _Anonymous();
}
const anonymous = _Anonymous();

@JS()
@anonymous
class MeshLambertMaterialParameters {
  external int get color;
  external set color(int c);
  external factory MeshLambertMaterialParameters();
}

@JS()
class MeshLambertMaterial {
  external factory MeshLambertMaterial(MeshLambertMaterialParameters parameters);
}

@JS()
class BoxGeometry {
  external factory BoxGeometry(num width, num height, num depth, int wSeg,
      int hSeg, int dSeg);
}

@JS()
class Vector3 {
  external num get x;
  external set x(num v);
  external num get y;
  external set y(num v);
  external num get z;
  external set z(num v);
}

@JS()
class Object3D {
  external factory Object3D();
  external Vector3 get position;
  external void add(Object3D object);
}

@JS()
class Mesh extends Object3D {
  external factory Mesh(BoxGeometry geometry, MeshLambertMaterial material);
}

@JS()
class FogExp2 {
  external factory FogExp2(int color, double density);
}

@JS()
class Scene extends Object3D {
  external factory Scene();
  external set fog(FogExp2 f);
}

@JS()
class PerspectiveCamera extends Object3D {
  external factory PerspectiveCamera(
      num fov, num aspect, num near, num far);
  external void lookAt(Vector3 target);
}

@JS()
class PointLight extends Object3D {
  external factory PointLight(int color);
}

@JS()
class WebGLRenderer {
  external factory WebGLRenderer([dynamic parameters]);
  external DivElement get domElement;
  external void setSize(num width, num height, bool updateStyle);
  external void render(Scene scene, PerspectiveCamera camera,
      [dynamic something, bool? something2]);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    song = _addAudio("nyanlooped.ogg", true);
    song2 = _addAudio("nyanslow.ogg", false);
    document.onMouseMove.listen(onDocumentMouseMove);
    document.onMouseDown.listen(onDocumentMouseDown);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _size = MediaQuery.of(context).size;
      init(_size);
      animate(0);
    });
    super.initState();
  }

  AudioElement _addAudio(String src, [bool play = false]) {
    final _element = AudioElement();
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('audio-$src', (int viewId) {
      _element
        ..style.border = '0'
        ..src = src
        ..loop = true;
      return _element;
    });
    if (play) {
      return _element;
    }
    return _element;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, dimens) {
        _updateSize(Size(dimens.maxWidth, dimens.maxHeight));
        return Container();
      },
    );
  }
}

void playAudio(String path, [bool second = false]) {
  js.context.callMethod('playAudio${second ? '2' : '1'}', [path]);
}

void pauseAudio(String path, [bool second = false]) {
  js.context.callMethod('pauseAudio${second ? '2' : '1'}', [path]);
}

Math.Random rand = Math.Random();

late DivElement container;
late WebGLRenderer renderer;
late Scene scene;
late PerspectiveCamera camera;

late Object3D poptart;
late Object3D feet;
late Object3D face;
late Object3D tail;

late List<List<Object3D>> stars;
num numStars = 10;

late Object3D rainbow;
late Object3D rainChunk;
num numRainChunks = 30;

num mouseX = 0;
num mouseY = 0;
late num windowHalfX;
late num windowHalfY;

double deltaSum = 0;
int frame = 0;
bool running = true;

late AudioElement song;
late AudioElement song2;

void init(Size windowSize) {
  container = DivElement();
  document.body!.children.add(container);

  camera = PerspectiveCamera(
    45.0,
    (window.innerWidth ?? 0) / (window.innerHeight ?? 1),
    0.1,
    10000.0,
  );
  camera.position.z = 30.0;
  camera.position.x = 0.0;
  camera.position.y = 0.0;

  scene = Scene();
  // TODO: FogExp2 does not inherit correctly.
  scene.fog = FogExp2(0x003366, 0.0095);

  //POPTART
  poptart = Object3D();
  helper(poptart, 0, -2, -1, 21, 14, 3, 0x222222);
  helper(poptart, 1, -1, -1, 19, 16, 3, 0x222222);
  helper(poptart, 2, 0, -1, 17, 18, 3, 0x222222);

  helper(poptart, 1, -2, -1.5, 19, 14, 4, 0xffcc99);
  helper(poptart, 2, -1, -1.5, 17, 16, 4, 0xffcc99);

  helper(poptart, 2, -4, 2, 17, 10, .6, 0xff99ff);
  helper(poptart, 3, -3, 2, 15, 12, .6, 0xff99ff);
  helper(poptart, 4, -2, 2, 13, 14, .6, 0xff99ff);

  helper(poptart, 4, -4, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 9, -3, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 12, -3, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 16, -5, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 8, -7, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 5, -9, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 9, -10, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 3, -11, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 7, -13, 2, 1, 1, .7, 0xff3399);
  helper(poptart, 4, -14, 2, 1, 1, .7, 0xff3399);

  poptart.position.x = -10.5;
  poptart.position.y = 9.0;
  scene.add(poptart);

  //FEET
  feet = Object3D();
  helper(feet, 0, -2, .49, 3, 3, 1, 0x222222);
  helper(feet, 1, -1, .49, 3, 3, 1, 0x222222);
  helper(feet, 1, -2, -.01, 2, 2, 2, 0x999999);
  helper(feet, 2, -1, -.01, 2, 2, 2, 0x999999);

  helper(feet, 6, -2, -.5, 3, 3, 1, 0x222222);
  helper(feet, 6, -2, -.5, 4, 2, 1, 0x222222);
  helper(feet, 7, -2, -.99, 2, 2, 2, 0x999999);

  helper(feet, 16, -3, .49, 3, 2, 1, 0x222222);
  helper(feet, 15, -2, .49, 3, 2, 1, 0x222222);
  helper(feet, 15, -2, -.01, 2, 1, 2, 0x999999);
  helper(feet, 16, -3, -.01, 2, 1, 2, 0x999999);

  helper(feet, 21, -3, -.5, 3, 2, 1, 0x222222);
  helper(feet, 20, -2, -.5, 3, 2, 1, 0x222222);
  helper(feet, 20, -2, -.99, 2, 1, 2, 0x999999);
  helper(feet, 21, -3, -.99, 2, 1, 2, 0x999999);

  feet.position.x = -12.5;
  feet.position.y = -6.0;
  scene.add(feet);

  //TAIL
  tail = Object3D();
  helper(tail, 0, 0, -.25, 4, 3, 1.5, 0x222222);
  helper(tail, 1, -1, -.25, 4, 3, 1.5, 0x222222);
  helper(tail, 2, -2, -.25, 4, 3, 1.5, 0x222222);
  helper(tail, 3, -3, -.25, 4, 3, 1.5, 0x222222);
  helper(tail, 1, -1, -.5, 2, 1, 2, 0x999999);
  helper(tail, 2, -2, -.5, 2, 1, 2, 0x999999);
  helper(tail, 3, -3, -.5, 2, 1, 2, 0x999999);
  helper(tail, 4, -4, -.5, 2, 1, 2, 0x999999);

  tail.position.x = -16.5;
  tail.position.y = 2.0;
  scene.add(tail);

  //FACE
  face = Object3D();
  helper(face, 2, -3, -3, 12, 9, 4, 0x222222);
  helper(face, 0, -5, 0, 16, 5, 1, 0x222222);
  helper(face, 1, -1, 0, 4, 10, 1, 0x222222);
  helper(face, 11, -1, 0, 4, 10, 1, 0x222222);
  helper(face, 3, -11, 0, 10, 2, 1, 0x222222);
  helper(face, 2, 0, 0, 2, 2, 1, 0x222222);
  helper(face, 4, -2, 0, 2, 2, 1, 0x222222);
  helper(face, 12, 0, 0, 2, 2, 1, 0x222222);
  helper(face, 10, -2, 0, 2, 2, 1, 0x222222);

  helper(face, 1, -5, .5, 14, 5, 1, 0x999999);
  helper(face, 3, -4, .5, 10, 8, 1, 0x999999);
  helper(face, 2, -1, .5, 2, 10, 1, 0x999999);
  helper(face, 12, -1, .5, 2, 10, 1, 0x999999);
  helper(face, 4, -2, .5, 1, 2, 1, 0x999999);
  helper(face, 5, -3, .5, 1, 1, 1, 0x999999);
  helper(face, 11, -2, .5, 1, 2, 1, 0x999999);
  helper(face, 10, -3, .5, 1, 1, 1, 0x999999);
  //Eyes
  helper(face, 4, -6, .6, 2, 2, 1, 0x222222);
  helper(face, 11, -6, .6, 2, 2, 1, 0x222222);
  helper(face, 3.99, -5.99, .6, 1.01, 1.01, 1.01, 0xffffff);
  helper(face, 10.99, -5.99, .6, 1.01, 1.01, 1.01, 0xffffff);
  //MOUTH
  helper(face, 5, -10, .6, 7, 1, 1, 0x222222);
  helper(face, 5, -9, .6, 1, 2, 1, 0x222222);
  helper(face, 8, -9, .6, 1, 2, 1, 0x222222);
  helper(face, 11, -9, .6, 1, 2, 1, 0x222222);
  //CHEEKS
  helper(face, 2, -8, .6, 2, 2, .91, 0xff9999);
  helper(face, 13, -8, .6, 2, 2, .91, 0xff9999);

  face.position.x = -.5;
  face.position.y = 4.0;
  face.position.z = 4.0;
  scene.add(face);

  //RAINBOW
  rainbow = Object3D();
  for (var c = 0; c < numRainChunks - 1; c++) {
    var yOffset = 8;
    if (c % 2 == 1) yOffset = 7;
    var xOffset = (-c * 8) - 16.5;
    helper(rainbow, xOffset, yOffset, 0, 8, 3, 1, 0xff0000);
    helper(rainbow, xOffset, yOffset - 3, 0, 8, 3, 1, 0xff9900);
    helper(rainbow, xOffset, yOffset - 6, 0, 8, 3, 1, 0xffff00);
    helper(rainbow, xOffset, yOffset - 9, 0, 8, 3, 1, 0x33ff00);
    helper(rainbow, xOffset, yOffset - 12, 0, 8, 3, 1, 0x0099ff);
    helper(rainbow, xOffset, yOffset - 15, 0, 8, 3, 1, 0x6633ff);
  }
  scene.add(rainbow);

  rainChunk = Object3D();
  helper(rainChunk, -16.5, 7, 0, 8, 3, 1, 0xff0000);
  helper(rainChunk, -16.5, 4, 0, 8, 3, 1, 0xff9900);
  helper(rainChunk, -16.5, 1, 0, 8, 3, 1, 0xffff00);
  helper(rainChunk, -16.5, -2, 0, 8, 3, 1, 0x33ff00);
  helper(rainChunk, -16.5, -5, 0, 8, 3, 1, 0x0099ff);
  helper(rainChunk, -16.5, -8, 0, 8, 3, 1, 0x6633ff);
  rainChunk.position.x -= (8 * (numRainChunks - 1));
  scene.add(rainChunk);

  stars = [];
  for (var state = 0; state < 6; state++) {
    stars.add([]);
    for (var c = 0; c < numStars; c++) {
      var star = Object3D();
      star.position.x = rand.nextDouble() * 200 - 100;
      star.position.y = rand.nextDouble() * 200 - 100;
      star.position.z = rand.nextDouble() * 200 - 100;
      buildStar(star, state);
      scene.add(star);
      stars[state].add(star);
    }
  }

  var pointLight = PointLight(0xFFFFFF);
  pointLight.position.z = 1000.0;
  scene.add(pointLight);

  renderer = WebGLRenderer();
  _updateSize(windowSize);
  container.nodes.add(renderer.domElement);

  // compute window half values after init
  windowHalfX = (window.innerWidth ?? 0) / 2;
  windowHalfY = (window.innerHeight ?? 0) / 2;
}

void _updateSize(Size windowSize) {
  renderer.setSize(windowSize.width, windowSize.height, true);
}

void animate(num t) {
  window.requestAnimationFrame(animate);
  render(t);
}

void render(num t) {
  var delta = t; //clock.getDelta();
  if (running) deltaSum += delta;
  if (deltaSum > .07) {
    deltaSum = deltaSum % .07;
    frame = (frame + 1) % 12;
    for (var c = 0; c < numStars; c++) {
      var tempX = stars[5][c].position.x,
          tempY = stars[5][c].position.y,
          tempZ = stars[5][c].position.z;
      for (var state = 5; state > 0; state--) {
        var star = stars[state][c];
        var star2 = stars[state - 1][c];
        star.position.x = star2.position.x - 8;
        star.position.y = star2.position.y;
        star.position.z = star2.position.z;

        if (star.position.x < -100) {
          star.position.x += 200;
          star.position.y = rand.nextDouble() * 200 - 100;
          star.position.z = rand.nextDouble() * 200 - 100;
        }
      }
      stars[0][c].position.x = tempX;
      stars[0][c].position.y = tempY;
      stars[0][c].position.z = tempZ;
    }
    switch (frame) {
      case 0: //2nd frame
        face.position.x++;
        feet.position.x++;
        break;
      case 1:
        face.position.y--;
        feet.position.x++;
        feet.position.y--;
        poptart.position.y--;
        rainbow.position.x -= 9.0;
        rainChunk.position.x += (8.0 * (numRainChunks - 1)) - 1;
        break;
      case 2:
        feet.position.x--;
        break;
      case 3:
        face.position.x--;
        feet.position.x--;
        rainbow.position.x += 9.0;
        rainChunk.position.x -= (8.0 * (numRainChunks - 1)) - 1;
        break;
      case 4:
        face.position.y++;
        break;
      case 5:
        poptart.position.y++;
        feet.position.y++;
        rainbow.position.x -= 9.0;
        rainChunk.position.x += (8.0 * (numRainChunks - 1)) - 1;
        break;
      case 6: //8th frame
        face.position.x++;
        feet.position.x++;
        break;
      case 7:
        poptart.position.y--;
        face.position.y--;
        feet.position.x++;
        feet.position.y--;
        rainbow.position.x += 9.0;
        rainChunk.position.x -= (8.0 * (numRainChunks - 1)) - 1;
        break;
      case 8:
        feet.position.x--;
        break;
      case 9:
        face.position.x--;
        feet.position.x--;
        rainbow.position.x -= 9.0;
        rainChunk.position.x += (8.0 * (numRainChunks - 1)) - 1;
        break;
      case 10:
        face.position.y++;
        break;
      case 11: //1st frame
        poptart.position.y++;
        feet.position.y++;
        rainbow.position.x += 9.0;
        rainChunk.position.x -= (8.0 * (numRainChunks - 1)) - 1;
        break;
    }
  }
  camera.position.x += (mouseX - camera.position.x) * .005;
  camera.position.y += (-mouseY - camera.position.y) * .005;
  camera.lookAt(scene.position);
  renderer.render(scene, camera, null, false);
}

void helper(Object3D o, num x, num y, num z, num w, num h, num d, int c) {
  MeshLambertMaterialParameters mat = MeshLambertMaterialParameters()..color = c;
  var material = MeshLambertMaterial(mat);
  var geometry = BoxGeometry(w.toDouble(), h.toDouble(), d.toDouble(), 1, 1, 1);
  var mesh = Mesh(geometry, material);
  mesh.position.x = x.toDouble() + (w.toDouble() / 2.0);
  mesh.position.y = y.toDouble() - (h.toDouble() / 2.0);
  mesh.position.z = z.toDouble() + (d.toDouble() / 2.0);
  o.add(mesh);
}

void buildStar(Object3D star, int state) {
  switch (state) {
    case 0:
      helper(star, 0, 0, 0, 1, 1, 1, 0xffffff);
      break;
    case 1:
      helper(star, 1, 0, 0, 1, 1, 1, 0xffffff);
      helper(star, -1, 0, 0, 1, 1, 1, 0xffffff);
      helper(star, 0, 1, 0, 1, 1, 1, 0xffffff);
      helper(star, 0, -1, 0, 1, 1, 1, 0xffffff);
      break;
    case 2:
      helper(star, 1, 0, 0, 2, 1, 1, 0xffffff);
      helper(star, -2, 0, 0, 2, 1, 1, 0xffffff);
      helper(star, 0, 2, 0, 1, 2, 1, 0xffffff);
      helper(star, 0, -1, 0, 1, 2, 1, 0xffffff);
      break;
    case 3:
      helper(star, 0, 0, 0, 1, 1, 1, 0xffffff);
      helper(star, 2, 0, 0, 2, 1, 1, 0xffffff);
      helper(star, -3, 0, 0, 2, 1, 1, 0xffffff);
      helper(star, 0, 3, 0, 1, 2, 1, 0xffffff);
      helper(star, 0, -2, 0, 1, 2, 1, 0xffffff);
      break;
    case 4:
      helper(star, 0, 3, 0, 1, 1, 1, 0xffffff);
      helper(star, 2, 2, 0, 1, 1, 1, 0xffffff);
      helper(star, 3, 0, 0, 1, 1, 1, 0xffffff);
      helper(star, 2, -2, 0, 1, 1, 1, 0xffffff);
      helper(star, 0, -3, 0, 1, 1, 1, 0xffffff);
      helper(star, -2, -2, 0, 1, 1, 1, 0xffffff);
      helper(star, -3, 0, 0, 1, 1, 1, 0xffffff);
      helper(star, -2, 2, 0, 1, 1, 1, 0xffffff);
      break;
    case 5:
      helper(star, 2, 0, 0, 1, 1, 1, 0xffffff);
      helper(star, -2, 0, 0, 1, 1, 1, 0xffffff);
      helper(star, 0, 2, 0, 1, 1, 1, 0xffffff);
      helper(star, 0, -2, 0, 1, 1, 1, 0xffffff);
      break;
  }
}

void onDocumentMouseMove(MouseEvent event) {
  mouseX = (event.client.x - windowHalfX);
  mouseY = (event.client.y - windowHalfY);
  // print("mouseX: $mouseX, mouseY: $mouseY");
}

void onDocumentMouseDown(MouseEvent event) {
  running = !running;
  if (running) {
    playAudio("nyanlooped.ogg");
    pauseAudio("nyanslow.ogg", true);
    // song.play();
    // song2.pause();
  } else {
    pauseAudio("nyanlooped.ogg");
    playAudio("nyanslow.ogg", true);
    // song.pause();
    // song2.play();
  }
}