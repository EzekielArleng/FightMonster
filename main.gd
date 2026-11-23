extends Node2D

@onready var spawn_p1: Marker2D = $SpawnP1
@onready var spawn_p2: Marker2D = $SpawnP2
@onready var tela_final: TelaFinal = $FimLayer/TelaFinal

var personagens: Array[Personagem] = []
var luta_encerrada: bool = false

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
	personagens.append(personagem)
	personagem.morreu.connect(_on_personagem_morreu)

	# Mantém a ordem de desenho de antes (atrás do obstáculo)
	move_child(personagem, jogador - 1)

func _on_personagem_morreu(jogador_morto: int) -> void:
	# Se os dois morrerem no mesmo instante, vale só a primeira morte
	if (luta_encerrada):
		return
	luta_encerrada = true

	var vencedor: int = 2 if jogador_morto == 1 else 1

	# Congela quem sobrou para ninguém mais se mexer ou atacar atrás da tela final.
	# set_deferred porque a morte acontece dentro de uma colisão da física,
	# e o Godot não deixa mudar isso naquele momento (dá erro).
	for personagem in personagens:
		if (is_instance_valid(personagem)):
			personagem.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

	tela_final.mostrar(vencedor)
