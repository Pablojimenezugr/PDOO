# encoding: utf-8


module Civitas
    class TituloPropiedad

        @@factorInteresesHipoteca = 1.1

        def initialize(nombre, alquilerBase, factorRevalorizacion, hipotecaBase, precioCompra, precioEdificar)
            @nombre = nombre
            @alquilerBase = alquilerBase
            @factorRevalorizacion = factorRevalorizacion
            @hipotecaBase = hipotecaBase
            @precioCompra = precioCompra
            @precioEdificar = precioEdificar

            @hipotecado = false
            @numCasas = 0
            @numHoteles = 0
            @propietario = nil
        end

        attr_reader :nombre, :numCasas, :numHoteles,  :precioEdificar, :propietario
        
        public
        def getPrecioEdificar
          @precioEdificar
        end
        
        private
        def esEsteElPropietario(jugador)
            result = @propietario == jugador
            return result
        end

        def getImporteHipoteca
            @hipotecaBase
        end

        def propietarioEncarcelado
            @propietario.isEncarcelado
        end
        
        
        public
        def getPrecioCompra()
          @precioCompra
        end

        def cancelarHipoteca( jugador )
            salida = false
            if @hipotecado && esEsteElPropietario(jugador)
                @propietario.paga getImporteCancelarHipoteca
            end
        end

        def getHipotecado
            @hipotecado
        end

        def getImporteCancelarHipoteca
            @hipotecaBase * @@factorInteresesHipoteca
        end

        def hipotecar jugador
            salida = false
            if !@hipotecado && esEsteElPropietario(jugador)
                @propietario.recibe @hipotecaBase
                @hipotecado = true
                salida = true
            end
            salida
        end

        def tienePropietario
            @propietario != nil
        end

        def tramitarAlquiler jugador
            if jugador != @propietario && !esEsteElPropietario(jugador)
                jugador.pagaAlquiler(@alquilerBase)
                propietario.recibe(@alquilerBase)
            end
        end

        def vender( jugador )
            rtado = false
        
            if(esEsteElPropietario(jugador) && !@hipotecado) 
                jugador.recibe(@precioCompra)
                @numCasas = 0
                @numHoteles = 0
                @propietario = nil
                rtado = true
            end

            return rtado;
            false
        end

        def actualizaPropietarioPorConversion(jugador)
            @propietario = jugador
        end

        def comprar(jugador)
            result = false
            if(!tienePropietario()) 
                @propietario = jugador
                result= true
                propietario.paga(@precioCompra)
            end
            return result
        end

        def construirCasa(jugador)
            salida = false
            if esEsteElPropietario(jugador)
                @propietario.paga(@precioEdificar)
                salida = true
                @numCasas += 1
            end
            return salida
        end
        
        def construirHotel(jugador)
            salida = false
            if esEsteElPropietario(jugador)
                jugador.paga(@precioEdificar)
                salida = true
                @numHoteles += 1
            end
            return salida
        end
        
        def derruirCasas(n, jugador)
            salida = false
            if esEsteElPropietario(jugador) && n <=  @numCasas
                numCasas-=n
                salida = true
            end
            salida
        end

        def getPrecioAlquiler
            salida = 0.0;
            if(! @hipotecado || !propietarioEncarcelado()) 
                salida = @alquilerBase*(1+(@numCasas*0.5) + (@numHoteles*2.5));
            end
            salida
        end

        def to_s
            """ Nombre:  #{@nombre}nombre
             Número de casas = #{@numCasas} \n
             Número de hoteles = #{@numHoteles} \n
             Precio de compra #{@precioCompra} \n
             Precio edificar = #{@precioEdificar}\n"""
        end

        

    end
end
