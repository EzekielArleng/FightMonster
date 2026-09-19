class_name kaiju_1
extends Personagem

var tipo_ataque: int

@onready var colisao_atq_neutro: CollisionShape2D = $Hitbox_atq_neutro/CollisionShape2D
@onready var efeito_atq_neutro: Polygon2D = $Hitbox_atq_neutro/Polygon2D

@onready var colisao_atq_especial1: CollisionShape2D = $Hitbox_atq_especial1/CollisionShape2D
@onready var efeito_atq_especial1: Polygon2D = $Hitbox_atq_especial1/Polygon2D

@onready var colisao_atq_especial2: CollisionShape2D = $Hitbox_atq_especial2/CollisionShape2D
@onready var efeito_atq_especial2: Polygon2D = $Hitbox_atq_especial2/Polygon2D

@onready var colisao_atq_especial3: CollisionShape2D = $Hitbox_atq_especial3/CollisionShape2D
@onready var efeito_atq_especial3: Polygon2D = $Hitbox_atq_especial3/Polygon2D

@onready var colisao_atq_especial4: CollisionShape2D = $Hitbox_atq_especial4/CollisionShape2D
@onready var efeito_atq_especial4: Polygon2D = $Hitbox_atq_especial4/Polygon2D


func atacar_neutro() -> void:
	#Mudanca de estado
	gerenciador_estado.mudar_estado_temporario(GerenciadorEstado.Tipo.ATACANDO_NEUTRO,tempo_ataque_neutro)
	
	#Sinalização de qual ataque o kaiju está usando
	tipo_ataque = 0
	
	# Ativa a Hitbox
	colisao_atq_neutro.disabled = false
	efeito_atq_neutro.visible = true
	
	#O que o ataque faz
	recuperar_energia(5)
	print("Ataque neutro iniciado")
	
	# Espera o tempo do ataque
	await get_tree().create_timer(tempo_ataque_neutro).timeout
	
	# Desativa a Hitbox
	colisao_atq_neutro.disabled = true
	efeito_atq_neutro.visible = false


func executar_especial(indice: int) -> void:

	match indice:
		1:
			if (energia >= energia_ataque_1):
				ataque_especial_1()
			else:
				print("Sem energia para atacar")
				gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)

		2:
			if (energia >= energia_ataque_2):
				ataque_especial_2()
			else:
				print("Sem energia para atacar")
				gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)
				
		3:
			if (energia >= energia_ataque_3):
				ataque_especial_3()
			else:
				print("Sem energia para atacar")
				gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)

		4:
			if (energia >= energia_ataque_4):
				ataque_especial_4()
			else:
				print("Sem energia para atacar")
				gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)
			
#Funcao do primeiro ataque do kaiju (Cima)
func ataque_especial_1() -> void:
	#Mudanca de estado
	gerenciador_estado.mudar_estado_temporario(GerenciadorEstado.Tipo.ATACANDO_ESPECIAL, tempo_ataque_1)
	
	#Sinalização de qual ataque o kaiju está usando
	tipo_ataque = 1
	
	# Ativa a Hitbox
	colisao_atq_especial1.disabled = false
	efeito_atq_especial1.visible = true
	
	#O que o ataque faz
	print("Kaiju1 executou ataque especial 1 (cima)")
	receber_dano(10)
	print(vida)
	
	# Espera o tempo do ataque
	await get_tree().create_timer(tempo_ataque_1).timeout
	
	# Desativa a Hitbox
	colisao_atq_especial1.disabled = true
	efeito_atq_especial1.visible = false
	


#Funcao do segundo ataque do kaiju (Direita)
func ataque_especial_2() -> void:
	#Mudanca de estado
	gerenciador_estado.mudar_estado_temporario(GerenciadorEstado.Tipo.ATACANDO_ESPECIAL,tempo_ataque_2)
	
	#Sinalização de qual ataque o kaiju está usando
	tipo_ataque = 2
	
	# Ativa a Hitbox
	colisao_atq_especial2.disabled = false
	efeito_atq_especial2.visible = true
	
	#O que o ataque faz
	print("Kaiju1 executou ataque especial 2 (direita)")
	print(vida)
	
	# Espera o tempo do ataque
	await get_tree().create_timer(tempo_ataque_2).timeout
	
	# Desativa a Hitbox
	colisao_atq_especial2.disabled = true
	efeito_atq_especial2.visible = false


#Funcao do terceiro ataque do kaiju (Baixo)
func ataque_especial_3() -> void:
	#Mudanca de estado
	gerenciador_estado.mudar_estado_temporario(GerenciadorEstado.Tipo.ATACANDO_ESPECIAL,tempo_ataque_3)
	
	#Sinalização de qual ataque o kaiju está usando
	tipo_ataque = 3
	
	# Ativa a Hitbox
	colisao_atq_especial3.disabled = false
	efeito_atq_especial3.visible = true
	
	#O que o ataque faz
	print("Kaiju1 executou ataque especial 3 (baixo)")
	usar_energia(10)
	print(energia)
	
	# Espera o tempo do ataque
	await get_tree().create_timer(tempo_ataque_3).timeout
	
	# Desativa a Hitbox
	colisao_atq_especial3.disabled = true
	efeito_atq_especial3.visible = false



#Funcao do quarto ataque do kaiju (Esquerda)	
func ataque_especial_4() -> void:
	#Mudanca de estado
	gerenciador_estado.mudar_estado_temporario(GerenciadorEstado.Tipo.ATACANDO_ESPECIAL,tempo_ataque_4)
	
	#Sinalização de qual ataque o kaiju está usando
	tipo_ataque = 4
	
	# Ativa a Hitbox
	colisao_atq_especial4.disabled = false
	efeito_atq_especial4.visible = true
	
	#O que o ataque faz
	print("Kaiju1 executou ataque especial 4 (esquerda)")
	print(energia)
	
	# Espera o tempo do ataque
	await get_tree().create_timer(tempo_ataque_4).timeout
	
	# Desativa a Hitbox
	colisao_atq_especial4.disabled = true
	efeito_atq_especial4.visible = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Ataque_neutro")):
		var kaiju_atacante = area.get_parent()
		if (kaiju_atacante == self):
			return
		print("Hurtbox atingida por um ataque neutro!")
		receber_dano(kaiju_atacante.dano_ataque_neutro)
	elif (area.is_in_group("Ataque_especial")):
		var kaiju_atacante = area.get_parent()
		if (kaiju_atacante == self):
			return
		print("Hurtbox atingida por um ataque especial")
		match kaiju_atacante.tipo_ataque:
			1:
				receber_dano(kaiju_atacante.dano_ataque_1)
			2:
				receber_dano(kaiju_atacante.dano_ataque_2)
			3:
				receber_dano(kaiju_atacante.dano_ataque_3)
			4:
				receber_dano(kaiju_atacante.dano_ataque_4)
