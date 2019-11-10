module.exports = class Enemy {
	constructor(spawnPoints) {
		this.position = spawnPoints[Math.floor(Math.random() * spawnPoints.length)];
		this.id;
	}

	getState() {
		return {
			position: this.position,
			id: this.id
		};
	}
}