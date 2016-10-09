local LARGURA_JANELA = 1000
local ALTURA_JANELA = 500

local X_INICIAL_ADVERSARIO = 902
local X_PLAYER = 27

local ALTURA_1 = 177 
local ALTURA_2 = 252

local ALTURA_CARRINHO = 73
local LARGURA_CARRINHO = 98

local LARGURA_QUADRADO = 23

local VELOCIDADE_INICIAL = 8
local velocidade = VELOCIDADE_INICIAL
local ACELERACAO = 0.3

local gameOver = false

local QUANTIDADE_ADVERSARIOS = 2

local qtdQuadrados = 0
local quadrados = {} 

local recorde = 0
local pontuacao = 0

--[[

	TRABALHO 6

	Identificar no jogo valores de tipos de dados não primitivos
		1. enumeração: love.keyboard.isDown("w")

			Nas funções love.keyboard.isDown (veja o trecho1.1) usamos o enum KeyConstant definido pelo LÖVE2d (veja a documentação: https://love2d.org/wiki/KeyConstant)

			--TRECHO-1.1-----------------------------------
			function verificarInteracaoUsuario()
				if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
					carrinhoPlayer.y = ALTURA_1
				elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
					carrinhoPlayer.y = ALTURA_2			
				end
			end	

		2. registro: elementos da tabela Adversarios
				(finito: os elementos do array Adversario contam somente com os campos "x", "y" e "gerar" — veja o trecho 3.1)
				(não-ordenado: acessamos os valores pelo nome dos seus campos, não pelo seu índice ordenado — veja o trecho 2.1)
				(heterogêneo: nesse elemento guardamos tanto valores numéricos (x e y) quanto uma closure (gerar))

				---TRECHO-2.1-------------------------------
				function CriarAdversario(i)
					local adversario = {}
					temp = gerarCarrinhoAdversario( (LARGURA_JANELA ) + (LARGURA_JANELA/QUANTIDADE_ADVERSARIOS)*(i-1)  )
					adversario.gerar, adversario.x, adversario.y = temp[1], temp[2], temp[3]	
					return adversario
				end

				---TRECHO-2.2-------------------------------
				function love.update(dt)
					-- parte do código foi omitida
					Adversarios = {}

					for i=1,QUANTIDADE_ADVERSARIOS do
						Adversarios[i]=CriarAdversario(i)
					end			
				end

		 
		3. tupla: variável "retorno" é uma tupla (veja o trecho3.1 abaixo)
				(finito: nessa variável armazenamos sempre 3 valores: x,y e uma closure — veja o trecho 3.1)
				(ordenado: acessamos os valores dessa variável por meio de seus índices — veja o trecho2.1: Note que nesse trecho estamos nos referindo à variável temp, que recebe a variável retorno do trecho3.1 )
				(heterogêneo: a variável "retorno" contém 2 inteiros (x e y) e uma closure)

				---TRECHO-3.1---------------------------------
				function gerarCarrinhoAdversario(xInicial)
					local x = xInicial; 
					local y = gerarAlturaInicialAdversario()
					velocidade = VELOCIDADE_INICIAL
				    

					local retorno = {function ()
							x = x - velocidade

							local carrinhoSaiuDaTela = x < -LARGURA_CARRINHO 

							if carrinhoSaiuDaTela then 
								pontuacao = pontuacao + 1
								x = X_INICIAL_ADVERSARIO
								y = gerarAlturaInicialAdversario()
							end

							return x, y
						end, x, y }

					return retorno

				end		


		4. array: quadrados 
				(infinito: em teoria, podemos adicionar quantos quadrados forem necessários. Note, no código, que adicionamos novos elementos enquanto a função update é chamada — veja os trechos 4.1 e 4.2 )
				(ordenado: podemos acessar um quadrado pelo seu índice — veja o trecho 4.1)
				(contíguo: temos índices ordenados)
				(homogêneo: a tabela "quadrados" guarda elementos do mesmo tipo, que é {x,y,atualizarPosicao} )

				---TRECHO-4.1--------------------------------------
				function criarQuadrado()
					if (math.random(20) == 1) then
						qtdQuadrados = qtdQuadrados + 1
						quadrados[qtdQuadrados] = {x=-50, y=-50, atualizarPosicao=nil} --inicializei com -50 só pra não correr o risco do quadrado aparecer
						quadrados[qtdQuadrados].atualizarPosicao = math.random(2) == 1 and gerarQuadradoDireita() or gerarQuadradoEsquerda()
					end
				end			

				---TRECHO-4.2--------------------------------------
				function love.update(dt)
					-- parte do código foi omitida
					criarQuadrado()
					verificarQuadradosSairamTela()
					verificarColisoesQuadrados()				
				end			


]]

function carregaRecordeDoArquivo()
    local f = io.open('recorde.txt', "r")

    local arquivoExiste = f 

    if (arquivoExiste) then
    	recorde = tonumber(f:read("*all"))
    	f:close()
    end
    
 end

function gravaRecordeNoArquivo()
	local f = assert(io.open('recorde.txt','w'))
	f:write(recorde)
	f:flush()
	f:close()
end

function gerarAlturaInicialAdversario()
	return math.random(0,1) == 1 and ALTURA_2 or ALTURA_1
end

function gerarAlturaInicialQuadrado()
	return 377 + math.random(0,4) * 25
end

function gerarCarrinhoAdversario(xInicial)
	local x = xInicial; 
	local y = gerarAlturaInicialAdversario()
	velocidade = VELOCIDADE_INICIAL
    

	local retorno = {function ()
			x = x - velocidade

			local carrinhoSaiuDaTela = x < -LARGURA_CARRINHO 

			if carrinhoSaiuDaTela then 
				pontuacao = pontuacao + 1
				x = X_INICIAL_ADVERSARIO
				y = gerarAlturaInicialAdversario()
			end

			return x, y
		end, x, y }

	return retorno

end

function gerarQuadradoDireita()
	local x = 955
	local y = gerarAlturaInicialQuadrado()

   	return 
		function ()
			x = x - velocidade
			return x, y
		end
end

function gerarQuadradoEsquerda()
	local x = 0
	local y = gerarAlturaInicialQuadrado()

   	return 
		function ()
			x = x + velocidade
			return x, y
		end
end

function verificarColisaoCarrinho(meuCar, carAdv)
	return meuCar.x < carAdv.x + LARGURA_CARRINHO and
			carAdv.x < meuCar.x + LARGURA_CARRINHO and
			meuCar.y == carAdv.y
end

function verificarColisaoQuadrado(quadDir, quadEsq)
	return quadDir.x < quadEsq.x + LARGURA_QUADRADO and
			quadEsq.x < quadDir.x + LARGURA_QUADRADO and
			quadDir.y == quadEsq.y
end

function verificarInteracaoUsuario()
	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		carrinhoPlayer.y = ALTURA_1
	elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		carrinhoPlayer.y = ALTURA_2			
	end
end

function verificarColisoesAdversarios()
	for i=1, QUANTIDADE_ADVERSARIOS do
		local colidiu = verificarColisaoCarrinho(carrinhoPlayer, Adversarios[i]);
		if colidiu then
			gameOver = true
			tempoFim = os.clock() - tempoInicio
			gravaRecordeNoArquivo();
			break
		end			
	end
end

function criarQuadrado()
	if (math.random(20) == 1) then
		qtdQuadrados = qtdQuadrados + 1
		quadrados[qtdQuadrados] = {x=-50, y=-50, atualizarPosicao=nil} --inicializei com -50 só pra não correr o risco do quadrado aparecer
		quadrados[qtdQuadrados].atualizarPosicao = math.random(2) == 1 and gerarQuadradoDireita() or gerarQuadradoEsquerda()
	end
end

function verificarQuadradosSairamTela()
	for i=1, qtdQuadrados do
		quadrados[i].x, quadrados[i].y = quadrados[i].atualizarPosicao()
		if ((quadrados[i].x < -LARGURA_QUADRADO) or (quadrados[i].x > LARGURA_JANELA)) then
			table.remove(quadrados, i)
			qtdQuadrados = qtdQuadrados - 1
			break
		end
	end
end

function CriarAdversario(i)
	local adversario = {}
	temp = gerarCarrinhoAdversario( (LARGURA_JANELA ) + (LARGURA_JANELA/QUANTIDADE_ADVERSARIOS)*(i-1)  )
	adversario.gerar, adversario.x, adversario.y = temp[1], temp[2], temp[3]	
	return adversario
end

function verificarColisoesQuadrados()
	local quadradosBateram
	for i,quadrado in ipairs(quadrados) do 
		quadradosBateram =false
		for j,quadradoD in ipairs(quadrados) do 

			if ((quadrado.x~=nil) and (quadradoD.x~=nil)) then
				quadradosBateram = i ~= j and verificarColisaoQuadrado(quadrado, quadradoD) 
			end

			if quadradosBateram then
				if (i>j) then
					table.remove(quadrados, i)
					table.remove(quadrados, j)
				else
					table.remove(quadrados, j)
					table.remove(quadrados, i)
				end
				qtdQuadrados = qtdQuadrados - 2
				break
			end
		end

	end
end

function love.load()

	carregaRecordeDoArquivo()

	love.graphics.setFont(love.graphics.newFont(50))

	carrinhoPlayerImg = love.graphics.newImage("/Imagens/CarrinhoFundoTransparenteDir98x73.png")
	quadradoImg = love.graphics.newImage("/Imagens/QuadradoPreto23x23.png")
	explosaoImg = love.graphics.newImage("/Imagens/ExplosaoPequena.png")
	pistaImg = love.graphics.newImage("/Imagens/Pista1000x500.png")

	love.window.setMode(LARGURA_JANELA, ALTURA_JANELA)
	love.window.setTitle("Carrinho - 9999 Games")
	love.window.setIcon(love.image.newImageData("/Imagens/QuadradoPreto45x45.png"))

	tempoInicio = os.clock()

	carrinhoPlayer = {}
	carrinhoPlayer.x = X_PLAYER
	carrinhoPlayer.y = ALTURA_1

	Adversarios = {}

	for i=1,QUANTIDADE_ADVERSARIOS do
		Adversarios[i]=CriarAdversario(i)
	end

end


function love.update(dt)

	velocidade = velocidade + ACELERACAO * dt

	if not gameOver then

		verificarInteracaoUsuario()

		verificarColisoesAdversarios()

		for i=1,QUANTIDADE_ADVERSARIOS do
			Adversarios[i].x, Adversarios[i].y = Adversarios[i].gerar()
		end

		criarQuadrado()

		verificarQuadradosSairamTela()

		verificarColisoesQuadrados()

		tempoDecorrido = os.clock() - tempoInicio

		if (pontuacao>recorde)then
			recorde = pontuacao
		end		

	else
		if love.keyboard.isDown("return") then
			tempoInicio = os.clock()
			gameOver = false
			pontuacao = 0
			quadrados = {}
			qtdQuadrados = 0

			for i=1,QUANTIDADE_ADVERSARIOS do
				Adversarios[i] = CriarAdversario(i)
			end
		end
	end

end


function love.draw()

	love.graphics.draw(pistaImg)
	love.graphics.print(string.format("Recorde: %d\n", recorde), LARGURA_JANELA-400, 30)

	if not gameOver then

		love.graphics.draw(carrinhoPlayerImg, X_PLAYER, carrinhoPlayer.y)

		for i=1,QUANTIDADE_ADVERSARIOS do
			love.graphics.draw(carrinhoPlayerImg, Adversarios[i].x, Adversarios[i].y)
		end

		for i=1, qtdQuadrados do
			love.graphics.draw(quadradoImg, quadrados[i].x, quadrados[i].y)
		end

		love.graphics.print(string.format("Tempo: %.2f\n", tempoDecorrido), LARGURA_JANELA-350 , ALTURA_JANELA-100)
		love.graphics.print(string.format("Pontuação: %d\n", pontuacao), 20, 30)		
	else
		love.graphics.draw(explosaoImg, 0, 110)
		love.graphics.print(string.format("Game Over!"), 20, 30)
		love.graphics.print(string.format("Tempo: %.2f\nPontuação: %d", tempoFim, pontuacao), 350, 190)
		love.graphics.print("Pressione ENTER para reiniciar", 100, 410)
	end
end
