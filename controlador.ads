with Kernel.Serial_Output; use Kernel.Serial_Output;

package controlador is
    protected Controlador_Eventos is
        pragma Priority(System.Interrupt_Priority'First + 9);
        procedure Interrupcion;
        pragma Attach_Handler (Interrupcion, Ada.Interrupts.Names.External_Interrupt_2);
        entry Esperar_Evento;

        private
            Llamada_Pendiente : Boolean := False; --barrera
    end Controlador_Eventos;

    task Esporadica
        pragma Priority(16);
    end Esporadica;

end controlador;