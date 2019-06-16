; -----------------------------------------------------------------------------
; INGENIERÍA DEL CONOCIMIENTO
; PRÁCTICA 2: SISTEMA INTELIGENTE DE REGADÍO
; AUTOR: JUAN OCAÑA VALENZUELA
; 
; secadora.clp
; Bucle para simular el paso del tiempo y las condiciones meteorológicas del
; entorno de las plantas, para comprobar el buen funcionamiento 
; del sistema de regadío planteado.
; -----------------------------------------------------------------------------

(deffacts climas
    ; -------------------------------------------
    ; Datos del ambiente al inicio.
    (t_global 80)
    (l_global 600)
    (secado 0)

    ; -------------------------------------------
    ; Datos de alarma de humedad y temperatura para cualquier planta.
    (t_max 40)
    (t_min 5)
    (h_max 200)
    (h_min 850)

    ; -------------------------------------------
    ; Datos de los climas.
    ; Despejado:
    (h_base despejado 5)
    (h_noche despejado 0)
    (h_dia despejado 10)

    (t_base despejado 23)
    (t_noche despejado 13)
    (t_dia despejado 30)

    (l_base despejado 1000)
    (l_noche despejado 200)
    (l_dia despejado 2000)

    ; Nublado:
    (h_base nublado -5)
    (h_noche nublado -10)
    (h_dia nublado 0)
    
    (t_base nublado 15)
    (t_noche nublado 5)
    (t_dia nublado 20)

    (l_base nublado 800)
    (l_noche nublado 150)
    (l_dia nublado 1200)

    ; Árido:
    (h_base arido 20)
    (h_noche arido 15)
    (h_dia arido 30)
    
    (t_base arido 30)
    (t_noche arido 20)
    (t_dia arido 38)

    (l_base arido 1500)
    (l_noche arido 200)
    (l_dia arido 2000)

    ; Lluvioso:
    (h_base lluvioso -20)
    (h_noche lluvioso -25)
    (h_dia lluvioso -15)
    
    (t_base lluvioso 10)
    (t_noche lluvioso 5)
    (t_dia lluvioso 15)

    (l_base lluvioso 500)
    (l_noche lluvioso 180)
    (l_dia lluvioso 650)

)

; -----------------------------------------------
; Cambio de clima:
(defrule CambioClima
    (declare (salience 100))
    ?c <- (nuevo_clima ?clima)
    =>
    ; Borramos
    (retract ?c)

    ; Introducimos el nuevo clima:
    (assert (clima ?clima))
)

; -----------------------------------------------
; Cambios de horario:
; Mañana a Tarde:
(defrule MañanaATarde
    (hora 14)
    ?m <- (manana)
    =>
    (retract ?m)
    (assert (tarde))
)

; Tarde a Noche:
(defrule TardeANoche
    (hora 20)
    ?t <- (tarde)
    =>
    (retract ?t)
    (assert (noche))
)

; Noche a Madrugada:
(defrule NocheAMadrugada
    (hora 2)
    ?n <- (noche)
    =>
    (retract ?n)
    (assert (madrugada))
)

; Madrugada a Mañana:
(defrule MadrugadaAMañana
    (hora 8)
    ?m <- (madrugada)
    =>
    (retract ?m)
    (assert (manana))
)

; -----------------------------------------------
; Ajustar temperatura y secado al momento del día y al clima:
(defrule AjustarValoresClima
    
)

; -----------------------------------------------
; Bucle de secado (se ejecuta cada hora):
(defrule InicioSimulacion
    (simulacion ?n)
    =>
    (assert(paso 0))
)

; Bucle simulación cutre:
(defrule BucleSimulacion
    (declare (salience -100))
    (not(secar))
    (simulacion ?max)
    ?p <- (paso ?n)
    (test(< ?n ?max))
    =>
    ; Secar las cosas:
    (assert (secar))
    (bind ?nn (+ ?n 1))
    (assert (paso ?nn))
    (retract ?p)
)

; Secar las plantas:
(defrule Secar
    (declare (salience -10))
    (secar)
    (secado ?s)
    (planta ?p ? ?)
    (not(planta_seca ?p))
    (not(borrar_planta_seca))
    ?hh <- (humedad ?p ?v)
    =>
    (bind ?vv (+ ?v ?s))
    (retract ?hh)
    (assert (humedad ?p ?vv))
    (assert (planta_seca ?p))
)

; Borrar estado seco:
(defrule BorrarPrimerSeco
    (declare (salience -50))
    ?p <- (planta_seca ?planta)
    =>
    (retract ?p)
    (assert (borrar_planta_seca))
)

; Borrar estado seco:
(defrule BorrarSeco
    (declare (salience -50))
    ?p <- (planta_seca ?planta)
    (borrar_planta_seca)
    =>
    (retract ?p)
)

; No seguir borrando plantas secas:
(defrule PararBorrarPlantasSecas
    (declare (salience -60))
    ?ss <- (secar)
    ?s <- (borrar_planta_seca)
    =>
    (retract ?s)
    (retract ?ss)
)

; Fin simulación cutre:
(defrule FinSimulacion
    (declare (salience -100))
    ?s <- (simulacion ?max)
    ?p <- (paso ?)
    =>
    (retract ?s)
    (retract ?p)
)

; Borrar los secar:
(defrule BorrarSecar
    (declare (salience -100))
    ?s <- (secar)
    =>
    (retract ?s)
)

; -----------------------------------------------
; 