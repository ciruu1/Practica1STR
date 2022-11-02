with Kernel.Serial_Output; use Kernel.Serial_Output;

package body controlador is

    protected body Controlador_Eventos is
        procedure Interrupcion is
        begin
            Llamada_Pendiente := True;
        end Interrupcion;
        entry Esperar_Evento when Llamada_Pendiente is
        begin
            Llamada_Pendiente := False;
        end Llamada_Pendiente; --Esperar_Evento
    end Controlador_Eventos;

    task body Esporadica is
    begin
        loop
            Controlador_Eventos.Esperar_Evento;
            -- Accion
            Put_Line("Llamada a esporadica");
        end loop;
    end Esporadica;



begin
    null;
end controlador;