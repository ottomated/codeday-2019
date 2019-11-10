const Player = require('./player');
const Enemy = require('./enemy');

module.exports = class GameState {
	constructor(ws) {
		this.ws = ws;
		this.players = [];
		this.traps = [];
		this.enemies = [];
		this.seed = new Date().getTime();
		this.nextPlayerColor = 0;
		this.nextId = 0;
		this.nextTrapId = 0;
		this.nextEnemyId = 0;
		this.spawnPoints = [[32, 32]];
	}

	getState() {
		return {
			players: this.players.map(p => p.getState()).filter(s => s),
			traps: this.traps.map(t => t.getState()).filter(s => s),
			seed: this.seed
		};
	}

	addTrap(trap) {
		trap.id = this.nextTrapId;
		this.nextTrapId++;
		this.traps.push(trap);
		setTimeout(() => {
			delete this.traps[trap.id];
			this.ws.clients.forEach(c => c.send(JSON.stringify({
				type: "remove_trap",
				id: trap.id
			})));
		}, trap.expiry);
	}

	spawnEnemy() {
		let e = new Enemy(this.spawnPoints);
		e.id = this.nextEnemyId;
		this.nextEnemyId++;
		this.enemies.push(e);
		this.ws.clients.forEach(c => c.send(JSON.stringify({
			type: "add_enemy",
			id: e.id,
			position: e.position
		})));

	}

	removePlayer(player) {
		delete this.players[player.id];
		this.ws.clients.forEach(c => c.send(JSON.stringify({
			type: "remove_player",
			id: player.id
		})));
	}

	removeEnemy(id) {
		delete this.enemies[id];
		this.ws.clients.forEach(c => c.send(JSON.stringify({
			type: "remove_enemy",
			id: id
		})));
	}

	addPlayer() {
		let player = new Player(this.spawnPoints);
		player.id = this.nextId;
		this.nextId++;
		player.color = hslToRgb(this.nextPlayerColor / 360, .7, .7);
		this.nextPlayerColor += 137.5;
		this.nextPlayerColor %= 360;
		this.players.push(player);
		return player;
	}
}
function hslToRgb(h, s, l) {
	var r, g, b;

	if (s == 0) {
		r = g = b = l;
	} else {
		var hue2rgb = function hue2rgb(p, q, t) {
			if (t < 0) t += 1;
			if (t > 1) t -= 1;
			if (t < 1 / 6) return p + (q - p) * 6 * t;
			if (t < 1 / 2) return q;
			if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
			return p;
		}

		var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
		var p = 2 * l - q;
		r = hue2rgb(p, q, h + 1 / 3);
		g = hue2rgb(p, q, h);
		b = hue2rgb(p, q, h - 1 / 3);
	}

	return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
}