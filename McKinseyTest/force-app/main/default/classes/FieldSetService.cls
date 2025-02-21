/**
 * @description Clase que contiene la lógica para obtener los campos de un fieldSet.
 * @author Sebastián Medina Delgado
 * @since  Febrero 2025
 */
public without sharing class FieldSetService {

    /**
     * @description Obtiene los campos de un Field Set y los encapsula en un objeto `FieldSetForm`.
     * @param recordId ID de un registro del objeto al que pertenece el Field Set.
     * @param fieldSetName Nombre del Field Set del cual se extraerán los campos.
     * @return `FieldSetForm` con la lista de campos obtenidos.
     * @throws IllegalArgumentException Si el Field Set no existe en el objeto.
     */
    @AuraEnabled
    public static FieldSetForm getFieldServiceForm(Id recordId, String fieldSetName) {
        FieldSetForm fieldSetFrm = new FieldSetForm();        
        fieldSetFrm.fields = getFieldsetFields(recordId, fieldSetName);
        return fieldSetFrm;
    } 

    /**
     * @description Obtiene los campos del Field Set y los devuelve como List<FormField>.
     * @param recordId ID de un registro del objeto al que pertenece el Field Set.
     * @param fieldSetName Nombre del Field Set del cual se extraerán los campos.
     * @return Lista de `FormField` que contiene detalles de cada campo en el Field Set.
     */
    private static List<FormField> getFieldsetFields(Id recordId, String fieldSetName) {
        List<FormField> fieldList = new List<FormField>();
        
        Schema.DescribeSObjectResult objDescribe = recordId.getSobjectType().getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objDescribe.fieldSets.getMap();

        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSet.getFields();
        
        for (Schema.FieldSetMember fsMember : fieldSetMembers) {
            fieldList.add(new FormField(
                fsMember.getFieldPath(), 
                fsMember.getLabel(), 
                String.valueOf(fsMember.getType())
            ));
        }
        
        return fieldList;
    }
    
    /**
     * @description Clase contenedora para la lista de campos obtenidos del Field Set.
     */
    public class FieldSetForm {
        /**
         * @description Lista de los campos obtenidos del Field Set.
         */
        @AuraEnabled
        public List<FormField> fields { get; set; }
        
        /**
         * @description Constructor por defecto que inicializa la lista de campos.
         */
        public FieldSetForm() {
            Fields = new List<FormField>();
        }
    }

    /**
     * @description Representacion del campo del Field Set.
     */
    public class FormField {
        /**
         * @description Nombre API del campo.
         */
        @AuraEnabled
        public String fieldName { get; set; }

        /**
         * @description Label del campo.
         */
        @AuraEnabled
        public String fieldLabel { get; set; }

        /**
         * @description Tipo del campo.
         */
        @AuraEnabled
        public String fieldType { get; set; }

        /**
         * @description Constructor para inicializar un campo del Field Set.
         * @param fieldName Nombre API del campo.
         * @param fieldLabel Label del campo.
         * @param fieldType Tipo del campo.
         */
        public FormField(String fieldName, String fieldLabel, String fieldType) {
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.fieldType = fieldType;
        }
    }
}
