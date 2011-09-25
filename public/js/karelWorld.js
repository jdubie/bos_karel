
// Karel World class
function KarelWorld(appWidth, appHeight) {

	var BORDER_SIZE = 4;
	var CROSS_SIZE = 10;

	var crossImage = new Image();
	crossImage.src = "/images/cross.png";

	var beeperImage = new Image();
	beeperImage.src = "/images/beeper.jpg";

	var rows, cols;

	var worldWidth, worldHeight;

	var top, left;
	var bottom, right;

	var beepers, virtualBeepers;
	var walls;

	this.draw = function(c) {
		c.fillStyle = "#000";
		c.fillRect(left - BORDER_SIZE, top - BORDER_SIZE,
			worldWidth + BORDER_SIZE*2, worldHeight + BORDER_SIZE*2);

		c.fillStyle = "#eaeefa";
		c.fillRect(left, top, worldWidth, worldHeight);

		for (var rIndex = 0; rIndex < rows; rIndex++) {
			for (var cIndex = 0; cIndex < cols; cIndex++) {
				var x = left + cIndex * KAREL_SIZE + (KAREL_SIZE - CROSS_SIZE)/2;
				var y = top + rIndex * KAREL_SIZE + (KAREL_SIZE - CROSS_SIZE)/2;
				c.drawImage(crossImage, x, y, CROSS_SIZE, CROSS_SIZE);
			}
		}

		beepers.draw(c);
	}

	this.drawWalls = function(c) {
		walls.draw(c);
	}



	this.loadWorld = function(world, karel) {


		var url = "/worlds/" + world;

		var worldText = loadDoc(url);

		var lines = worldText.split("\n");

		// get world dimension
		var dimensionTxt = lines[0];
		var dimensionStrings = lines[0].split(":");

		rows = parseInt(dimensionStrings[1]);
		cols = parseInt(dimensionStrings[2]);

		// reset variables
		worldWidth = cols * KAREL_SIZE;
		worldHeight = rows * KAREL_SIZE;

		top = (appHeight - worldHeight)/2;
		left = (appWidth - worldWidth)/2;

		bottom = top + worldHeight;
		right = left + worldWidth;

		beepers = new Beepers(rows, cols, left, top);
		virtualBeepers = new Beepers(rows, cols, left, top);
		walls = new Walls(rows, cols, left, top);

		karel.reset(rows - 1, 0);

		// load world details
		for (var i = 1; i < lines.length; i++) {
			loadLine(lines[i], karel);
		}
	}

	function loadLine(line, karel) {
		var elements = line.split(":");
		if (elements.length != 3) {
			return;
		}
		var key = elements[0];
		var v1 = parseInt(elements[1]);
		var v2 = parseInt(elements[2]);

		if (key == "karel")  {
			karel.reset(v1, v2);
		} else if (key == "top")  {
			walls.addTopWall(v1, v2);
		} else if (key == "right") {
			walls.addRightWall(v1, v2);
		} else if (key == "beeper") {
			beepers.putBeeper(v1, v2);
			virtualBeepers.putBeeper(v1, v2);
		}
	}

	this.isMoveValid = function(startX, startY, endX, endY) {
		if(endX < 0 || endX >= cols) return false;
		if(endY < 0 || endY >= rows) return false;

		if(startX + 1 == endX && walls.rightWall(startY, startX)) return false;
		if(startX - 1 == endX && walls.rightWall(endY, endX)) return false;

		if(startY + 1 == endY && walls.topWall(endY, endX)) return false;
		if(startY - 1 == endY && walls.topWall(startY, endX)) return false;

		return true;
	}

	this.putBeeper = function(r, c) {
		beepers.putBeeper(r, c);
	}

	this.putVirtualBeeper = function(r, c) {
		virtualBeepers.putBeeper(r, c);
	}

	this.pickBeeper = function(r, c) {
		beepers.pickBeeper(r, c);

	}

	this.pickVirtualBeeper = function(r, c) {
		if (virtualBeepers.beeperPresent(r, c)) {
			virtualBeepers.pickBeeper(r, c);
		}
	}

	this.virtualBeeperPresent = function(r, c) {
		return virtualBeepers.beeperPresent(r, c);
	}

	this.beeperPresent = function(r, c) {
		return beepers.beeperPresent(r, c);
	}

	this.getRows = function() {
		return rows;
	}

	this.getCols = function() {
		return cols;
	}

	this.getBottom = function() {
		return bottom;
	}

	this.getTop = function() {
		return top;
	}

	this.getLeft = function() {
		return left;
	}
}


