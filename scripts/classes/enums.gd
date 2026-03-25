extends RefCounted

class_name Enums
enum EmotionType { Fear, Frustration }
enum HealthStatus { Healthy, LightBruised, ModerateBruised, HeavyBruised, Wounded, Dying, Dead }

static func worsen_health_status(current_status: HealthStatus, hit: bool) -> HealthStatus:

	if not hit:
		match current_status:
			HealthStatus.Healthy: return HealthStatus.LightBruised
			HealthStatus.LightBruised: return HealthStatus.ModerateBruised
			HealthStatus.ModerateBruised: return HealthStatus.HeavyBruised
			HealthStatus.HeavyBruised: return HealthStatus.Wounded
			HealthStatus.Wounded: return HealthStatus.Dying
			HealthStatus.Dying: return HealthStatus.Dead
			HealthStatus.Dead: return HealthStatus.Dead
	else:
		match current_status:
			HealthStatus.Healthy: return HealthStatus.Wounded
			HealthStatus.LightBruised: return HealthStatus.Wounded
			HealthStatus.ModerateBruised: return HealthStatus.Wounded
			HealthStatus.HeavyBruised: return HealthStatus.Dying
			HealthStatus.Wounded: return HealthStatus.Dying
			HealthStatus.Dying: return HealthStatus.Dead
			HealthStatus.Dead: return HealthStatus.Dead

	return HealthStatus.Healthy

static func health_to_str(status: HealthStatus) -> String:
	match status:
		HealthStatus.Healthy: return "Healthy"
		HealthStatus.LightBruised: return "LBruised"
		HealthStatus.ModerateBruised: return "MBruised"
		HealthStatus.HeavyBruised: return "HBruised"
		HealthStatus.Wounded: return "Wounded"
		HealthStatus.Dying: return "Dying"
		HealthStatus.Dead: return "Dead"
	return ""

static func health_to_des(status: HealthStatus) -> String:
	match status:
		HealthStatus.Healthy: return "healthy"
		HealthStatus.LightBruised: return "lightly bruised"
		HealthStatus.ModerateBruised: return "moderately bruised"
		HealthStatus.HeavyBruised: return "heavily bruised"
		HealthStatus.Wounded: return "wounded"
		HealthStatus.Dying: return "dying"
		HealthStatus.Dead: return "dead"
	return ""

enum ActionWeight { Light, Medium, Heavy }
enum ActionType { Strike, Thrust }
enum Stance { Pressure, Guard, Flow, Exposed }

static func stance_to_str(stance: Stance) -> String:
	match stance:
		Stance.Pressure: return "Pressure"
		Stance.Guard: return "Guard"
		Stance.Flow: return "Flow"
		Stance.Exposed: return "Exposed"
	return ""

static func stance_to_des(stance: Stance) -> String:
	match stance:
		Stance.Pressure: return "aggressive, pressing forward"
		Stance.Guard: return "solid guard"
		Stance.Flow: return "moving fluidly"
		Stance.Exposed: return "disoriented"
	return ""

static func get_stance_modifier(stance: Stance) -> int:
	match stance:
		Stance.Pressure: return 2
		Stance.Guard: return 0
		Stance.Flow: return -1
		Stance.Exposed: return -3
	return 0
	
enum Outcome { Hit, Bruised, Blocked, Parried, Fumbled, Dodged, Miss }

static func outcome_to_str(outcome: Outcome) -> String:
	match outcome:
		Outcome.Hit: return "Hit"
		Outcome.Bruised: return "Bruised"
		Outcome.Blocked: return "Blocked"
		Outcome.Parried: return "Parried"
		Outcome.Fumbled: return "Fumbled"
		Outcome.Dodged: return "Dodged"
		Outcome.Miss: return "Miss"
	return ""

static func outcome_to_desc(outcome: Outcome) -> String:
	match outcome:
		Outcome.Hit: return " is badly wounded."
		Outcome.Bruised: return " is bruised and shaken."
		Outcome.Blocked: return " blocks."
		Outcome.Parried: return " parries effectively."
		Outcome.Fumbled: return " connects but was too weak to do anything."
		Outcome.Dodged: return " dodges."
		Outcome.Miss: return " misses."
	return ""

static func get_worst_outcome(outcome: Outcome) -> Outcome:
	match outcome:
		Outcome.Hit: return Outcome.Hit
		Outcome.Bruised: return Outcome.Hit
		Outcome.Blocked: return Outcome.Bruised
		Outcome.Parried: return Outcome.Blocked
		Outcome.Fumbled: return Outcome.Bruised
		Outcome.Dodged: return Outcome.Fumbled
		Outcome.Miss: return Outcome.Fumbled
	return Outcome.Miss

static func alertness_to_des(alertness: int) -> String:
	if alertness >= 80: return "Sharp, eyes tracking"
	elif alertness >= 60: return "Focused"
	elif alertness >= 40: return "Wearing down, breathing harder"
	elif alertness >= 20: return "Desperate, movements sluggish"
	else: return "Shattered, barely standing"

static func get_outcome(stance: Stance, modifier: int) -> Outcome:
	match stance:
		Stance.Guard:
			if modifier >= 2:
				return Outcome.Hit
			if modifier >= 0:
				return Outcome.Bruised
			if modifier >= -1:
				return Outcome.Blocked
			if modifier >= -2:
				return Outcome.Fumbled
			return Outcome.Miss
		Stance.Flow:
			if modifier >= 2:
				return Outcome.Hit
			if modifier >= 1:
				return Outcome.Bruised
			if modifier >= 0:
				return Outcome.Fumbled
			if modifier >= -1:
				return Outcome.Dodged
			return Outcome.Miss
		Stance.Pressure:
			if modifier >= 2:
				return Outcome.Hit
			if modifier >= 1:
				return Outcome.Bruised
			if modifier >= 0:
				return Outcome.Blocked
			if modifier >= -1:
				return Outcome.Parried
			if modifier >= -2:
				return Outcome.Fumbled
			return Outcome.Miss
		Stance.Exposed:
			if modifier >= 0:
				return Outcome.Hit
			if modifier >= -2:
				return Outcome.Bruised
			if modifier >= -3:
				return Outcome.Fumbled
			return Outcome.Miss
		
	return Outcome.Miss

static func get_contact_modifier(type: ActionType, stance: Stance) -> int:
	match type:
		ActionType.Strike:
			match stance:
				Stance.Guard:
					return -1
				Stance.Flow:
					return -1
				Stance.Pressure:
					return 0
				Stance.Exposed:
					return +2
		ActionType.Thrust:
			match stance:
				Stance.Guard:
					return -1
				Stance.Flow:
					return +1
				Stance.Pressure:
					return -1
				Stance.Exposed:
					return +2
	return 0

static func is_weapon_contact(outcome: Outcome) -> bool:
	match outcome:
		Outcome.Hit: return true
		Outcome.Bruised: return true
		Outcome.Blocked: return true
		Outcome.Parried: return true
		Outcome.Fumbled: return true
		Outcome.Dodged: return false
		Outcome.Miss: return false
	return false

static func is_contact(outcome: Outcome) -> bool:
	match outcome:
		Outcome.Hit: return true
		Outcome.Bruised: return true
		Outcome.Blocked: return true
		Outcome.Parried: return true
		Outcome.Fumbled: return true
		Outcome.Dodged: return false
		Outcome.Miss: return false
	return false

static func get_alertness_drain_for_attacker(outcome: Outcome, weight: ActionWeight) -> int:
	if weight == ActionWeight.Heavy:
		if is_weapon_contact(outcome):
			return 10
		else:
			return 15
	return 0

static func get_alertness_drain_for_defender(outcome: Outcome, weight: ActionWeight) -> int:
 
	match weight:
		ActionWeight.Light:
			if is_contact(outcome):
				return 5
			else:
				return 2
		ActionWeight.Medium:
			if is_contact(outcome):
				return 10
			else:
				return 7
		ActionWeight.Heavy:
			if is_contact(outcome):
				return 20
			else:
				return 10
		
	return 0