
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

-- Packages needed to generate pulse interrupts       
-- with Ada.Interrupts.Names;
-- with Pulse_Interrupt; use Pulse_Interrupt;

package body add is

    ----------------------------------------------------------------------
    ------------- procedure exported 
    ----------------------------------------------------------------------
    procedure Background is
    begin
      loop
        null;
      end loop;
    end Background;
    ----------------------------------------------------------------------

    -----------------------------------------------------------------------
    ------------- declaration of tasks 
    -----------------------------------------------------------------------

    -- Aqui se declaran las tareas que forman el STR
    task SensorDistancia20 is
        pragma priority (15);
    end SensorDistancia20;

    task CabezaInclinada is
        pragma priority (16);
    end CabezaInclinada;


    -----------------------------------------------------------------------
    ------------- body of tasks 
    -----------------------------------------------------------------------

    -- Aqui se escriben los cuerpos de las tareas
    task body SensorDistancia20 is
    Current_D: Distance_Samples_Type := 0;
    Current_V: Speed_Samples_Type := 0;
    begin
        for i in 1..20 loop
            Reading_Speed (Current_V);
            Reading_Distance (Current_D);
            Display_Distance (Current_D);
                if (Current_D < 30) then Beep(5);
                elsif (Current_D < 60 and Current_V > 80) then Beep(2);
                end if;
            delay until (Clock + Milliseconds(200));
        end loop;
    end SensorDistancia20;

    task body CabezaInclinada is
    Current_H: HeadPosition_Samples_Type := (+2,-2);
    Old_Current_H: HeadPosition_Samples_Type := (+2,-2);
    Current_S: Steering_Samples_Type := 0;
    begin
        loop
            Reading_HeadPosition (Current_H);
            Display_HeadPosition_Sample (Current_H);
            Reading_Steering (Current_S);
            if ((Current_H(x) > 30 and Old_Current_H(x) > 30) or
            (Current_H(x) < -30 and Old_Current_H(x) < -30)) then
                -- CABEZA INCLINADA := TRUE
                New_Line;
                Put_Line("TRUE");
            elsif (((Current_H(y) > 30 and Old_Current_H(y) > 30) and Current_S <= 0) or
            ((Current_H(x) < -30 and Old_Current_H(x) < -30) and Current_S >= 0)) then
                -- CABEZA INCLINADA := TRUE
                New_Line;
                Put_Line("TRUE");
            else
                -- CABEZA INCLINADA := FALSE
                New_Line;
                Put_Line("FALSE");
            end if;

            Old_Current_H := Current_H;
            delay until (Clock + Milliseconds(400));
        end loop;
    end CabezaInclinada;


    ----------------------------------------------------------------------
    ------------- procedure para probar los dispositivos 
    ----------------------------------------------------------------------
    procedure Prueba_Dispositivos; 

    Procedure Prueba_Dispositivos is
        Current_V: Speed_Samples_Type := 0;
        Current_H: HeadPosition_Samples_Type := (+2,-2);
        Current_D: Distance_Samples_Type := 0;
        Current_O: Eyes_Samples_Type := (70,70);
        Current_E: EEG_Samples_Type := (1,1,1,1,1,1,1,1,1,1);
        Current_S: Steering_Samples_Type := 0;
    begin
         Starting_Notice ("Prueba_Dispositivo");

         for I in 1..120 loop
         -- Prueba distancia
            --Reading_Distance (Current_D);
            --Display_Distance (Current_D);
            --if (Current_D < 40) then Light (On); 
            --                    else Light (Off); end if;

         -- Prueba velocidad
            --Reading_Speed (Current_V);
            --Display_Speed (Current_V);
            --if (Current_V > 110) then Beep (2); end if;

         -- Prueba volante
            --Reading_Steering (Current_S);
            --Display_Steering (Current_S);
            --if (Current_S > 30) OR (Current_S < -30) then Light (On);
                                                     --else Light (Off); end if;

         -- Prueba Posicion de la cabeza
            --Reading_HeadPosition (Current_H);
            --Display_HeadPosition_Sample (Current_H);
            --if (Current_H(x) > 30) then Beep (4); end if;

         -- Prueba ojos
            --Reading_EyesImage (Current_O);
            --Display_Eyes_Sample (Current_O);

         -- Prueba electroencefalograma
            --Reading_Sensors (Current_E);
            --Display_Electrodes_Sample (Current_E);
   
         delay until (Clock + To_time_Span(0.1));
         end loop;

         Finishing_Notice ("Prueba_Dispositivo");
    end Prueba_Dispositivos;


begin
   Starting_Notice ("Programa Principal");
   Prueba_Dispositivos;
   Finishing_Notice ("Programa Principal");
end add;



