

// Karel class
function Karel(karelWorld) {

	var KAREL_NORTH = 0;
	var KAREL_EAST = 1;
	var KAREL_SOUTH = 2;
	var KAREL_WEST = 3;

	var MOVE = 0;
	var TURN_LEFT = 1;
	var TURN_RIGHT = 2;
	var PUT_BEEPER = 3;
	var PICK_BEEPER = 4;

	var MAX_ACTIONS = 10000;

	var karelImages = new Array();
	karelImages[KAREL_NORTH] = new Image();
	karelImages[KAREL_NORTH].src = "/images/karelNorth.png";

	karelImages[KAREL_EAST] = new Image();
	karelImages[KAREL_EAST].src = "/images/karelEast.png";

	karelImages[KAREL_SOUTH] = new Image();
	karelImages[KAREL_SOUTH].src = "/images/karelSouth.png";

	karelImages[KAREL_WEST] = new Image();
	karelImages[KAREL_WEST].src = "/images/karelWest.png";

	var xIndex, yIndex, direction;
	var virtualX, virtualY, virtualDirection;
	var actionBuffer, actionIndex;

	this.draw = function(c) {
		var img = karelImages[direction];
		var x = karelWorld.getLeft() + xIndex * KAREL_SIZE;
		var y = karelWorld.getTop() + yIndex * KAREL_SIZE;

		//draw karel one pixel smaller on all sides
		c.drawImage(img,x+1, y+1, KAREL_SIZE-2, KAREL_SIZE-2);
	}

	this.reset = function(row, col) {
		xIndex = col;
		yIndex = row;
		direction = KAREL_EAST;

		actionBuffer = new Array();
		actionIndex = 0;

		virtualX = xIndex;
		virtualY = yIndex;
		virtualDirection = direction;
	}

	this.frontIsClear = function() {
		var newX = virtualX;
		var newY = virtualY;
		switch(virtualDirection) {
			case KAREL_EAST: newX = newX + 1; break;
			case KAREL_WEST: newX = newX - 1; break;
			case KAREL_NORTH: newY = newY - 1; break;
			case KAREL_SOUTH: newY = newY + 1; break;
			default: alert("invalid direction"); break;
		}
		return karelWorld.isMoveValid(virtualX, virtualY, newX, newY);
	}

	this.beeperPresent = function() {
		return karelWorld.virtualBeeperPresent(virtualY, virtualX);
	}

	this.move = function() {
		var newX = virtualX;
		var newY = virtualY;
		switch(virtualDirection) {
			case KAREL_EAST: newX = newX + 1; break;
			case KAREL_WEST: newX = newX - 1; break;
			case KAREL_NORTH: newY = newY - 1; break;
			case KAREL_SOUTH: newY = newY + 1; break;
			default: alert("invalid direction"); break;
		}
		virtualX = newX;
		virtualY = newY;
		addToActionBuffer(MOVE);
	}

	this.turnLeft = function() {
		var newD = virtualDirection;
		switch(virtualDirection) {
			case KAREL_EAST:  newD = KAREL_NORTH; break;
			case KAREL_WEST:  newD = KAREL_SOUTH; break;
			case KAREL_NORTH: newD = KAREL_WEST; break;
			case KAREL_SOUTH: newD = KAREL_EAST; break;
			default: alert("invalid direction"); break;
		}
		virtualDirection = newD;
		addToActionBuffer(TURN_LEFT);
	}

	this.turnRight = function() {
		var newD = virtualDirection;
		switch(virtualDirection) {
			case KAREL_EAST:  newD = KAREL_SOUTH; break;
			case KAREL_WEST:  newD = KAREL_NORTH; break;
			case KAREL_NORTH: newD = KAREL_EAST; break;
			case KAREL_SOUTH: newD = KAREL_WEST; break;
			default: alert("invalid direction"); break;
		}
		virtualDirection = newD;
		addToActionBuffer(TURN_RIGHT);
	}

	this.putBeeper = function() {
		karelWorld.putVirtualBeeper(virtualY, virtualX);
		addToActionBuffer(PUT_BEEPER);
	}

	this.pickBeeper = function() {
		karelWorld.pickVirtualBeeper(virtualY, virtualX);
		addToActionBuffer(PICK_BEEPER);
	}

	this.executeNextAction = function() {

		if (actionIndex >= actionBuffer.length || actionIndex == -1) {
			return false;
		}
		if (actionIndex == MAX_ACTIONS) {
			alert("karel has executed "+MAX_ACTIONS+" "+
			 	"commands and appears to be in an " +
				"infinite loop.");
			error();
		}

		var action = actionBuffer[actionIndex];
		actionIndex = actionIndex + 1;

		switch(action) {
			case MOVE: executeMove(); break;
			case TURN_LEFT: executeTurnLeft(); break;
			case TURN_RIGHT: executeTurnRight(); break;
			case PUT_BEEPER: executePutBeeper(); break;
			case PICK_BEEPER: executePickBeeper(); break;
			default: alert("invalid action"); break;
		}

		return true;

	}

	function addToActionBuffer(action) {
		if (actionBuffer.length > MAX_ACTIONS) {
			throw("infinite loop");
		}
		actionBuffer.push(action);
	}

	function executePutBeeper() {
		karelWorld.putBeeper(yIndex, xIndex);
	}

	function executePickBeeper() {
		if (!karelWorld.beeperPresent(yIndex, xIndex)) {
			alert("no beepers present");
			error();
		} else {
			karelWorld.pickBeeper(yIndex, xIndex);
		}
	}

	function executeTurnLeft() {
		var newD = direction;
		switch(direction) {
			case KAREL_EAST:  newD = KAREL_NORTH; break;
			case KAREL_WEST:  newD = KAREL_SOUTH; break;
			case KAREL_NORTH: newD = KAREL_WEST; break;
			case KAREL_SOUTH: newD = KAREL_EAST; break;
			default: alert("invalid direction"); break;
		}
		direction = newD;
	}

	function executeMove() {
		var newX = xIndex;
		var newY = yIndex;
		switch(direction) {
			case KAREL_EAST: newX = newX + 1; break;
			case KAREL_WEST: newX = newX - 1; break;
			case KAREL_NORTH: newY = newY - 1; break;
			case KAREL_SOUTH: newY = newY + 1; break;
			default: alert("invalid direction"); break;
		}
		if (karelWorld.isMoveValid(xIndex, yIndex, newX, newY)) {
			xIndex = newX;
			yIndex = newY;
		} else {
			alert("karel blocked");
			error();
		}
	}

	function executeTurnRight() {
		var newD = direction;
		switch(direction) {
			case KAREL_EAST:  newD = KAREL_SOUTH; break;
			case KAREL_WEST:  newD = KAREL_NORTH; break;
			case KAREL_NORTH: newD = KAREL_EAST; break;
			case KAREL_SOUTH: newD = KAREL_WEST; break;
			default: alert("invalid direction"); break;
		}
		direction = newD;
	}

	function error() {
		actionBuffer = new Array();
		actionIndex = -1;
	}
}




