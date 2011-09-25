

// Beepers class
function Beepers(rows, cols, left, top) {

	var BEEPER_SIZE = 30;

	var beeperImage = new Image();
	beeperImage.src = "/images/beeper.png";

	var beepers = new Array();
	for (var i = 0; i < rows; i++) {
		beepers[i] = new Array();
		for (var j = 0; j < cols; j++) {
			beepers[i][j] = 0;
		}
	}

	this.draw = function(c) {
		c.fillStyle = "#000";
		c.font = "bold 14px courier";
		c.textAlign = "center";
		c.textBaseline = "middle";


		for (var rIndex = 0; rIndex < rows; rIndex++) {
			for (var cIndex = 0; cIndex < cols; cIndex++) {

				var numBeepers = beepers[rIndex][cIndex];

				if (numBeepers > 0) {
					var x = left + cIndex * KAREL_SIZE + (KAREL_SIZE - BEEPER_SIZE)/2;
					var y = top + rIndex * KAREL_SIZE + (KAREL_SIZE - BEEPER_SIZE)/2;
					c.drawImage(beeperImage, x, y, BEEPER_SIZE, BEEPER_SIZE);
				}

				if (numBeepers > 1) {
					var strWidth = c.measureText(""+numBeepers);
					var strHeight = 12;
					var x = left + cIndex * KAREL_SIZE + (KAREL_SIZE)/2;
					var y = top + rIndex * KAREL_SIZE + (KAREL_SIZE)/2;
					c.fillText(""+numBeepers, x, y);
				}
			}
		}
	}

	this.beeperPresent = function(r, c) {
		return beepers[r][c] > 0;
	}

	this.putBeeper = function(r, c) {
		beepers[r][c] = beepers[r][c] + 1;
	}

	this.pickBeeper = function(r, c) {
		beepers[r][c] = beepers[r][c] - 1;
	}
}


