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
local ACELERACAO = 0.3

local gameOver = false

local QUANTIDADE_ADVERSARIOS = 2

local qtdQuadrados = 0
local quadrados = {}

local recorde = 0
local pontuacao = 0

--[[

	TRABALHO 5

	O array "quadrados" guarda a coleção dinâmica de objetos pedida neste trabalho.
	Por enquanto, os quadrados não possuem função útil no jogo.

	O escopo desse array (e de seus objetos, por consequência) é local a este arquivo.
	Já seu tempo de vida será o mesmo do programa, sendo alocado na inicialização e desalocado
	no encerramento deste.

	Por outro lado, seus objetos são criados dinâmica e aleatóriamente durante a execução da 
	função love.update, sendo removidos/desalocados na mesma ao colidirem entre si ou ao saírem 
	da tela. 

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
    
	return 
		function ()
			x = x - velocidade

			local carrinhoSaiuDaTela = x < -LARGURA_CARRINHO 

			if carrinhoSaiuDaTela then 
				pontuacao = pontuacao + 1
				x = X_INICIAL_ADVERSARIO
				y = gerarAlturaInicialAdversario()
			end

			return x, y
		end, x, y
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
		quadrados[qtdQuadrados] = {x=-50, y=-50} --inicializei com -50 só pra não correr o risco do quadrado aparecer
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
		Adversarios[i] = {}
		Adversarios[i].gerar, Adversarios[i].x, Adversarios[i].y = gerarCarrinhoAdversario( (LARGURA_JANELA ) + (LARGURA_JANELA/QUANTIDADE_ADVERSARIOS)*(i-1)  )
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
				Adversarios[i].gerar, Adversarios[i].x, Adversarios[i].y = gerarCarrinhoAdversario( (LARGURA_JANELA ) + (LARGURA_JANELA/QUANTIDADE_ADVERSARIOS)*(i-1)  )
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
