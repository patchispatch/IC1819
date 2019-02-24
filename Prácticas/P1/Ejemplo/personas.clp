; Datos de personas

(deftemplate Persona
   (multifield Nombre)
   (field Edad)
   (field Sexo)
   (field EstadoCivil)
)

(deffacts VariosHechos
   (Persona
      (Nombre Juan Ocaña Valenzuela)
      (Edad 20)
   )

   (Persona
      (Nombre Pepe)
      (Sexo M)
   )
)
(deffacts OtrosHechos
   (NumeroDeReactores 4)
)