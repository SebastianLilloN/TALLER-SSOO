# TALLER01-SSOO

* Autor: Sebastián Lillo Núñez

* Correo: sebastian.lillon@alumnos.uv.cl

  A continuacion se presenta un desafio planeteado a modo de taller en donde se solicita caluclar estadistica descriptiva a través de distintos archivos en distintos directorios, todo esto desarrollado en GNU Bash. Para esto se planteo una metodología más un diseño previo para llevar a cabo la implementación de la solución a las tareas solicitadas. 
Cada directorio posee 3 archivos de texto plano, llamados executionSummary-NNN.txt, summary-NNN.text y usePhone-NNN.txt, y los campos están separados el símbolo “:” los cuales contienen los datos que son la fuente de análisis para este taller. Por tanto, se necesita de un ingreso de parámetros para ejecutar el script en la línea de comandos indicando en qué directorio debe inspeccionar los elementos. Se plantean 3 requerimientos en forma de tareas para analizar los datos y obtener resultados referentes a una solicitud en particular. Además, se utilizarán archivos intermedios de existencia volátil para poder organizar y operar los datos leídos en los archivos.
Para poder obtener los resultados de la estadística descriptiva debemos de leer los datos de los archivos de forma individual y por cada uno de ellos se deben realizar los cálculos pertinentes para obtener medidas como la media, valor máximo y mínimo, siendo almacenados en un archivo nuevo con su nombre respectivo, los cuales son: metrics.txt, evacuation.txt, usePhone.txt.
1. En la tarea uno se requiere de dos archivos temporales ya que se deben registrar dos datos entregados por las fuentes de datos, valga la redundancia y los resultados son almacenados en uno de los tres archivos finales.
2. En la tarea dos se utiliza de forma recursiva anidada el metodo con el cual se seleccionan los campos en las fuentes de datos, esto se debe a los variados parametros que solicitan, para luego realizar los calculos y exponerlos en el archivo final.
3. Y por último en la tarea tres se necesita considerar la forma de como accedar a cada segmento de la fuente de datos, ya que estan definidos en tramos de 10 en 10 en la columna *timeStamp* parámetro necesario para realizar en cálculo que se solicita.
En este repositorio se encuentra ademas un informe técnico que muestra mas en detalle el proceso de resolución del desafio llamado Taller01.
