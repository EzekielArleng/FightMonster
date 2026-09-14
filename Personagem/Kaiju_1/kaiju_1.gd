class_name kaiju_1
extends Personagem


func atacar_neutro() -> void:
	gerenciador_estado.mudar_estado_temporario(
		GerenciadorEstado.Tipo.ATACANDO_NEUTRO,
		0.5
	)

	print("Ataque neutro iniciado")


func executar_especial(indice: int) -> void:

	match indice:
		1:
			ataque_especial_1()

		2:
			ataque_especial_2()

		3:
			ataque_especial_3()

		4:
			ataque_especial_4()
			
func ataque_especial_1() -> void:
	print("Kaiju1 executou ataque especial 1 (cima)")

	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(
		GerenciadorEstado.Tipo.LIVRE
	)

	print("Ataque especial acabou")

func ataque_especial_2() -> void:
	print("Kaiju1 executou ataque especial 2 (direita)")

	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(
		GerenciadorEstado.Tipo.LIVRE
	)

	print("Ataque especial acabou")
	
func ataque_especial_3() -> void:
	print("Kaiju1 executou ataque especial 3 (baixo)")

	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(
		GerenciadorEstado.Tipo.LIVRE
	)

	print("Ataque especial acabou")
	
func ataque_especial_4() -> void:
	print("Kaiju1 executou ataque especial 4 (esquerda)")

	await get_tree().create_timer(1.0).timeout

	gerenciador_estado.mudar_estado(
		GerenciadorEstado.Tipo.LIVRE
	)

	print("Ataque especial acabou")
