
// Walls class	
function Walls(rows, cols, left, top) {

	var WALL_THICKNESS = 4;

	var topWalls = new Array();
	for (var i = 0; i < rows; i++) {
		topWalls[i] = new Array();
		for (var j = 0; j < cols; j++) {
			topWalls[i][j] = 0;
		}
	}

	var rightWalls = new Array();
	for (var i = 0; i < rows; i++) {
		rightWalls[i] = new Array();
		for (var j = 0; j < cols; j++) {
			rightWalls[i][j] = 0;
		}
	}

	this.draw = function(c) {

		for (var rIndex = 0; rIndex < rows; rIndex++) {
			for (var cIndex = 0; cIndex < cols; cIndex++) {

				if (topWalls[rIndex][cIndex] != 0) {
					var x = left + cIndex * KAREL_SIZE - WALL_THICKNESS/2;
					var y = top + rIndex * KAREL_SIZE - WALL_THICKNESS/2;

					c.fillStyle = "#000";
					c.fillRect(x, y, KAREL_SIZE + WALL_THICKNESS, WALL_THICKNESS);
				} 

				if (rightWalls[rIndex][cIndex] != 0) {
					var x = left + (cIndex + 1) * KAREL_SIZE - WALL_THICKNESS/2;
					var y = top + rIndex * KAREL_SIZE - WALL_THICKNESS/2;

					c.fillStyle = "#000";
					c.fillRect(x, y, WALL_THICKNESS, KAREL_SIZE + WALL_THICKNESS);
				} 
			}
		}
	}

	this.addTopWall = function(r, c) {
		topWalls[r][c] = 1;
	}

	this.addRightWall = function(r, c) {
		rightWalls[r][c] = 1;
	}

	this.rightWall = function(r, c) {
		return rightWalls[r][c] != 0;
	}

	this.topWall = function(r, c) {
		return topWalls[r][c] != 0;
	}

}
