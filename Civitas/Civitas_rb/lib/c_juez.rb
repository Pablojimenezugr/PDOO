# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CJuez < Casilla
    
    def initialize(numCarcel, nombre)
      super(nombre)
      @carcel = numCarcel
    end
    
    def recibeJugador(iactual, todos)
      recibeJugador_juez(iactual, todos)
    end
    
    def recibeJugador_juez(iactual, todos)
        if jugadorCorrecto(iactual, todos)
            todos[iactual].encarcelar(@@carcel)
            informe(iactual, todos)
        end
    end
    
    
  end
end
