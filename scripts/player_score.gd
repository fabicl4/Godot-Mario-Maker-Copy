extends Node

var health_percentage : float
var score : int

func update_score(amount: int):
	score += amount
	print("Total score: " , score)

func update_health(percentage: float):
	health_percentage = percentage
