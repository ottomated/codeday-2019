module.exports = class Player {
	constructor(spawnPoints) {
		this.position = spawnPoints[Math.floor(Math.random() * spawnPoints.length)].map(p => p * 64 + 32);
		this.color;
		this.id;
		this.health = 3;
	}

	getState() {
		return {
			id: this.id,
			position: this.position,
			color: this.color,
			health: this.health
		};
	}
}