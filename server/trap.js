module.exports = class Trap {
	constructor(type) {
		this.TYPES = ['wall', 'spike'];
		this.position = [0, 0];
		this.type = type;
		this.expiry;
		this.id;
	}

	getState() {
		return {
			position: this.position,
			trap_type: this.type,
			id: this.id
		};
	}
}