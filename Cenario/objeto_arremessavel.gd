class_name ObjetoArremessavel
extends Node2D

enum Estado { PARADO, CARREGADO, VOANDO }

@export_category("Arremesso")
@export var distancia_arremesso: float = 400.0   # quantos pixels ele anda pelo chão
@export var duracao_voo: float = 0.6             # segundos no ar
@export var altura_arco: float = 120.0           # altura máxima do arco (pixels)
@export var margem_tela: float = 40.0            # distância mínima da borda da tela ao cair

@export_category("Carregar")
@export var posicao_na_mao: Vector2 = Vector2(0, -90)  # onde fica em relação a quem carrega

@onready var sprite: Sprite2D = $Sprite2D
@onready var sombra: Sprite2D = $Sombra

var estado: Estado = Estado.PARADO
var dono: Node2D = null


func _ready() -> void:
	# O personagem procura os objetos por este grupo
	add_to_group("objeto_arremessavel")


func _physics_process(_delta: float) -> void:
	if (estado != Estado.CARREGADO):
		return

	# Se quem carregava sumiu (morreu), o objeto cai no chão onde estava
	if (not is_instance_valid(dono)):
		_aterrissar()
		return

	global_position = dono.global_position


func pode_ser_pego() -> bool:
	return estado == Estado.PARADO


func pegar(novo_dono: Node2D) -> void:
	estado = Estado.CARREGADO
	dono = novo_dono

	# O nó fica no "chão" (posição de quem carrega); só o desenho sobe até a mão
	sprite.position = posicao_na_mao
	sombra.visible = false


func arremessar(direcao: Vector2) -> void:
	estado = Estado.VOANDO
	dono = null
	sombra.visible = true

	var inicio: Vector2 = global_position
	var altura_inicial: float = -sprite.position.y
	var destino: Vector2 = inicio + direcao.normalized() * distancia_arremesso

	# Não deixa o objeto cair fora da tela
	var limites: Rect2 = get_viewport_rect().grow(-margem_tela)
	destino = destino.clamp(limites.position, limites.end)

	# Vai de t = 0 até t = 1 durante duracao_voo, chamando _atualizar_voo a cada quadro
	var tween := create_tween()
	tween.tween_method(_atualizar_voo.bind(inicio, destino, altura_inicial), 0.0, 1.0, duracao_voo)
	tween.tween_callback(_aterrissar)


func _atualizar_voo(t: float, inicio: Vector2, destino: Vector2, altura_inicial: float) -> void:
	# No chão: anda em linha reta do início até o destino
	global_position = inicio.lerp(destino, t)

	# No ar: desce da mão até o chão + um arco (parábola) que vale 0 no início e no fim
	var altura: float = altura_inicial * (1.0 - t) + 4.0 * altura_arco * t * (1.0 - t)
	sprite.position = Vector2(0, -altura)


func _aterrissar() -> void:
	estado = Estado.PARADO
	dono = null
	sprite.position = Vector2.ZERO
	sombra.visible = true
	print("Objeto aterrissou em: ", global_position)
