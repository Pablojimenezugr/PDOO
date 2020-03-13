

module Civitas
  class SIrCarcel < Sorpresa
    def initialize(tablero)
      @texto = "Vaya inmediatamente a la carcel"
      @tablero = tablero
    end
    
    def aplicarAJugador(actual, todos)
      aplicarAJugador_irACarcel(actual, todos)
    end
    
    private
    def aplicarAJugador_irACarcel(actual, todos)
        if jugadorCorrecto(actual, todos)
            informe(actual, todos)
            todos[actual].encarcelar(@tablero.numCasillaCarcel)
        end
    end
  end
end
