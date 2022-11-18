package body measures is

protected body Datos is

    function GetVelocidad return Integer is
    begin
        return Velocidad;
    end GetVelocidad;

    function GetDistancia return Integer is
    begin
        return Distancia;
    end GetDistancia;

    procedure SetVelocidad (Vel : Integer) is
    begin
        Velocidad := Vel;
    end SetVelocidad;

    procedure SetDistancia (Dist : Integer) is
    begin
        Distancia := Dist;
    end SetDistancia;

end Datos;

begin
    null;
end measures;