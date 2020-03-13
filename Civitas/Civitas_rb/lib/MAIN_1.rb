# encoding: utf-8

require_relative 'CivitasJuego.rb'
require_relative 'VistaTextual.rb'
require_relative 'Controlador.rb'
require_relative 'Dado.rb'

include Civitas # Módulo del proyecto

Dado.instance.debug = true
juego = CivitasJuego.new(["Pablo", "Ana"])
vista = VistaTextual.new
controlador = Controlador.new(juego, vista)

controlador.juega