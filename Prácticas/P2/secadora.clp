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

    ; -------------------------------------------
    ; Estado inicial:
    (hora 8)
    (horario madrugada)
    (clima despejado)
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
    ?m <- (horario manana)
    ?tt <- (t_global ?)
    ?ll <- (l_global ?)
    ?ss <- (secado ?)

    (clima ?clima)
    (h_dia ?clima ?h)
    (t_dia ?clima ?t)
    (l_dia ?clima ?l)
    =>
    (retract ?m)
    (retract ?tt)
    (retract ?ll)
    (retract ?ss)

    (assert (horario tarde))
    (assert (t_global ?t))
    (assert (l_global ?l))
    (assert (secado ?h))
)

; Tarde a Noche:
(defrule TardeANoche
    (hora 20)
    ?m <- (horario tarde)
    ?tt <- (t_global ?)
    ?ll <- (l_global ?)
    ?ss <- (secado ?)

    (clima ?clima)
    (h_base ?clima ?h)
    (t_base ?clima ?t)
    (l_base ?clima ?l)
    =>
    (retract ?m)
    (retract ?tt)
    (retract ?ll)
    (retract ?ss)

    (assert (horario noche))
    (assert (t_global ?t))
    (assert (l_global ?l))
    (assert (secado ?h))
)

; Noche a Madrugada:
(defrule NocheAMadrugada
    (hora 2)
    ?m <- (horario noche)
    ?tt <- (t_global ?)
    ?ll <- (l_global ?)
    ?ss <- (secado ?)

    (clima ?clima)
    (h_noche ?clima ?h)
    (t_noche ?clima ?t)
    (l_noche ?clima ?l)
    =>
    (retract ?m)
    (retract ?tt)
    (retract ?ll)
    (retract ?ss)

    (assert (horario madrugada))
    (assert (t_global ?t))
    (assert (l_global ?l))
    (assert (secado ?h))
)

; Madrugada a Mañana:
(defrule MadrugadaAMañana
    (hora 8)
    ?m <- (horario madrugada)
    ?tt <- (t_global ?)
    ?ll <- (l_global ?)
    ?ss <- (secado ?)

    (clima ?clima)
    (h_base ?clima ?h)
    (t_base ?clima ?t)
    (l_base ?clima ?l)
    =>
    (retract ?m)
    (retract ?tt)
    (retract ?ll)
    (retract ?ss)

    (assert (horario manana))
    (assert (t_global ?t))
    (assert (l_global ?l))
    (assert (secado ?h))
)

; -----------------------------------------------
; Simular el paso de las horas:
(defrule PasoDeLasHoras
    ?h <- (hora ?n)
    (not(bucle_secado ?))
    (not(bucle_calentado))
    =>
    (bind ?nn (mod (+ ?n 1) 24))
    (retract ?h)
    (assert (hora ?nn))
    (assert (bucle_secado 5))
    (assert (bucle_calentado))
)

; -----------------------------------------------
; Bucle de secado (se ejecuta cada hora):
(defrule InicioSecado
    (bucle_secado ?n)
    =>
    (assert(paso 0))
)

; Bucle simulación cutre:
(defrule BucleSecado
    (declare (salience -100))
    (not(secar))
    (bucle_secado ?max)
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
    (planta ?p ? ? ?)
    (not (planta_seca ?p))
    (not (borrar_planta_seca))
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
(defrule FinBucleSecado
    (declare (salience -100))
    ?s <- (bucle_secado ?max)
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
; Bucle de calentado (se ejecuta cada hora)
(defrule Calentado
    (bucle_calentado)
    (planta ?p ? ? ?)
    (not (planta_caliente ?p))
    (not (borrar_planta_caliente))
    ?tt <- (temperatura ?p ?t)
    (t_global ?tg)
    (test (< ?t ?tg))
    =>
    (bind ?tn (+ ?t 2))
    (retract ?tt)
    (assert (temperatura ?p ?tn))
    (assert (planta_caliente ?p))
)

(defrule Enfriado
    (bucle_calentado)
    (planta ?p ? ? ?)
    (not(planta_caliente ?p))
    (not (borrar_planta_caliente))
    ?tt <- (temperatura ?p ?t)
    (t_global ?tg)
    (test (> ?t ?tg))
    =>
    (bind ?tn (- ?t 1))
    (retract ?tt)
    (assert (temperatura ?p ?tn))
    (assert (planta_caliente ?p))
)

(defrule Igualado
    (bucle_calentado)
    (planta ?p ? ? ?)
    (not (planta_caliente ?p))
    (not (borrar_planta_caliente))
    ?tt <- (temperatura ?p ?t)
    (t_global ?tg)
    (test (eq ?t ?tg))
    =>
    (assert (planta_caliente ?p))
)

; Borrar plantas calientes:
(defrule BorrarPrimerCaliente
    (declare (salience -50))
    ?p <- (planta_caliente ?planta)
    =>
    (retract ?p)
    (assert (borrar_planta_caliente))
)

(defrule BorrarCaliente
    (declare (salience -50))
    ?p <- (planta_seca ?planta)
    (borrar_planta_caliente)
    =>
    (retract ?p)
)

; No seguir borrando plantas calientes:
(defrule FinBucleCalentado
    (declare (salience -60))
    ?ss <- (bucle_calentado)
    ?s <- (borrar_planta_caliente)
    =>
    (retract ?s)
    (retract ?ss)
)


; -----------------------------------------------
; Cambiar clima al día siguiente:
(defrule ClimaSiguiente
    (hora 0)
    ?s <- (clima_siguiente ?clima)
    (not (nuevo_clima ?))
    =>
    (assert (nuevo_clima ?clima))
    (retract ?s)
)
