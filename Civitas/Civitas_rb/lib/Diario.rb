# encoding: utf-8

require 'singleton'

module Civitas

    class Diario
        include Singleton

        def initialize
            @eventos = []
        end

        def ocurre_evento(e)
            @eventos << e
        end

        def eventos_pendientes
            @eventos.length > 0
        end

        def leer_evento
            e = @eventos.shift #elimina el primer elemento del vector
            e 
        end
    end
end