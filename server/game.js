console.log('game.js loaded');

/* players health
 * experience
 * bonus: powerups (emp, mines, nukes)
 */

// Player "class"

module.exports = {
	
	players: [],
	
	playerFactory: function(name, health, experience){
		
		return {
			name: name, 
			health: health,
			experience: experience,
			display: function(){
					   
				console.log(this.name+ " , has " + this.health + " and " + this.experience + " experience.");
	    
		    };
		};
	};
}


// if you want to create new player,
// var player1 = playerFactory(some name, some health, some exp);

//to display the player
//player1.display();