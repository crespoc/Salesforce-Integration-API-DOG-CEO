# Dog Viewer App 🐾

## Descripción
Dog Viewer App es una aplicación desarrollada en Salesforce que permite a los amantes de los perros explorar imágenes de diferentes razas, seleccionar sus favoritas y guardarlas en un objeto personalizado en Salesforce. La aplicación está integrada con la [Dog API](https://dog.ceo/dog-api/), lo que permite obtener dinámicamente información sobre razas y subrazas, así como sus imágenes.

## Tecnologías y Componentes Utilizados
- **Salesforce**:
  - **Apex Class**: `DogApiService` para realizar las llamadas HTTP a la Dog API y procesar las respuestas.
  - **Custom Object**: `Dog_Favorite__c` para almacenar las imágenes y los nombres de las razas seleccionadas como favoritas.
- **Lightning Web Components (LWC)**:
  - **DogSelectForm**: Formulario para seleccionar una raza y una subraza, y realizar la búsqueda de imágenes.
  - **DogCard**: Componente que muestra una tarjeta con la imagen de un perro y su raza, y permite marcarla como favorita.
  - **DogViewer**: Componente principal que organiza la interfaz de usuario, mostrando las imágenes obtenidas y las favoritas.

## Características
1. **Seleccionar Razas y Subrazas**:
   - Permite al usuario elegir una raza y, si aplica, una subraza para obtener imágenes correspondientes.
2. **Guardar Favoritos**:
   - Los usuarios pueden guardar las imágenes que les gustan en el objeto personalizado `Dog_Favorite__c`.
3. **Gestión de Favoritos**:
   - Las imágenes favoritas se muestran en una pestaña separada y pueden desmarcarse para eliminarlas de la lista de favoritos.
4. **Persistencia de Favoritos**:
   - Los datos de favoritos se almacenan en Salesforce y se conservan incluso después de recargar el navegador.

## Instrucciones para Implementar
1. **Clonar el repositorio**:
   ```bash
   git clone <URL-DEL-REPOSITORIO>
