/**
 * @description Clase base para los selectores de objetos en Salesforce.
 * @author      Sebastián Medina Delgado
 * @since       Febrero  2025
 */
public abstract with sharing class SelectorHandler {
    /**
     * @description Método para obtener el nombre del SObject.
     * @return String con el nombre API del objeto.
     */
    protected abstract String getSObjectName();

    /**
     * @description Método para obtener la lista de campos a consultar.
     * @return Lista<String> con los nombres de los campos a consultar.
     */
    protected abstract List<String> getFields();
}
