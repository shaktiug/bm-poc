# Minio in HA mode

Minio operator will get installed by terraform present in `modules/k8s-resources`.

To install minio storage solution in HA moode in `AKS`, run the below commands:

```sh
 kubectl apply -f minio-tenant.yml
```

## Retrieve MinIO Console Access Information

```sh
 kubectl -n minio get svc
 kubectl -n minio get secret minio-creds-secret -o jsonpath="{.data.accesskey}" | base64 --decode
 kubectl -n minio get secret minio-creds-secret -o jsonpath="{.data.secretkey}" | base64 --decode

```

## Access the MinIO Console

Use the external IP or NodePort obtained from the `kubectl -n minio get svc` command to access the MinIO console in your browser.