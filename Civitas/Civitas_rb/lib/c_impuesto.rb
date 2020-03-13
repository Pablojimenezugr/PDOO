# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CImpuesto < Casilla
    def initialize(cantidad, nombre)
      super(nombre)
      @importe = cantidad
    end
    
    def recibeJugador(iactual, todos)
      recibeJugador_impuesto(iactual, todos)
    end
    
    private
    def recibeJugador_impuesto(iactual, todos)
      if jugadorCorrecto(iactual, todos) 
          todos[iactual].pagaImpuesto(@importe)
          informe(iactual, todos)
      end
  end
    
  end
end
