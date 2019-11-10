module.exports = class Player {
	constructor() {
		this.position = [32, 32];
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