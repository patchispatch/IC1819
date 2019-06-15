; -----------------------------------------------------------------------------
; INGENIERÍA DEL CONOCIMIENTO
; PRÁCTICA 2: SISTEMA INTELIGENTE DE REGADÍO
; AUTOR: JUAN OCAÑA VALENZUELA
; 
; secadora.clp
; Bucle para simular el paso del tiempo y el secado (o no) de las plantas,
; así como las diferentes partes del día de forma simplificada, para comprobar
; el buen funcionamiento del sistema de regadío formulado en regadio.clp 
; -----------------------------------------------------------------------------

; -----------------------------------------------
; Bucle de secado:
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