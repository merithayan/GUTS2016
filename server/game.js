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

	playerFactory: function(id, name, health, lat, lng, experience) {
		return {
			id: id,
			name: name,
			health: health,
			lat: lat,
			lng: lng,
			experience: experience,
			display: function(){
				console.log(this.name, "LAT", this.lat, "LNG", this.lng);
		    }
		}
	}
}

// if you want to create new player,
// var player1 = playerFactory(some name, some health, some exp);
