require 'singleton'

module Civitas

    class Dado
        # Este módulo ya proporciona la funcionalidad del patrón Singleton
        # Esto incluye tanto la referencia a la instancia como el consultor de ese atributo
        # También convierte al constructor new en un método privado
        include Singleton

        def initialize
            @debug = false
            @ultimoResultado = 0
            @SalidaCarcel = 5
        end

        attr_accessor :debug

        attr_reader :ultimoResultado

        def tirar
            if !@debug
                @ultimoResultado = rand(6) + 1
                @ultimoResultado
            else
                1
            end
        end

        def salgoDeLaCarcel
            if tirar >= 5
                true
            else 
                false
            end
        end

        def quienEmpieza(numJugadores)
            rand(numJugadores) # [0, numJugadores[
        end

    end
end