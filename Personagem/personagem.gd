class_name Personagem
extends CharacterBody2D

@export_category("Status")
@export var vida: float
@export var energia: float
@export var energia_max: float

@export_category("Movement")
@export var speed: float = 3.0
@export_range(0.0, 1.0) var lerp_smoothness: float = 0.5

var input_vector: Vector2 = Vector2.ZERO

var gerenciador_estado: GerenciadorEstado = GerenciadorEstado.new()

func _process(_delta: float) -> void:
	input_vector = Vector2.ZERO

	if not gerenciador_estado.esta_livre():
		return

	var horizontal := Input.get_axis("ui_left", "ui_right")
	var vertical := Input.get_axis("ui_up", "ui_down")

	if horizontal != 0:
		input_vector.x = horizontal
	elif vertical != 0:
		input_vector.y = vertical


func _physics_process(_delta: float) -> void:
	if gerenciador_estado.esta_livre():
		movimentar()
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func movimentar() -> void:
	var target_velocity: Vector2 = input_vector * speed * 100.0
	velocity = velocity.lerp(target_velocity, lerp_smoothness)

func _input(event: InputEvent) -> void:
	
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
	if (dano > vida):
		vida = 0
	else:
		vida -= dano
	
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
