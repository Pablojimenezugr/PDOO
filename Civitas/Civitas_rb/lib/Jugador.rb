# encoding: utf-8

module Civitas
    class Jugador
      
        @@CasasMax       = 4
        @@CasasPorHotel  = 4
        @@HotelesMax     = 4
        @@PasoPorSalida  = 1000
        @@PrecioLibertad = 200
        @@saldoInicial   = 7500

        def initialize(nombre)
            @nombre = nombre
            @propiedades = []
            @saldo = @@saldoInicial

            @numCasillaActual = 0
            @puedeComprar = true
            @encarcelado = false
            @salvoconducto = nil
        end

        attr_reader :nombre, :numCasillaActual, :saldo, :encarcelado
        
        public
        def puede_comprar
          if !@encarcelado 
            @puedeComprar = true
          else
            @puedeComprar = false
          end
          return @puedeComprar
        end
        
        def self.CasasMax
            @@CasasMax
        end

        def self.CasasPorHotel
            @@CasasPorHotel
        end

        def self.HotelesMax
            @@HotelesMax
        end

        def self.PrecioLibertad
            @@PrecioLibertad
        end

        def self.PasoPorSalida
            @@PasoPorSalida
        end

        private_class_method :CasasMax, :CasasPorHotel, :HotelesMax, :PrecioLibertad, :PasoPorSalida

        def hipotecar(ip)
            result = false
            if(@encarcelado) 
                return result
            else 
                if(existeLaPropiedad(ip))
                    propiedad = @propiedades[ip]
                    
                    result = propiedad.hipotecar(self)
                 
                end
            end

            if(result) 
                Diario.instance.ocurre_evento("El jugador #{@nombre} hipoteca la propiedad #{ip}")
            end
            return result
        end

        def isEncarcelado
            @encarcelado
        end

        def cancelarHipoteca(ip)
            result = false
            if @encarcelado 
                return result
            else 
                if existeLaPropiedad(ip) 
                    propiedad = @propiedades[ip]
                    cantidad = propiedad.getImporteCancelarHipoteca()
                    puedoGastar = puedoGastar(cantidad)
                
                    if puedoGastar
                        result = propiedad.cancelarHipoteca(self)
                        if result
                            Diario.instance.ocurreEvento("El jugador " + nombre + " cancela la hipoteca de la propiedad " + ip)
                        end
                    end
                end
            end
            result
        end

        def cantidadCasasHoteles
            sum = 0
            for i in @propiedades
                if i != nil
                    sum += i.numCasas + i.numHoteles
                end
            end
            sum
        end

        def comprar(titulo)
            result = false
        
            if @encarcelado
                return result
            else 
                if @puedeComprar
                    precio = titulo.getPrecioCompra()
                    if puedoGastar(precio) 
                        result = titulo.comprar(self)
                        if result
                            @propiedades << titulo
                            Diario.instance.ocurre_evento("El jugador #{@nombre} compra la propiedad #{titulo.nombre}")
                            @puedeComprar = false
                        end
                    end
                end
            end
            result
        end

        def construirCasa(ip)
            result = false
            if @encarcelado
                return result
            else 
                existe = existeLaPropiedad(ip)
                if existe
                    propiedad = @propiedades[ip]
                    puedoEdificarCasa = puedoEdificarCasa(propiedad)
                    precio = propiedad.getPrecioEdificar()
                    
                    puedoEdificarCasa = puedoGastar(precio) && propiedad.numCasas < @@CasasMax
              
                    if !puedoEdificarCasa
                      Diario.instance.ocurre_evento("-->no puedes construir mas casas!")
                    end
                    if !@encarcelado && puedoEdificarCasa
                        result = propiedad.construirCasa(self)
                    end
                end
            end
            return result
        end

        def construirHotel(ip)
            result = false
            if @encarcelado
                return result
            else 
                if existeLaPropiedad(ip)

                    propiedad = @propiedades[ip]
                    puedoEdificarHotel = puedoEdificarHotel(propiedad)
                    puedoEdificarHotel = false
                    precio = propiedad.precioEdificar

                    if puedoGastar(precio) && propiedad.numHoteles < @@HotelesMax && propiedad.numCasas >= @@CasasPorHotel
                        puedoEdificarHotel = true
                    end
                    puedoEdificarHotel = true
                    if puedoEdificarHotel
                        result = propiedad.construirHotel(self)
                        propiedad.derruirCasas(@@CasasPorHotel, self)
                        Diario.instance.ocurre_evento("El jugador #{@nombre} construye hotel en la propiedad #{ip}")
                    end
                end
            end
            result
        end

        def enBancarrota
            @saldo == 0
        end

        def encarcelar(numCasillaCarcel)
            if debeSerEncarcelado
                moverACasilla(numCasillaCarcel)
                @encarcelado = true
                Diario.instance.ocurreEvento("Se ha encarcelado al jugador" + @nombre)
            end
            encarcelado
        end

        def modificarSaldo(cantidad)
            @saldo += cantidad
            Diario.instance.ocurre_evento("Se incrementa el saldo en #{cantidad}")
            true
        end

        def moverACasilla(numCasilla)
            if @encarcelado
                return false
            else
                @numCasillaActual = numCasilla
                @puedeComprar = false
                Diario.instance.ocurre_evento("Se actualiza la casilla actual #{numCasilla}")
                return true
            end
        end

        def obtenerSalvoconducto(sorpresa)
            if !@encarcelado
                @salvoconducto = sorpresa
                return true
            else
                return false
            end
        end

        def paga(cantidad)
            modificarSaldo(-1 * cantidad)
        end

        def pagaAlquiler(cantidad)
            if !@encarcelado
                paga(cantidad)
            else
                return false
            end
        end

        def pagaImpuesto(cantidad)
            if !@encarcelado
                paga(cantidad)
            else
                return false
            end
        end

        def pasaPorSalida
            modificarSaldo(@@PasoPorSalida)
            Diario.instance.ocurreEvento("Pasa por salida  #{@@PasoPorSalida}");
            true
        end
             
        def puedeComprarCasilla
            @puedeComprar = !@encarcelado;
            
            return @puedeComprar
        end

        def vender(ip) 
            if !@encarcelado
                if existeLaPropiedad(ip)
                    @propiedades[ip].vender(self)
                    Diario.instance.ocurre_evento("Se vende la propiedad " + @propiedades[ip].nombre)
                    @propiedades.delete_at(ip)
                    
                    return true
                else
                    return false;
                end
            else
                return false;
            end
        end

        def tieneSalvoconducto
            @salvoconducto != nil
        end

        def tieneAlgoQueGestionar
            @propiedades.length > 0
        end

        def salirCarcelTirando
            if Dado.instance.salgoDeLaCarcel
                @encarcelado = false
                Diario.instance.ocurreEvento("El jugador sale de la carcel")
                return true
            else
                return false
            end
        end

        def salirCarcelPagando
            puedoSalirCarcelPagando
        end

        def recibe(cantidad) 
            if @encarcelado
                return false
            else
                return modificarSaldo(cantidad)
            end
        end

        # a<=>b
        # a<b => -1
        # a=b => 0
        # a>b => 1
        # a no comparable b => nil
        def <=> (otro)
            @saldo <=> otro.saldo
        end

        # protected 
        public
        def getPropiedades()
            @propiedades
        end

        def tiene_algo_que_gestionar
          @propiedades.length > 0
        end
        
        def debeSerEncarcelado
            salida = false
            if @encarcelado
                return salida
            elsif !tieneSalvoConducto
                salida = true
            elsif tieneSalvoConducto
                perderSalvoConducto
                Diario.instance.ocurreEvento("Se ha salvado de la carcel por tener un salvoconducto")
                return salida
            end
        end
        
        private
        def existeLaPropiedad(ip)
            ip >= 0 && ip <= @propiedades.length
        end

        def perderSalvoConducto
            @salvoconducto.usada
            @salvoconducto = nil
        end

        def puedoGastar(precio)
            if !@encarcelado
                return saldo >= precio
            else
                return false
            end
        end

        def puedoEdificarCasa(propiedad)
            propiedad.getPrecioEdificar() < @saldo
        end
        
        def puedoEdificarHotel(propiedad)
            result = false
            if propiedad.getPrecioEdificar() < @saldo 
                result = true
            end
            result
        end

        def puedoSalirCarcelPagando
            if @encarcelado && puedeSalirCarcelPagando()
                paga(@@PrecioLibertad)
                @encarcelado = false
                Diario.instance.ocurreEvento("Sale de la carcel el jugador " + nombre)
                true
            else 
                false
            end
        end

        def puedeSalirCarcelPagando
            @saldo >= @@PrecioLibertad
        end

        public
        def to_s
            "Jugador #{@nombre} tiene un saldo de #{@saldo}."
        end
    end
end
