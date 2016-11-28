local LARGURA_JANELA = 1000
local ALTURA_JANELA = 500

local VELOCIDADE_INICIAL = 7
local velocidade = VELOCIDADE_INICIAL
local ACELERACAO = 0.3

local X_INICIAL_ADVERSARIO = 902
local Y_MINIMO_ADVERSARIO = 177
local Y_VARIACAO_ADVERSARIO = 75

local X_INICIAL_PLAYER = 27

local Y_MINIMO_MOTO = 179
local Y_MAXIMO_MOTO = 300

local X_MAXIMO_MOTO = 427
local X_MINIMO_MOTO = 32

local ALTURA_1_POSICAO = 25

local LARGURA_QUADRADO = 23

local ALTURA_CARRINHO = 73
local LARGURA_CARRINHO = 98
local ALTURA_MOTO = 23
local LARGURA_MOTO = 73
local TEMPO_PARA_MUDANCA_DA_COR_DA_MOTO = 0.05

local QUANTIDADE_ADVERSARIOS = 2

local qtdQuadrados = 0
local quadrados = {} 

local gameOver = false

local recorde = 0
local pontuacao = 0

-- trabalho-07 - coroutine
local mCor

-- Manipulação de arquivos para gravar o recorde
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

-- Geradores de altura aleatória
function gerarAlturaInicialAdversario()
	return Y_MINIMO_ADVERSARIO + math.random(Y_VARIACAO_ADVERSARIO)
end

function gerarAlturaInicialQuadrado()
	return 377 + math.random(0,4) * ALTURA_1_POSICAO
end

-- Geradores de objetos
-- trabalho-07 - closure
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

function CriarAdversario(i)
	local adversario = {}
	-- trabalho-07 - closure
	temp = gerarCarrinhoAdversario( (LARGURA_JANELA) + (LARGURA_JANELA/QUANTIDADE_ADVERSARIOS)*(i-1) )
	adversario.gerar, adversario.x, adversario.y = temp[1], temp[2], temp[3]	
	return adversario
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

function criarQuadrado()
	if (math.random(20) == 1) then
		qtdQuadrados = qtdQuadrados + 1
		quadrados[qtdQuadrados] = {x=-50, y=-50, atualizarPosicao=nil} --inicializei com -50 só pra não correr o risco do quadrado aparecer
		quadrados[qtdQuadrados].atualizarPosicao = math.random(2) == 1 and gerarQuadradoDireita() or gerarQuadradoEsquerda()
	end
end


-- Verificadores de colisão/posição
function verificarColisaoCarrinho(minhaMoto, carAdv)
	return minhaMoto.x < carAdv.x + LARGURA_CARRINHO and
			carAdv.x < minhaMoto.x + LARGURA_MOTO and
			minhaMoto.y < carAdv.y + ALTURA_CARRINHO and
			carAdv.y < minhaMoto.y + ALTURA_MOTO
end

function verificarColisaoQuadrado(quadDir, quadEsq)
	return quadDir.x < quadEsq.x + LARGURA_QUADRADO and
			quadEsq.x < quadDir.x + LARGURA_QUADRADO and
			quadDir.y == quadEsq.y
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

function verificarColisoesAdversarios()
	for i=1, QUANTIDADE_ADVERSARIOS do
		local colidiu = verificarColisaoCarrinho(motoPlayer, Adversarios[i]);
		if colidiu then
			gameOver = true
			tempoFim = os.clock() - tempoInicio
			gravaRecordeNoArquivo();
			break
		end			
	end
end

function verificarQuadradosSairamTela()
	local temp = qtdQuadrados;
	for i=1, qtdQuadrados do
		quadrados[i].x, quadrados[i].y = quadrados[i].atualizarPosicao()
		if ((quadrados[i].x < -LARGURA_QUADRADO) or (quadrados[i].x > LARGURA_JANELA)) then
			table.remove(quadrados, i)
			temp = temp - 1
			break
		end
	end
	qtdQuadrados = temp;
end

-- Verificador de comando do usuário
function verificarInteracaoUsuario()
	while true do
		if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and motoPlayer.y >= Y_MINIMO_MOTO then
			motoPlayer.y = motoPlayer.y - velocidade - 1
		elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") and motoPlayer.y <= Y_MAXIMO_MOTO then
			motoPlayer.y = motoPlayer.y + velocidade + 1
		elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") and motoPlayer.x >= X_MINIMO_MOTO then
			motoPlayer.x = motoPlayer.x - velocidade - 1	
		elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") and motoPlayer.x <= X_MAXIMO_MOTO then
			motoPlayer.x = motoPlayer.x + velocidade + 1
		end
		coroutine.yield()
	end
end

-- Verificador de comando do usuário
local movePlayer = coroutine.wrap(verificarInteracaoUsuario)

local acumulador = 0;

-- trabalho-07 - coroutine
function mudarCor(dt)
	while true do	

		while true do
			if (acumulador > TEMPO_PARA_MUDANCA_DA_COR_DA_MOTO) then
				motoPlayerImg = moto_r
				acumulador = 0
				break
			else
				acumulador = acumulador + dt;
				coroutine.yield()
			end
		end

		while true do
			if (acumulador > TEMPO_PARA_MUDANCA_DA_COR_DA_MOTO) then
				motoPlayerImg = moto_w
				acumulador = 0
				break
			else
				acumulador = acumulador + dt;
				coroutine.yield()
			end
		end		

		while true do
			if (acumulador > TEMPO_PARA_MUDANCA_DA_COR_DA_MOTO) then
				motoPlayerImg = moto_b
				acumulador = 0
				break
			else
				acumulador = acumulador + dt;
				coroutine.yield()
			end
		end		

		

	end
end


function love.load()

	carregaRecordeDoArquivo()

	-- trabalho-07 - coroutine
	mCor = coroutine.wrap(mudarCor);

	love.graphics.setFont(love.graphics.newFont(50))
	moto_r = love.graphics.newImage("/Imagens/Moto73x23_r.png")
	moto_w = love.graphics.newImage("/Imagens/Moto73x23_w.png")
	moto_b = love.graphics.newImage("/Imagens/Moto73x23_b.png")

	motoPlayerImg = moto_b

	policeLogo = love.graphics.newImage("/Imagens/police.png")
	carrinhoAdversarioImg = love.graphics.newImage("/Imagens/CarrinhoFundoTransparenteDir98x73.png")
	quadradoImg = love.graphics.newImage("/Imagens/QuadradoPreto23x23.png")
	explosaoImg = love.graphics.newImage("/Imagens/ExplosaoPequena.png")
	pistaImg = love.graphics.newImage("/Imagens/Pista1000x500.png")

	love.window.setMode(LARGURA_JANELA, ALTURA_JANELA)
	love.window.setTitle("Moto")
	love.window.setIcon(love.image.newImageData("/Imagens/QuadradoPreto45x45.png"))

	tempoInicio = os.clock()

	motoPlayer = {}
	motoPlayer.x = X_INICIAL_PLAYER
	motoPlayer.y = Y_MINIMO_MOTO

	Adversarios = {}

	for i=1,QUANTIDADE_ADVERSARIOS do
		Adversarios[i] = CriarAdversario(i)
	end

end


function love.update(dt)

	velocidade = velocidade + ACELERACAO * dt

	if not gameOver then
		movePlayer()

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

		-- trabalho-07 - coroutine
		mCor(dt);		

	else
		if love.keyboard.isDown("return") then
			tempoInicio = os.clock()
			gameOver = false
			motoPlayer.x = X_INICIAL_PLAYER
			motoPlayer.y = Y_MINIMO_MOTO
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

		love.graphics.draw(motoPlayerImg, motoPlayer.x, motoPlayer.y)
		love.graphics.draw(policeLogo, 460, 30)

		for i=1,QUANTIDADE_ADVERSARIOS do
			love.graphics.draw(carrinhoAdversarioImg, Adversarios[i].x, Adversarios[i].y)
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
