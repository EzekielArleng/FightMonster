extends Node2D

@onready var spawn_p1: Marker2D = $SpawnP1
@onready var spawn_p2: Marker2D = $SpawnP2

func _ready() -> void:
	_criar_jogador(1, spawn_p1)
	_criar_jogador(2, spawn_p2)

# Instancia o personagem que o jogador escolheu na tela de seleção
func _criar_jogador(jogador: int, spawn: Marker2D) -> void:
	var cena: PackedScene = Partida.obter_cena(jogador)
	var personagem := cena.instantiate() as Personagem

	# Define o jogador ANTES do add_child, pois o personagem usa isso para ler o input (acao())
	personagem.jogador = jogador
	personagem.position = spawn.position
	add_child(personagem)

	# Mantém a ordem de desenho de antes (atrás do obstáculo)
	move_child(personagem, jogador - 1)
