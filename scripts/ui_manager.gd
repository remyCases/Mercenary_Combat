extends Node

var combat_log: CombatLog
var player_log: PlayerLog
var opponent_log: OpponentLog

var opponent_icon: OpponentIcon
var opponent_name: OpponentName
var opponent_action_display: OpponentActionDisplay

func ready() -> void:
	combat_log = get_tree().root.find_child("CombatLog", true, false)
	if not combat_log:
		push_error("CombatLog not found in scene tree")
	
	player_log = get_tree().root.find_child("PlayerLog", true, false)
	if not player_log:
		push_error("PlayerLog not found in scene tree")
	
	opponent_log = get_tree().root.find_child("OpponentLog", true, false)
	if not opponent_log:
		push_error("OpponentLog not found in scene tree")	
		
	opponent_icon = get_tree().root.find_child("OpponentIcon", true, false)
	if not opponent_icon:
		push_error("OpponentIcon not found in scene tree")
	opponent_icon.texture = Globals.OPPONENTS[Globals.opponent_id].icon
		
	opponent_name = get_tree().root.find_child("OpponentName", true, false)
	if not opponent_name:
		push_error("OpponentName not found in scene tree")
	opponent_name.text = Globals.opponent_id

	opponent_action_display = get_tree().root.find_child("OpponentActionDisplay", true, false)
	if not opponent_action_display:
		push_error("OpponentActionDisplay not found in scene tree")
	
	reset()

func update_combat_log(str_log: String) -> void:
	combat_log.text += str_log

func error_combat_log() -> void:
	combat_log.text = "Select 3 moves on the left"

func update_player_log(str_log: String) -> void:
	player_log.text = str_log
	
func update_opponent_log(str_log: String) -> void:
	opponent_log.text = str_log

func reset() -> void:
	combat_log.text = ""
	player_log.text = ""
	opponent_log.text = ""
	opponent_action_display.text = Globals.OPPONENTS[Globals.opponent_id].strategy[0]
