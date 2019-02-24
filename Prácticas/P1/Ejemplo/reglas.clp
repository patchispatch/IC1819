; Reglas del ejemplo de personas

(deffacts VariosHechosVectores
   (Persona Pedro 45 M C)
   (Persona Maria 38 F S)
)

(defrule ImprimeSolteros
   (Persona ?Nombre ?Edad M S)
   =>
   (printout t crlf ?Nombre " está soltero" crlf)
)

(defrule ImprimeSolteras
   (Persona ?Nombre ?Edad F S)
   =>
   (printout t crlf ?Nombre " está soltera" crlf)
)
