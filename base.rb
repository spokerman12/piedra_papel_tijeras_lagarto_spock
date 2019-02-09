# = base.rb
#
# Autores:: Daniel Francis 12-10863
# 			Francisco Márquez 12-11163
# 
# == Módulo Base
# Contiene la lógica y estructura de datos de la aplicación.
# Se proveen métodos de simulación para simular partidas
# sin necesidad de hacer uso de la interfaz gráfica.
# 

module Base

# === Clase Jugada
# Representa la noción de jugada ejecutada por un jugador.
# Cuenta con las subclases
# * Roca
# * Papel
# * Tijera
# * Lagarto
# * Spock
# 
# Cada subclase posee un método to_s que lo representa como un string.
# El método puntos(j) retorna una tupla del resultado de una partida
# contra la jugada 'j'. En otras palabras, contiene la lógica esencial
# del juego.

	class Jugada 
		def puntos(j)
			# j es el oponente
			if j.class == self.class
				[0,0]
			elsif j.class == Roca
				if self.class == Tijera
					[0,1]
				elsif self.class == Lagarto
					[0,1]
				elsif self.class == Papel
					[1,0]
				elsif self.class == Spock
					[1,0]
				else
					j.puntos(self).reverse
				end	
			elsif j.class == Papel
				if self.class == Spock
					[0,1]
				elsif self.class == Tijera
					[1,0]
				elsif self.class == Lagarto
					[1,0]
				else
					j.puntos(self).reverse
				end
			elsif j.class == Tijera
				if self.class == Lagarto
					[0,1]
				elsif self.class == Spock
					[1,0]
				else
					j.puntos(self).reverse
				end
			elsif j.class == Lagarto
				if self.class == Spock
					[0,1]
				else
					j.puntos(self).reverse
				end
			else
				j.puntos(self).reverse
			end
		end
	end

	class Roca < Jugada
		def to_s
			print "Roca"
		end
	end

	class Papel < Jugada
		def to_s
			print "Papel"
		end
	end

	class Tijera < Jugada
		def to_s
			print "Tijera"
		end
	end

	class Lagarto < Jugada
		def to_s
			print "Lagarto"
		end
	end

	class Spock < Jugada
		def to_s
			print "Spock"
		end
	end


# === Clase Estrategia
# Representa la noción de un jugador del juego en cuestión.
# Cuenta con las subclases
# * Manual (Para uso a través de la consola)
# * Humano (Para uso a través de la interfaz)
# * Uniforme (Se le provee una lista de las jugadas posibles y escoge)
# * Sesgada (Se le provee una lista de jugadas con nivel de preferencia)
# * Copiar (Copia el último movimiento del oponente)
# * Pensar (Usa una regla aritmética para escoger un movimiento adecuado)
# 
# Cada subclase posee un método to_s que lo representa como un string.
# El método prox retorna una jugada apropiada según la subclase de la estrategia
# y reset reinicia la Estrategia al estado inicial, cuando esto tiene sentido.


	class Estrategia
		def to_s
			puts @nombre
			puts self.class
		end

		def nombre(nombre)
			@nombre = nombre
		end

		def reset
			nil
		end
	end

	class Manual < Estrategia
		def initialize
		end

		def prox
			# Se solicita la jugada a traves de la consola
			puts "1: Roca\n2: Papel\n3: Tijera\n4: Lagarto\n5: Spock"
			jugada = gets
			puts jugada
			case jugada.chomp!
			when "1" 
				Roca.new
			when "2" 
				Papel.new
			when "3" 
				Tijera.new
			when "4" 
				Lagarto.new
			when "5" 
				Spock.new
			else 
				raise "Jugada no válida"
			end
		end
	end

	class Humano < Estrategia
		# Esta subclase es solo para usar con la interfaz gráfica
		def initialize
		end

		def definir_jugada(jugada)
			#Roca.new, por ejemplo
			@jugada = jugada
		end

		def prox
			@jugada
		end
	end


	class Uniforme < Estrategia

		def initialize(lista)
			if lista == nil or lista.length == 0
				raise 'La lista no puede ser vacía'
			end
			@lista = lista.uniq
			@lista_original = @lista
		end

		def prox
			@prox = @lista.sample
			@prox.new
		end

		def reset
			@lista = @lista_original
		end
	end

	class Sesgada < Estrategia

		def initialize(roca,papel,tijera,lagarto,spock)
			@roca = roca
			@papel = papel 
			@tijera = tijera
			@lagarto = lagarto
			@spock = spock
		
			@lista = ([Roca]*@roca) + 
					 ([Papel]*@papel) + 
					 ([Tijera]*@tijera) + 
					 ([Lagarto]*@lagarto) +
					 ([Spock]*@spock)

			@lista_original = @lista
		end

		def prox
			@prox = @lista.sample
			@prox.new
		end

		def reset
			@lista = @lista_original
		end

	end

	class Copiar < Estrategia

		def initialize(jugada)
			@anterior = Roca.new
			@jugada = jugada
			@jugada_original = @jugada
		end
		
		def agregar_jugada(jugada)
			@anterior = jugada
		end

		def prox
			@anterior
		end
	end

	class Pensar < Estrategia
		
		def initialize
			@lista = [Roca]
			@rng = Random.new(42)
			@r,@t,@p,@l,@s = 1,0,0,0,0
		end

		def agregar_jugada(jugada)
			@lista = @lista + [jugada]
			@r = @lista.count(Roca)
			@t = @lista.count(Tijera)
			@p = @lista.count(Papel)
			@l = @lista.count(Lagarto)
			@s = @lista.count(Spock)		
		end

		def prox
			top = @r+@t+@p+@l+@s-1
			resultado = @rng.rand(0..top)

			case resultado
			when 0..@r
				Roca.new
			when @r..(@r+@p)
				Papel.new
			when (@r+@p)..(@r+@p+@t)
				Tijera.new
			when (@r+@p+@t)..(@r+@p+@t+@l)
				Lagarto.new
			else
				Spock.new
			end
		end

		def reset
			@lista = [Roca]
		end
	end

#
# === Clase Partida
#
# Recibe un mapa (hash, en Ruby) de nombres de jugadores como claves
# y estrategias como objetos de las claves.
# Se pueden definir las rondas(n) a jugar o un número a alcanzar con
# alcanzar(n).
#
# Se provee el método to_s para entender qué se está jugando en
# cada ronda, de ser necesario.

	class Partida

		def initialize(map)
			@rondas = 1
			@alcanzar = 1
			if map.length != 2
				raise "Debe haber dos jugadores"
			else
				keys = map.keys
				@s1 = map[keys[0]]
				@s2 = map[keys[1]]

				if not (@s1.class < Estrategia and @s2.class < Estrategia)
					raise "Debe haber alguna estrategia asociada a cada jugador"
				end

				@p1 = [keys[0].to_sym,@s1]
				@p2 = [keys[1].to_sym,@s2]
				@puntos = {@p1 => 0, @p2 => 0}
				@p1[1].nombre(keys[0].to_sym)
				@p2[1].nombre(keys[1].to_sym)
			end
		end

		def to_s
			puts "Jugador 1: #{@p1[0]}\nEstrategia: #{@p1[1]}\nJugador 2: #{@p2[0]}\nEstrategia: #{@p2[1]}"
		end

		def reiniciar
			@rondas = 1
			@alcanzar = 1
			@p1.reset
			@p2.reset
		end

		def rondas(n)
			@rondas = rondas + n
		end

		def alcanzar(n)
			if n < @rondas
				raise "No puede haber un objetivo menor al número de rondas"
			else
				@alcanzar = n
			end
		end

		def jugar
			nil
		end

	end

# ==== Método simular
#
# Se le provee un número de rondas a jugar y, opcionalmente
# un número de rondas ganadas a alcanzar. 
#
# Dentro del método yacen jugadores pre-cargados para facilitar
# la verificación de las estrategias y del funcionamiento del juego
# como tal.
#

	def simular(num_rondas,alcanzar=nil)

		if num_rondas <= 0
			raise "Número de rondas inválido"
		end

		n1 = "Homero"
		e1 = Manual.new

		n2 = "Marge"
		e2 = Uniforme.new([Roca, Papel, Spock])

		n3 = "Maggie"
		e3 = Sesgada.new(1,2,3,1,2)

		n4 = "Bart"
		e4 = Copiar.new(Roca.new)

		n5 = "Lisa"
		e5 = Pensar.new


		# Acá podemos modificar los nombres y
		# las estrategias a gusto.
		# Si queremos una partida de dos estrategias "Manual"
		# podemos asignar:
		# estrategia1 = e1
		# estrategia = e1
		# Luego, basta ejecutar el método

		jugador1 = n2
		jugador2 = n5
		estrategia1 = e1 
		estrategia2 = e3

		partida = Partida.new({jugador1 => estrategia1,
				  		      jugador2 => estrategia2})

		puntuacion = [0,0] 

		i=1
		while i <= num_rondas do
			puts "Ronda #{i}:"
			resultado_ronda = jugar_ronda(jugador1,estrategia1,jugador2,estrategia2) 
			puntuacion = [puntuacion[0]+resultado_ronda[0],puntuacion[1]+resultado_ronda[1]] 
			puts "#{puntuacion}"

			if alcanzar != nil and (puntuacion[0]==alcanzar or puntuacion[1]==alcanzar)
				break
			end 

			i+=1
		end

		if puntuacion[0] > puntuacion[1]
			puts "Gana el jugador 1: #{jugador1}"
		elsif puntuacion[0] < puntuacion[1]
			puts "Gana el jugador 2: #{jugador2}"
		else
			puts "¡Empate!"
		end
	end

# ==== Método jugar_ronda
#
# Simula la ejecución de una única ronda, tomando
# los nombres de los jugadores y sus estrategias.
# Se consideran las jugadas ya "vistas"
# por los jugadores que usan estrategias de 
# Copiar y Pensar
#

	def jugar_ronda(nombre1,estrategia1,nombre2,estrategia2)

		jugada1 = estrategia1.prox
		jugada2 = estrategia2.prox

		if estrategia1.class == Copiar or estrategia1.class == Pensar
			estrategia1.agregar_jugada(jugada2)
		end
		if estrategia2.class == Copiar or estrategia2.class == Pensar
			estrategia2.agregar_jugada(jugada1)
		end

		texto1 = "#{nombre1} juega #{jugada1.class}" 
		texto2 = "y #{nombre2} juega #{jugada2.class}"

		print "#{texto1} #{texto2}\n"

		resultado = jugada1.puntos(jugada2)

	end
end