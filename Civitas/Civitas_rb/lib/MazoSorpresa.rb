# encoding: utf-8


module Civitas

    class MazoSorpresas

        def initialize(debug=false)
            @debug = debug
            init
        end

        private
        def init
            @sorpresas = Array.new
            @cartasEspeciales = Array.new
            @barajada = false
            @usadas = 0
        end

        public
        def alMazo(sorpresa)
            if !@barajada
                @sorpresas << sorpresa
            end
        end

        def siguiente()
            
            if ( !@barajada || @usadas == @sorpresas.length )
              if ( !@debug )
                @sorpresas.shuffle
                @barajada = true
                @usadas = 0
              end
            end

            @usadas += 1
            first = @sorpresas.shift #.remove(0)
            @sorpresas << first

            @ultimaSorpresa = first
        
            return @ultimaSorpresa
        end

        def inhabilitarCartaEspecial(sorpresa)
            indiceBuscado = @sorpresas.index(sorpresa)
            if indiceBuscado != -1 # TODO: puede devolver .index {-1} si no encuentra el elemento en el array?
                @cartasEspeciales << sorpresa
                @sorpresas.delete_at(indiceBuscado)
                Diario.instance.ocurreEvento("Se añade una sorpresa a las cartas especiales")
            end
        end

        def habilitarCartaEspecial(sorpresa)
            indiceBuscado = @cartasEspeciales.index(sorpresa)
            if indiceBuscado != -1
                @sorpresas << sorpresa
                @cartasEspeciales.remove(indiceBuscado)
                Diario.instance.ocurreEvento("Se añade una sorpresa especial a las cartas _normales_")
            end
        end

    end
end