
PROGRAM tienda;
CONST
	NCTIPO = 15; {número caracteres tipo}
	NCIDENTIFICADOR = 4; {número caracteres del identificador del componente}
	MAXPC = 25; {número de ordenadores (PC) máximos en la tienda}
	MAXCOMPONENTES = 100; {número de componentes sueltos máximo}
	MIN = 1;
TYPE
	tTipo = string[NCTIPO]; {Tipo para almacenar el tipo del componente}
	tIdentificador = string[NCIDENTIFICADOR]; {Para almacenar el identificador}
	tNumComponentes = MIN..MAXCOMPONENTES; {Para almacenar el índice de componentes}
	tNumPc = MIN..MAXPC; {Tipo para almacenar el índice de ordenadores}

	tComponente = RECORD {Tipo para almacenar un producto}
		tipo: tTipo;
		id: tIdentificador;
		descripcion: string;
		precio: real;
	END;

	tPc = RECORD {Tipo para almacenar un ordenador}
		datos, memoria, procesador, discoDuro: tComponente;
	END;

	tListaComponentes= ARRAY [tNumComponentes] OF tComponente;

	tListaPcs = ARRAY [tNumPc] OF tPc;

	tAlmacenComponentes = RECORD {Almacén de componentes}
		listaComponentes : tListaComponentes;
		tope: integer;
	END;

	tAlmacenPcs = RECORD {Almacén de Pcs}
		listaPcs: tListaPcs;
		tope: integer;
	END;

	tTienda = RECORD {Tienda}
		almacenPcs: tAlmacenPcs;
		almacenComponentes: tAlmacenComponentes;
		ventasTotales: real; {Almacena el total de la ventas}
	END;

	tFicheroPcs = FILE OF tPc;
	tFicheroComponentes = FILE OF tComponente;
VAR
	opcionMenu:char;
	datosTienda:tAlmacenComponentes;
	datosTiendapcs:tAlmacenPcs;
	dato:tIdentificador;
	datoTienda:tTienda;
	almacenTienda:tTienda;
	encuentra:boolean;
	ficheroComponentes :text;
	ficheroPcs:text;
	nombreFichero:string;
	nombreFichero1:string;
	ficherocomp:tFicheroComponentes;
	ficheropc:tFicheroPcs;
	identificador:tIdentificador;

PROCEDURE mostrarMenu;{mostrarMenu}
BEGIN
	writeln('********************************');
    writeln('Autores: Guillermo Navas Gracia');
    writeln('         Ivan Perez Huete');
    writeln('         Daniel Peña Martinez');
    writeln('         Jesus Prieto Garcia');
    writeln('********************************');
    writeln;
    writeln('*****************  MENU  *****************');
    writeln;
    writeln('---------  a) Dar de alta un componente    --------');
    writeln('---------  b) Configurar un ordenador     --------');
    writeln('---------  c) Modificar un componente    --------');
    writeln('---------  d) Vender un componente    --------');
    writeln('---------  e) Vender un ordenador    --------');
    writeln('---------  f) Mostrar ventas actuales    --------');
    writeln('---------  g) Mostrar todos los ordenadores (ordenados por precio)    --------');
    writeln('---------  h) Mostrar todos los componentes sueltos   --------');
    writeln('---------  i) Guardar datos en los ficheros binarios    --------');
    writeln('---------  j) Guardar datos en ficheros de texto    --------');
    writeln('---------  k) Cargar datos en ficheros binarios    --------');
	writeln('---------  l) Cargar datos en ficheros de texto   --------');
	writeln('---------  m) Finalizar --------');
	writeln;
	writeln('Elija una opcion');
END;{mostrarMenu}


PROCEDURE altaComponente (VAR datos:tAlmacenComponentes);
VAR
	i:integer;
	contador:integer;
	identificador:tIdentificador;
BEGIN{altaComponente}
	IF datos.tope<MAXCOMPONENTES THEN BEGIN
		i:=datos.tope+1;
		WITH datos.listaComponentes[i] DO BEGIN
			identificador:=id;
			contador:=MIN;
			writeln('Introduzca identificador del componente(max. 4 caracteres): ');
			readln(id);
				WHILE (contador>MAXPC) AND (id<>identificador) DO BEGIN {Verifica que no se repita el identificador}
					contador:=contador+1;
					IF id=identificador THEN
						writeln('Este componente ya está en la tienda')
					ELSE
						writeln('El componente se puede añadir a la lista');
				END;
			writeln('Introduzca el tipo de componente (procesador, memoria o disco duro): ');
			readln(tipo);
			writeln('Introduzca la descripcion del componente: ');
			readln(descripcion);
			writeln('Introduzca el precio de venta del componente: ');
			readln(precio);
		END;{WITH}
		datos.tope:=datos.tope+1;
	END;{IF}
END;{altaComponente}

PROCEDURE Eliminar (VAR datos:tAlmacenComponentes ; idem:string);
VAR
	i:integer;
BEGIN
	WITH datos DO BEGIN
		FOR i:=MIN TO tope DO BEGIN
			IF idem = listaComponentes[i].id THEN BEGIN
				listaComponentes[i] := listaComponentes[tope];
				tope:=tope-1;
			END;
		END;
	END;
END;

PROCEDURE configurarOrdenador(VAR datos:tAlmacenComponentes ; VAR datospcc:tAlmacenPcs );
VAR
	i,j:integer;
	idmem,iddisco,idproce,identi:tIdentificador;
	 pc:tNumPc;
	aux1,aux2,aux,suma:real;
BEGIN
	j:=0;
	i:=datospcc.tope;

	IF pc=datospcc.tope THEN
	writeln('no se puede añadir ninguno mas')
	ELSE
	BEGIN
			writeln('introduzca la id del disco duro');
			readln(iddisco);
			WITH datos DO
				WHILE  (iddisco <> listaComponentes[j].id) DO
				j:=j+1;
				END;
				datospcc.listaPcs[i].discoDuro.tipo:=datos.listaComponentes[j].tipo;
				datospcc.listaPcs[i].discoDuro.id:=iddisco ;
				datospcc.listaPcs[i].discoDuro.descripcion:=datos.listaComponentes[j].descripcion;
				datospcc.listaPcs[i].discoDuro.precio:=datos.listaComponentes[j].precio ;
				aux:=datospcc.listaPcs[i].discoDuro.precio;
				Eliminar( datos,iddisco);
				writeln('introduzca la id de la memoria');
			readln(idmem);
			WITH datos DO
				WHILE  (idmem <> listaComponentes[j].id) DO BEGIN
				j:=j+1;
				END;
				datospcc.listaPcs[i].memoria.tipo:=datos.listaComponentes[j].tipo;
				datospcc.listaPcs[i].memoria.id:=idmem ;
				datospcc.listaPcs[i].memoria.descripcion:=datos.listaComponentes[j].descripcion;
				datospcc.listaPcs[i].memoria.precio:=datos.listaComponentes[j].precio ;
				aux1:=datospcc.listaPcs[i].memoria.precio;
				Eliminar( datos,idmem);
				writeln('introduzca la id del procesador');
			readln(idproce);
			WITH datos DO
				WHILE  (idproce <> listaComponentes[j].id) DO BEGIN
				j:=j+1;
				END;
				datospcc.listaPcs[i].procesador.tipo:=datos.listaComponentes[j].tipo;
				datospcc.listaPcs[i].procesador.id:=iddisco ;
				datospcc.listaPcs[i].procesador.descripcion:=datos.listaComponentes[j].descripcion;
				datospcc.listaPcs[i].procesador.precio:=datos.listaComponentes[j].precio ;
				aux2:=datospcc.listaPcs[i].procesador.precio;
				Eliminar( datos,idproce);

			writeln('Introduzca el identificador del ordenador');
					readln(identi);
					datospcc.tope:=datospcc.tope + 1;
					datospcc.listaPcs[i].datos.id:=identi;
					suma:=aux+aux1+aux2+10;
					datospcc.listaPcs[i].datos.precio:=suma;
END;


PROCEDURE mostrarVentaComponente (numero:integer; VAR datos:tAlmacenComponentes);
BEGIN{mostrarVentaComponente}
	WITH datos.listaComponentes[numero] DO BEGIN
		writeln('Tipo: ',tipo);
		writeln('Id: ',id);
		writeln('Descripcion: ',descripcion);
		writeln('Precio: ',precio:0:2);
	END;{WITH}
END;{mostrarVentaComponente}

PROCEDURE venderComponente (iden:tIdentificador; VAR datos:tAlmacenComponentes; VAR datos2:tTienda);
VAR
	i:integer;
	SiNo:char;
BEGIN{venderComponente}
	i:=0;
	WITH datos DO BEGIN
		WHILE (i<tope) AND (iden<>listaComponentes[i].id) DO BEGIN
			i:=i+1;
		END;{WHILE}
		IF (iden=listaComponentes[i].id) THEN BEGIN
			mostrarVentaComponente(i,datos);
			writeln('¿Desea eliminar el componente? (s/n)');
			readln(SiNo);
			CASE SiNo OF
				'S', 's':	BEGIN
								listaComponentes[i]:=listaComponentes[tope];
								tope:=tope-1;
								writeln('Componente vendido');
							END;
				'N', 'n':	BEGIN
								writeln('Venta cancelada por el usuario');
							END;
			ELSE
				writeln('Debe de introducir (s) ó (n)');
			END;{CASE}
		END
		ELSE
			writeln('Componente no encontrado');
	END;{WITH}
	datos2.ventasTotales:=(datos2.ventasTotales + datos.listaComponentes[i].precio);
END;{venderComponente}

PROCEDURE modificarComponente (idMod:string; VAR datos:tAlmacenComponentes);
VAR
	i,contador:integer;
	nuevoTipo:tTipo;
	nuevoDesc:string;
	nuevoPrecio:real;
	nuevoDato:char;
BEGIN
	contador:=0;
	WITH datos DO BEGIN
		FOR i:=MIN TO tope DO BEGIN
			IF (listaComponentes[i].id=idMod) THEN BEGIN
				writeln('Componente encontrado, sus datos son: ');
				writeln;
				writeln('Tipo: ',listaComponentes[i].tipo);
				writeln('Id: ',listaComponentes[i].id);
				writeln('Descripcion: ',listaComponentes[i].descripcion);
				writeln('Precio: ',listaComponentes[i].precio:0:2);
				writeln;
				writeln('¿Que datos desea modificar? A(Tipo), B(Descricpion), C(Precio) (identifador no es posible)');
				readln(nuevoDato);
				CASE nuevoDato OF
					'a','A':	BEGIN
									writeln('Introduzca el nuevo tipo: ');
									readln(nuevoTipo);
									listaComponentes[i].tipo:=nuevoTipo;
								END;
					'b','B':	BEGIN
									writeln('Introduzca la nueva descripcion: ');
									readln(nuevoDesc);
									listaComponentes[i].descripcion:=nuevoDesc;
								END;
					'c','C':	BEGIN
									writeln('Introduzca el nuevo precio: ');
									readln(nuevoPrecio);
									listaComponentes[i].precio:=nuevoPrecio;
								END;
				ELSE
					writeln('Debe de introducir tipo, descripcion o precio');
				END;{CASE}
			END
			ELSE BEGIN
				contador:=contador+1;
				IF contador=tope THEN
					writeln('Componente no encontrado');
			END;{IF}
		END;{FOR}
	END;{WITH}
END;
{PROCEDURE configuracionComponente (VAR datos:tAlmacenComponentes; datosPcs:tAlmacenPcs);}
PROCEDURE venderOrdenador (id:tIdentificador; VAR datosOrd:tAlmacenPcs; tiendaa:tTienda);
VAR
opcionSN:char;
contador,o:integer;

BEGIN
	contador:=0;
	WITH datosOrd DO BEGIN
		FOR o:=MIN TO tope DO BEGIN
			IF (listaPcs[o].datos.id=id) OR (listaPcs[o].memoria.id=id) OR (listaPcs[o].procesador.id=id) OR (listaPcs[o].discoDuro.id=id)THEN BEGIN
				writeln('Odenador encontrado, sus datos son: ');
				writeln;
				writeln('Datos: ');
					WITH listaPcs[o].datos DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
				writeln('Memoria: ');
					WITH listaPcs[o].memoria DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
				writeln('Procesador: ');
					WITH listaPcs[o].procesador DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
				writeln('Disco Duro: ');
					WITH listaPcs[o].discoDuro DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
				writeln;
				writeln('¿Esta seguro de vender este ordenador?');
				readln(opcionSN);
				CASE opcionSN OF {CASE}
				'S', 's':	BEGIN
								listaPcs[o]:=listaPcs[tope];
								tope:=tope-1;
								writeln('El ordenador seleccionado ha sido vendido');
							END;
				'N', 'n':	BEGIN
								writeln('Venta cancelada por el usuario');
							END;
				ELSE
					writeln('Debe decidir si vender o no (S/N)');
				END;{CASE}
				END
			ELSE BEGIN
				contador:=contador+1;
				IF contador=tope THEN
					writeln('Odenador no encontrado');
			END;{IF}
		END;{FOR}
		tiendaa.ventasTotales:=(tiendaa.ventasTotales + listaPcs[o].datos.precio);
	END;{WITH}
END;

{PROCEDURE mostrarVentas (datos:tTienda);}


PROCEDURE mostrarOrdenadores (dato:tAlmacenPcs);
VAR
	i, j:tNumPc ;
	o :integer;
	aux: real;
BEGIN
FOR i := MIN TO pred(MAXPC) DO
	FOR j := MIN TO MAXPC-i DO
 		IF dato.listaPcs[j].datos.precio > dato.listaPcs[j+1].datos.precio THEN
		 BEGIN
 			aux := dato.listaPcs[j].datos.precio ;
 			dato.listaPcs[j].datos.precio := dato.listaPcs[j+1].datos.precio ;
			dato.listaPcs[j+1].datos.precio:= aux
 		END; {IF}
	FOR o:=MIN TO dato.tope DO BEGIN
		WITH dato.listaPcs[o] DO BEGIN
			writeln('****************');
			writeln('Datos: ');
					WITH datos DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
			writeln('Memoria: ');
					WITH memoria DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
			writeln('Procesador: ');
					WITH procesador DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
			writeln('Disco Duro: ');
					WITH discoDuro DO BEGIN
						writeln('tipo: ',tipo);
						writeln('Id: ' ,id);
						writeln('Descripcion: ',descripcion);
						writeln('Precio: ',precio:0:2);
					END;
			writeln('****************');
		END; {WITH}
	END;{FOR}
END;


PROCEDURE mostrarComponentes (datos:tAlmacenComponentes);
VAR
	i:integer;
BEGIN
	FOR i:=MIN TO datos.tope DO BEGIN
		WITH datos.listaComponentes[i] DO BEGIN
			writeln('Tipo: ',tipo);
			writeln('Id: ',id);
			writeln('Descripcion: ',descripcion);
			writeln('Precio: ',precio:0:2);
		END;{WITH}
	END;{FOR}
END;
PROCEDURE guardarDatosBin (VAR fich:tFicheroComponentes;VAR fichPcs:tFicheroPcs; datos:tAlmacenComponentes ; datosPcs:tAlmacenPcs);
VAR
	i:integer;
	nombreFichero,nombreFicheroO:string;
BEGIN{guardardatos }
	writeln('Introduce el nombre del fichero donde se guardaran los datos de los componentes:');
	readln(nombreFichero);
	assign(fich,nombreFichero);
	rewrite(fich);
	FOR i:=MIN to datos.tope DO BEGIN
		write(fich,datos.listaComponentes[i]);
		writeln();
	writeln('...Componentes guardados en componentes.dat');
	END;
	close(fich);
	writeln('Introduce el nombre del fichero donde quieres que se guarden los datos de los Ordenadores:');
	readln(nombreficheroO);
	assign(fichPcs,nombreficheroO);
	rewrite(fichPcs);
	FOR i:=MIN to datosPcs.tope DO
		write(fichPcs,datosPcs.listaPcs[i]);
		writeln();
	write('...Ordenadores guardados en ordenadores.dat');
END;{guardar datos bin}

PROCEDURE guardarDatosText (datosComp:tAlmacenComponentes; datosPcs:tAlmacenPcs; VAR fichComp:text ; VAR fichPcs:text );
VAR
	i:integer;
BEGIN
	rewrite(fichComp);
	WITH datosComp DO BEGIN
		FOR i:=MIN to tope DO BEGIN
			write(fichComp,listaComponentes[i].tipo,' ');
			write(fichComp,listaComponentes[i].id,' ');
			writeln(fichComp,listaComponentes[i].descripcion,' ');
			writeln(fichComp,listaComponentes[i].precio,' ');
		END;
	END;
	close(fichComp);
	writeln('...Componentes guardados correctamente');

	rewrite(fichPcs);
	WITH datosPcs DO BEGIN
		FOR i:=MIN to tope DO BEGIN
			write(fichPcs,listaPcs[i].datos.tipo,' ');
			write(fichPcs,listaPcs[i].datos.id,' ');
			write(fichPcs,listaPcs[i].datos.descripcion,' ');
			write(fichPcs,listaPcs[i].datos.precio,' ');
			write(fichPcs,listaPcs[i].memoria.tipo,' ');
			write(fichPcs,listaPcs[i].memoria.id,' ');
			write(fichPcs,listaPcs[i].memoria.descripcion,' ');
			write(fichPcs,listaPcs[i].memoria.precio,' ');
			writeln(fichPcs,listaPcs[i].procesador.tipo,' ');
			writeln(fichPcs,listaPcs[i].procesador.id,' ');
			writeln(fichPcs,listaPcs[i].procesador.descripcion,' ');
			writeln(fichPcs,listaPcs[i].procesador.precio,' ');
			writeln(fichPcs,listaPcs[i].discoDuro.tipo,' ');
			writeln(fichPcs,listaPcs[i].discoDuro.id,' ');
			writeln(fichPcs,listaPcs[i].discoDuro.descripcion,' ');
			writeln(fichPcs,listaPcs[i].discoDuro.precio,' ');
		END;
	END;
	close(fichPcs);
	writeln('...Ordenadores guardados correctamente');

END;

PROCEDURE cargarDatosBin (VAR datosComp:tAlmacenComponentes; VAR datosPcs:tAlmacenPcs; VAR fichComp:tFicheroComponentes; VAR fichPcs:tFicheroPcs);
VAR
	i:integer;
BEGIN
	i:=MIN;
	reset(fichComp);
	WHILE NOT EOF(fichComp) DO BEGIN
		read(fichComp,datosComp.listaComponentes[i]);
		i:=i+1;
	END;
	close(fichComp);
	datosComp.tope:=i-1;

	reset(fichPcs);
	WHILE NOT EOF(fichPcs) DO BEGIN
		read(fichPcs,datosPcs.listaPcs[i]);
		i:=i+1;
	END;
	close(fichPcs);
	datosPcs.tope:=i-1;
END;


PROCEDURE cargarDatosText ;
VAR
    linea: string;
    archivo:string;
    fichero: text;
BEGIN {mostrarClasificacionFichero}
 	writeln('Introduzca la direccion en donde se encuentra el archivo que desea abrir componentes.txt');
 	readln(archivo);
  	assign(fichero, archivo);
  	writeln;
 	writeln;
  	reset(fichero);
  	WHILE NOT EOF(fichero) DO BEGIN
    	readln(fichero, linea);
    	writeln(linea);
  	END;
  	close(fichero);
  	readln();
  	writeln('Introduzca la direccion en donde se encuentra el archivo que desea abrir ordenador.txt');
 	readln(archivo);
  	assign(fichero, archivo);
  	writeln;
 	writeln;
  	reset(fichero);
  	WHILE NOT EOF(fichero) DO BEGIN
    	readln(fichero, linea);
    	writeln(linea);
  	END;
  	close(fichero);
  	readln();
END;

BEGIN{programaPrincipal}
	REPEAT
		mostrarMenu;
		readln(opcionMenu);
		CASE opcionMenu OF
			'a', 'A':	BEGIN{altaComponente}
							altaComponente(datosTienda);
						END;{altaComponente}
			'b', 'B':	BEGIN{configurarOrdenador}

						configurarOrdenador(datosTienda,datosTiendapcs);

						END;{configurarOrdenador}
			'c', 'C':	BEGIN{modificarComponente}
							IF datosTienda.tope<=0 THEN BEGIN
								writeln('No hay componentes en la tienda');
							END
							ELSE
								writeln('Identificador del componente a modificar');
								readln(dato);
								modificarComponente(dato,datosTienda);
						END;{modificarComponente}
			'd', 'D':	BEGIN{venderComponente}
							IF datosTienda.tope<=0 THEN BEGIN
								writeln('No hay componentes en la tienda');
							END
							ELSE
								writeln('Identificador del componente a vender');
								readln(dato);
								venderComponente(dato,datosTienda,datoTienda);
						END;{venderComponente}
			'e', 'E':	BEGIN{venderOrdenador}
							writeln ('Introduzca la id del ordenador que desea vender');
							readln(dato);
							venderOrdenador(dato,datosTiendapcs,datoTienda);
						END;{venderOrdenador}
			'f', 'F':	BEGIN{mostrarVentas}
						writeln('Se ha producido un total de :',almacenTienda.ventasTotales:2:2,'€');
						END;{mostrarVentas}
			'g', 'G':	BEGIN{mostrarOrdenadores}
						mostrarOrdenadores(datosTiendapcs);
						END;{mostrarOrdenadores}
			'h', 'H':	BEGIN{mostrarComponentes}
							IF datosTienda.tope<=0 THEN BEGIN
								writeln('No hay componentes en la tienda');
							END
							ELSE
								writeln('Los componentes actuales de la tienda: ');
								mostrarComponentes(datosTienda);
						END;{mostrarComponentes}
			'i', 'I':	BEGIN{guardarDatosBin}

						{writeln('Introduce el nombre del fichero donde se guardaran los datos de los ordenadores:');
						readln(nombreFichero1);
						assign(ficheropc,nombreFichero1);}
						guardarDatosBin(ficherocomp,ficheropc,datosTienda,datosTiendaPcs);
						END;{guardarDatosBin}
			'j', 'J':	BEGIN{guardarDatosText}
						writeln('Introduce el nombre del fichero donde se guardaran los datos de los componentes:');
						 	readln(nombreFichero);
						writeln('Introduce el nombre del fichero donde se guardaran los datos de los ordenadores:');
						 	readln(nombreFichero1);
							assign(ficheroComponentes,nombreFichero);
							assign(ficheroPcs,nombreFichero1);
							guardarDatosText(datosTienda,datosTiendapcs,ficheroComponentes,ficheroPcs);

						END;{guardarDatosText}
			'k', 'K':	BEGIN{cargarDatosBin}
						assign(ficherocomp,'C:\Users\guillermo\Desktop\componentes.dat');
						assign(ficheropc,'C:\Users\guillermo\Desktop\ordenadores.dat');
						cargarDatosBin(datosTienda,datosTiendapcs,ficherocomp,ficheropc);
						END;{cargarDatosBin}
			'l', 'L':	BEGIN{cargarDatosText}
							cargarDatosText;
						END;{cargarDatosText}
			'm', 'M':	BEGIN{finalizar}
							writeln('Programa terminado, pulse INTRO para salir del programa, GRACIAS');
						END;{finalizar}
			ELSE
				writeln('La opcion introducida es incorrecta');
		END;{CASE}
	UNTIL (opcionMenu='m') OR (opcionMenu='M');
	readln;
END.
{programaPrincipal}

