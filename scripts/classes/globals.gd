extends Node

var ACTION_DATABASE: Dictionary[String, Action] = {
	# light action
	"PROBE": Action.new(
		"PROBE",
		1,
		Enums.ActionWeight.Light,
		Enums.ActionType.Strike,
		1,
		2,
		Enums.Stance.Guard,
		"Your blade flicks forward, connecting with a sharp *tap*. Annoying. Persistent.",
		"You overcommit the probe—they see it coming and slip past.",
	),
	"POKE": Action.new(
		"POKE",
		2,
		Enums.ActionWeight.Light,
		Enums.ActionType.Thrust,
		1,
		2,
		Enums.Stance.Flow,
		"The point slides past their defense—a small puncture, barely bleeding. Maddening.",
		"They pivot and your thrust passes harmlessly into air.",
	),
	# medium action
	"SLASH": Action.new(
		"SLASH",
		0,
		Enums.ActionWeight.Medium,
		Enums.ActionType.Strike,
		3,
		4,
		Enums.Stance.Pressure,
		"Your blade cuts a gleaming arc—they barely turn away in time. Blood trails down their arm. *Real*.",
		"You overextend. Your whole side is open."
	),
	# heavy
	"CLEAVE": Action.new("CLEAVE",
		-1,
		Enums.ActionWeight.Heavy,
		Enums.ActionType.Strike,
		5,
		6,
		Enums.Stance.Exposed,
		"Your blade *screams* through the air. They barely get their guard up in time—their arm buckles. A wound opens.",
		"Overcommitted. Completely exposed. This will haunt you."
	),
	"EXECUTE": Action.new(
		"EXECUTE",
		0,
		Enums.ActionWeight.Heavy,
		Enums.ActionType.Thrust,
		6,
		7,
		Enums.Stance.Exposed,
		"You drive your blade deep. The world goes quiet. They fall.",
		"They twist—your killing blow glances off. You've given everything and gotten nothing."
	),
	# setup
	# combination
}