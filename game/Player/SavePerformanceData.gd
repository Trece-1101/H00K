extends Resource

export var respawn_position: Vector2
export var last_state: String
export var current_room: String
export var current_room_version: int
export var current_level_name: String
export var current_level_number: int

export var total_death_count: int
export var levels_performance: Array
export var level_performance: Dictionary = {
	"level": "",
	"deaths": 0,
	"enter": 0,
	"exit": 0,
	"time": 0,
}
export var total_time_elapsed: int
export var total_rooms := 0
