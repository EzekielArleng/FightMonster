extends Node

# PARA ADICIONAR UM PERSONAGEM NOVO: inclua mais um item em PERSONAGENS.
# A tela de seleção monta os cards sozinha a partir desta lista.
const PERSONAGENS: Array[Dictionary] = [
	{
		"nome": "Kaiju 1",
		"cena": "res://Personagem/Kaiju_1/kaiju_1.tscn",
		"imagem": "res://imagens_testes/73dc85a8a808a94b31a6b31185e7e8a3.jpg",
	},
	{
		"nome": "Kaiju 2",
		"cena": "res://Personagem/Kaiju2/kaiju_2.tscn",
		"imagem": "res://imagens_testes/3d235fe6499874d286e02caa6d1e9976.jpg",
	},
]

# Índice (dentro de PERSONAGENS) escolhido por cada jogador. -1 = ainda não escolheu.
var escolha_p1: int = -1
var escolha_p2: int = -1

func definir_escolha(jogador: int, indice: int) -> void:
	if (jogador == 1):
		escolha_p1 = indice
	else:
		escolha_p2 = indice

func obter_cena(jogador: int) -> PackedScene:
	var indice: int = escolha_p1 if jogador == 1 else escolha_p2

	# Sem escolha (ex.: rodando main.tscn direto com F6): usa um padrão para testar
	if (indice < 0 or indice >= PERSONAGENS.size()):
		indice = mini(jogador - 1, PERSONAGENS.size() - 1)

	var dados: Dictionary = PERSONAGENS[indice]
	return load(dados["cena"]) as PackedScene
