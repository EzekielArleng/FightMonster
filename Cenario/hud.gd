
extends CanvasLayer

@onready var preenchimento_vida_p1: TextureRect = $Interface/BarraVidaFundo/PreenchimentoVida
@onready var preenchimento_energia_p1: TextureRect = $Interface/BarraVidaFundo/PreenchimentoEnergia

@onready var preenchimento_vida_p2: TextureRect = $Interface/BarraVidaFundo2/PreenchimentoVida2
@onready var preenchimento_energia_p2: TextureRect = $Interface/BarraVidaFundo2/PreenchimentoEnergia2

var personagem_p1: Personagem
var personagem_p2: Personagem

var vida_max_p1: float
var vida_max_p2: float

var largura_vida_p1: float
var largura_vida_p2: float

var largura_energia_p1: float
var largura_energia_p2: float

var posicao_vida_p2: float
var posicao_energia_p2: float


func definir_personagens(p1: Personagem, p2: Personagem) -> void:
	personagem_p1 = p1
	personagem_p2 = p2

	vida_max_p1 = p1.vida
	vida_max_p2 = p2.vida

	largura_vida_p1 = preenchimento_vida_p1.size.x
	largura_vida_p2 = preenchimento_vida_p2.size.x

	largura_energia_p1 = preenchimento_energia_p1.size.x
	largura_energia_p2 = preenchimento_energia_p2.size.x

	posicao_vida_p2 = preenchimento_vida_p2.position.x
	posicao_energia_p2 = preenchimento_energia_p2.position.x



func _process(_delta: float) -> void:
	if (not is_instance_valid(personagem_p1)):
		return

	if (not is_instance_valid(personagem_p2)):
		return

	atualizar_barras()


func atualizar_barras() -> void:
	var vida_p1: float = clampf(personagem_p1.vida / vida_max_p1, 0.0, 1.0)
	var vida_p2: float = clampf(personagem_p2.vida / vida_max_p2, 0.0, 1.0)
	

	var energia_p1: float = clampf(personagem_p1.energia / personagem_p1.energia_max, 0.0, 1.0)
	var energia_p2: float = clampf(personagem_p2.energia / personagem_p2.energia_max, 0.0, 1.0)

	# Vida do jogador 1
	preenchimento_vida_p1.size.x = largura_vida_p1 * vida_p1

	# Energia do jogador 1
	preenchimento_energia_p1.size.x = largura_energia_p1 * energia_p1

	# Vida do jogador 2 (preenchimento da direita para a esquerda)
	preenchimento_vida_p2.size.x = largura_vida_p2 * vida_p2

	preenchimento_vida_p2.position.x = posicao_vida_p2 + (largura_vida_p2 - preenchimento_vida_p2.size.x) * preenchimento_vida_p2.scale.x

	# Energia do jogador 2
	preenchimento_energia_p2.size.x = largura_energia_p2 * energia_p2

	preenchimento_energia_p2.position.x = posicao_energia_p2 + (largura_energia_p2 - preenchimento_energia_p2.size.x) * preenchimento_energia_p2.scale.x
