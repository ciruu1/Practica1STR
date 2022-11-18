package body symptoms is

protected body Datos is

    function GetVolantazo return boolean is
    begin
        return Volantazo;
    end GetVolantazo;

    function GetCabezaInclinada return boolean is
    begin
        return CabezaInclinada;
    end GetCabezaInclinada;

    function GetDistancia return TipoDistancia is
    begin
        return Distancia;
    end GetDistancia;

    procedure SetVolantazo (Vol : boolean) is
    begin
        Volantazo := Vol;
    end SetVolantazo;

    procedure SetCabezaInclinada(Cabeza : boolean) is
    begin
        CabezaInclinada := Cabeza;
    end SetCabezaInclinada;

    procedure SetDistancia (Dist : TipoDistancia) is
    begin
        Distancia := Dist;
    end SetDistancia;

end Datos;

begin
    null;
end symptoms;