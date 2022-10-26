
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

with symptoms; use symptoms;

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
    task DistanciaSeguridad is
        pragma priority (15);
    end DistanciaSeguridad;

    task CabezaInclinada is
        pragma priority (16);
    end CabezaInclinada;

    task GiroVolante is
        pragma priority (17);
    end GiroVolante;

    task Deteccion is
        pragma priority (20);
    end Deteccion;


    -----------------------------------------------------------------------
    ------------- body of tasks 
    -----------------------------------------------------------------------

    -- Aqui se escriben los cuerpos de las tareas
    task body DistanciaSeguridad is
    Current_D: Distance_Samples_Type := 0;
    Current_V: Speed_Samples_Type := 0;
    Distancia_Segura : float := 0.0;
    N : integer := 300;
    Next : Ada.Real_Time.Time := Big_Bang + Milliseconds(N);
    begin
        loop
            Starting_Notice("DistanciaSeguridad");
            Reading_Speed (Current_V);
            Reading_Distance (Current_D);
            --Display_Distance (Current_D);
            Distancia_Segura := (float(Current_V) / 10.0) ** 2;
            if (float(Current_D) < Distancia_Segura / 3.0) then
                symptoms.Datos.SetDistancia(COLISION);
            elsif (float(Current_D) < Distancia_Segura / 2.0) then
                symptoms.Datos.SetDistancia(IMPRUDENTE);
            elsif (float(Current_D) < Distancia_Segura) then
                symptoms.Datos.SetDistancia(INSEGURA);
            else
                symptoms.Datos.SetDistancia(SEGURA);
            end if;
            Finishing_Notice("DistanciaSeguridad");

            delay until Next;
            Next := Next + Milliseconds(N);
        end loop;
    end DistanciaSeguridad;

    task body CabezaInclinada is
    Current_H: HeadPosition_Samples_Type := (+2,-2);
    Old_Current_H: HeadPosition_Samples_Type := (+2,-2);
    Current_S: Steering_Samples_Type := 0;
    N : integer := 400;
    Next : Ada.Real_Time.Time := Big_Bang + Milliseconds(N);
    begin
        loop
            Starting_Notice("CabezaInclinada");
            Reading_HeadPosition (Current_H);
            --Display_HeadPosition_Sample (Current_H);
            Reading_Steering (Current_S);
            if ((Current_H(x) > 30 and Old_Current_H(x) > 30) or
            (Current_H(x) < -30 and Old_Current_H(x) < -30)) then
                symptoms.Datos.SetCabezaInclinada(true);
            elsif (((Current_H(y) > 30 and Old_Current_H(y) > 30) and Current_S <= 0) or
            ((Current_H(x) < -30 and Old_Current_H(x) < -30) and Current_S >= 0)) then
                symptoms.Datos.SetCabezaInclinada(true);
            else
                symptoms.Datos.SetCabezaInclinada(false);
            end if;

            Old_Current_H := Current_H;
            Finishing_Notice("CabezaInclinada");
            delay until Next;
            Next := Next + Milliseconds(N);
        end loop;
    end CabezaInclinada;

    task body GiroVolante is
    Current_S: Steering_Samples_Type := 0;
    Old_S: Steering_Samples_Type := 0;
    Current_V: Speed_Samples_Type := 0;
    N : integer := 350;
    Next : Ada.Real_Time.Time := Big_Bang + Milliseconds(N);
    begin
        loop
            Starting_Notice("GiroVolante");
            Reading_Steering (Current_S);
            Reading_Speed (Current_V);
            if abs(Current_S - Old_S) > 20 and Current_V > 40 then
                symptoms.Datos.SetVolantazo(true);
            else
                symptoms.Datos.SetVolantazo(false);
            end if;
            Old_S := Current_S;
            Finishing_Notice("GiroVolante");
            delay until Next;
            Next := Next + Milliseconds(N);
        end loop;
    end GiroVolante;

    task body Deteccion is
    Current_V: Speed_Samples_Type := 0;
    N : integer := 150;
    Next : Ada.Real_Time.Time := Big_Bang + Milliseconds(N);
    begin
        loop
            Starting_Notice("Deteccion");
            Reading_Speed (Current_V);

            -- DISTANCIA
            if symptoms.Datos.GetCabezaInclinada and
            symptoms.Datos.GetDistancia = COLISION then
                Beep(5);
                Activate_Brake;
            elsif symptoms.Datos.GetDistancia = IMPRUDENTE then
                Beep(4);
                Light(On);
            elsif symptoms.Datos.GetDistancia = INSEGURA then
                Light(On);
            end if;


            -- CABEZA INCLINADA
            if symptoms.Datos.GetCabezaInclinada = true then
                if Current_V >= 70 then
                    Beep(3);
                else
                    Beep(2);
                end if;
            end if;

            -- VOLANTAZO
            if symptoms.Datos.GetVolantazo = true then
                Beep(1);
            end if;
            Finishing_Notice("Deteccion");
            delay until Next;
            Next := Next + Milliseconds(N);
        end loop;
    end Deteccion;

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



