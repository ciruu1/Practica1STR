with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

with symptoms; use symptoms;
with measures; use measures;

package body maintasks is
    task body DistanciaSeguridad is
    Current_D: Distance_Samples_Type := 0;
    Current_V: Speed_Samples_Type := 0;
    Distancia_Segura : float := 0.0;
    N : integer := 300;
    Next : Ada.Real_Time.Time := Big_Bang + Milliseconds(N);
    I : Time;
    D : Time_Span;
    begin
        loop
            I := Clock;
            Starting_Notice("Distancia");
            Reading_Speed (Current_V);
            Reading_Distance (Current_D);
            measures.Datos.SetDistancia(Integer(Current_D));
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
            Finishing_Notice("Distancia");

            D := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(D)));

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
    I : Time;
    D : Time_Span;
    begin
        loop
            I := Clock;
            Starting_Notice("Cabeza");
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
            Finishing_Notice("Cabeza");

            D := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(D)));

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
    I : Time;
    D : Time_Span;
    begin
        loop
            I := Clock;
            Starting_Notice("Volante");
            Reading_Steering (Current_S);
            Reading_Speed (Current_V);
            if abs(Current_S - Old_S) > 20 and Current_V > 40 then
                symptoms.Datos.SetVolantazo(true);
            else
                symptoms.Datos.SetVolantazo(false);
            end if;
            Old_S := Current_S;
            Finishing_Notice("Volante");

            D := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(D)));

            delay until Next;
            Next := Next + Milliseconds(N);
        end loop;
    end GiroVolante;

    task body Riesgos is
    Current_V: Speed_Samples_Type := 0;
    N : integer := 150;
    Next : Ada.Real_Time.Time := Big_Bang + Milliseconds(N);
    Dist : TipoDistancia;
    I : Time;
    D : Time_Span;
    begin
        loop
            I := Clock;
            Starting_Notice("Riesgos");
            Reading_Speed (Current_V);
            measures.Datos.SetVelocidad(Integer(Current_V));

            Dist := symptoms.Datos.GetDistancia;

            -- DISTANCIA
            if symptoms.Datos.GetCabezaInclinada and
            Dist = COLISION then
                Beep(5);
                Activate_Brake;
            elsif Dist = IMPRUDENTE then
                Beep(4);
                Light(On);
            elsif Dist = INSEGURA then
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
            Finishing_Notice("Riesgos");

            D := Clock - I;
            Put_Line(Duration'Image(To_Duration(D)));

            delay until Next;
            Next := Next + Milliseconds(N);
        end loop;
    end Riesgos;

    task body Display is
    N : integer := 1000;
    Next : Ada.Real_Time.Time := Big_Bang + Milliseconds(N);
    Current_V: Speed_Samples_Type := 0;
    Current_D: Distance_Samples_Type := 0;
    Dist : TipoDistancia;
    I : Time;
    D : Time_Span;
    begin
        loop
            I := Clock;
            Dist := symptoms.Datos.GetDistancia;
            Starting_Notice("Display");
            Reading_Speed (Current_V);
            Reading_Distance (Current_D);
            New_Line;
            Put_Line("----------------DISPLAY----------------");
            Put("Velocidad actual: ");
            Print_an_Integer (measures.Datos.GetVelocidad);
            New_Line;
            Put_Line("----------------");
            Put("Distancia actual: ");
            Print_an_Integer (measures.Datos.GetDistancia);
            New_Line;
            Put_Line("----------------");
            Put_Line("Sintomas detectados");
            -- DISTANCIA
            if symptoms.Datos.GetCabezaInclinada and
            Dist = COLISION then
                Put_Line("COLISION INMINENTE");
            elsif Dist = IMPRUDENTE then
                Put_Line("DISTANCIA IMPRUDENTE");
            elsif Dist = INSEGURA then
                Put_Line("DISTANCIA INSEGURA");
            end if;

            -- CABEZA INCLINADA
            if symptoms.Datos.GetCabezaInclinada = true then
                Put_Line("CABEZA INCLINADA");
            end if;

            -- VOLANTAZO
            if symptoms.Datos.GetVolantazo = true then
                Put_Line("VOLANTAZO");
            end if;


            Put_Line("---------------------------------------");
            Finishing_Notice("Display");

            D := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(D)));

            delay until Next;
            Next := Next + Milliseconds(N);
        end loop;
    end Display;
end maintasks;