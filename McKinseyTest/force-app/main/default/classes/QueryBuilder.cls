/**
 * @description Clase utilizada para construir dinámicamente consultas sobre SObjects.
 * @author  Sebastián Medina Delgado
 * @since   Febrero  2025
 */
public with sharing class QueryBuilder {
    private String objectName;
    private Set<String> fields = new Set<String>();
    private String conditions;
    private List<String> orderBy;
    private String orderByDirection;
    private Integer rowLimit;
    private Boolean securityEnforced;

    /**
     * @description Define el nombre del SObject a consultar.
     * @param objectName String que proporciona el nombre API del SObject.
     * @return Instancia del QueryBuilder.
     */
    public QueryBuilder objectName(String objectName) {
        this.objectName = objectName;
        return this;
    }

    /**
     * @description Agrega una lista de campos a la consulta.
     * @param fields Lista<String> de nombres de campos a incluir en la consulta.
     * @return Instancia del QueryBuilder.
     */
    public QueryBuilder fields(List<String> fields) {
        this.fields.addAll(fields);
        return this;
    }

    /**
     * @description Especifica las condiciones para la consulta.
     * @param conditions String con las condiciones que debe cumplir la consulta.
     * @return Instancia del QueryBuilder.
     */
    public QueryBuilder conditions(String conditions) {
        this.conditions = conditions;
        return this;
    }

    /**
     * @description Define los campos por los cuales se ordenarán los resultados.
     * @param orderBy List<String> de campos a incluir en la cláusula ORDER BY.
     * @return Instancia del QueryBuilder.
     */
    public QueryBuilder orderBy(List<String> orderBy) {
        this.orderBy = orderBy;
        return this;
    }

    /**
     * @description Especifica la dirección del ordenamiento (ASC o DESC).
     * @param orderByDirection String que porporciona la dirección de ordenamiento.
     * @return Instancia del QueryBuilder.
     */
    public QueryBuilder orderByDirection(String orderByDirection) {
        this.orderByDirection = orderByDirection;
        return this;
    }

    /**
     * @description Define un límite de registros para la consulta.
     * @param rowLimit Integer que especifica el número máximo de registros a consultar.
     * @return Instancia del QueryBuilder.
     */
    public QueryBuilder rowLimit(Integer rowLimit) {
        this.rowLimit = rowLimit;
        return this;
    }

    /**
     * @description Establece si se debe aplicar el uso de WITH SECURITY_ENFORCED en la consulta.
     * @param securityEnforced Valor booleano que indica si se aplica la seguridad en la consulta.
     * @return Instancia del QueryBuilder.
     */
    public QueryBuilder securityEnforced(Boolean securityEnforced) {
        this.securityEnforced = securityEnforced;
        return this;
    } 

    /**
     * @description Construye la consulta SOQL en base a los parámetros definidos.
     * @return String con la consulta SOQL a realizar.
     */
    public String build() {
        String query = 'SELECT ' + String.join(new List<String>(fields), ', ');
        query += ' FROM ' + String.escapeSingleQuotes(objectName) + ' ';

        if (String.isNotBlank(conditions)) {
            query += ' WHERE ' + conditions;
        }

        if (orderBy != null && !orderBy.isEmpty()) {
            query += ' ORDER BY ' + String.escapeSingleQuotes(String.join(orderBy, ', '));
            if (String.isNotBlank(orderByDirection)) {
                query += ' ' + orderByDirection;
            }
        }

        if (rowLimit != null) {
            query += ' LIMIT ' + rowLimit;
        }

        return query;
    }
}
