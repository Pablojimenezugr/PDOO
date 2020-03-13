module Civitas

    class OperacionInmobiliaria

        def initialize(gestion, numPropiedad)
            @numPropiedad = numPropiedad
            @gestion = gestion
        end
        attr_reader :numPropiedad, :gestion
    end
    
end