extends RefCounted

class_name ActionLog

var slot: int
var player_incorrect_choice: String
var opponent_incorrect_choice: String
var first: ExecutionLog
var second: ExecutionLog

class Summary:
	var attacker_init: int
	var defender_init: int
	var attacker_stamina: int
	var defender_stamina: int
	var attacker_stance: Enums.Stance
	var defender_stance: Enums.Stance
	var attacker_health: Enums.HealthStatus
	var defender_health: Enums.HealthStatus
	var attacker_alertness: int
	var defender_alertness: int

class ExecutionLog:
	var attacker_name: String
	var defender_name: String
	var action: String
	var outcome: Enums.Outcome
	var contact_details: String
	var outcome_details: String
	var summary: Summary
	
	func _init() -> void:
		summary = Summary.new()

	func execution_to_log(string_builder: String) -> String:
		if action == "DEAD":
			string_builder += "{name} died, {defender_name} won.\n".format({
				"name": attacker_name,
				"defender_name": defender_name,
			})
			return string_builder

		if action == "TURN PASSED":
			string_builder += "{name} was too slow to act, his turn is passed! Forced into Exhausted stance until next action.\n".format({
				"name": attacker_name,
			})
			return string_builder

		string_builder += "{name} acts using {action}\n".format({
			"name": attacker_name,
			"action": action
		});

		if contact_details == "NO STAMINA":
			string_builder += "{name} lack the stamina for {action}! Forced into Exhausted stance until next action.\n".format({
				"name": attacker_name,
				"action": action
			})
			return string_builder
		
		string_builder += "{defender_name} {outcome} {name}'s attack\n".format({
			"name": attacker_name,
			"defender_name": defender_name,
			"outcome": Enums.outcome_to_des(outcome),
		})
	
		#if modified_outcome != Enums.Outcome.Miss:
		#	string_builder += Globals.ACTION_DATABASE[action].flavor_hit + "\n"
		#else:
		#	string_builder += Globals.ACTION_DATABASE[action].flavor_miss + "\n"

		string_builder += "{name} shifts to {stance} stance.\n".format({
			"name": attacker_name,
			"stance": Enums.stance_to_str(summary.attacker_stance)
		})

		return string_builder

func _init() -> void:
	first = ExecutionLog.new()
	second = ExecutionLog.new()

func combatlog_to_str() -> String:

	var string_builder = ""

	#execution_log.append(defender.name + "'s frustration breaks their composure!")
	#execution_log.append(defender.name + " is terrified! They're barely standing.")

	# Invalid actions
	if player_incorrect_choice != "":
		string_builder += "ERROR: [Player's action {action} prerequisites not met. Action skipped.]".format({
			"action": player_incorrect_choice
		})
	if opponent_incorrect_choice != "":
		string_builder += "WARNING: [Opponent's action {action} not available. Falls back to SLASH.]".format({
			"action": opponent_incorrect_choice
		})

	# Acting first
	string_builder = first.execution_to_log(string_builder)
	string_builder += "\n"

	# Acting second
	string_builder = second.execution_to_log(string_builder)
	string_builder += "------\n"

	return string_builder


func combatantlog_to_str(actor: String) -> String:

	var string_builder = ""

	if second.attacker_name == actor:
		if second.summary.attacker_health == Enums.HealthStatus.Dead:
			string_builder += "Dead\n"
		else:
			string_builder += "{alertness}, {health}, {stance}\n".format({
				"alertness": Enums.alertness_to_des(second.summary.attacker_alertness),
				"health": Enums.health_to_des(second.summary.attacker_health),
				"stance": Enums.stance_to_des(second.summary.attacker_stance),
			})
	elif second.defender_name == actor:
		if second.summary.defender_health == Enums.HealthStatus.Dead:
			string_builder += "Dead\n"
		else:
			string_builder += "{alertness}, {health}, {stance}\n".format({
				"name": second.defender_name,
				"alertness": Enums.alertness_to_des(second.summary.defender_alertness),
				"health": Enums.health_to_des(second.summary.defender_health),
				"stance": Enums.stance_to_des(second.summary.defender_stance),
			})
	
	#if first.emotional_states[Enums.EmotionType.Fear] > 0:
	#	state_log.append("  [Frightened: " + str(player.emotional_states[Enums.EmotionType.Fear]) + "]")
	#if player.emotional_states[Enums.EmotionType.Frustration] > 0:
	#	state_log.append("  [Frustrated: " + str(player.emotional_states[Enums.EmotionType.Frustration]) + "]")

	return string_builder

func stancelog_to_str(actor: String) -> String:

	var string_builder = ""

	if second.attacker_name == actor:
		if second.summary.attacker_health == Enums.HealthStatus.Dead:
			string_builder = "Dead\n"
		else:
			string_builder = Enums.stance_to_str(second.summary.attacker_stance)
	elif second.defender_name == actor:
		if second.summary.defender_health == Enums.HealthStatus.Dead:
			string_builder += "Dead\n"
		else:
			string_builder = Enums.stance_to_str(second.summary.defender_stance)

	return string_builder

func debuglog_to_str() -> String:

	var string_builder = ""
	string_builder += "[name  ]:\t{aname}\t{dname}\n[initia]\t{ainitiative}\t{dinitiative}\n[stamin]\t{astamina}\t{dstamina}\n[altert]\t{aalertness}\t{dalertness}\n[health]\t{ahealth}\t{dhealth}\n[stance]\t{astance}\t{dstance}\n".format({
		"aname": first.attacker_name.substr(0, 6),
		"ainitiative": first.summary.attacker_init,
		"astamina": first.summary.attacker_stamina,
		"aalertness": first.summary.attacker_alertness,
		"ahealth": first.summary.attacker_health,
		"astance": first.summary.attacker_stance,
		"dname": first.defender_name.substr(0, 6),
		"dinitiative": first.summary.defender_init,
		"dstamina": first.summary.defender_stamina,
		"dalertness": first.summary.defender_alertness,
		"dhealth": first.summary.defender_health,
		"dstance": first.summary.defender_stance,
	})
	string_builder += "[name  ]:\t{aname}\t{dname}\n[initia]\t{ainitiative}\t{dinitiative}\n[stamin]\t{astamina}\t{dstamina}\n[altert]\t{aalertness}\t{dalertness}\n[health]\t{ahealth}\t{dhealth}\n[stance]\t{astance}\t{dstance}\n".format({
		"aname": second.attacker_name.substr(0, 6),
		"ainitiative": second.summary.attacker_init,
		"astamina": second.summary.attacker_stamina,
		"aalertness": second.summary.attacker_alertness,
		"ahealth": second.summary.attacker_health,
		"astance": second.summary.attacker_stance,
		"dname": second.defender_name.substr(0, 6),
		"dinitiative": second.summary.defender_init,
		"dstamina": second.summary.defender_stamina,
		"dalertness": second.summary.defender_alertness,
		"dhealth": second.summary.defender_health,
		"dstance": second.summary.defender_stance,
	})
	return string_builder