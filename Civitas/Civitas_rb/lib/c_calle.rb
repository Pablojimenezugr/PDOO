
module Civitas
  class CCalle < Casilla
    def initialize(tituloPropiedad)
      super(tituloPropiedad.nombre)
      @tituloPropiedad = tituloPropiedad
    end
    
    attr_reader :tituloPropiedad
    
    def recibeJugador(iactual, todos)
      recibeJugador_calle(iactual, todos)
    end
    
    private
    def recibeJugador_calle(iactual, todos) 
      if jugadorCorrecto(iactual, todos)
          informe(iactual, todos)
          jugador = todos[iactual]

          if(!@tituloPropiedad.tienePropietario())
              jugador.puedeComprarCasilla()
          else
              @tituloPropiedad.tramitarAlquiler(jugador);
          end
      end
    end
    
  end
end
