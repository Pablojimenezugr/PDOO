# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SIrCasilla < Sorpresa
    def initialize(tab, valor, texto)
      @tablero = tab
      @valor = valor
      @texto = texto
    end
    
    
    def aplicarAJugador(actual, todos)
      aplicarAJugador_irACasilla(actual, todos)
    end
    
    private
    def aplicarAJugador_irACasilla(actual, todos)
        if jugadorCorrecto(actual, todos)
            informe(actual, todos)
            casillaActual = todos[actual].numCasillaActual
            tirada = @tablero.calcularTirada(casillaActual, @valor)

            todos[actual].moverACasilla(@tablero.nuevaPosicion(casillaActual, tirada))
        end
    end
    
  end
end
