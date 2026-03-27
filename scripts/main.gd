extends Node2D

@onready var player_actions_node = $"CanvasLayer/MarginContainer/HBoxContainer/LeftContainer/SlotActionController"
var player = Combatant.new("player")
var opponent = Combatant.new("opponent")

func _ready() -> void:
	UIManager.ready()

func resolve_turn() -> void:

	var player_actions: Array[String] = player_actions_node.selected_actions
	# validate actions
	for slot in range(3):
		if player_actions[slot] == "empty":
			UIManager.error_combat_log()
			return

	var opponent_actions: Array[String] = Globals.OPPONENTS[Globals.opponent_id].strategy

	# Phase 1: Resolve each action slot
	for slot in range(3):
		if player.is_dead() or opponent.is_dead():
			break
		resolve_action_slot(player_actions[slot], opponent_actions[slot], slot)
		await get_tree().create_timer(1.0).timeout
	
	# Phase 2: Stamina recovery
	player.stamina = 10
	opponent.stamina = 10

	# Phase 3: Passive alertness recovery
	player.alertness = min(100, player.alertness + 5)
	opponent.alertness = min(100, opponent.alertness + 5)
	
	# Phase 4: Emotional state decay
	player.emotional_states[Enums.EmotionType.Frustration] = max(0, player.emotional_states[Enums.EmotionType.Frustration] - 1)
	player.emotional_states[Enums.EmotionType.Fear] = max(0, player.emotional_states[Enums.EmotionType.Fear] - 1)
	opponent.emotional_states[Enums.EmotionType.Frustration] = max(0, opponent.emotional_states[Enums.EmotionType.Frustration] - 1)
	opponent.emotional_states[Enums.EmotionType.Fear] = max(0, opponent.emotional_states[Enums.EmotionType.Fear] - 1)

func resolve_action_slot(
	player_action_name: String,
	opponent_action_name: String,
	slot: int
) -> void:
	
	var action_log := ActionLog.new()

	# Retrieve action data
	var player_action: Action = Globals.ACTION_DATABASE[player_action_name]
	var opponent_action: Action = Globals.ACTION_DATABASE[opponent_action_name]

	# Step 0: Return into default stance if was forced to expose
	if player.is_force_exposed:
		player.is_force_exposed = false
		player.stance = Enums.Stance.Guard
	if opponent.is_force_exposed:
		opponent.is_force_exposed = false
		opponent.stance = Enums.Stance.Guard
	
	# Step 1: Calculate modified initiative
	var pass_turn: bool = false
	var player_init = player_action.base_initiative + Enums.get_stance_modifier(player.stance) + get_emotional_modifier(player)
	var opponent_init = opponent_action.base_initiative + Enums.get_stance_modifier(opponent.stance) + get_emotional_modifier(opponent)
	
	# Step 2: Determine who acts first
	var acts_first: Combatant
	var acts_second: Combatant
	var acts_first_action: Action
	var acts_second_action: Action
	var acts_first_init: int
	var acts_second_init: int

	if player_init >= opponent_init:
		acts_first = player
		acts_second = opponent
		acts_first_action = player_action
		acts_second_action = opponent_action
		acts_first_init = player_init
		acts_second_init = opponent_init
		if player_init > 4 + opponent_init:
			pass_turn = true
			acts_second.stance = Enums.Stance.Exposed
			acts_second.is_force_exposed = true
	else:
		acts_first = opponent
		acts_second = player
		acts_first_action = opponent_action
		acts_second_action = player_action
		acts_first_init = opponent_init
		acts_second_init = player_init
		if player_init > 4 + opponent_init:
			pass_turn = true
			acts_second.stance = Enums.Stance.Exposed
			acts_second.is_force_exposed = true
	
	# Step 3: Resolve actors
	resolve_action_execution(
		acts_first_action,
		acts_first,
		acts_second,
		action_log.first
	)
	
	# log info
	action_log.first.attacker_name = acts_first.name
	action_log.first.defender_name = acts_second.name
	action_log.first.action = acts_first_action.name

	action_log.first.summary.attacker_init = acts_first_init
	action_log.first.summary.defender_init = acts_second_init
	action_log.first.summary.attacker_stamina = acts_first.stamina
	action_log.first.summary.defender_stamina = acts_second.stamina
	action_log.first.summary.attacker_stance = acts_first.stance
	action_log.first.summary.defender_stance = acts_second.stance
	action_log.first.summary.attacker_health = acts_first.health_states
	action_log.first.summary.defender_health = acts_second.health_states
	action_log.first.summary.attacker_alertness =  acts_first.alertness
	action_log.first.summary.defender_alertness =  acts_second.alertness

	if not pass_turn and not acts_second.is_dead():
		resolve_action_execution(
			acts_second_action,
			acts_second,
			acts_first,
			action_log.second
		)

	action_log.second.attacker_name = acts_second.name
	action_log.second.defender_name = acts_first.name
	action_log.second.action = "DEAD" if acts_second.is_dead() else "TURN PASSED" if pass_turn else acts_second_action.name

	action_log.second.summary.attacker_init = acts_second_init
	action_log.second.summary.defender_init = acts_first_init
	action_log.second.summary.attacker_stamina = acts_second.stamina
	action_log.second.summary.defender_stamina = acts_first.stamina
	action_log.second.summary.attacker_stance = acts_second.stance
	action_log.second.summary.defender_stance = acts_first.stance
	action_log.second.summary.attacker_health = acts_second.health_states
	action_log.second.summary.defender_health = acts_first.health_states
	action_log.second.summary.attacker_alertness =  acts_second.alertness
	action_log.second.summary.defender_alertness =  acts_first.alertness

	UIManager.update_combat_log(action_log.combatlog_to_str())
	UIManager.update_player_log(action_log.combatantlog_to_str("player"))
	UIManager.update_opponent_log(action_log.combatantlog_to_str("opponent"))
	UIManager.update_player_stance(action_log.stancelog_to_str("player"))
	UIManager.update_opponent_stance(action_log.stancelog_to_str("opponent"))

func resolve_action_execution(
	action: Action,
	attacker: Combatant,
	defender: Combatant,
	exe_log: ActionLog.ExecutionLog,
) -> void:

	exe_log.contact_details = ""

	# Check stamina
	if attacker.stamina < action.stamina_cost_hit:
		attacker.stance = Enums.Stance.Exposed
		attacker.stamina = 0
		exe_log.contact_details = "NO STAMINA"
		attacker.is_force_exposed = true
		return
	
	# Determine outcome vs defender's stance
	var outcome: Enums.Outcome = resolve_contact(
		action,
		defender.alertness,
		defender.stance,
		exe_log
	)
	
	# Apply outcome-based effects
	apply_outcome(attacker, defender, action, outcome)
	
	# Stance change (always applies after action)
	attacker.stance = action.new_stance
	
	# Emotional state effects
	if Enums.EmotionType.Frustration in action.buildup:
		defender.emotional_states[Enums.EmotionType.Frustration] += action.buildup[Enums.EmotionType.Frustration]
	elif Enums.EmotionType.Fear in action.buildup:
		defender.emotional_states[Enums.EmotionType.Fear] += action.buildup[Enums.EmotionType.Fear]

func resolve_contact(
	attacking_action: Action,
	defender_alertness: int,
	defending_stance: Enums.Stance,
	contact_log: ActionLog.ExecutionLog
) -> Enums.Outcome:
	
	# Modify based on defender's alertness
	var defender_modifier = get_defense_effectiveness(
		defender_alertness,
	)

	var contact_modifier = Enums.get_contact_modifier(
		attacking_action.attack_type,
		defending_stance,
	)

	var outcome = Enums.get_outcome(defending_stance, defender_modifier + contact_modifier)
	contact_log.outcome = outcome
	
	return outcome

func apply_outcome(
	attacker: Combatant,
	defender: Combatant,
	action: Action,
	outcome: Enums.Outcome
):
	attacker.alertness -= Enums.get_alertness_drain_for_attacker(outcome, action.weight)
	defender.alertness -= Enums.get_alertness_drain_for_defender(outcome, action.weight)

	var contact = Enums.is_contact(outcome)
	var damaging = Enums.is_damaging_health(outcome)
	if contact:
		attacker.stamina -= action.stamina_cost_hit
		if damaging:
			defender.health_states = Enums.worsen_health_status(defender.health_states, outcome == Enums.Outcome.Hit)
	else:
		attacker.stamina -= action.stamina_cost_miss

func get_emotional_modifier(stance) -> int:
	return 0

func get_defense_effectiveness(
	alertness: int,
) -> int:

	if alertness >= 80:
		return -2
	elif alertness >= 60:
		return -1
	elif alertness >= 40:
		return 0
	elif alertness >= 20:
		return +1
	else:
		return +2
	
func get_wrong_stance_chance(alertness) -> float:
	if alertness >= 80: return 0.0
	elif alertness >= 60: return 0.1
	elif alertness >= 40: return 0.35
	elif alertness >= 20: return 0.65
	else: return 0.85

func get_feint_success_rate(alertness) -> float:
	if alertness >= 80: return 0.0
	elif alertness >= 60: return 0.2
	elif alertness >= 40: return 0.6
	elif alertness >= 20: return 0.85
	else: return 0.95

func describe_opponent_state(actor: Combatant) -> String:
	var desc = Enums.stance_to_des(actor.stance)
	
	if actor.emotional_states[Enums.EmotionType.Fear] > 0:
		desc += ", frightened"
	if actor.emotional_states[Enums.EmotionType.Frustration] > 0:
		desc += ", frustrated"
	
	return desc
