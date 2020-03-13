
module Civitas
  class CSorpresa < Casilla
    def initialize(mazo, nombre)
      super(nombre)
      @mazo = mazo
    end
    
    def recibeJugador(iactual, todos)
      recibeJugador_sorpresa(iactual, todos)
    end
    
    private
    def recibeJugador_sorpresa(iactual, todos)
        if jugadorCorrecto(iactual, todos)
            @sorpresa = @mazo.siguiente()
            informe(iactual, todos)
            @sorpresa.aplicarAJugador(iactual, todos)
        end
    end
    
  end
end
