class_name kaiju_1
extends Personagem

var tipo_ataque: int
var posicao_original_sprite: Vector2

@onready var colisao_atq_neutro: CollisionShape2D = $Pivo/Hitbox_atq_neutro/CollisionShape2D
@onready var efeito_atq_neutro: Polygon2D = $Pivo/Hitbox_atq_neutro/Polygon2D

@onready var colisao_atq_especial1: CollisionShape2D = $Pivo/Hitbox_atq_especial1/CollisionShape2D
@onready var efeito_atq_especial1: Polygon2D = $Pivo/Hitbox_atq_especial1/Polygon2D

@onready var colisao_atq_especial2: CollisionShape2D = $Pivo/Hitbox_atq_especial2/CollisionShape2D
@onready var efeito_atq_especial2: Polygon2D = $Pivo/Hitbox_atq_especial2/Polygon2D

@onready var colisao_atq_especial3: CollisionShape2D = $Pivo/Hitbox_atq_especial3/CollisionShape2D
@onready var efeito_atq_especial3: Polygon2D = $Pivo/Hitbox_atq_especial3/Polygon2D

@onready var colisao_atq_especial4: CollisionShape2D = $Pivo/Hitbox_atq_especial4/CollisionShape2D
@onready var efeito_atq_especial4: Polygon2D = $Pivo/Hitbox_atq_especial4/Polygon2D

@onready var hitbox_area_neutro: Area2D = $Pivo/Hitbox_atq_neutro

@onready var sprite_personagem: AnimatedSprite2D = $Pivo/AnimatedSprite2D
@onready var sprite_efeito: AnimatedSprite2D = $Pivo/AnimatedSprite_efeitos

func _ready() -> void:
	super._ready()
	
	posicao_original_sprite = $Pivo/AnimatedSprite2D.position
	sprite_efeito.visible = false

func atacar_neutro() -> void:
	animacao.play("default")
	
	# Impede outras ações durante a preparação e o ataque
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.ATACANDO_NEUTRO)

	# Sinaliza qual ataque está sendo preparado
	tipo_ataque = 0

	# Garante que a hitbox esteja desativada durante o aviso
	colisao_atq_neutro.set_deferred("disabled", true)

	# Mostra a área de aviso
	efeito_atq_neutro.visible = true

	print("Preparando ataque neutro")

	# Aguarda o tempo de reação do adversário
	await get_tree().create_timer(tempo_preparacao_neutro).timeout

	# Encerra o aviso visual
	efeito_atq_neutro.visible = false

	# Ativa a hitbox após a preparação
	colisao_atq_neutro.set_deferred("disabled", false)

	# O que o ataque faz
	recuperar_energia(5)
	print("Ataque neutro iniciado")
	
	som_arranhao_tocado = false
	
	$Pivo/AnimatedSprite2D.position = posicao_original_sprite + Vector2(50, 0)
	
	$Pivo/AnimatedSprite2D.play("atk_neutro")

	# Aguarda a duração do ataque
	await $Pivo/AnimatedSprite2D.animation_finished

	# Desativa a hitbox e esconde o indicador
	colisao_atq_neutro.set_deferred("disabled", true)
	efeito_atq_neutro.visible = false

	print("Ataque neutro finalizado")
	
	$Pivo/AnimatedSprite2D.position = posicao_original_sprite
	$Pivo/AnimatedSprite2D.play("default")
	
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.LIVRE)

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
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.ATACANDO_ESPECIAL)
	# Sinaliza qual ataque está sendo utilizado
	tipo_ataque = 1
	
	#usando energia
	usar_energia(energia_ataque_1)
	print(energia)
	
	# Garante que a hitbox esteja desativada durante a preparação
	colisao_atq_especial1.set_deferred("disabled", true)

	# Mostra a área de perigo
	efeito_atq_especial1.visible = true

	print("Preparando ataque especial 1")

	# Aguarda o tempo de reação do adversário
	await get_tree().create_timer(tempo_preparacao_1).timeout

	# Esconde o indicador antes de executar o golpe
	efeito_atq_especial1.visible = false

	# Ativa a hitbox
	colisao_atq_especial1.set_deferred("disabled", false)

	# Efeito do ataque
	print("Kaiju1 executou ataque especial 1 (cima)")

	# Aguarda a duração do ataque
	await get_tree().create_timer(tempo_ataque_1).timeout

	# Desativa a hitbox
	colisao_atq_especial1.set_deferred("disabled", true)

	print("Ataque especial 1 finalizado")
	
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.LIVRE)

#Funcao do segundo ataque do kaiju (Direita)
func ataque_especial_2() -> void:
	# Mantém o personagem ocupado durante preparação e execução
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.ATACANDO_ESPECIAL)

	# Sinaliza qual ataque está sendo utilizado
	tipo_ataque = 2

	#usando energia
	usar_energia(energia_ataque_2)

	# Garante que a hitbox esteja desativada durante a preparação
	colisao_atq_especial2.set_deferred("disabled", true)

	# Mostra a área de perigo
	efeito_atq_especial2.visible = true

	print("Preparando ataque especial 2")

	# Aguarda o tempo de reação do adversário
	await get_tree().create_timer(tempo_preparacao_2).timeout

	# Esconde o indicador antes de executar o golpe
	efeito_atq_especial2.visible = false

	# Ativa a hitbox
	colisao_atq_especial2.set_deferred("disabled", false)

	# Efeito do ataque
	print("Kaiju1 executou ataque especial 2 (direita)")

	# Aguarda a duração do ataque
	await get_tree().create_timer(tempo_ataque_2).timeout

	# Desativa a hitbox
	colisao_atq_especial2.set_deferred("disabled", true)

	print("Ataque especial 2 finalizado")
	
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.LIVRE)

#Funcao do terceiro ataque do kaiju (Baixo)
func ataque_especial_3() -> void:
	# Mantém o personagem ocupado durante preparação e execução
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.ATACANDO_ESPECIAL)

	# Sinaliza qual ataque está sendo utilizado
	tipo_ataque = 3

	#usando energia
	usar_energia(energia_ataque_3)

	# Garante que a hitbox esteja desativada durante a preparação
	colisao_atq_especial3.set_deferred("disabled", true)

	# Mostra a área de perigo
	efeito_atq_especial3.visible = true

	print("Preparando ataque especial 3")

	# Aguarda o tempo de reação do adversário
	await get_tree().create_timer(tempo_preparacao_3).timeout

	# Esconde o indicador antes de executar o golpe
	efeito_atq_especial3.visible = false
	
	$Pivo/AnimatedSprite2D.position = posicao_original_sprite + Vector2(0, -50)
	# Reproduz a animação do ataque
	sprite_personagem.play("atk_especial_3")
	sprite_efeito.play("efeito_atk_especial_3")
	
	# Ativa a hitbox
	colisao_atq_especial3.set_deferred("disabled", false)

	# Efeito do ataque
	print("Kaiju1 executou ataque especial 3 (baixo)")
	usar_energia(10)
	print(energia)
	
	print("Posição original: ", posicao_original_sprite)
	
	print("Posição durante ataque: ", $Pivo/AnimatedSprite2D.position)
	
	# Aguarda a duração do ataque
	await sprite_personagem.animation_finished
	sprite_efeito.visible = false

	# Desativa a hitbox
	colisao_atq_especial3.set_deferred("disabled", true)

	$Pivo/AnimatedSprite2D.position = posicao_original_sprite
	$Pivo/AnimatedSprite2D.play("default")
	print("Posição após ataque: ", $Pivo/AnimatedSprite2D.position)
	print("Ataque especial 3 finalizado")
	
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.LIVRE)

#Funcao do quarto ataque do kaiju (Esquerda)	
func ataque_especial_4() -> void:
	# Mantém o personagem ocupado durante preparação e execução
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.ATACANDO_ESPECIAL)

	# Sinaliza qual ataque está sendo utilizado
	tipo_ataque = 4

	#usando energia
	usar_energia(energia_ataque_4)
	

	# Garante que a hitbox esteja desativada durante a preparação
	colisao_atq_especial4.set_deferred("disabled", true)

	# Mostra a área de perigo
	efeito_atq_especial4.visible = true

	print("Preparando ataque especial 4")

	# Aguarda o tempo de reação do adversário
	await get_tree().create_timer(tempo_preparacao_4).timeout

	# Esconde o indicador antes de executar o golpe
	efeito_atq_especial4.visible = false

	# Ativa a hitbox
	colisao_atq_especial4.set_deferred("disabled", false)

	# Efeito do ataque
	print("Kaiju1 executou ataque especial 4 (esquerda)")

	# Aguarda a duração do ataque
	await get_tree().create_timer(tempo_ataque_4).timeout

	# Desativa a hitbox
	colisao_atq_especial4.set_deferred("disabled", true)

	print("Ataque especial 4 finalizado")
	
	gerenciador_estado.mudar_estado(
	GerenciadorEstado.Tipo.LIVRE)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if (area.is_in_group("Ataque_neutro")):
		
		var kaiju_atacante = area.get_parent().get_parent()
		
		if (kaiju_atacante == self):
			return
			
		print("Hurtbox atingida por um ataque neutro!")
		
		var direcao_ataque: Vector2 = (area.global_position - kaiju_atacante.global_position).normalized()
		
		receber_dano(kaiju_atacante.dano_ataque_neutro)
		receber_knockback(direcao_ataque,kaiju_atacante.knockback_ataque_neutro)
		
	elif (area.is_in_group("Ataque_especial")):
		var kaiju_atacante = area.get_parent().get_parent()
		if (kaiju_atacante == self):
			return
		print("Hurtbox atingida por um ataque especial")
		var direcao_ataque: Vector2 = (area.global_position - kaiju_atacante.global_position).normalized()
		
		match kaiju_atacante.tipo_ataque:
			1:
				receber_dano(kaiju_atacante.dano_ataque_1)
				receber_knockback(direcao_ataque,kaiju_atacante.knockback_ataque_1)
			2:
				receber_dano(kaiju_atacante.dano_ataque_2)
				receber_knockback(direcao_ataque,kaiju_atacante.knockback_ataque_2)
			3:
				receber_dano(kaiju_atacante.dano_ataque_3)
				receber_knockback(direcao_ataque,kaiju_atacante.knockback_ataque_3)
			4:
				receber_dano(kaiju_atacante.dano_ataque_4)
				receber_knockback(direcao_ataque,kaiju_atacante.knockback_ataque_4)


func _on_animated_sprite_2d_frame_changed() -> void:
	if ($Pivo/AnimatedSprite2D.animation == "atk_neutro"):
		if ($Pivo/AnimatedSprite2D.frame == 2 && !som_arranhao_tocado):
			$Som_atq_neutro.play()
			som_arranhao_tocado = true
	if (sprite_personagem.animation == "atk_especial_3"):
		sprite_efeito.visible = (sprite_personagem.frame >= 2)
