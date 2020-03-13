# encoding: utf-8

require_relative "Casilla.rb"

require_relative 'Casilla.rb'
require_relative 'CivitasJuego.rb'
require_relative 'Dado.rb'
require_relative 'Diario.rb'
require_relative 'Jugador.rb'
require_relative 'MazoSorpresa.rb'
require_relative 'Operaciones_juego.rb'
require_relative 'Tablero.rb'
require_relative 'TituloPropiedad.rb'
require_relative 'estados_juego.rb'
require_relative 'gestor_estados.rb'
require_relative 'sorpresa.rb'

module Civitas

    class Tablero
        
        
        @@NUM_CASILLAS = 20 # para evitar números mágicos

        def initialize( casillaCarcel )
            if casillaCarcel >= 1 
                @numCasillaCarcel = casillaCarcel
            else
                @numCasillaCarcel = 1
            end
            
            @casillas = Array.new # = [] 
            @porSalida = 0
            @tieneJuez = false
        end
        
        attr_reader :numCasillaCarcel
        
        private # Métodos privados
        def correcto
            @casillas.size > @numCasillaCarcel
        end
        
        def correcto(numCasilla)
            @casillas.size > @numCasillaCarcel && numCasilla >= 0
        end

        public 
        def getPorSalida 
            salida = @porSalida
            if(@porSalida > 0)
                @porSalida -= 1
            end
            salida
        end

        def aniadeCasilla(casilla)
          @casillas << casilla   
        end

        def aniadeJuez
          @tieneJuez = true
        end

        def getCasilla(numCasilla)
            if correcto(numCasilla)
                return @casillas[numCasilla]
            else
                puts "______ Retorno una casilla null ____"
                return nil
            end
        end

        def nuevaPosicion(actual, tirada)
            if @casillas.size() > @numCasillaCarcel;
              nuevaPos = actual + tirada;
                if nuevaPos > @casillas.length
                    nuevaPos = nuevaPos % @@NUM_CASILLAS
                    porSalida += 1
                end
                nuevaPos
            else
                -1
            end
        end

        def calcularTirada(origen, destino)
            pasos = origen - destino
            if pasos < 0
                pasos += casillas.length + 1 # v empieza en 0
            end
            pasos
        end

    end
end
