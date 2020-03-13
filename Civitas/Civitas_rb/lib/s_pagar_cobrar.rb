# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SPagarCobrar < Sorpresa
    def initialize(valor, texto)
      @valor = valor
      @texto = texto
    end
    
    def aplicarAJugador(actual, todos)
      aplicarAJugador_pagarCobrar(actual, todos)
    end
    
    private
    def aplicarAJugador_pagarCobrar(actual, todos)
        if jugadorCorrecto(actual, todos)
            informe(actual, todos)
            todos[actual].modificarSaldo(@valor)
        end
    end
    
  end
end
