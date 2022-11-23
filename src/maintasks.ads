package maintasks is

    task DistanciaSeguridad is
        pragma priority (13);
    end DistanciaSeguridad;

    task CabezaInclinada is
        pragma priority (15);
    end CabezaInclinada;

    task GiroVolante is
        pragma priority (12);
    end GiroVolante;

    task Riesgos is
        pragma priority (14);
    end Riesgos;

    task Display is
        pragma priority (11);
    end Display;


end maintasks;