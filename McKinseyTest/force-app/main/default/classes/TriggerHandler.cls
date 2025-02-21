/**
 * @description Clase base para manejar la ejecucion de logica en triggers.
 * @author      Sebastián Medina Delgado
 * @since       Febrero 2025
 */
public abstract class TriggerHandler {
    protected List<SObject> newRecords;
    protected List<SObject> oldRecords;

    /**
     * @description Constructor que inicializa las listas de registros nuevos y antiguos.
     */
    public TriggerHandler() {
        this.newRecords = Trigger.new;
        this.oldRecords = Trigger.old;
    } 

    /**
     * @description Metodo principal que ejecuta la logica correspondiente segun el tipo de operacion del trigger.
     */
    public void run() {
        TriggerOperation operation = Trigger.operationType;

        switch on operation {
            when BEFORE_INSERT { beforeInsert(newRecords); }
            when AFTER_INSERT { afterInsert(newRecords); }
            // when BEFORE_UPDATE { beforeUpdate(newRecords, oldRecords); }
            // when AFTER_UPDATE { afterUpdate(newRecords, oldRecords); }
            // when BEFORE_DELETE { beforeDelete(oldRecords); }
            // when AFTER_DELETE { afterDelete(oldRecords); }
            // when AFTER_UNDELETE { afterUndelete(newRecords); }
        }
    }

    /**
     * @description Metodo a sobrescribir para ejecutar logica antes de insertar registros.
     * @param records Lista de registros nuevos en la operación de inserción.
     */
    protected virtual void beforeInsert(List<SObject> records) {}

    /**
     * @description Metodo a sobrescribir para ejecutar logica después de insertar registros.
     * @param records Lista de registros insertados.
     */
    protected virtual void afterInsert(List<SObject> records) {}

    /**
     * @description Metodo a sobrescribir para ejecutar logica antes de actualizar registros.
     * @param newRecords Lista de registros nuevos en la operación de actualización.
     * @param oldRecords Lista de registros anteriores a la actualización.
     */
    // protected virtual void beforeUpdate(List<SObject> newRecords, List<SObject> oldRecords) {}

    /**
     * @description Metodo a sobrescribir para ejecutar logica después de actualizar registros.
     * @param newRecords Lista de registros nuevos en la operación de actualización.
     * @param oldRecords Lista de registros anteriores a la actualización.
     */
    // protected virtual void afterUpdate(List<SObject> newRecords, List<SObject> oldRecords) {}

    /**
     * @description Metodo a sobrescribir para ejecutar logica antes de eliminar registros.
     * @param records Lista de registros que seran eliminados.
     */
    // protected virtual void beforeDelete(List<SObject> records) {}

    /**
     * @description Metodo a sobrescribir para ejecutar logica después de eliminar registros.
     * @param records Lista de registros eliminados.
     */
    // protected virtual void afterDelete(List<SObject> records) {}

    /**
     * @description Metodo a sobrescribir para ejecutar logica después de recuperar registros eliminados.
     * @param records Lista de registros recuperados.
     */
    // protected virtual void afterUndelete(List<SObject> records) {}
}
