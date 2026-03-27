extends Node

var combat_log: Label

var player_log: Label
var player_stance: Label

var opponent_log: Label
var opponent_icon: TextureRect
var opponent_name: Label
var opponent_action_display: Label
var opponent_stance: Label

func get_component(component_name: String) -> Node:
	var node = get_tree().root.find_child(component_name, true, false)
	if not node:
		push_error("%s not found in scene tree" % component_name)
	return node

func ready() -> void:
	combat_log = get_component("CombatLog")

	player_log = get_component("PlayerLog")
	player_stance = get_component("PlayerStance")

	opponent_log = get_component("OpponentLog")	
	opponent_name = get_component("OpponentName")
	opponent_icon = get_component("OpponentIcon")
	opponent_action_display = get_component("OpponentActionDisplay")
	opponent_stance = get_component("OpponentStance")

	reset()

func update_combat_log(str_log: String) -> void:
	combat_log.text += str_log

func error_combat_log() -> void:
	combat_log.text = "Select 3 moves on the left"

func update_player_log(str_log: String) -> void:
	player_log.text = str_log

func update_player_stance(str_log: String) -> void:
	player_stance.text = str_log
	
func update_opponent_log(str_log: String) -> void:
	opponent_log.text = str_log

func predict_player_stance(actions: Array[String]) -> void:
	if not player_stance:
		return
	player_stance.text = "%s" % Enums.stance_to_str(Globals.GAME_STATE["player"].stance)
	for i in actions:
		if i == "" or i == "empty":
			return
		player_stance.text += " -> %s" % Enums.stance_to_str(Globals.ACTION_DATABASE[i].new_stance)
	
func predict_opponent_log(str_log: String) -> void:
	opponent_log.text = str_log

func update_opponent_stance(str_log: String) -> void:
	opponent_stance.text = str_log

func reset() -> void:
	combat_log.text = ""

	player_log.text = ""
	player_stance.text = ""

	opponent_log.text = ""
	opponent_name.text = Globals.opponent_id
	opponent_icon.texture = Globals.OPPONENTS[Globals.opponent_id].icon
	opponent_action_display.text = Globals.OPPONENTS[Globals.opponent_id].strategy[0]
	opponent_stance.text = ""
