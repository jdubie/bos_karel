
// constants
var KAREL_SIZE = 40;
var CANVAS_WIDTH = 610;
var CANVAS_HEIGHT = 610;

// globals
var application = new Application();

/****************************************************
 *                    MAIN                          *
 ****************************************************/

window.onload = function() {
	canvas = document.getElementById('canvas');

	// Check the element is in the DOM and the browser supports canvas
	if(canvas && canvas.getContext) {
		canvas.width = CANVAS_WIDTH;
		canvas.height = CANVAS_HEIGHT;
		application.init();
	} else {
		alert("canvas not supported by your browser");
	}
}

/****************************************************
 *                   PUBLIC                         *
 ****************************************************/
function Application() {
	// constants
	var ACTION_HEARTBEATS = 1;
	var HEART_BEAT = 10;

	// instance variables
	var canvas = null;
	var context = null;
	var karel = null;
	var karelWorld = null;
	var animating = false;
	var actionCountdown = ACTION_HEARTBEATS;
	var codeMirror = null;
	var worldName = null;

	karelWorld = new KarelWorld(CANVAS_WIDTH, CANVAS_HEIGHT);
	karel = new Karel(karelWorld);

	this.init = function () {
		initCodeMirror();

		canvas = document.getElementById('canvas');
		context = canvas.getContext('2d');

		worldName = document.getElementById('map').innerHTML + '.w';
		// worldName = "15x15.w";

		loadCurrentWorld();
		setInterval("application.heartbeat();", HEART_BEAT);

	}

	this.changeWorld = function(selector) {
		worldName = selector.options[selector.selectedIndex].text;
		loadCurrentWorld();
	}

	function loadCurrentWorld() {
		karelWorld.loadWorld(worldName, karel);
		draw();
	}

	this.runButton = function () {
		var code = codeMirror.getCode();
		var karelApplication = new KarelApplication(code, karel);
		animating = true;
		loadCurrentWorld();
		karelApplication.start();
	}

	function initCodeMirror() {

		var textArea = document.getElementById('code');

		codeMirror = CodeMirror.fromTextArea(textArea, {
  			parserfile: ["tokenizejavascript.js", "parsejavascript.js"],
  			path: "../codeMirror/js/",
  			stylesheet: "../codeMirror/css/jscolors.css",
  			indentUnit:4,
			height: 1
		});

	}

	this.heartbeat = function() {
		if (!animating) return;

		update();
		draw();
	}

	function update() {
		actionCountdown = actionCountdown - 1;
		if (actionCountdown == 0 ) {
			animating = karel.executeNextAction();
			actionCountdown = ACTION_HEARTBEATS;
		}
	}

	function draw() {
		clear();
		karelWorld.draw(context);
		karel.draw(context);
		karelWorld.drawWalls(context);
	}


	function clear() {
		context.fillStyle = "#91b9df";
		context.fillRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
	}


}

