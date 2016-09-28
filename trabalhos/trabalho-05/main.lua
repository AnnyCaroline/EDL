local LARGURA_JANELA = 1000
local ALTURA_JANELA = 500

local X_INICIAL_ADVERSARIO = 902
local X_PLAYER = 27

--Um inimigo pode estar somente em duas posições em y. 
--As duas variáveis abaixo somente definem essas duas posições.
local ALTURA_1 = 177 
local ALTURA_2 = 252

local ALTURA_CARRINHO = 73
local LARGURA_CARRINHO = 98

local VELOCIDADE_INICIAL = 7
local ACELERACAO = 0.3

local gameOver = false

local QUANTIDADE_ADVERSARIOS = 2

local recorde = 0
local pontuacao = 0

 function carregaRecordeDoArquivo()
 	--Retorna o valor de record. 
 	--Caso o arquivo seja aberto corretamente e o valor que tenha nele seja um inteiro, retornamos o valor.
 	--Caso contrário, retorna-se 0.
    local f = io.open('recorde.txt', "r")

    local arquivoExiste = f 
    --no lua, quando uma função falha, retorna nil em seu primeiro parâmentro 
    --(veja https://groups.google.com/forum/#!topic/lua-br/FbteIfNHdF8)
    --Em suma, quando não conseguimos ler o arquivo, o record continua com 0 (seu valor default)
    --Na hora de gravar a variável record no arquivo um arquivo já é criado automaticamente.

    if (arquivoExiste) then
    	recorde = tonumber(f:read("*all")) --pega o único valor presente no arquivo, o recorde
    	f:close() --fecha o arquvio
    end
    
 end

function gravaRecordeNoArquivo()
	--grava a variável record no arquivo para que, quando o jogo for reaberto, o valor seja carregado.
	--note que o arquivo será criado caso ele não exista
	local f = assert(io.open('recorde.txt','w'))
	f:write(recorde)
	f:flush()
	f:close()
end

function gerarAlturaInicial()
	--essa função retorna um valor de y aleatório.
	--note que em nosso programa o y de qualquer carrinho pode assumir somente 2 valores, definidos nas constantes ALTURA_1 e ALTURA_2

	return math.random(0,1) == 1 and ALTURA_2 or ALTURA_1
	-- Funciona como operador ternário: (posicao == 1) ? ALTURA_2 : ALTURA 1	
end

function gerarCarrinhoAdversario(xinicial)
	local x = xinicial; 
	local y = gerarAlturaInicial()
	velocidade = VELOCIDADE_INICIAL --reinicia a velocidade. Isso acontece toda a vez que o jogo começa ou quando o jogo reinicia
    
	return 
		function ()
			x = x - velocidade

			local carrinhoSaiuDaTela = x < -LARGURA_CARRINHO 

			if carrinhoSaiuDaTela then 
				pontuacao = pontuacao+1 -- + um ponto para o usuario
				x = X_INICIAL_ADVERSARIO --quando chega no final, volta para o início
				y = gerarAlturaInicial() --define se o carrinho fica embaixo ou em cima.
			end

			return x, y
		end, x, y
end


function verificarColisao(meuCar, carAdv)
	return meuCar.x < carAdv.x + LARGURA_CARRINHO and
			carAdv.x < meuCar.x + LARGURA_CARRINHO and
			meuCar.y == carAdv.y
end

function love.load()

	-- Ler record gravado no arquivo
	carregaRecordeDoArquivo()

	--- Define o tamanho da fonte usada
	love.graphics.setFont(love.graphics.newFont(50))

	-- Carrega imagens
	carrinhoPlayerImg = love.graphics.newImage("/Imagens/CarrinhoFundoTransparenteDir98x73.png")
	carrinhoAdversarioImg = love.graphics.newImage("/Imagens/CarrinhoFundoTransparenteEsq98x73.png")
	explosaoImg = love.graphics.newImage("/Imagens/ExplosaoPequena.png")
	pistaImg = love.graphics.newImage("/Imagens/Pista1000x500.png")

	-- Ajusta a janela
	love.window.setMode(LARGURA_JANELA, ALTURA_JANELA)
	love.window.setTitle("Carrinho - 9999 Games")
	love.window.setIcon(love.image.newImageData("/Imagens/QuadradoPreto1x1.png"))

	--- Inicia o contador de tempo
	tempoInicio = os.clock()

	-- Cria o carrinho do jogador
	carrinhoPlayer = {}
	carrinhoPlayer.x = X_PLAYER
	carrinhoPlayer.y = ALTURA_1

	--cria o array de adversarios
	Adversarios = {};

	-- Cria os carrinhos dos adversários	
	for i=1,QUANTIDADE_ADVERSARIOS do
		Adversarios[i] = {}
		Adversarios[i].gerar, Adversarios[i].x, Adversarios[i].y = gerarCarrinhoAdversario( (LARGURA_JANELA ) + (LARGURA_JANELA/QUANTIDADE_ADVERSARIOS)*(i-1)  )
	end

end


function love.update(dt)

	velocidade = velocidade + ACELERACAO*dt

	if not gameOver then
		-- Controla a posição do carrinho do jogador
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			carrinhoPlayer.y = ALTURA_1
		elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			carrinhoPlayer.y = ALTURA_2			
		end

		-- Verifica se o jogo acabou
		for i=1,QUANTIDADE_ADVERSARIOS do
			colidiu = verificarColisao(carrinhoPlayer, Adversarios[i]);
			if colidiu then
				gameOver = true
				tempoFim = os.clock() - tempoInicio
				-- Calcula o recorde
				gravaRecordeNoArquivo();
				break;
			end			
		end

		--atualiza a posição dos adversários
		for i=1,QUANTIDADE_ADVERSARIOS do
			Adversarios[i].x, Adversarios[i].y = Adversarios[i].gerar()
		end

		-- Calcula tempo decorrido
		tempoDecorrido = os.clock() - tempoInicio

		-- Calcula o recorde
		if (pontuacao>recorde)then
			recorde = pontuacao
		end		

	else
		-- Possibilita reiniciar o jogo
		if love.keyboard.isDown("return") then -- return ==ger enter
			tempoInicio = os.clock()
			gameOver = false
			pontuacao = 0

			for i=1,QUANTIDADE_ADVERSARIOS do
				Adversarios[i].gerar = gerarCarrinhoAdversario( (LARGURA_JANELA ) + (LARGURA_JANELA/QUANTIDADE_ADVERSARIOS)*(i-1)  )
			end
		end
	end

end


function love.draw()
	-- Desenha a pista
	love.graphics.draw(pistaImg)

	--imprime o recorde
	love.graphics.print(string.format("Recorde: %d\n", recorde), LARGURA_JANELA-400, 30)

	-- Mostra o tempo decorrido, pontuacao, desenha o player e o adversário
	if not gameOver then
		
		--desenha o tempo decorrido
		love.graphics.print(string.format("Tempo: %.2f\n", tempoDecorrido), LARGURA_JANELA-350 , ALTURA_JANELA-100)

		--desenha a pontuacao
		love.graphics.print(string.format("Pontuação: %d\n", pontuacao), 20, 30)

		--desenha o carrinho do player
		love.graphics.draw(carrinhoPlayerImg, X_PLAYER, carrinhoPlayer.y)

		--desenha o carrinho dos adversários
		for i=1,QUANTIDADE_ADVERSARIOS do
			love.graphics.draw(carrinhoAdversarioImg, Adversarios[i].x, Adversarios[i].y)
		end

	-- Exibe explosao, tempo total de jogo, pontuação e mensagem de reinício
	else
		love.graphics.draw(explosaoImg, 0, 110)
		love.graphics.print(string.format("Game Over!"), 20, 30)
		love.graphics.print(string.format("Tempo: %.2f\nPontuação: %d", tempoFim, pontuacao), 350, 190)
		love.graphics.print("Pressione ENTER para reiniciar", 100, 410)
	end
end
