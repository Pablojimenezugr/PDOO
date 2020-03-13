# encoding: utf-8

require_relative 'MazoSorpresa.rb'
require_relative 'Jugador.rb'
require_relative 'Tablero.rb'

module Civitas
    class Sorpresa

      def jugadorCorrecto(actual, todos)
          actual < todos.length && actual >= 0
      end

      def to_s
          "Carta #{@tipo} : #{@texto}"
      end

      private
      def init()
          @valor = -1
          @mazo = nil
          @tablero = nil
          @texto = nil
      end

      protected
      def informe(actual, todos)
        Diario.instance.ocurre_evento("Aplicando sorpresa #{@texto} al jugador #{todos[actual]}")
      end
    end
end
