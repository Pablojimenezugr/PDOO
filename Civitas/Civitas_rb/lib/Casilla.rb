# encoding: utf-8

require_relative 'Diario.rb'

module Civitas
    class Casilla

        def initialize(nombre)
            init
            @nombre = nombre
        end
        
        attr_reader :nombre, :tituloPropiedad
        
        def getTituloPropiedad
          if @tituloPropiedad != nil
            return @tituloPropiedad
          elsif
            puts "titulo propiedad es null (Casilla.rb)"
          end
          return @tituloPropiedad
        end

        def jugadorCorrecto(iactual, todos)
            iactual >= 0 && iactual < todos.length
        end

        def to_s
            "Casilla #{@nombre}"
        end
        
        protected
        def init
            @@carcel = 0
            @nombre = "sin nombre"
            @importe = 0.0
        end
        
        
        private
        def informe(iactual, todos)
            jug = todos[iactual]
            Diario.instance.ocurre_evento("Ha caido el juador #{iactual}, #{jug.nombre} en la casilla.")
        end
    end
end