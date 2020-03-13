
module Civitas
  class SSalirCarcel < Sorpresa
    def initialize (mazo)
      init
      @mazo = mazo
      @texto = "Salir carcel"
    end
    
    
    def aplicarAJugador(actual, todos)
      aplicarAJugador_salirCarcel(actual, todos)
    end
    
    def usada
      @mazo.habilitarCartaEspecial(self)
    end
    
    def salirDelMazo
        
      @mazo.inhabilitarCartaEspecial(self)
        
    end
    
    
    private
    def aplicarAJugador_salirCarcel(actual, todos)
        if jugadorCorrecto(actual, todos)
            informe(actual, todos)
            tiene = false
            for i in (0..todos.length)
                if todos[i].tieneSalvoconducto
                    tiene = true
                end
            end
            if !tiene
                todos[actual].obtenerSalvoconducto(self)
                salirDelMazo()
            end
        end
    end
    
  end
end
