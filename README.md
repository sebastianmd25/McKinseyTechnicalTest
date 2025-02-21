# McKinsey & Company - Salesforce Technical Test

Este repositorio contiene el proyecto de Salesforce desarrollado para la prueba técnica de McKinsey & Company.

## 📂 Estructura del Proyecto

- **McKinseyTest/** - Contiene el código fuente del proyecto.
- **force-app/** - Incluye los metadatos y componentes de Salesforce.
- **config/** - Configuraciones adicionales del proyecto.

## 🚀 Configuración y Despliegue

### 1️⃣ Requisitos previos
Antes de instalar el proyecto, asegúrate de tener:
- [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli) instalado
- Una organización de Salesforce (sandbox o scratch org) configurada

### 2️⃣ Clonar el repositorio
```sh
  git clone https://github.com/sebastianmd25/McKinseyTechnicalTest.git
  cd McKinseyTechnicalTest/McKinseyTest
```

### 3️⃣ Autenticarse en Salesforce
Ejecuta el siguiente comando para iniciar sesión en Salesforce:
```sh
sfdx auth:web:login -a NombreDeAlias
```

### 4️⃣ Desplegar a una org
```sh
sfdx force:source:push -u NombreDeAlias
```

## 🧪 Pruebas
Para ejecutar las pruebas unitarias en Salesforce, usa:
```sh
sfdx force:apex:test:run -u NombreDeAlias -r human --codecoverage
```

## 📧 Contacto
Si tienes preguntas o necesitas soporte, puedes contactarme en **devtestmckinsey@gmail.com**.

