# = gui.rb
#
# Autores:: Daniel Francis 12-10863
# 			Francisco Márquez 12-11163
# 
# == Módulo Gui
# Contiene la interfáz gráfica de la aplicación.
# Se pueden jugar partidas de un solo jugador
# o de a dos.
# Las simulaciones se reservan para la cónsola, por ahora.
# También se permite jugar una sola ronda. (Por esto, el
# jugador que "Copia" siempre jugará Roca)
# 

module Gui

# === Método menu_principal
#
# Le muesta al usuario las opciones disponibles
#

	def menu_principal
		Shoes.app(title: "RPTLS. ver. 0.1",
		   width: 400, height: 200, resizable: false) {
		     background white
		     $ventana_resultado && $ventana_resultado.close
		     flow :width => "100%", :margin => 10 do
		     	para "Menu principal"
		     end
		     flow :width => "100%", :margin => 10 do
		     	stack :width => "50%" do
		     		button "Un jugador", :width => "100%", :margin => 10 do
		     			$elegir_oponente = elegir_oponente
		     		end
		     		button "Dos jugadores", :width => "100%", :margin => 10 do
		     			$interfaz_manual_2 = interfaz_manual_2
		     		end
		     	end
		     	stack :width => "50%" do
		     		button "Simulación", :width => "100%", :margin => 10 do
		     			alert "Solo disponible por cónsola. Leer el manual, por favor"
		     		end
		     		button "Salir", :width => "100%", :margin => 10 do
		     			Shoes.exit 
		     		end
		     	end
		     end 
	
		}	
	end

# === Método elegir_oponente
#
# Le permite al jugador único elegir la estrategia
# de su oponente.
#

	def elegir_oponente
	Shoes.app(title: "RPTLS. ver. 0.1",
		   width: 400, height: 200, resizable: false) {
		     background white
		     @s1 = Humano.new
		     $menu_principal && $menu_principal.close
		     flow :width => "100%", :margin => 10 do
		     	para "Elige a tu oponente"
		     end
		     flow :width => "100%", :margin => 10 do
		     	stack :width => "50%" do

		     		# Designación de los comportamientos
		     		# o estrategias de la computadora. 
		     		
		     		button "Uniforme", :width => "100%", :margin => 10 do
		     			
		     			# Podemos alterar la lista de opciones disponibles
		     			# Por ejemplo, en vez de  [Roca, Papel, Tijera, Lagarto, Spock]
		     			# podemos colocar [Roca, Spock]

		     			@s2 = Uniforme.new([Roca, Papel, Tijera, Lagarto, Spock])
		     			$interfaz_manual_1 = interfaz_manual_1("Jugador1",@s2)
		     		end

		     		button "Predecible (sesgado)", :width => "100%", :margin => 10 do
		     			
						# Podemos cambiar la quíntupla
						# para alterar la preferencia
						# de jugadas en orden:
						# (Roca, papel, tijera, lagarto, Spock)	

		     			@s2 = Sesgada.new(4,2,3,1,2)
		     			$interfaz_manual_1 = interfaz_manual_1("Jugador1",@s2)
		     		end
		     	end
		     	stack :width => "50%" do
		     		button "Copión", :width => "100%", :margin => 10 do
		     			@s2 = Copiar.new(Roca.new)
		     			$interfaz_manual_1 = interfaz_manual_1("Jugador1",@s2)
		     		end
		     		button "Pensador", :width => "100%", :margin => 10 do
		     			@s2 = Pensar.new
		     			$interfaz_manual_1 = interfaz_manual_1("Jugador1",@s2) 
		     		end
		     	end
		     end 
		}	
	end		

# === Método interfaz_manual_1
#
# Interfaz que muestra las jugadas posibles para un jugador humano
# cuyo oponente ya tiene estrategia designada 
#.

	def interfaz_manual_1(nombre,estrategia_computadora,oponente=:Computadora,dos_jugadores=false)
		Shoes.app(title: "RPTLS. ver. 0.1",
		   width: 400, height: 200, resizable: false) {
		     background white

		     @n1 = nombre
		     @n2 = oponente
		     @s1 = Humano.new
		     @s2 = estrategia_computadora

		    if not dos_jugadores
		    	$elegir_oponente.close
		    else
				$interfaz_manual_2.close
			end

		     flow :width => "100%", :margin => 10 do
		     	para "Escoge tu jugada #{nombre}"
		     end
		   		flow :width => "20%", :margin => 10 do
		   			stack do 
				    	image "roca.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60,
				     				      :click => nil
				     	button "Roca", :width => 60,
				     				   :margin => 10 do
				     				   @s1.definir_jugada(Roca.new)
				     				   $ventana_resultado = ventana_resultado(@n1,@s1,@n2,@s2)
				     				   end
				     end
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do
				     	image "papel.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
				     	button "Papel", :width => 60,
				     				   :margin => 10 do
				     				   @s1.definir_jugada(Papel.new)
				     				   $ventana_resultado = ventana_resultado(@n1,@s1,@n2,@s2)
				     				   end
				     end
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do 	
				     	image "tijera.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
						button "Tijera", :width => 60,
				     				   :margin => 10 do
				     				   @s1.definir_jugada(Tijera.new)
				     				   $ventana_resultado = ventana_resultado(@n1,@s1,@n2,@s2)
				     				   end
				    end		     				      
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do 	
				     	image "lagarto.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
						button "Lagarto", :width => 60,
				     				   :margin => 10 do
				     				   @s1.definir_jugada(Lagarto.new)
				     				   $ventana_resultado = ventana_resultado(@n1,@s1,@n2,@s2)
				     				   end
				    end		     				      
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do 	
				     	image "spock.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
						button "Spock", :width => 60,
				     				   :margin => 10 do
				     				   @s1.definir_jugada(Spock.new)
				     				   $ventana_resultado = ventana_resultado(@n1,@s1,@n2,@s2)
				     				   end
				    end		     				      
			    end
		 }
	end 

# === Método interfaz_manual_2
#
# Interfaz que muestra las jugadas posibles para un jugador humano
# cuyo oponente NO TIENE AÚN estrategia designada 
#

	def interfaz_manual_2
		Shoes.app(title: "RPTLS. ver. 0.1",
		   width: 400, height: 200, resizable: false) {
		   			    
		     background white
		     @s2 = Humano.new
		     $menu_principal && $menu_principal.close

		     flow :width => "100%", :margin => 10 do
		     	para "Escoge tu jugada Jugador1"
		     end
		   		flow :width => "20%", :margin => 10 do
		   			stack do 
				    	image "roca.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60,
				     				      :click => nil
				     	button "Roca", :width => 60,
				     				   :margin => 10 do
				     				   @s2.definir_jugada(Roca.new)
		     						   $interfaz_manual_1 = interfaz_manual_1("Jugador2",@s2,:Jugador1,true)
				     				   end
				     end
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do
				     	image "papel.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
				     	button "Papel", :width => 60,
				     				   :margin => 10 do
				     				   @s2.definir_jugada(Papel.new)
		     						   $interfaz_manual_1 = interfaz_manual_1("Jugador2",@s2,:Jugador1,true)
				     				   end
				     end
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do 	
				     	image "tijera.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
						button "Tijera", :width => 60,
				     				   :margin => 10 do
				     				   @s2.definir_jugada(Tijera.new)
		     						   $interfaz_manual_1 = interfaz_manual_1("Jugador2",@s2,:Jugador1,true)
				     				   end
				    end		     				      
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do 	
				     	image "lagarto.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
						button "Lagarto", :width => 60,
				     				   :margin => 10 do
				     				   @s2.definir_jugada(Lagarto.new)
		     						   $interfaz_manual_1 = interfaz_manual_1("Jugador2",@s2,:Jugador1,true)
				     				   end
				    end		     				      
			    end
			    flow :width => "20%", :margin => 10 do
				    stack do 	
				     	image "spock.jpg", :radius => 12,
				     				   	  :width => 60,
				     				      :height => 60
						button "Spock", :width => 60,
				     				   :margin => 10 do
				     				   @s2.definir_jugada(Spock.new)
		     						   $interfaz_manual_1 = interfaz_manual_1("Jugador2",@s2,:Jugador1,true)
				     				   end
				    end		     				      
			    end
		 }
	end

# === Método ventana_resultado
#
# Interfaz que muestra el resultado de la ronda
# jugada por ambos jugadores. Permite jugar de nuevo o salir.
#

	def ventana_resultado(nombre1,estrategia1,nombre2,estrategia2)
		Shoes.app(title: "RPTLS. ver. 0.1",
		   width: 400, height: 180, resizable: false) {
		     background white
		     @resultado = jugar_ronda(nombre1,estrategia1,nombre2,estrategia2)
	     	 if $interfaz_manual_1 
	     	 	$interfaz_manual_1.close
	     	 else
	     	    $interfaz_manual_2.close
	     	end
		     flow :width => "100%", :margin => 10 do
		     	if @resultado == [1,0] 
		     		para "¡Gana #{nombre1}!"
		     	elsif @resultado == [0,1]
		     		para "¡Gana #{nombre2}!"
		     	else
		     		para "¡Empate!"
		     	end
		     end
		     flow :width => "100%", :margin => 10 do
		     	button "Volver a jugar", :width => "50%", :margin => 10 do 
		     		$menu_principal = menu_principal
		     		return
		     	end
		     	button "Salir", :width => "50%", :margin => 10 do
		     		Shoes.exit
		     	end
			 end
		}
	end
end
