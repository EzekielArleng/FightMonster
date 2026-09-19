extends Node2D

@export_category("Dano Ataques")
@export var dano_ataque_neutro: float
@export var dano_ataque_1: float
@export var dano_ataque_2: float
@export var dano_ataque_3: float
@export var dano_ataque_4: float

@export var tipo_ataque:int

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Ataque_neutro") or area.is_in_group("Ataque_especial")):
		print("Obstáculo atingido por: ", area.name)
		queue_free()
