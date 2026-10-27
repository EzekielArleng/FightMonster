class_name GerenciadorEstado
extends RefCounted


enum Tipo {
	LIVRE,
	ATACANDO_NEUTRO,
	ATACANDO_ESPECIAL,
	SELECIONANDO_ESPECIAL,
	BLOQUEANDO,
	EVADINDO,
	KNOCKBACK
}


var estado_atual: Tipo = Tipo.LIVRE

func mudar_estado(novo_estado: Tipo) -> void:
	estado_atual = novo_estado

func mudar_estado_temporario( novo_estado: Tipo, duracao: float) -> void:
	estado_atual = novo_estado
	
	await Engine.get_main_loop().create_timer(duracao).timeout
	
	if estado_atual == Tipo.ATACANDO_NEUTRO:
		print("Ataque neutro acabou")
	elif estado_atual == Tipo.ATACANDO_ESPECIAL:
		print("Ataque especial acabou")
	
	estado_atual = Tipo.LIVRE


func esta_livre() -> bool:
	return estado_atual == Tipo.LIVRE


func esta_atacando() -> bool:
	return (
		estado_atual == Tipo.ATACANDO_NEUTRO
		or estado_atual == Tipo.ATACANDO_ESPECIAL
	)
	
func esta_selecionando_especial() -> bool:
	return estado_atual == Tipo.SELECIONANDO_ESPECIAL

func iniciar_selecao_especial() -> void:
	estado_atual = Tipo.SELECIONANDO_ESPECIAL
	
func cancelar_selecao_especial() -> void:
	if estado_atual == Tipo.SELECIONANDO_ESPECIAL:
		estado_atual = Tipo.LIVRE
		print("Seleção de ataque especial cancelada")
		
func esta_bloqueando() -> bool:
	return estado_atual == Tipo.BLOQUEANDO
	
func iniciar_bloqueio() -> void:
	if (estado_atual == Tipo.LIVRE):
		estado_atual = Tipo.BLOQUEANDO

func finalizar_bloqueio() -> void:
	if (estado_atual == Tipo.BLOQUEANDO):
		estado_atual = Tipo.LIVRE
		
func esta_evadindo() -> bool:
	return estado_atual == Tipo.EVADINDO
	
func esta_em_knockback() -> bool:
	return estado_atual == Tipo.KNOCKBACK
