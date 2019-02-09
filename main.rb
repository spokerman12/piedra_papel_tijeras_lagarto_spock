# = main.rb
#
# Autores:: Daniel Francis 12-10863
# 			Francisco Márquez 12-11163
# 
# == Módulo principal
# Para usar la aplicación, ejecutar este archivo con
# Ruby Shoes, teniendo los archivos shoes.rb y base.rb 
# en el mismo directorio, además de las imágenes
# correspondientes a las jugadas.


require "./gui"
require "./base"
include Gui, Base


$menu_principal = menu_principal