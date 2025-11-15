extends Node

var collected_artifacts: int = 0
var collected_coins: float = 0.0
var collected_orbs: float = 0.0

func _ready() -> void:
	collected_artifacts = 0
	collected_coins = 0
	collected_orbs = 0

func increment_value(variable, amount):
	variable += amount
