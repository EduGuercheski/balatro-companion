import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Map<String, List<Map<String, String>>> gameData = {
  'Cartas de Tarô': [
    {
      'name': 'A Carruagem',
      'description': 'Melhora 1 carta selecionada em uma Carta de Aço.',
    },
    {
      'name': 'A Estrela',
      'description': 'Converte até 3 cartas selecionadas em Diamantes.',
    },
    {
      'name': 'A Imperatriz',
      'description': 'Melhora 2 cartas selecionadas para Multi Cards.',
    },
    {
      'name': 'A Lua',
      'description': 'Converte até 3 cartas selecionadas em Paus.',
    },
    {
      'name': 'A Roda da Fortuna',
      'description': '1 em 4 chances de adicionar edição Foil, Holográfica ou Policromática a um Joker aleatório.',
    },
    {
      'name': 'A Sacerdotisa',
      'description': 'Cria até 2 cartas de planeta aleatórias (precisa ter espaço).',
    },
    {
      'name': 'A Torre',
      'description': 'Melhora 1 carta selecionada em uma Carta de Pedra.',
    },
    {
      'name': 'Força',
      'description': 'Aumenta a classificação de até 2 cartas selecionadas em 1 (Ex. 3 para 4, Rainha para Rei, Ás para 2).',
    },
    {
      'name': 'Julgamento',
      'description': 'Cria uma carta Joker aleatória (precisa ter espaço).',
    },
    {
      'name': 'Justiça',
      'description': 'Melhora 1 carta selecionada em uma Carta de Vidro.',
    },
    {
      'name': 'Morte',
      'description': 'Selecione 2 cartas, converta a carta da esquerda na carta da direita (arraste as cartas para reorganizá-las).',
    },
    {
      'name': 'O Demônio',
      'description': 'Melhora 1 carta selecionada em uma carta dourada.',
    },
    {
      'name': 'O Enforcado',
      'description': 'Destrói até 2 cartas selecionadas.',
    },
    {
      'name': 'O Eremita',
      'description': 'Duplica dinheiro.',
    },
    {
      'name': 'O Hierofante',
      'description': 'Melhora 2 cartas selecionadas para cartas bônus.',
    },
    {
      'name': 'O Imperador',
      'description': 'Cria até 2 cartas de tarô aleatórias (precisa ter espaço).',
    },
    {
      'name': 'O Mundo',
      'description': 'Converte até 3 cartas selecionadas em Espadas.',
    },
    {
      'name': 'O Mago',
      'description': 'Melhora 2 cartas selecionadas para Cartas da Sorte.',
    },
    {
      'name': 'O Sol',
      'description': 'Converte até 3 cartas selecionadas em Copas.',
    },
    {
      'name': 'O Tolo',
      'description': 'Crie a última carta de Tarô ou Planeta usada durante esta corrida (O Louco excluído).',
    },
    {
      'name': 'Os Amantes',
      'description': 'Melhora 1 carta selecionada em uma Carta Coringa.',
    },
    {
      'name': 'Temperança',
      'description': 'Fornece o valor total de venda de todos os Jokers atuais (máx.\$50).',
    },
  ],
  'Cartas Espectrais': [
    {
      'name': 'A Alma',
      'description': 'Cria um Coringa Lendário (necessário espaço para armazená-lo).',
    },
    {
      'name': 'Ankh',
      'description': 'Cria uma cópia de um Coringa aleatório, mas destrói todos os outros Coringas.',
    },
    {
      'name': 'Aura',
      'description': 'Adiciona o efeito Foil, Holográfico ou Policromático a 1 carta selecionada em sua mão.',
    },
    {
      'name': 'Buraco Negro',
      'description': 'Melhora todas as mãos de pôquer em 1 nível.',
    },
    {
      'name': 'Criptídeo',
      'description': 'Cria 2 cópias de 1 carta selecionada em sua mão.',
    },
    {
      'name': 'Déjà Vu',
      'description': 'Adiciona um Selo Vermelho a 1 carta selecionada em sua mão.',
    },
    {
      'name': 'Ectoplasma',
      'description': 'Adiciona o efeito Negativo a um Coringa aleatório e reduz o tamanho da mão em 1.',
    },
    {
      'name': 'Encantamento',
      'description': 'Destrói 1 carta aleatória da sua mão e adiciona 4 cartas numeradas aprimoradas aleatórias à sua mão.',
    },
    {
      'name': 'Espectro',
      'description': 'Cria um Coringa Raro aleatório, mas reduz seu dinheiro a \$0.',
    },
    {
      'name': 'Familiar',
      'description': 'Destrói 1 carta aleatória da sua mão e adiciona 3 cartas com figuras aprimoradas aleatórias à sua mão.',
    },
    {
      'name': 'Feitiço',
      'description': 'Adiciona o efeito Policromático a um Coringa aleatório e destrói todos os outros Coringas.',
    },
    {
      'name': 'Imolação',
      'description': 'Destrói 5 cartas aleatórias da sua mão e concede \$20.',
    },
    {
      'name': 'Médium',
      'description': 'Adiciona um Selo Roxo a 1 carta selecionada em sua mão.',
    },
    {
      'name': 'Ouija',
      'description': 'Converte todas as cartas da sua mão para um único valor aleatório, reduzindo o tamanho da mão em 1.',
    },
    {
      'name': 'Símbolo',
      'description': 'Converte todas as cartas da sua mão para um único naipe aleatório.',
    },
    {
      'name': 'Sombrio',
      'description': 'Destrói 1 carta aleatória da sua mão e adiciona 2 Áses aprimorados aleatórios à sua mão.',
    },
    {
      'name': 'Talismã',
      'description': 'Adiciona um Selo de Ouro a 1 carta selecionada em sua mão.',
    },
    {
      'name': 'Transe',
      'description': 'Adiciona um Selo Azul a 1 carta selecionada em sua mão.',
    },
  ],
  'Baralhos': [
    {
      'name': 'Baralho Abandonado',
      'description': 'Comece a tentativa sem Cartas de Realeza no seu baralho.',
    },
    {
      'name': 'Baralho Amarelo',
      'description': 'Inicia com mais \$10.',
    },
    {
      'name': 'Baralho Anáglifo',
      'description': 'Após derrotar cada Blind de Chefe, ganhe Marca Dupla.',
    },
    {
      'name': 'Baralho Azul',
      'description': '+1 mão em cada rodada.',
    },
    {
      'name': 'Baralho de Nebulosa',
      'description': 'Comece a tentativa com o cupom de #1# #2# espaço(s) de consumível.',
    },
    {
      'name': 'Baralho de Plasma',
      'description': 'Equilibre Fichas e Multi ao calcular a pontuação para a mão preferida X2 de tamanho base do Blind.',
    },
    {
      'name': 'Baralho do Zodíaco',
      'description': 'Comece a tentativa com 1, 2.',
    },
    {
      'name': 'Baralho Errático',
      'description': 'Todas as Classes e Naipes no baralho são aleatórios.',
    },
    {
      'name': 'Baralho Fantasma',
      'description': 'Cartas Espectrais podem aparecer na loja, comece com uma carta de Feitiço.',
    },
    {
      'name': 'Baralho Mágico',
      'description': 'Comece a tentativa com o cupom de #1# e 2 cópias de #2#.',
    },
    {
      'name': 'Baralho Pintado',
      'description': '+#1# tamanho de mão #2# espaço de Curinga.',
    },
    {
      'name': 'Baralho Preto',
      'description': '+1 Espaço de Curinga -2 mão em cada rodada.',
    },
    {
      'name': 'Baralho Verde',
      'description': 'No fim de cada Rodada: \$2 por Mão restante \$1 por Descarte restante Sem Juros.',
    },
    {
      'name': 'Baralho Vermelho',
      'description': '+1 descarte em cada rodada.',
    },
    {
      'name': 'Baralho Xadrez',
      'description': 'Comece a tentativa com 26 Espadas e 26 Copas no baralho.',
    },
  ],
  'Coringas': [
    {
      'name': '9dades',
      'description': 'Descrição do coringa 9dades...',
    },
    {
      'name': 'A Dupla',
      'description': 'Descrição do coringa A Dupla...',
    },
    {
      'name': 'A Família',
      'description': 'X4 Mult se a mão jogada contiver uma Quadra. ',
    },
    {
      'name': 'A Meia e o Coturno',
      'description': 'Descrição do coringa A Meia e o Coturno...',
    },
    {
      'name': 'A Ordem',
      'description': 'X3 Mult se a mão jogada contiver uma Sequência. ',
    },
    {
      'name': 'A Tribo',
      'description': 'Descrição do coringa A Tribo...',
    },
    {
      'name': 'Acrobata',
      'description': 'X3 Mult na última mão da rodada. ',
    },
    {
      'name': 'Adaga Cerimonial',
      'description': 'Quando o Blind é selecionado.  Destrói o curinga da direita e adiciona, permanentemente, o dobro do valor de venda a esta multi. ',
    },
    {
      'name': 'Ágata Onix',
      'description': 'Cartas jogadas com o naipe de Paus dão +7 Mult. ',
    },
    {
      'name': 'Alcance os Céus',
      'description': 'Descrição do coringa Alcance os Céus...',
    },
    {
      'name': 'Alucinação',
      'description': '1 em 2 chances de criar uma carta de Tarot ao abrir qualquer Pacote de Impulso. ',
    },
    {
      'name': 'Anoitecer',
      'description': 'Reativa as cartas jogadas pontuadoras na mão final da rodada. ',
    },
    {
      'name': 'Astrônomo',
      'description': 'Todas as cartas de Planeta e Pacotes Celestiais na loja são gratuitas. ',
    },
    {
      'name': 'Atalho',
      'description': 'Permite que Sequências sejam feitas com lacunas de 1 valor. ',
    },
    {
      'name': 'Atleta',
      'description': 'Descrição do coringa Atleta...',
    },
    {
      'name': 'Aventureiro',
      'description': 'Descrição do coringa Aventureiro...',
    },
    {
      'name': 'Barão',
      'description': 'Descrição do coringa Barão...',
    },
    {
      'name': 'Bêbado',
      'description': '+1 ao tamanho da mão. ',
    },
    {
      'name': 'Bilhete Dourado',
      'description': 'Jogue uma mão de 5 cartas contendo apenas cartas de Ouro. ',
    },
    {
      'name': 'Boa Ideia',
      'description': 'Descrição do coringa Boa Ideia...',
    },
    {
      'name': 'Bola 8',
      'description': 'Chance de 1 em 4 para cada 8 jogado para criar umas carta de Tarô quando pontuada. ',
    },
    {
      'name': 'Bonificação',
      'description': 'Descrição do coringa Bonificação...',
    },
    {
      'name': 'Cai fora',
      'description': 'Descrição do coringa Cai fora...',
    },
    {
      'name': 'Calças sobressalentes',
      'description': 'Ganha +2 Mult se a mão jogada contiver Dois Pares. ',
    },
    {
      'name': 'Caminhante',
      'description': 'Cada carta jogada ganha permanentemente +5 Fichas ao ser pontuada. ',
    },
    {
      'name': 'Caos, o palhaço',
      'description': '1 atualização(ões) grátis na loja. ',
    },
    {
      'name': 'Carinha Sorridente',
      'description': 'Descrição do coringa Carinha Sorridente...',
    },
    {
      'name': 'Carta Afiada',
      'description': 'Descrição do coringa Carta Afiada...',
    },
    {
      'name': 'Carta de Beisebol',
      'description': 'Cada Curinga Incomum dá X1,5 Mult. ',
    },
    {
      'name': 'Carta de Lealdade',
      'description': 'X4 multi a cada 6 mãos jogadas. ',
    },
    {
      'name': 'Carta de Troca',
      'description': 'Descrição do coringa Carta de Troca...',
    },
    {
      'name': 'Carta Relâmpago',
      'description': 'Descrição do coringa Carta Relâmpago...',
    },
    {
      'name': 'Carta Vermelha',
      'description': 'Descrição do coringa Carta Vermelha...',
    },
    {
      'name': 'Cartão de Crédito',
      'description': 'Tenha até -\$20 em dívida. ',
    },
    {
      'name': 'Cartão de visita',
      'description': 'Ases jogados dão +20 Fichas e +4 Mult ao serem pontuadas. ',
    },
    {
      'name': 'Cartão Presente',
      'description': '+5 tamanho de mão, reduz em 1 a cada rodada. ',
    },
    {
      'name': 'Carteira de Habilitação',
      'description': '+13 Mult para cada Rainha mantida na mão. ',
    },
    {
      'name': 'Cartomante',
      'description': 'X3 Mult se você tiver pelo menos 16 cartas Melhoradas no baralho completo. ',
    },
    {
      'name': 'Castelo',
      'description': 'Reativa todas as cartas jogadas nas próximas 10 mãos. ',
    },
    {
      'name': 'Cavendish',
      'description': 'X3 Mult se a mão de pôquer jogada já tiver sido jogada nesta rodada. ',
    },
    {
      'name': 'Certificado',
      'description': 'No início da rodada, adiciona uma carta de baralho aleatória com um selo aleatório à sua mão. ',
    },
    {
      'name': 'Cola Diet',
      'description': 'Reveja esta carta para criar uma Etiqueta Dupla gratuita. ',
    },
    {
      'name': 'Comprovante',
      'description': 'Descrição do coringa Comprovante...',
    },
    {
      'name': 'Constelação',
      'description': 'Ganha X0,1 Mult por carta de Planeta usada. ',
    },
    {
      'name': 'Curinga',
      'description': '+4 Mult. ',
    },
    {
      'name': 'Curinga Abstrato',
      'description': 'Descrição do coringa Coringa Abstrato...',
    },
    {
      'name': 'Curinga Alegre',
      'description': '+8 Mult se a mão jogada contiver um Par. ',
    },
    {
      'name': 'Curinga Antigo',
      'description': 'X2 Mult, reduz X0,01 Mult por carta descartada. ',
    },
    {
      'name': 'Curinga Astuto',
      'description': '+80 Fichas se a mão jogada contiver uma Dois Pares. ',
    },
    {
      'name': 'Curinga Azul',
      'description': '+2 Fichas para cada carta restante no baralho. ',
    },
    {
      'name': 'Curinga Borrado',
      'description': 'Descrição do coringa Coringa Borrado...',
    },
    {
      'name': 'Curinga de Aço',
      'description': 'Descrição do coringa Coringa de Aço...',
    },
    {
      'name': 'Curinga de Mármore',
      'description': 'Adiciona uma carta de Pedra ao baralho quando seu Blind é selecionado. ',
    },
    {
      'name': 'Curinga de Pedra',
      'description': 'Este Curinga ganha +25 Fichas para cada carta de Pedra no baralho completo. ',
    },
    {
      'name': 'Curinga de Vidro',
      'description': 'Descrição do coringa Coringa de Vidro...',
    },
    {
      'name': 'Curinga Dourado',
      'description': 'Descrição do coringa Coringa Dourado...',
    },
    {
      'name': 'Curinga Engraçado',
      'description': '+10 Mult se a mão jogada contiver um Flush. ',
    },
    {
      'name': 'Curinga Espacial',
      'description': 'Descrição do coringa Coringa Espacial...',
    },
    {
      'name': 'Curinga Esperto',
      'description': 'Descrição do coringa Coringa Esperto...',
    },
    {
      'name': 'Curinga Estampado',
      'description': 'x1 Multi para cada espaço de Curinga vazio (Curinga Estampado incluído). ',
    },
    {
      'name': 'Curinga Excêntrico',
      'description': 'Descrição do coringa Coringa Excêntrico...',
    },
    {
      'name': 'Curinga Furioso',
      'description': 'Cartas jogadas com o naipe de Espada dão +3 Mult ao serem pontuadas. ',
    },
    {
      'name': 'Curinga Ganancioso',
      'description': 'Cartas jogadas com o naipe de Ouros dão +3 Mult quando pontuadas. ',
    },
    {
      'name': 'Curinga Guloso',
      'description': 'Cartas jogadas com o naipe de Paus dão +3 Mult ao serem pontuadas. ',
    },
    {
      'name': 'Curinga Habilidoso',
      'description': 'Descrição do coringa Coringa Habilidoso...',
    },
    {
      'name': 'Curinga Inteligente',
      'description': 'Descrição do coringa Coringa Inteligente...',
    },
    {
      'name': 'Curinga Invisível',
      'description': 'Após 2 rodadas, venda esta carta para duplicar um Curinga aleatório. ',
    },
    {
      'name': 'Curinga Louco',
      'description': 'Descrição do coringa Coringa Louco...',
    },
    {
      'name': 'Curinga Maluco',
      'description': '+12 Mult se a mão jogada contiver uma Sequência. ',
    },
    {
      'name': 'Curinga Pérfido',
      'description': 'Descrição do coringa Coringa Préfido...',
    },
    {
      'name': 'Curinga Plebeu',
      'description': 'Descrição do coringa Coringa Plebeu...',
    },
    {
      'name': 'Curinga Quadrado',
      'description': 'Ganha +4 Fichas se a mão jogada tiver exatamente 4 cartas. ',
    },
    {
      'name': 'Curinga Queimado',
      'description': 'Descrição do coringa Coringa Queimado...',
    },
    {
      'name': 'Curinga Verde',
      'description': '+1 Mult por mão jogada, 1 Mult por descarte. ',
    },
    {
      'name': 'Curinga Vigoroso',
      'description': 'Cartas jogadas com o naipe de Copas dão +3 Mult quando pontuadas. ',
    },
    {
      'name': 'Desconto de correio',
      'description': 'Ganha \$3 para cada Ás descartado;  o valor muda a cada rodada.',
    },
    {
      'name': 'DNA',
      'description': '+100 Fichas -5 Fichas para cada mão jogada. ',
    },
    {
      'name': 'Dublê',
      'description': '+250 Fichas, 2 no tamanho da mão. ',
    },
    {
      'name': 'Erosão',
      'description': '+4 Mult para cada carta abaixo de 52 no baralho completo. ',
    },
    {
      'name': 'Erro de Impressão',
      'description': '+0-22 multi. ',
    },
    {
      'name': 'Estacionamento Reservado',
      'description': 'Cada carta com figura mantida na mão tem 1 em 2 chances de dar \$1. ',
    },
    {
      'name': 'Estandarte',
      'description': '+30 Fichas para cada descarte restante. ',
    },
    {
      'name': 'Estudioso',
      'description': 'Descrição do coringa Estudioso...',
    },
    {
      'name': 'Feijão Preto',
      'description': 'Descrição do coringa Feijão Preto...',
    },
    {
      'name': 'Fibonacci',
      'description': 'Cada Ás, 2, 3, 5 ou 8 jogado concede +8 Mult ao ser pontuado. ',
    },
    {
      'name': 'Fogueira',
      'description': 'Este Curinga ganha X0,5 Mult para cada carta vendida;  o valor é resetado quando o Boss Blind é derrotado. ',
    },
    {
      'name': 'Foguete',
      'description': 'Ganha \$1 ao final da rodada e \$2 adicionais ao derrotar o Boss Blind. ',
    },
    {
      'name': 'Fotografia',
      'description': 'A primeira carta com figura jogada dá X2 Mult ao ser pontuada. ',
    },
    {
      'name': 'Gato Sortudo',
      'description': 'Ganha X0,25 Mult cada vez que uma carta de Sorte é ativada com sucesso. ',
    },
    {
      'name': 'Gratificação atrasada',
      'description': 'Receba \$2 por descarte se nenhum descarte for usado até o final da rodada. ',
    },
    {
      'name': 'Gros Michel',
      'description': '+15 Mult, com 1 em 6 chances de ser destruído ao final da rodada. ',
    },
    {
      'name': 'Holograma',
      'description': 'Cria uma carta de Tarot se a mão jogada tiver \$4 ou menos. ',
    },
    {
      'name': 'Ímpar Imperfeito',
      'description': 'Cartas jogadas com valor impar dão +31 Fichas ao serem pontuadas. ',
    },
    {
      'name': 'Impostor',
      'description': 'Descrição do coringa Impostor...',
    },
    {
      'name': 'Insanidade',
      'description': 'Quando Small Blind ou Big Blind é selecionado, ganha X0,5 Mult e destrói um Curinga aleatório. ',
    },
    {
      'name': 'Jogada de Descartes',
      'description': 'Descrição do coringa Jogada de Descartes...',
    },
    {
      'name': 'Joia Bruta',
      'description': 'Cartas jogadas com o naipe de Ouros ganham \$1 ao serem pontuadas. ',
    },
    {
      'name': 'Ladrão',
      'description': 'Quando Blind é selecionado, ganha +3 Mãos e perde todos os descartes. ',
    },
    {
      'name': 'Lámen',
      'description': 'X2 Mult, reduz X0,01 Mult por carta descartada. ',
    },
    {
      'name': 'Lista de Tarefas',
      'description': 'Ganha \$5 se a mão de pôquer for Dois Pares;  a mão muda ao final da rodada. ',
    },
    {
      'name': 'Luchador',
      'description': 'Descrição do coringa Luchador...',
    },
    {
      'name': 'Malabarista',
      'description': '+1 Mult para cada carta de Tarot usada nesta partida. ',
    },
    {
      'name': 'Máscara de Midas',
      'description': 'Todas as cartas com figuras tornam-se cartas de Ouro ao serem jogadas. ',
    },
    {
      'name': 'Matador',
      'description': 'Descrição do coringa Matador...',
    },
    {
      'name': 'Meio Curinga',
      'description': '+20 multi se a mão jogada contiver 3 ou menos cartas. ',
    },
    {
      'name': 'Mestre do ringue',
      'description': 'Descrição do coringa Mestre do ringue...',
    },
    {
      'name': 'Mímico',
      'description': 'Reativa todas as habilidades das cartas na sua mão. ',
    },
    {
      'name': 'O Ídolo',
      'description': 'Cada Ás de Espadas jogado dá X2 Mult ao ser pontuado (carta muda a cada rodada). ',
    },
    {
      'name': 'O Trio',
      'description': 'X2 Mult se a mão jogada contiver um Par. ',
    },
    {
      'name': 'Obelisco',
      'description': 'Descrição do coringa Obelisco...',
    },
    {
      'name': 'Opa! Tudo 6',
      'description': 'Descrição do coringa Opa! Tudo 6...',
    },
    {
      'name': 'Osmar Vados',
      'description': 'Descrição do coringa Osmar Vados...',
    },
    {
      'name': 'Ovo',
      'description': 'Ganha \$3 de valor de venda ao final da rodada. ',
    },
    {
      'name': 'Para a Lua',
      'description': 'Descrição do coringa Para a Lua...',
    },
    {
      'name': 'Pareidolia',
      'description': 'Todas as cartas são consideradas cartas com figuras. ',
    },
    {
      'name': 'Passear de ônibus',
      'description': '+1 Mult por mão consecutiva jogada sem uma carta com figura pontuada. ',
    },
    {
      'name': 'Pedra de Sangue',
      'description': '1 em 2 chances de cartas jogadas com o naipe de Copas darem X1,5 Mult ao serem pontuadas. ',
    },
    {
      'name': 'Pico Místico',
      'description': '+15 Multi quando 0 descartes restantes. ',
    },
    {
      'name': 'Pipoca',
      'description': '+2 Mult por reroll na loja. ',
    },
    {
      'name': 'Ponta de Flecha',
      'description': 'Cartas jogadas com o naipe de Espadas dão +50 Fichas ao serem pontuadas. ',
    },
    {
      'name': 'Projeto',
      'description': 'Copia a habilidade dos Coringas à direita. ',
    },
    {
      'name': 'Punho Erguido',
      'description': 'Adiciona o dobro da classe da carta de classe mais baixa presente na mão ao Multi. ',
    },
    {
      'name': 'Quadro Negro',
      'description': 'Descrição do coringa Quadro Negro...',
    },
    {
      'name': 'Quatro Dedos',
      'description': 'Todos os Flushes e Sequências podem ser feitos com 4 cartas. ',
    },
    {
      'name': 'Ralé',
      'description': 'Quando Blind é selecionado, cria 2 Coringas Comuns. ',
    },
    {
      'name': 'Realeza Assustadora',
      'description': 'Cartas com figuras jogadas dão +30 Fichas ao serem pontuadas. ',
    },
    {
      'name': 'Retorno',
      'description': 'X0,025 Mult para cada Blind ignorado nesta partida. ',
    },
    {
      'name': 'Satélite',
      'description': 'Ganha \$1 no final da rodada por cada carta de Planeta única usada na partida. ',
    },
    {
      'name': 'Seltzer',
      'description': 'Descrição do coringa Seltzer...',
    },
    {
      'name': 'Senhor Osso',
      'description': 'Previne a Morte se as fichas pontuadas forem pelo menos 25% das fichas necessárias;  se autodestrói.',
    },
    {
      'name': 'Sessão Mediúnica',
      'description': 'Descrição do coringa Sessão Mediúnica...',
    },
    {
      'name': 'Sexto Sentido',
      'description': 'Descrição do coringa Sexto Sentido...',
    },
    {
      'name': 'Sobreposição',
      'description': 'Descrição do coringa Sobreposição...',
    },
    {
      'name': 'Sorvete',
      'description': 'Descrição do coringa Sorvete...',
    },
    {
      'name': 'Splash',
      'description': 'Descrição do coringa Splash...',
    },
    {
      'name': 'Supernova',
      'description': 'Cartas com figuras jogadas têm 1 em 2 chances de dar \$2 ao serem pontuadas. ',
    },
    {
      'name': 'Touro',
      'description': 'Descrição do coringa Touro...',
    },
    {
      'name': 'Trovador',
      'description': 'Descrição do coringa Trovador...',
    },
    {
      'name': 'Vagabundo',
      'description': 'Descrição do coringa Vagabundo...',
    },
    {
      'name': 'Vampiro',
      'description': 'Descrição do coringa Vampiro...',
    },
    {
      'name': 'Vaso de Flores',
      'description': 'Descrição do coringa Vaso de Flores...',
    },
    {
      'name': 'Vidente',
      'description': 'Descrição do coringa Vidente...',
    },
    {
      'name': 'Visão Duplicada',
      'description': 'Descrição do coringa Visão Duplicada...',
    },
    {
      'name': 'Walkie Talkie',
      'description': 'Cada 10 ou 4 jogado dá +10 Fichas e +4 Mult ao ser pontuado. ',
    },
  ],
  'Cartas Celestiais': [
    {
      'name': 'Ceres',
      'description': 'Subir de nível, Flush House, +4 Multi e +40 fichas.',
    },
    {
      'name': 'Éris',
      'description': 'Subir de nível, Flush Five..., +3 Multi, +50 fichas.',
    },
    {
      'name': 'Júpiter',
      'description': 'Subir de nível, Flush, +2 Multi e +15 fichas.',
    },
    {
      'name': 'Marte',
      'description': 'Subir de nível, Quadra, +3 Multi e +30 fichas.',
    },
    {
      'name': 'Mercúrio',
      'description': 'Subir de nível, Par, +1 Multi e +15 fichas.',
    },
    {
      'name': 'Netuno',
      'description': 'Subir de nível, Straight Flush, +4 Multi e +40 fichas.',
    },
    {
      'name': 'Plutão',
      'description': 'Subir de nível, Carta Alta, +1 Multi e +10 fichas.',
    },
    {
      'name': 'Saturno',
      'description': 'Subir de nível, Sequência, +3 Multi, +30 fichas.',
    },
    {
      'name': 'Terra',
      'description': 'Subir de nível, Full House, +2 Multi e +25 fichas.',
    },
    {
      'name': 'Urano',
      'description': 'Subir de nível, Dois Pares, +1 Multi e +20 fichas.',
    },
    {
      'name': 'Vênus',
      'description': 'Subir de nível, Trinca, +2 Multi e +20 fichas.',
    },
    {
      'name': 'Planeta X',
      'description': 'Subir de nível, Five of a Kind, +3 Multi e +35 fichas.',
    },
  ],
};

