Feature: Consultar comentarios

COMO usuario,
QUIERO que en el refinanciamiento se recalcule al 18% el IGV de la ultima cuota,
PARA que el cliente no me devuelva la factura con el IGV incorrecto,



Background:
    Given Poliza esta activa
    And el plan no tiene el concepto de intereses
   
   
    Scenario: Ajuste Automático de Facturas
       
        When ingreso al modulo Refinanciamiento
        And busco la poliza a refinanciar
        And refinancio en la cantidad de cuotas que desee
        Then verifico el recalculo en la ultima couta

        @CP_001_Login
        Scenario Outline: Login al sistema AX
            Given ingreso al sistema de AX
            When ingreso el usuario "<user>"
            And ingreso la contraseña "<password>"
            And selecciono en Ingresar
            Then el sistema me muestra la pantalla princial de AX
            Examples:
            | user      | password |
            | moviedo   | sqa2021p |
            | manguljo1 | sqa2021p |


             @CP_001 @PruebasIntegrales
        Scenario Outline: Realizar el ajuste automático de la última cuota con Derecho de Emisión
            Given ingreso al sistema de AX
            #@CP_001_Login
            And realizo el Login
            When pulso en Administrativa y Financiera
            And pulso en Menu Creditos y Cobranzas
            And pulso en Financiamientos / Fraccionamientos
            And selecciono al modulo Refinanciamiento
            And selecciono la opcion Agregar
            And ingreso la codigo del producto "<PRODUCTO>"
            And ingreso la poliza "<POLIZA>"
            And pulso en Aceptar
            And se muestra en la pantalla la poliza y el financiamiento
            And selecciono el registro
            And selecciono el tipo de refinanciamiento "<tipo>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Refinanciamiento
            And escojo el plan de refinanciamiento "<PLAN>"
            And ingreso la cantidad de cuotas "<NUMERO>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Financiamientos Asociados al Refinanciamiento
            And se muestra todas las cuotas
            And selecciona la ultima cuota
            Then verifico que el IGV este al 18%
            And verifico que el ajuste positivo o negativo que se realizo en el IGV, se aplique en el Derecho de Emisión
            And valido que la Prima Neta no se haya modificado
            And valido que la Prima Total no se vea alterada

            Examples:
            | producto | poliza | tipo | plan   | numero |
            | 2003     | 233456 | CP   | CUP107 | 4      |
            | 9028     | 500111 | CC   | CCA001 | 10     |
           
        @CP_002 @PruebasIntegrales
        Scenario Outline: Realizar el ajuste automático de la última cuota sin Derecho de Emisión
            #@CP_001_Login
            And realizo el Login
            When pulso en Administrativa y Financiera
            And pulso en Menu Creditos y Cobranzas
            And pulso en Financiamientos / Fraccionamientos
            And selecciono al modulo Refinanciamiento
            And selecciono la opcion Agregar
            And ingreso la codigo del producto "<PRODUCTO>"
            And ingreso la poliza "<POLIZA>"
            And pulso en Aceptar
            And se muestra en la pantalla la poliza y el financiamiento
            And selecciono el registro
            And selecciono el tipo de refinanciamiento "<tipo>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Refinanciamiento
            And escojo el plan de refinanciamiento "<PLAN>"
            And ingreso la cantidad de cuotas "<NUMERO>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Financiamientos Asociados al Refinanciamiento
            And se muestra todas las cuotas
            And selecciona la ultima cuota
            Then verifico que el IGV este al 18%
            And verifico que el ajuste positivo o negativo que se realizo en el IGV, se aplique en la Prima Neta
            And valido que la Prima Total no se vea alterada

            Examples:
            | producto | poliza | tipo | plan   | numero |
            | 2001     | 233456 | CP   | CUP005 | 7      |
            | 1301     | 500111 | CC   | CCA005 | 5      |
           
        @CP_001_DE_LIBRE
        Scenario Outline: Validar el Derecho de Emsión Libre
            #@CP_001_Login
            And realizo el Login
            When pulso en Administrativa y Financiera
            And pulso en Menu Creditos y Cobranzas
            And pulso en Financiamientos / Fraccionamientos
            And selecciono al modulo Refinanciamiento
            And pulso en buscar
            And ingreso el plan de financiamiento "<PLAN>"
            And pulso en buscar
            And el sistema me muestra el detalle del plan
            Then valido si tiene marcado la opcion Derecho de Emsión Libre "<condición>"

            Examples:
            | plan   | condición |
            | CUP102 | si        |
            | CCA102 | si        |
            | CUP005 | no        |  


        @CP_003 @PruebasIntegrales
        Scenario Outline: Realizar el ajuste automático de la última cuota con Derecho de Emisión Libre
            #@CP_001_Login
            And realizo el Login
            When pulso en Administrativa y Financiera
            And pulso en Menu Creditos y Cobranzas
            And pulso en Financiamientos / Fraccionamientos
            And selecciono al modulo Refinanciamiento
            And selecciono la opcion Agregar
            And ingreso la codigo del producto "<PRODUCTO>"
            And ingreso la poliza "<POLIZA>"
            And pulso en Aceptar
            And se muestra en la pantalla la poliza y el financiamiento
            And selecciono el registro
            And selecciono el tipo de refinanciamiento "<tipo>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Refinanciamiento
            And escojo el plan de refinanciamiento "<PLAN>"
          #@CP_001_DE_LIBRE
            And valido si el plan tiene derecho de emisión libre
            And ingreso la cantidad de cuotas "<NUMERO>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Financiamientos Asociados al Refinanciamiento
            And se muestra todas las cuotas
            And selecciona la ultima cuota
            Then verifico que el sistema este respetando el Derecho de Emisión origen del financiamiento
            And verifico que el IGV este al 18%
            And verifico que el ajuste positivo o negativo que se realizo en el IGV, se aplique en el Derecho de Emisión
            And valido que la Prima Neta no se haya modificado
            And valido que la Prima Total no se vea alterada

            Examples:
            | producto | poliza | tipo | plan   | numero |
            | 2003     | 233456 | CP   | CUP102 | 4      |
            | 9028     | 500111 | CC   | CCA102 | 10     |



        @CP_004 @PruebasIntegrales
        Scenario Outline: Realizar el ajuste automático de la última cuota con intereses
            Given ingreso al sistema de AX
            When ingreso el usuario "<user>"
            And ingreso la contraseña "<password>"
            And selecciono en Ingresar
            And pulso en Administrativa y Finaciera
            And pulso en Menu Creditos y Cobranzas
            And pulso en Financiamientos / Fraccionamientos
            And selecciono al modulo Refinanciamiento
            And selecciono la opcion Agregar
            And ingreso la codigo del producto "<PRODUCTO>"
            And ingreso la poliza "<POLIZA>"
            And pulso en Aceptar
            And se muestra en la pantalla la poliza y el financiamiento
            And selecciono el tipo de refinanciamiento "<tipo>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Refinanciamiento
            And escojo el plan de refinanciamiento "<CCA , CUP>"
            And ingreso la cantidad de cuotas "<NUMERO>"
            And pulso en la opcion ++
            And el sistema pasa a otra pantalla Financiamientos Asociados al Refinanciamiento
            And se muestra todas las cuotas
            And selecciona la ultima cuota
            Then verifico que no se ha realizado ningun ajuste del IGV ya que la cuota tiene interes
            And valido que la Prima Neta no se haya modificado
            And valido que la Prima Total no se vea alterada

            Examples:
            | producto | poliza | tipo | plan   | numero |
            | 2001     | 233456 | CP   | CUP222 | 10     |
            | 1301     | 500111 | CC   | CCA333 | 12     |