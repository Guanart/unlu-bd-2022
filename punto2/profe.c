#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Foma de compilacion:
 * $ gcc -Wall -o secdelim2 secdelim2.c
 * Forma de ejecucion:
 * $ ./secdelim2
 */

// declaro prototipo de funciones de "alto nivel" opciones de menu
void lectura();
void baja();
void modifico();
void agrego();

// funciones de mas bajo nivel, pero no obstante, no son reusables, solo sirven para este programa
void muestroProducto(int *,char *,double *);

// declaro prototipo de funciones de "mas bajo nivel"
// void corrijoCadena(char *);  funcion mal definida, es mas reusable reemplazoCadena()
void reemplazoCadena(char *,char,char);
void ingresoCadena(char *,int);
int ingresoEntero();
double ingresoDoble();

int main(int argc, char **argv)
{
        int opcion=0;
        do {
                printf("MENU ABM SOBRE ARCHIVO SECUENCIAL\n");
                printf("No tiene mucho sentido todo esto, en especial  baja y modificacion\n");
                printf("Los archivos secuenciales son para ser leidos y procesados,\n"
                       "para agregar registros al final del archivo (append)\n\n");
                printf("1. Mostrar Archivo\n");
                printf("2. Borrar Producto\n");
                printf("3. Modificar Producto\n");
                printf("4. Agregar Producto\n");
                printf("99. Salir\n");
                printf("Ingrese su Opcion:");
                opcion = ingresoEntero();
                switch(opcion) {
                        case 1:
                                // uso funcion
                                lectura();
                                break;
                        case 2:
                                // uso funcion
                                baja();
                                break;
                        case 3:
                                modifico();
                                break;
                        case 4:
                                agrego();
                                break;
                }
        } while(opcion != 99);

        printf("fin!\n");
}

/**********************************************************************
 * funciones de alto nivel, NO reusables en otros proyectos
 * propias de este programa
 **********************************************************************/

// implemento funcion
void lectura() {
        // arbro archivo
        FILE *f = fopen("datos.txt","r");
        // proceso archivo
        int codigo=0, nc=0;
        char nombre[200];
        double precio=0.0;

        do {
                //printf("hago fscanf()\n");
                nc = fscanf(f,"%d %s %lf",&codigo,nombre,&precio);
                if ( nc == 3 ) {
                        // este registro es correcto! y lo proceso
                        //corrijoCadena(nombre);
                        reemplazoCadena(nombre,'_',' ');
                        printf("feof=%2d, nc = %2d",feof(f),nc);
                        muestroProducto(&codigo,nombre,&precio);
                        printf("\n");
                } else {
                        // termino el proceso del archivo, error de formato de registro o bien EOF
                        if ( !feof(f) ) { // si no es fin de archivo, entonces esta mal el formato del registro
                                printf("Error en formato de Registro!\n");
                        }
                }
                //printf("loop nc=%d\n",nc);
        } while(!feof(f) && nc == 3);

        // cierro archivo
        fclose(f);
}

void baja() {
        // arbro archivo
        FILE *f = fopen("datos.txt","r");
        FILE *fw = fopen("datos2.txt","w"); // creo archivo, si antes existia, lo destruye
        // proceso archivo
        int codigo=0, dcodigo=0, nc=0;
        char nombre[200];
        double precio=0.0;

        printf("Ingrese el Codigo de Producto a Borrar (-1=salir):");
        dcodigo = ingresoEntero();
        if ( dcodigo == -1 || dcodigo <= 0 ) {
                fclose(f);
                fclose(fw);
                remove("datos2.txt"); // elimino archivo temporario creado antes
                return; // me voy, retorno a main()
        }

        do {
                nc = fscanf(f,"%d %s %lf",&codigo,nombre,&precio);
                if ( nc == 3 ) {
                        // este registro es correcto! y lo proceso
                        //corrijoCadena(nombre);  // ahora no necesito cambiar _ por espacio porque paso el registro tal cual esta
                        //reemplazoCadena(nombre,'_',' ');
                        if ( codigo != dcodigo ) {
                                // copio registro
                                fprintf(fw,"%d %s %lf\n",codigo,nombre,precio);
                        } else {
                                // no lo copio, no hago nada, este registro lo ignoro, no queda en el nuevo archivo
                                printf("Registro a dar de baja:\n");
                                muestroProducto(&codigo,nombre,&precio);
                                printf("\n");
                        }
                } else {
                        // termino el proceso del archivo, error de formato de registro o bien EOF
                        if ( !feof(f) ) { // si no es fin de archivo, entonces esta mal el formato del registro
                                printf("Error en formato de Registro!\n");
                        }
                }
        } while(!feof(f) && nc == 3);

        // cierro archivo
        fclose(f);
        fclose(fw);
        remove("datos.txt"); // borro archivo original
        rename("datos2.txt","datos.txt"); // cambio archivo temporal por archivo original
}
void modifico() {
        // arbro archivo
        FILE *f = fopen("datos.txt","r");
        FILE *fw = fopen("datos2.txt","w"); // creo archivo, si antes existia, lo destruye
        // proceso archivo
        int codigo=0, dcodigo=0, nc=0;
        char nombre[200];
        double precio=0.0;

        printf("Ingrese el Codigo de Producto a Modificar (-1=salir):");
        dcodigo = ingresoEntero();
        if ( dcodigo == -1 || dcodigo <= 0 ) {
                fclose(f);
                fclose(fw);
                remove("datos2.txt"); // elimino archivo temporario creado antes
                return; // me voy, retorno a main()
        }

        do {
                nc = fscanf(f,"%d %s %lf",&codigo,nombre,&precio);
                if ( nc == 3 ) {
                        // este registro es correcto! y lo proceso
                        //corrijoCadena(nombre);  // ahora no necesito cambiar _ por espacio porque paso el registro tal cual esta
                        //reemplazoCadena(nombre,'_',' ');
                        if ( codigo != dcodigo ) {
                                // copio registro
                                fprintf(fw,"%d %s %lf\n",codigo,nombre,precio);
                        } else {
                                printf("Registro a modificar:\n");
                                muestroProducto(&codigo,nombre,&precio);
                                printf("\n");
                                printf("Ingrese nuevamente los datos de este registro:\n");
                                printf("Nombre:");ingresoCadena(nombre,100);
                                reemplazoCadena(nombre,' ','_'); // cambio espacios por _ para luego no tener problemas con la lectura fscanf()
                                printf("Precio:");precio = ingresoDoble();
                                fprintf(fw,"%d %s %lf\n",codigo,nombre,precio);
                                printf("Registro Modificado!\n");
                        }
                } else {
                        // termino el proceso del archivo, error de formato de registro o bien EOF
                        if ( !feof(f) ) { // si no es fin de archivo, entonces esta mal el formato del registro
                                printf("Error en formato de Registro!\n");
                        }
                }
        } while(!feof(f) && nc == 3);

        // cierro archivo
        fclose(f);
        fclose(fw);
        remove("datos.txt"); // borro archivo original
        rename("datos2.txt","datos.txt"); // cambio archivo temporal por archivo original
}

void agrego() {
        // arbro archivo
        FILE *f = fopen("datos.txt","a");
        // proceso archivo
        int codigo=0;
        char nombre[200];
        double precio=0.0;

        // atencion! como es archivo secuencial sin manejo de clave primaria
        // aqui se pueden ingresar codigos de producto repetidos

        printf("Ingrese el Codigo de Producto a Agregar (-1=salir):");
        codigo = ingresoEntero();
        while(codigo != -1 && codigo > 0) {
                printf("Nombre:");ingresoCadena(nombre,100);
                reemplazoCadena(nombre,' ','_'); // cambio espacios por _ para luego no tener problemas con la lectura fscanf()
                printf("Precio:");precio = ingresoDoble();
                fprintf(f,"%d %s %lf\n",codigo,nombre,precio);
                printf("Registro Agregado!\n");
                printf("Ingrese el Codigo de Producto a Agregar (-1=salir):");
                codigo = ingresoEntero();
        }

        // cierro archivo
        fclose(f);
}

// mas bajo nivel, pero no resuables
void muestroProducto(int *codigo,char *nombre,double *precio) {
        printf("%6.0d %-30s %8.2lf",*codigo,nombre,*precio);
}



/**********************************************************************
 * funciones de mas bajo nivel, reusables en otros proyectos
 * funciones que pueden convertirse en una o mas librerias
 * para ser reusadas
 **********************************************************************/

/*
// cambio _ por espacio en la cadena apuntada por p
void corrijoCadena(char *p) {
        // mientras lo apuntado por p sea distinto de NULL (cero binario)
        while(*p) {
                if ( *p == '_' ) *p = ' ';
                p++;
        }
}
*/
// busco caracter busco en cadena p y lo reemplazo por caracter reemplazo
void reemplazoCadena(char *p,char busco,char reemplazo) {
        // mientras lo apuntado por p sea distinto de NULL (cero binario)
        while(*p) {
                if ( *p == busco ) *p = reemplazo;
                p++;
        }
}


// ingresa cadena de caracteres por teclado
void ingresoCadena(char *destino,int largo) {
        fgets(destino,largo,stdin);
        destino[strlen(destino)] = '\0'; // quito el \n que tipeo el usuario
}
// ingresa por teclado un numero entero
int ingresoEntero() {
        char buffer[200];
        ingresoCadena(buffer,200);
        return atoi(buffer);
}
// ingresa por teclado un numero double
double ingresoDoble() {
        char buffer[200];
        ingresoCadena(buffer,200);
        return atof(buffer);
}