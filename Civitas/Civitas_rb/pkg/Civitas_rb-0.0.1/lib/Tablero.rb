# encoding: utf-8

require_relative "Casilla"

module Civitas

    class Tablero
        
        def initialize casillaCarcel
            if casillaCarcel >= 1 
                @numCasillaCarcel = casillaCarcel
            else
                @numCasillaCarcel = 1
            end
            
            @casillas = Array.new # = [] 
            @casillas << Casilla.new("Salida")
            @porSalida = 0
            @tieneJuez = false
        end
        
        attr_accessor :numCasillaCarcel, :numCasillaCarcel
        
        private # Métodos privados
        def correcto
            @casillas.size > @numCasillaCarcel
        end
        
        def correcto(numCasilla)
            @casillas.size > @numCasillaCarcel && numCasilla >= 0
        end

        public # Métodos públicos
        def getPorSalida 
            
            salida = @porSalida
            if(@porSalida > 0)
                @porSalida -= 1
            end
            return salida

        end

        def aniadeCasilla(casilla)
            
            if @casillas.length == @numCasilla
                @casillas << Casilla.new("Cárcel")
                @casillas << casilla
            end

            while @casillas.length == @numCasilla
                @casillas << Casilla.new("Cárcel")
            end
            
        end

        def aniadeJuez
            if !@casillas.include? Casilla.new("Juez")
                @casillas << Casilla.new("Juez")
                @tieneJuez = true
            end
        end

        def getCasilla (numCasilla)
            if correcto(numCasilla)
                return casillas[numCasilla]
            else
                return nil
            end
        end

        def nuevaPosicion(actual, tirada)
            
            nuevaPos = actual + tirada

            if nuevaPos > @casillas.length
                nuevaPos -= @casillas.length
                @porSalida += 1
            end

            nuevaPos
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
