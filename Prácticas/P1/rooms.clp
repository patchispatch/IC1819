; #############################################################################
; INGENIERÍA DEL CONOCIMIENTO
; PRÁCTICA 1: REPRESENTACIÓN DEL PLANO DE UNA CASA EN CLIPS
; AUTOR: JUAN OCAÑA VALENZUELA
; GRADO EN INGENIERÍA INFORMÁTICA, CURSO 2018/2019
;
; rooms.clp
; -----------------------------------------------------------------------------
; En esta práctica se ha escogido un plano de una vivienda, y se pretende
; representar la misma de cara a que un sistema experto para el control de
; la domótica de la casa pueda saber el número de habitaciones y cómo están
; conectadas. Este archivo define los hechos necesarios para representar las
; diferentes habitaciones.
;
; La casa está compuesta de las siguientes habitaciones:
;  - Salón (lroom)
;  - Cocina (kitchen)
;  - Baño (bath)
;  - Pasillo (corridor)
;  - Despacho (office)
;  - Habitación grande (big)
;  - Habitación mediana (medium)
;  - Habitación pequeña (small)
;  - Entrada (hall)
;  - Patio (courtyard)
;  - Terraza 1 (terrace_1)
;  - Terraza 2 (terrace_2)
;
; Las habitaciones se definirán como hechos de la siguiente forma:
;    (room <room_id> <puertas_pasos_asociados>)
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
; #############################################################################

; Definición de habitaciones:
(deffacts rooms
  (room lroom terr_1_lroom lroom_corridor)
  (room kitchen terr1_kitchen kitchen_corridor)
  (room bath bath_corridor)
  (room corridor kitchen_corridor bath_corridor office_corridor medium_corridor
                 big_corridor small_corridor entrance_corridor
                 courtyard_corridor lroom_corridor)
  (room office office_corridor)
  (room big big_corridor)
  (room medium medium_corridor)
  (room small small_corridor)
  (room entrance entrance_corridor entrance_courtyard)
  (room courtyard courtyard_corridor terr2_courtyard)
  (room terrace_1 terr1_kitchen terr1_lroom)
  (room terrace_2 terr2_courtyard)
)

; Definición de las puertas:
(deffacts doors
  (door terr1_kitchen)
  (door terr1_lroom)
  (door kitchen_corridor)
  (door bath_corridor)
  (door office_corridor)
  (door medium_corridor)
  (door big_corridor)
  (door small_corridor)
  (door entrance_corridor)
  (door courtyard_corridor)
  (door entrance_courtyard)
  (door entrance_outside)
)

; Definición de los pasos:
(deffacts passages
  (passage terr2_courtyard)
  (passage lroom_corridor)
)

; Definición de las ventanas:
(deffacts windows
  (window w_entrance entrance)
  (window w_small small)
  (window w_big big)
  (window w_terr2 terrace_2)
  (window w_lroom lroom)
  (window w_kitchen kitchen)
  (window w_terr1 terrace_1)
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
  ;(printout t crlf "EEEEEEEEE" ?room_1)
)

; La habitación es interior:
(defrule habitacion_interior
  (room ?room_id ?)
  (not(window ?window_id ?room_id))
  =>
  (assert(habitacion_interior ?room_id))
)

; Imprimir por pantalla el resultado:
(defrule print_posible_pasar
  (posible_pasar ?room_1 ?room_2)
  =>
  (printout t crlf "Posible pasar de " ?room_1 " a " ?room_2)
)

(defrule print_necesario_pasar
  (necesario_pasar ?room_1 ?room_2)
  =>
  (printout t crlf "Necesario pasar de " ?room_1 " a " ?room_2)
)

(defrule print_habitacion_interior
  (habitacion_interior ?room_id)
  =>
  (printout t crlf "La habitación " ?room_id " es interior")
)
