class_name Personagem
extends CharacterBody2D

@export_category("Status")
@export var vida: float
@export var energia: float
@export var energia_max: float

@export_category("Movement")
@export var speed: float = 3.0
@export_range(0.0, 1.0) var lerp_smoothness: float = 0.5

@export_category("Dano Ataques")
@export var dano_ataque_neutro: float
@export var dano_ataque_1: float
@export var dano_ataque_2: float
@export var dano_ataque_3: float
@export var dano_ataque_4: float

@export_category("Tempo Ataques")
@export var tempo_ataque_neutro: float
@export var tempo_preparacao_neutro: float = 0.4
@export var tempo_ataque_1: float
@export var tempo_preparacao_1: float = 0.4
@export var tempo_ataque_2: float
@export var tempo_preparacao_2: float = 0.4
@export var tempo_ataque_3: float
@export var tempo_preparacao_3: float = 0.4
@export var tempo_ataque_4: float
@export var tempo_preparacao_4: float = 0.4

@export_category("Energia Ataques")
@export var energia_ataque_1: float
@export var energia_ataque_2: float
@export var energia_ataque_3: float
@export var energia_ataque_4: float

@export_category("Block/Evasão")
@export var tempo_para_bloquear: float = 0.2
@export var velocidade_evasao: float = 800.0
@export var duracao_evasao: float = 0.2

var tempo_botao_defesa: float = 0.0
var botao_defesa_pressionado: bool = false
var direcao_evasao: Vector2 = Vector2.ZERO

@export_category("Knockback")
@export var desaceleracao_knockback: float = 1500.0
@export var velocidade_minima_knockback: float = 10.0
@export var knockback_ataque_neutro: float = 500.0
@export var knockback_ataque_1: float = 500.0
@export var knockback_ataque_2: float = 500.0
@export var knockback_ataque_3: float = 500.0
@export var knockback_ataque_4: float = 500.0

var direcao_knockback: Vector2 = Vector2.ZERO
var velocidade_knockback: float = 0.0

var input_vector: Vector2 = Vector2.ZERO

var gerenciador_estado: GerenciadorEstado = GerenciadorEstado.new()

@onready var indicador_atq_neutro: Polygon2D = $Hitbox_atq_neutro/Polygon2D

@export_category("Configuração do Jogador")
@export_range(1, 2, 1) var jogador: int = 1

@export_category("Interação")
@export var alcance_interacao: float = 160.0
@export var tempo_arremesso: float = 0.25

var objeto_carregado: ObjetoArremessavel = null

func _process(delta: float) -> void:
	if (botao_defesa_pressionado):
		tempo_botao_defesa += delta
		
		if (tempo_botao_defesa >= tempo_para_bloquear and gerenciador_estado.esta_livre()):
			gerenciador_estado.iniciar_bloqueio()
			print("BLOCK iniciado - botão segurado por: ", tempo_botao_defesa)
	
	input_vector = Vector2.ZERO

	if (not gerenciador_estado.esta_livre() and not gerenciador_estado.esta_bloqueando()):
		return

	var horizontal := Input.get_axis(
		acao("Mov_esquerda"),
		acao("Mov_direita")
	)

	var vertical := Input.get_axis(
		acao("Mov_cima"),
		acao("Mov_baixo")
	)

	if (horizontal != 0):
		input_vector.x = horizontal
	elif (vertical != 0):
		input_vector.y = vertical


func _physics_process(delta: float) -> void:
	if (gerenciador_estado.esta_livre() or gerenciador_estado.esta_bloqueando()):
		movimentar()
	elif (gerenciador_estado.esta_evadindo()):
		movimentar_evasao()
	elif (gerenciador_estado.esta_em_knockback()):
		movimentar_knockback(delta)
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func movimentar() -> void:
	var target_velocity: Vector2 = input_vector * speed * 100.0
	velocity = velocity.lerp(target_velocity, lerp_smoothness)

func _input(event: InputEvent) -> void:
	
	# Iniciar bloqueio
	if event.is_action_pressed(acao("Block_evasao")):
		if (gerenciador_estado.esta_livre()):
			botao_defesa_pressionado = true
			tempo_botao_defesa = 0.0
			print("Botão de defesa pressionado")
		return

	# Finalizar bloqueio
	if (event.is_action_released(acao("Block_evasao"))):
		if (botao_defesa_pressionado):
			botao_defesa_pressionado = false
			if (gerenciador_estado.esta_bloqueando()):
				gerenciador_estado.finalizar_bloqueio()
				print("BLOCK finalizado - tempo total: ", tempo_botao_defesa)
			else:
				print("EVASÃO detectada - toque de: ", tempo_botao_defesa)
				iniciar_evasao()

			tempo_botao_defesa = 0.0
		
		return
		
	# Soltar X sem escolher um ataque cancela a seleção
	if event.is_action_released(acao("Ataque_especial")):
		if gerenciador_estado.esta_selecionando_especial():
			gerenciador_estado.cancelar_selecao_especial()
		return

	# Abrir a roda de ataques especiais
	if event.is_action_pressed(acao("Ataque_especial")):
		if gerenciador_estado.esta_livre():
			gerenciador_estado.iniciar_selecao_especial()
			print("Seleção de ataque especial iniciada")
		return

	# Escolher um ataque enquanto a roda está aberta
	if gerenciador_estado.esta_selecionando_especial():
		if event.is_action_pressed(acao("Mov_cima")):
			selecionar_especial(1)
		elif event.is_action_pressed(acao("Mov_direita")):
			selecionar_especial(2)
		elif event.is_action_pressed(acao("Mov_baixo")):
			selecionar_especial(3)
		elif event.is_action_pressed(acao("Mov_esquerda")):
			selecionar_especial(4)
		return

		# Pegar objeto próximo
	if event.is_action_pressed(acao("Interagir")):
		if gerenciador_estado.esta_livre():
			tentar_pegar_objeto()
		return

	# Ataque neutro (se estiver carregando um objeto, arremessa em vez de atacar)
	if event.is_action_pressed(acao("Ataque_neutro")):
		if gerenciador_estado.esta_livre():
			if (objeto_carregado != null):
				arremessar_objeto()
			else:
				atacar_neutro()

func atacar_neutro() -> void:
	pass

func selecionar_especial(indice: int) -> void:
	print("Ataque especial selecionado: ", indice)

	gerenciador_estado.mudar_estado(
		GerenciadorEstado.Tipo.ATACANDO_ESPECIAL
	)

	executar_especial(indice)
	
func executar_especial(_indice: int) -> void:
	pass
	
func receber_dano(dano: float) -> void:
	if (esta_invulneravel()):
		print("Dano ignorado - personagem invulnerável")
		return
	
	if (dano > vida):
		vida = 0
	else:
		vida -= dano
	
	print("Dano recebido: ", dano)
	print("Vida atual: ", vida)
	
	if (vida <= 0):
		morrer()
	
func morrer() -> void:
	queue_free()
	
func usar_energia(energia_gasta: float) -> void:
	if (energia_gasta > energia):
		energia = 0
	else:
		energia -= energia_gasta
	
func recuperar_energia(energia_recuperada: float) -> void:
	if (energia + energia_recuperada > energia_max):
		energia = energia_max
	else:
		energia += energia_recuperada

func iniciar_evasao() -> void:
	if (not gerenciador_estado.esta_livre()):
		return
	
	if (input_vector == Vector2.ZERO):
		print("Evasão cancelada: nenhuma direção selecionada")
		return
	
	direcao_evasao = input_vector.normalized()
	
	gerenciador_estado.mudar_estado(
		GerenciadorEstado.Tipo.EVADINDO
	)
	
	set_collision_mask_value(2, false)
	set_collision_layer_value(2, false)
	print("Máscara durante evasão: ", get_collision_mask_value(2))
	
	print("Evasão iniciada")
	print("Direção da evasão: ", direcao_evasao)
	
	await get_tree().create_timer(duracao_evasao).timeout
	
	if (gerenciador_estado.esta_evadindo()):
		gerenciador_estado.mudar_estado(
			GerenciadorEstado.Tipo.LIVRE
		)
	
	set_collision_mask_value(2, true)
	set_collision_layer_value(2, true)
	print("Máscara após evasão: ", get_collision_mask_value(2))
		
	print("Evasão finalizada")
		
func movimentar_evasao() -> void:
	velocity = direcao_evasao * velocidade_evasao
	
func esta_invulneravel() -> bool:
	return (
		gerenciador_estado.esta_bloqueando() or gerenciador_estado.esta_evadindo())

func receber_knockback(direcao: Vector2, forca: float) -> void:
	if (esta_invulneravel()):
		print("Knockback ignorado - personagem invulneravel")
		return
	
	if (direcao == Vector2.ZERO):
		return
	
	direcao_knockback = direcao.normalized()
	velocidade_knockback = forca
	
	gerenciador_estado.mudar_estado(
		GerenciadorEstado.Tipo.KNOCKBACK
	)
	
	print("KNOCKBACK iniciado")
	print("Direção: ", direcao_knockback)
	print("Força: ", forca)
	
func movimentar_knockback(delta: float) -> void:
	velocity = direcao_knockback * velocidade_knockback
	
	velocidade_knockback = move_toward(
		velocidade_knockback,
		0.0,
		desaceleracao_knockback * delta
	)
	
	if (velocidade_knockback <= velocidade_minima_knockback):
		velocidade_knockback = 0.0
		velocity = Vector2.ZERO
		
		gerenciador_estado.mudar_estado(
			GerenciadorEstado.Tipo.LIVRE
		)
		
		print("KNOCKBACK finalizado")

func mostrar_telegraph(indicador: Polygon2D) -> void:
	indicador.visible = true
	
func ocultar_telegraph(indicador: Polygon2D) -> void:
	indicador.visible = false
	
func acao(nome: String) -> String:
	return nome + "_p" + str(jogador)
	
func tentar_pegar_objeto() -> void:
	if (objeto_carregado != null):
		return

	# Procura o objeto livre mais próximo dentro do alcance
	var mais_proximo: ObjetoArremessavel = null
	var menor_distancia: float = alcance_interacao

	for no in get_tree().get_nodes_in_group("objeto_arremessavel"):
		var objeto := no as ObjetoArremessavel
		if (objeto == null or not objeto.pode_ser_pego()):
			continue

		var distancia: float = global_position.distance_to(objeto.global_position)
		if (distancia <= menor_distancia):
			menor_distancia = distancia
			mais_proximo = objeto

	if (mais_proximo == null):
		print("Nenhum objeto ao alcance")
		return

	objeto_carregado = mais_proximo
	objeto_carregado.pegar(self)
	print("Objeto pego")

func arremessar_objeto() -> void:
	# Mesma linha do ataque básico: do centro do personagem até a hitbox do ataque neutro
	var hitbox: Area2D = $Hitbox_atq_neutro
	var direcao: Vector2 = (hitbox.global_position - global_position).normalized()

	# Trava o personagem por um instante, como se fosse um ataque
	gerenciador_estado.mudar_estado_temporario(
		GerenciadorEstado.Tipo.ATACANDO_NEUTRO,
		tempo_arremesso
	)

	objeto_carregado.arremessar(direcao)
	objeto_carregado = null
	print("Objeto arremessado")
