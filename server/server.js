const WebSocket = require('ws');
const GameState = require('./gamestate');
const Trap = require('./trap');

const wss = new WebSocket.Server({
	port: 8080
});

const state = new GameState(wss);

wss.on('connection', function connection(ws, req) {
	let player;
	ws.on('message', (message) => {
		let json;
		try {
			json = JSON.parse(message);
		} catch (e) {
			console.error(e);
			console.error(message);
		}
		switch (json.type) {
			case "player_move":
				state.players[json.id].position = json.position;
				wss.clients.forEach(c => {
					if (c != ws) {
						c.send(JSON.stringify({
							type: "update_player_pos",
							id: player.id,
							position: json.position
						}));
					}
				});
				break;
				case "player_damage":
					state.players[json.id].health = json.health;
					wss.clients.forEach(c => {
						if (c != ws) {
							c.send(JSON.stringify({
								type: "update_player_health",
								id: player.id,
								health: json.health
							}));
						}
					});
					break;
			case "player_dash":
					wss.clients.forEach(c => {
						if (c != ws) {
							c.send(JSON.stringify({
								type: "player_dash",
								id: json.id,
								direction: json.direction
							}));
						}
					});
					break;
			case "add_trap":
				let trap = new Trap(json.trap_type);
				trap.position = json.position;
				trap.expiry = json.expiry;
				state.addTrap(trap);
				wss.clients.forEach(c => {
					if (c != ws) {
						c.send(JSON.stringify({
							type: "add_trap",
							id: trap.id,
							position: trap.position,
							trap_type: trap.type
						}));
					}
				});
		}
	});
	if (req.url === '/vr') {
		ws.send(JSON.stringify(Object.assign(state.getState(), {
			type: "initialize"
		})));
	} else {
		ws.on('close', () => {
			state.removePlayer(player);
		});

		player = state.addPlayer();

		wss.clients.forEach(c => {
			if (c != ws) {
				c.send(JSON.stringify({
					type: "add_player",
					id: player.id,
					health: player.health,
					position: player.position,
					color: player.color
				}));
			}
		});
		ws.send(JSON.stringify(Object.assign(state.getState(), {
			type: "initialize"
		})));

		ws.send(JSON.stringify({
			type: "set_player_local",
			id: player.id
		}));
	}
});
console.log("started");