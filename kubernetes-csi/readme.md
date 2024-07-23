# Подготовка к выполнению домашнего задания
## Развертывание кластера k8s в yc 
Домашнее задание требует развертывания managed k8s в Yandexcloud. Будем использовать терраформ. Поправили количество нод на 3.

```bash
export TF_VAR_token_id=`yc iam create-token`
cd terraform
terraform validate ##проверяем валидность конфиграции
terraform plan ##проверяем план развертывания
terraform apply ##запускаем развертывание

##получаем конфигурация для подключения к кластеру 
yc managed-kubernetes cluster get-credentials --id <cluster_id> --external --kubeconfig <path_to_kube_config> --context-name yandex
```

# Выполнение домашнего задания 
## Создайте бакет в s3 object storage Yandex cloud
Можно создать с помощью терраформа или через интерфейс. Создадим через интерфейс.
- Создаем бакет t1mon-ggg  

Создаем сервисный аккаунт через интерфейс YC.  
- Создаем сам сервисный аккаунт  
- Создаем статический ключ доступа  
- Прописываем права ```storage.editor```  

## Установка драйвера CSI
```bash
export HELM_EXPERIMENTAL_OCI=1 && \
helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/csi-s3/csi-s3 --version 0.35.5 --untar
helm install --namespace kube-system csi-s3 . --values csi-values.yaml
```
StorageClass создается автоматически при установке  
Оставлять реальные ключи доступа я тоже не буду. Яндекс мониторит все публичные репозитории и потом замучает спамом.  
Secret с ключами тоже создасться автоматически при установке.

Создаем под и PVC для него
```bash
kubectl apply -f pvc.yaml
kubectl apply -f pod.yaml
```
# Завершение

```bash
cd terraform
terraform destroy ##экономим деньги на домашние задания. их и так мало
```