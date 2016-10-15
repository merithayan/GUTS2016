console.log('game.js loaded');

/* players health
 * experience
 * bonus: powerups (emp, mines, nukes)
 */

// Player "class"

module.exports = {
	
	players: [],
	defaultHealth: 3,
	defaultExperience: 0,
	
	playerFactory: function(id, name, health, experience) {
	
		var temp = {};
	
		temp.id = id;
		temp.name = name;
		temp.health = health;
		temp.experience = experience;
	    
		temp.display = function(){	   
		    console.log(this.name+ " , has " + this.health + " and " + this.experience + " experience.");
		};
		
		return {
			id: temp.id,
			name: temp.name, 
			health: temp.health,
			experience: temp.experience,
			display: temp.display
		}

	}

}


// if you want to create new player,
// var player1 = playerFactory(some name, some health, some exp);

//to display the player
//player1.display();