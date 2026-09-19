class_name kaiju_1
extends Personagem

@export_category("Energia Ataques")
@export var energia_ataque_1: float
@export var energia_ataque_2: float
@export var energia_ataque_3: float
@export var energia_ataque_4: float

func atacar_neutro() -> void:
	gerenciador_estado.mudar_estado_temporario(
		GerenciadorEstado.Tipo.ATACANDO_NEUTRO,
		0.5
	)
	recuperar_energia(5)
	print("Ataque neutro iniciado")


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
	print("Kaiju1 executou ataque especial 1 (cima)")
	receber_dano(10)
	print(vida)
	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)

	print("Ataque especial acabou")

#Funcao do segundo ataque do kaiju (Direita)
func ataque_especial_2() -> void:
	print("Kaiju1 executou ataque especial 2 (direita)")
	print(vida)
	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)

	print("Ataque especial acabou")

#Funcao do terceiro ataque do kaiju (Baixo)
func ataque_especial_3() -> void:
	print("Kaiju1 executou ataque especial 3 (baixo)")
	usar_energia(10)
	print(energia)
	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)

	print("Ataque especial acabou")

#Funcao do quarto ataque do kaiju (Esquerda)	
func ataque_especial_4() -> void:
	print("Kaiju1 executou ataque especial 4 (esquerda)")
	print(energia)
	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(GerenciadorEstado.Tipo.LIVRE)

	print("Ataque especial acabou")
