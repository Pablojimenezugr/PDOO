# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class JugadorEspeculador < Jugador
    
    @@FACTORESPECULADOR = 2
    
    
    def initialize(otro, fianza)
      super(otro)
      @fianza = fianza
      for p in @propiedades
        p.actualizaPropietarioPorConversion(self)
      end
    end
  
    def getCasasMax 
       @@CasasMax * @@FACTORESPECULADOR
    end
    
    def getHotelesMax
      @@HotelesMax * @@FACTORESPECULADOR
    end
    
    def pagaImpuesto(cantidad)
      if !@encarcelado
        return paga( cantidad / 2 )
      else
        return false
      end
    end
    
    def encarcelar(numCasillaCarcel)
      if debeSerEncarcelado() 
        moverACasilla(numCasillaCarcel)
        @encarcelado = true
        Diario.instance.ocurre_evento("Se ha encarcelado al jugadore #{@nombre}") 
      end
      return @encarcelado
    end
   
    def to_s
      "__JugadorEspecualdor__\n #{@nombre} con #{@saldo}EUR en la casilla #{@numCasillaActual}"
    end
    
    protected 
    def debeSerEncarcelado()
      salida = false
      if @encarcelado
        return salida
      elsif !tieneSalvoconducto()
        puts "El jugadorEspeculador sale de la carcel pagando"
        return salirCarcelPagando()
      elsif tieneSalvoconducto()
        perderSalvoConducto()
        Diario.instance.ocurre_evento("Se ha salvado de la carcel por tener un salvoconducto")
        return salida
      end
      return salida
    end
    
    
    
    
  end
end
