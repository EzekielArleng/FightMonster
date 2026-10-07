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
@export var tempo_ataque_1: float
@export var tempo_ataque_2: float
@export var tempo_ataque_3: float
@export var tempo_ataque_4: float

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

var input_vector: Vector2 = Vector2.ZERO

var gerenciador_estado: GerenciadorEstado = GerenciadorEstado.new()

func _process(delta: float) -> void:
	if (botao_defesa_pressionado):
		tempo_botao_defesa += delta
		
		if (tempo_botao_defesa >= tempo_para_bloquear and gerenciador_estado.esta_livre()):
			gerenciador_estado.iniciar_bloqueio()
			print("BLOCK iniciado - botão segurado por: ", tempo_botao_defesa)
	
	input_vector = Vector2.ZERO

	if (not gerenciador_estado.esta_livre() and not gerenciador_estado.esta_bloqueando()):
		return

	var horizontal := Input.get_axis("ui_left", "ui_right")
	var vertical := Input.get_axis("ui_up", "ui_down")

	if (horizontal != 0):
		input_vector.x = horizontal
	elif (vertical != 0):
		input_vector.y = vertical


func _physics_process(_delta: float) -> void:
	if (gerenciador_estado.esta_livre() or gerenciador_estado.esta_bloqueando()):
		movimentar()
	elif (gerenciador_estado.esta_evadindo()):
		movimentar_evasao()
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func movimentar() -> void:
	var target_velocity: Vector2 = input_vector * speed * 100.0
	velocity = velocity.lerp(target_velocity, lerp_smoothness)

func _input(event: InputEvent) -> void:
	
	# Iniciar bloqueio
	if event.is_action_pressed("Block_evasao"):
		if (gerenciador_estado.esta_livre()):
			botao_defesa_pressionado = true
			tempo_botao_defesa = 0.0
			print("Botão de defesa pressionado")
		return

# Finalizar bloqueio
	if (event.is_action_released("Block_evasao")):
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
	if event.is_action_released("Ataque_especial"):
		if gerenciador_estado.esta_selecionando_especial():
			gerenciador_estado.cancelar_selecao_especial()
		return

	# Abrir a roda de ataques especiais
	if event.is_action_pressed("Ataque_especial"):
		if gerenciador_estado.esta_livre():
			gerenciador_estado.iniciar_selecao_especial()
			print("Seleção de ataque especial iniciada")
		return

	# Escolher um ataque enquanto a roda está aberta
	if gerenciador_estado.esta_selecionando_especial():
		if event.is_action_pressed("ui_up"):
			selecionar_especial(1)
		elif event.is_action_pressed("ui_right"):
			selecionar_especial(2)
		elif event.is_action_pressed("ui_down"):
			selecionar_especial(3)
		elif event.is_action_pressed("ui_left"):
			selecionar_especial(4)
		return

	# Ataque neutro
	if event.is_action_pressed("Ataque_neutro"):
		if gerenciador_estado.esta_livre():
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
	
	print("Evasão iniciada")
	print("Direção da evasão: ", direcao_evasao)
	
	await get_tree().create_timer(duracao_evasao).timeout
	
	if (gerenciador_estado.esta_evadindo()):
		gerenciador_estado.mudar_estado(
			GerenciadorEstado.Tipo.LIVRE
		)
		
		print("Evasão finalizada")
		
func movimentar_evasao() -> void:
	velocity = direcao_evasao * velocidade_evasao
	
func esta_invulneravel() -> bool:
	return (
		gerenciador_estado.esta_bloqueando() or gerenciador_estado.esta_evadindo())
