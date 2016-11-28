local larguraJanela = love.graphics.getWidth()
local alturaJanela = love.graphics.getHeight()

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function criarBolinha ()
    local x = math.random(0,larguraJanela) 
    local y = 0
    local v = math.random(4,11)

    return
        function ()
            y = y + v
            if (y>alturaJanela) then 
            	y=0
            	x=math.random(0,larguraJanela)
		-- Nome: math.random
		-- Propriedade: biblioteca
		-- Binding time: compilação
		-- Explicação: antes da execução o nosso código é "linkado" à biblioteca math a fim de "obter" a função random.

            	v=math.random(4,11)
            end
            love.graphics.circle("fill", x, y, raio_das_bolinhas, 100);

            return x, y
        end

end

function love.load()

	love.graphics.setFont(love.graphics.newFont(23)) --define o tamanho da fonte que será usada

	gameOver = false

	raio_das_bolinhas = 10

	--define as propriedades da barrinha
	barrinha = {}

	-- Nome: {}
	-- Propriedade: endereço
	-- Binding time: execução
	-- Explicação: o construtor de tabelas do lua ({}) cria uma tabela dinamicamente, 
	--             assim como seus elementos (nesse caso nenhum).


	barrinha.x = 0
	barrinha.y = 500
	barrinha.w = 100
	barrinha.h = 10
	barrinha.v = 6



	--numero de bolinhas que vão ficar caindo durante o jogo
	num_bolinhas = 5

	--array que guarda as propriedades x e y das bolinhas e a própria bolinha. Inicialmente os valores de x e y serão 0.
	bolinhas = {}
	for i=1,num_bolinhas do
		bolinhas[i] = {}
		bolinhas[i].bolinha = criarBolinha()
		-- Nome: bolinhas[i].bolinha
		-- Propriedade: valor
		-- Binding time: execução
		-- Explicação: a cada chamada do método criarBolinha uma nova closure será criada, 
		--             dinamicamente, e seu endereço virará o valor da bolinhas[i].bolinha.
		bolinhas[i].x = 0
		bolinhas[i].y = 0
	end

end


function love.update()

	--mover barra
	--se o jogador perder, não pode movimentar mais a barra
	if (not gameOver) then
			-- Nome: not
			-- Propriedade: semântica
			-- Binding time: design
			-- Explicação: durante a design foi decidido que "not" seria uma palavra 
			--             reservada e que significaria um operador de negação, negando 
			--             tudo que estiver escrito depois dele. 
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
			barrinha.x = barrinha.x + barrinha.v;
			-- Nome: +
			-- Propriedade: semântica
			-- Binding time: compilação
			-- Explicação: durante a compilação é decidida qual a implementação do operador +, 
			--             isto é, como o operador irá funcionar. Isso depende dos operandos.
		elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			barrinha.x = barrinha.x - barrinha.v;			
		end
	end

	--checa colissão da barrinha com as bolinhas
	colissao = false
	for i=1,num_bolinhas do
		-- Nome: for
		-- Propriedade: semântica
		-- Binding time: design
		-- Explicação: O(s) criador(es) da linguagem decidiram que "for" seria uma palavra reservada 
		--            que faz parte da sintaxe do loop de repetição "for".

		colissao = colissao or CheckCollision(barrinha.x, barrinha.y, barrinha.w, barrinha.h, bolinhas[i].x, bolinhas[i].y, raio_das_bolinhas*2, raio_das_bolinhas*2)
	end

	if (colissao) then
		gameOver = true
	end

end

function love.draw()

	-- desenha a barrinha
	love.graphics.rectangle("fill", barrinha.x, barrinha.y, barrinha.w, barrinha.h )
						  --Drawmode mode, x, y,      width,    height

	-- chama a closure de cada bolinha e guarda as propriedades x e y de cada uma, importantes para checar a colisão.
	for i=1,num_bolinhas do
		bolinhas[i].x, bolinhas[i].y = bolinhas[i].bolinha()
	end

	if (gameOver) then
		love.graphics.print("Game over :(", 320, 50)
	end


end
