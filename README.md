CI/CD pipeline architecture:
- GitHub actions workflows que ejecuta:
  - PyTest tests para validar el codigo python
  - Build + Push Docker de la imagen a GCP Artifact Registry
  - Terraform para administrar los servicios usados en GCP
  - Uso de secretos para autenticar a GCP o almacenar secretos

- Terraform: usando GCS como backend para tener un estado persistente en la nube, tfvars por entorno
- GCP:
  - Artifact registry: para alojar las imagenes Docker
  - Cloud Run Service: para deployar el codigo python (service cuando se necesita una API, jobs puntual)
  - IAM Binding: para otorgar permisos para usar el service
  - Secret Manager: por si algun secreto es necesario dentro del codigo python

1. Crear repositorio
2. Crear secretos dentro de GitHub
3. Push a main para ejecutar el workflow
