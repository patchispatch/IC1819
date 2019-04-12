; #############################################################################
; INGENIERÍA DEL CONOCIMIENTO
; PRÁCTICA 1: REPRESENTACIÓN DEL PLANO DE UNA CASA EN CLIPS
; AUTOR: JUAN OCAÑA VALENZUELA
; GRADO EN INGENIERÍA INFORMÁTICA, CURSO 2018/2019
;
; CasaInteligente.clp
; -----------------------------------------------------------------------------
; En esta práctica se ha escogido un plano de una vivienda, y se pretende
; representar la misma de cara a que un sistema experto para el control de
; la domótica de la casa pueda saber el número de habitaciones y cómo están
; conectadas. Este archivo define los hechos necesarios para representar las
; diferentes habitaciones.
;
; La casa está compuesta de las siguientes habitaciones:
;  - Salón (salon)
;  - Cocina (cocina)
;  - Baño (bano)
;  - Pasillo (pasillo)
;  - Despacho (despacho)
;  - Habitación grande (grande)
;  - Habitación mediana (mediana)
;  - Habitación pequeña (pequena)
;  - Entrada (entrada)
;  - Patio (patio)
;  - Terraza 1 (terraza_1)
;  - Terraza 2 (terraza_2)
;
; Las habitaciones se definirán como hechos de la siguiente forma:
;    (room <room_id> <puertas_pasos_asociados> <tipo_hab>)
;
; También se considerarán las puertas, pasos y ventanas asociadas
; a las mismas. Consideraremos que las puertas y los pasos unen dos
; habitaciones, y las ventanas pertenecen a una habitación. Todos
; estos elementos estarán identificados por su ID.
;
; Las definiremos de la siguiente forma:
;    (door <door_id>)
;    (window <window_id> <room_id>)
;    (passage <pass_id>)
;
;
; Manejo inteligente de las luces:
; Existen cuatro tipos de salas:
; - Tipo 1: salones. Mínimo 300lx, máximo 600lx.
; - Tipo 2: dormitorios. Mínimo 150lx, máximo 300lx.
; - Tipo 3: cocinas, baños y pasillos. Mínimo 200lx, máximo 400lx.
; - Tipo 4: despachos. Mínimo 500lx, máximo 1000lx.
;
; #############################################################################

; Definición de habitaciones:
(deffacts rooms
  (room salon terr_1_salon salon_pasillo tipo_1)
  (room cocina terr1_cocina cocina_pasillo tipo_3)
  (room bano bano_pasillo tipo_3)
  (room pasillo cocina_pasillo bano_pasillo despacho_pasillo mediana_pasillo
                 grande_pasillo pequena_pasillo entrada_pasillo
                 patio_pasillo salon_pasillo tipo_3)
  (room despacho despacho_pasillo tipo_4)
  (room grande grande_pasillo tipo_2)
  (room mediana mediana_pasillo tipo_2)
  (room pequena pequena_pasillo tipo_2)
  (room entrada entrada_pasillo entrada_patio tipo_3)
  (room patio patio_pasillo terr2_patio tipo_3)
  (room terraza_1 terr1_cocina terr1_salon tipo_3)
  (room terraza_2 terr2_patio tipo_3)
)

; Definición de las puertas:
(deffacts doors
  (door terr1_cocina)
  (door terr1_salon)
  (door cocina_pasillo)
  (door bano_pasillo)
  (door despacho_pasillo)
  (door mediana_pasillo)
  (door grande_pasillo)
  (door pequena_pasillo)
  (door entrada_pasillo)
  (door patio_pasillo)
  (door entrada_patio)
  (door entrada_outside)
)

; Definición de los pasos:
(deffacts passages
  (passage terr2_patio)
  (passage salon_pasillo)
)

; Definición de las ventanas:
(deffacts windows
  (window w_entrada entrada)
  (window w_pequena pequena)
  (window w_grande grande)
  (window w_terr2 terraza_2)
  (window w_salon salon)
  (window w_cocina cocina)
  (window w_terr1 terraza_1)
)

; Últimos registros por defecto de los sensores de las habitaciones:
(deffacts registros_por_defecto
  ; Movimiento:
  (ultimo_registro movimiento salon 0)
  (ultimo_registro movimiento cocina 0)
  (ultimo_registro movimiento pasillo 0)
  (ultimo_registro movimiento bano 0)
  (ultimo_registro movimiento despacho 0)
  (ultimo_registro movimiento grande 0)
  (ultimo_registro movimiento mediana 0)
  (ultimo_registro movimiento pequena 0)
  (ultimo_registro movimiento entrada 0)
  (ultimo_registro movimiento patio 0)
  (ultimo_registro movimiento terraza_1 0)
  (ultimo_registro movimiento terraza_2 0)

  ; Luminosidad:
  (ultimo_registro luminosidad salon 0)
  (ultimo_registro luminosidad cocina 0)
  (ultimo_registro luminosidad pasillo 0)
  (ultimo_registro luminosidad bano 0)
  (ultimo_registro luminosidad despacho 0)
  (ultimo_registro luminosidad grande 0)
  (ultimo_registro luminosidad mediana 0)
  (ultimo_registro luminosidad pequena 0)
  (ultimo_registro luminosidad entrada 0)
  (ultimo_registro luminosidad patio 0)
  (ultimo_registro luminosidad terraza_1 0)
  (ultimo_registro luminosidad terraza_2 0)

  ; Estado luz
  (ultimo_registro estadoluz salon 0)
  (ultimo_registro estadoluz cocina 0)
  (ultimo_registro estadoluz pasillo 0)
  (ultimo_registro estadoluz bano 0)
  (ultimo_registro estadoluz despacho 0)
  (ultimo_registro estadoluz grande 0)
  (ultimo_registro estadoluz mediana 0)
  (ultimo_registro estadoluz pequena 0)
  (ultimo_registro estadoluz entrada 0)
  (ultimo_registro estadoluz patio 0)
  (ultimo_registro estadoluz terraza_1 0)
  (ultimo_registro estadoluz terraza_2 0)
)

; Tipos de habitaciones: (tipo ?minimo ?maximo)
(deffacts tipos_habitaciones
  (tipo_sala tipo_1 300 600)
  (tipo_sala tipo_2 150 300)
  (tipo_sala tipo_3 200 400)
  (tipo_sala tipo_4 500 1000)
)

; Definición de reglas:

; Se puede acceder de una habitación a otra a través de una puerta:
(defrule posible_pasar
  (room ?room_1 $? ?door_pass $?)
  (room ?room_2 $? ?door_pass $?)
  (test(neq ?room_1 ?room_2))
  =>
  (assert(posible_pasar ?room_1 ?room_2))
)

; Es necesario pasar por una habitación intermedia para llegar a otra:
(defrule necesario_pasar
  (room ?room_1 ?door_pass)
  (room ?room_2 $? ?door_pass $?)
  (test(neq ?room_1 ?room_2))
  =>
  (assert(necesario_pasar ?room_1 ?room_2))
)

; La habitación es interior:
(defrule habitacion_interior
  (room ?room_id ?)
  (not(window ?window_id ?room_id))
  =>
  (assert(habitacion_interior ?room_id))
)

; Registrar valores de los sensores en un tiempo dado:
(defrule registrar_valor
  (valor ?tipo ?habitacion ?valor)
  =>
  (bind ?seg (totalsegundos ?*hora* ?*minutos* ?*segundos*))
  (assert(valor_registrado ?seg ?tipo ?habitacion ?valor))
)

; Actualizar el último registro del sensor de una habitación:
(defrule actualiza_ultimo_registro
  (valor_registrado ?t1 ?tipo ?hab ?)
  ?borrar <- (ultimo_registro ?tipo ?hab ?t2)
  (test (> ?t1 ?t2))
  =>
  (retract ?borrar)
  (assert(ultimo_registro ?tipo ?hab ?t1))
)

; Devuelve una lista ordenada de los registros:
(defrule genera_informe
  (informe ?hab)
  =>
  (bind ?seg (totalsegundos ?*hora* ?*minutos* ?*segundos*))

  ; Iniciamos la aventura para buscar el mínimo:
  (assert(encontrar_minimo ?hab 0))

  ; Establecemos un valor artificialmente alto:
  (assert(minimo_actual ?hab 60000000))

  ; Pasamos la hora a formato legible:
  (bind ?hh (hora-segundos ?seg))
  (bind ?mm (minuto-segundos ?seg))
  (bind ?ss (segundo-segundos ?seg))

  ; Imprimimos por pantalla:
  (printout t crlf "Generando informe de " ?hab " a las " ?hh ":" ?mm ":" ?ss ": ")
)

(defrule encontrar_minimo
  (declare (salience 300))
  ?encontrar <- (encontrar_minimo ?hab ?seg1)
  ?borrar <- (minimo_actual ?hab ?min)
  (valor_registrado ?seg2 ?tipo ?hab ?valor)
  (test(> ?seg2 ?seg1))
  (test(< ?seg2 ?min))
  =>
  ; Borramos el anterior mínimo:
  (retract ?borrar)

  (printout t crlf "A")

  ; Creamos el nuevo:
  (assert(minimo_actual ?hab ?seg2))

  ; Continuamos el bucle creando de nuevo el hecho y borrando el anterior:
  (retract ?encontrar)
  (assert(encontrar_minimo ?hab ?seg2))
)

(defrule imprimir_minimo
  (declare(salience 200))
  ?borrar <- (minimo_actual ?hab ?seg)
  (valor_registrado ?seg ?tipo ?hab ?valor)
  =>
  ; Calculamos la hora en formato legible:
  (bind ?hh (hora-segundos ?seg))
  (bind ?mm (minuto-segundos ?seg))
  (bind ?ss (segundo-segundos ?seg))

  ; Imprimimos por pantalla:
  (printout t crlf "Tipo: " ?tipo ". Valor: " ?valor ". Hora: " ?hh ":" ?mm ":" ?ss ".")

  ; Borramos el mínimo:
  (retract ?borrar)

  ; Buscamos el siguiente mínimo:
  (assert(encontrar_minimo ?hab ?seg))

  ; Establecemos un valor artificialmente alto:
  (assert(minimo_actual ?hab 6000000))
)

(defrule borrar_encontrar_minimo
  (declare(salience -100))
  ?borrar <- (encontrar_minimo ? ?)
  =>
  (retract ?borrar)
)

(defrule borrar_minimo_actual
  (declare(salience -100))
  ?borrar <- (minimo_actual ? ?)
  =>
  (retract ?borrar)
)

(defrule borrar_informe
  (declare(salience -100))
  ?borrar <- (informe ?)
  =>
  (retract ?borrar)
)

; -----------------------------------------------
; APARTADO 3.B
; Manejo inteligente de las luces:

; Corregir baja luminosidad:
(defrule encender_baja_luminosidad
  (valor luminosidad ?hab ?valor)
  (room ?nombre ?$ ?tipo)
  (tipo_sala ?tipo ?minimo ?)
  (test(< ?valor ?minimo))
  =>
  ; Encender luz en esta habitación:
  (assert(accion pulsador_luz ?hab encender))
)

; Corregir alta luminosidad:
(defrule apagar_alta_luminosidad
  (valor luminosidad ?hab ?valor)
  (room ?nombre ?$ ?tipo)
  (tipo_sala ?tipo ? ?maximo)
  (test(> ?valor ?maximo))
  =>
  ; Apagar la luz en esta habitación:
  (assert(accion pulsador_luz ?hab apagar))
)

; Encender luces en base a los sensores de movimiento:

(defrule encender_movimiento
  (valor estadoluz ?hab off)
  (valor movimiento ?hab on)
  =>
  (accion pulsador_luz ?hab encender)
)

; OPCIÓN 1: apagar una sala si no hay movimiento en ella tras 10 segundos
; desde la detección de movimiento off.

(defrule hab_parcialmente_inactiva
  (valor_registrado ?seg estadoluz ?hab on)
  (valor movimiento ?hab off)
  =>
  (parc_inactiva ?hab ?seg)

)

(defrule hab_inactiva
  (parc_inactiva ?hab ?seg)
  ()
)


; Imprimir por pantalla el resultado:
;(defrule print_posible_pasar
;  (posible_pasar ?room_1 ?room_2)
;  =>
;  (printout t crlf "Posible pasar de " ?room_1 " a " ?room_2)
;)

;(defrule print_necesario_pasar
;  (necesario_pasar ?room_1 ?room_2)
;  =>
;  (printout t crlf "Necesario pasar de " ?room_1 " a " ?room_2)
;)

;(defrule print_habitacion_interior
;  (habitacion_interior ?room_id)
;  =>
;  (printout t crlf "La habitación " ?room_id " es interior")
;)

;(defrule print_ultimos_registros
;  (declare (salience -1000))
;  (ultimo_registro ?tipo ?hab ?t)
;  =>
;  (printout t crlf "Último registro almacenado: " ?tipo " " ?hab " " ?t ".")
;)
