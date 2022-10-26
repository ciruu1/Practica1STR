package maintasks is

    task DistanciaSeguridad is
        pragma priority (5);
    end DistanciaSeguridad;

    task CabezaInclinada is
        pragma priority (3);
    end CabezaInclinada;

    task GiroVolante is
        pragma priority (4);
    end GiroVolante;

    task Riesgos is
        pragma priority (8);
    end Riesgos;


end maintasks;