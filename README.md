CI/CD pipeline architecture:
- GitHub actions workflows to execute:
  - PyTest execution
  - Build + Push Docker image into GCP Artifact Registry
  - Terraform to manage GCP assets

- Terraform: usando GCS como backend para tener un estado persistente en la nube
- GCP:
  - Artifact registry: para alojar las imagenes Docker
  - Cloud Run Service: para deployar el codigo python (service cuando se necesita una API, jobs puntual)
  - IAM Binding: para otorgar permisos para usar el service
  - Secret Manager: por si algun secreto es necesario dentro del codigo python

1. Crear repositorio
2. Crear secretos dentro de GitHub
3. Push a main para ejecutar el workflow