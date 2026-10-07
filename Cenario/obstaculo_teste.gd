extends Node2D

@export_category("Dano Ataques")
@export var dano_ataque_neutro: float
@export var dano_ataque_1: float
@export var dano_ataque_2: float
@export var dano_ataque_3: float
@export var dano_ataque_4: float

@export var tipo_ataque:int

@export_category("Knockback")
@export var knockback_ataque_neutro: float = 500.0
@export var knockback_ataque_1: float = 700.0
@export var knockback_ataque_2: float = 900.0
@export var knockback_ataque_3: float = 500.0
@export var knockback_ataque_4: float = 500.0
@export var direcao_knockback: Vector2 = Vector2.LEFT	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Ataque_neutro") or area.is_in_group("Ataque_especial")):
		print("Obstáculo atingido por: ", area.name)
		queue_free()
