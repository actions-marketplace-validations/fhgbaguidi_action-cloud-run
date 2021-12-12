# Github Action for Google Cloud Run

An GitHub Action for deploying revisions to Google Cloud Run.

## Usage

In your actions workflow, somewhere after the step that builds
`gcr.io/<your-project>/<image>`, insert this:

```yaml
- name: Deploy service to Cloud Run
  uses: frodonLD/action-cloud-run@master
  with:
    image: [your-project]/[image]
    registry: gcr.io
    tag: latest
    service: [your-service]
    project: [your-project]
    region: [gcp-region]
    env: [path-to-env-file]
    key: ${{ secrets.GCLOUD_AUTH }}
```

OR 

```yaml
- name: Deploy service to Cloud Run
  uses: frodonLD/action-cloud-run@master
  with:
    image: [your-project]/[image]
    registry: gcr.io
    tag: latest
    service: [your-service]
    project: [your-project]
    region: [gcp-region]
    serviceyamlfile: [path-to-service-yaml-config-file]
    key: ${{ secrets.GCLOUD_AUTH }}
```

Your `GCLOUD_AUTH` secret (or however you name it) must be a base64 encoded
gcloud service key with the following permissions:
- Service Account User
- Cloud Run Admin
- Storage Admin

The image must be present on Google's container registries

The `env` input is optional. If you don't provide a path to env file the run
deployment will be triggered with the `--clear-env-vars` flag.