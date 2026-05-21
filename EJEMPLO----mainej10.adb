with Ada.Integer_Text_Io, Ada.Text_Io, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_Io, Coladinamica, Lista;
use Ada.Integer_Text_Io, Ada.Text_Io, Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_Io;

procedure Mainej10 is 
   


   package Cola_Auto is new Coladinamica(Unbounded_String);
   use Cola_Auto;
   

   type Empleado is record
      Nombre:Unbounded_String;
      Autos:Cola_Auto.Tipocoladinamica;
   end record;
   
   package Lista_Emp is new Lista(Empleado);
   use Lista_Emp;
   

   procedure proceso (Lista:in out Lista_Emp.Tipolista) is 
      Ptr_Aux:Lista_Emp.Tipolista:=lista;
      Reg_Emp:Empleado;
      patente:unbounded_string;
   begin
      put_line("---Turnos a atender---");
      while not Vacia (ptr_aux) loop
         Reg_Emp:=Info(Ptr_Aux);
         Ptr_Aux:=Sig(Ptr_Aux);
         Put_Line("Nombre del empleado: " & To_String(Reg_Emp.Nombre));
         if not Vacia(Reg_Emp.Autos) then
            suprimir(lista,reg_emp);
            Supcola(Reg_Emp.Autos,Patente);
            Put_Line("Patente prox a atender: " & To_String(Patente));
            Insertar(Lista,Reg_Emp);
         else
            put_line("El empleado no tiene autos para atender");
            end if;
         Put_Line("-----------------");         
            
         end loop;
      end Proceso;
      
            
         
         
    
   Var_Lista:Lista_Emp.Tipolista;
   
begin
   Proceso(Var_Lista);
end Mainej10;

         
   
