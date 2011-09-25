

// Karel Application class	
function KarelApplication(code, karel) {

	this.start = function() {
		try {
			eval(code);
			run();
		} catch(e) {
			alert(e);
		}
	}

	/*******************************
      *       PRE-DEFINED FUNCITONS *
      *******************************/

	function move() {
		karel.move();
	}

	function turnLeft() {
		karel.turnLeft();
	}

	function turnRight() {
		karel.turnRight();
	}

	function frontIsClear() {
		return karel.frontIsClear();
	}

	function putBeeper() {
		karel.putBeeper();
	}

	function pickBeeper() {
		karel.pickBeeper();
	}

	function beeperPresent() {
		return karel.beeperPresent();
	}

}
