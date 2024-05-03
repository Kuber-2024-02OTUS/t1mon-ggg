# Подготовка к выполнению домашнего задания
## Развертывание кластера k8s в яндексоблаке  
Развертывание произведится с помощью terraform. Сама конфигурация развертывания добавлена gitignore и находится в директории terraform/.

```bash
export TF_VAR_token_id=`yc iam create-token`
cd terraform
terraform validate ##проверяем валидность конфиграции
terraform plan ##проверяем план развертывания
terraform apply ##запускаем развертывание

##получаем конфигурация для подключения к кластеру 
yc managed-kubernetes cluster get-credentials --id <cluster_id> --external --kubeconfig <path_to_kube_config> --context-name yandex
```
## Установка основных компонентов
так как кластер "пустой", то для выполнения домашнего задания нужно подготовить кластер
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx ## выполняется единожды и при каждом ДЗ не требует повтора
helm repo update ## выполняется единожды и при каждом ДЗ не требует повтора

helm install -n ingress --create-namespace ingress ingress-nginx/ingress-nginx
```

# Выполнение домашнего задания 
## Маркировка нод
```bash
kubectl taint nodes <node1> node-role=infra:NoSchedule
kubectl get node -o wide --show-labels
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
```
Результат:
```console
cl12pvegoov2qtgpnb1m-aner   Ready    <none>   12m   v1.28.2   10.0.0.18     158.160.60.37    Ubuntu 20.04.6 LTS   5.4.0-174-generic   containerd://1.6.28   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=standard-v1,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=ru-central1-a,kubernetes.io/arch=amd64,kubernetes.io/hostname=cl12pvegoov2qtgpnb1m-aner,kubernetes.io/os=linux,node.kubernetes.io/instance-type=standard-v1,node.kubernetes.io/kube-proxy-ds-ready=true,node.kubernetes.io/masq-agent-ds-ready=true,node.kubernetes.io/node-problem-detector-ds-ready=true,topology.kubernetes.io/zone=ru-central1-a,yandex.cloud/node-group-id=cat7d13ftckmm1nc9rah,yandex.cloud/pci-topology=k8s,yandex.cloud/preemptible=false
cl12pvegoov2qtgpnb1m-uxav   Ready    <none>   12m   v1.28.2   10.0.0.26     158.160.48.160   Ubuntu 20.04.6 LTS   5.4.0-174-generic   containerd://1.6.28   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=standard-v1,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=ru-central1-a,kubernetes.io/arch=amd64,kubernetes.io/hostname=cl12pvegoov2qtgpnb1m-uxav,kubernetes.io/os=linux,node.kubernetes.io/instance-type=standard-v1,node.kubernetes.io/kube-proxy-ds-ready=true,node.kubernetes.io/masq-agent-ds-ready=true,node.kubernetes.io/node-problem-detector-ds-ready=true,topology.kubernetes.io/zone=ru-central1-a,yandex.cloud/node-group-id=cat7d13ftckmm1nc9rah,yandex.cloud/pci-topology=k8s,yandex.cloud/preemptible=false

cl12pvegoov2qtgpnb1m-aner   [map[effect:NoSchedule key:node-role value:infra]]
cl12pvegoov2qtgpnb1m-uxav   <none>
```
## Создаем бакет
```bash
cd s3
terraform validate
terraform plan
terraform apply

##получаем ключи доступа
terraform output -json
```
## Установите в кластер Loki, promtail, Grafana
```bash
helm install \
  --namespace <пространство_имен> \
  --create-namespace \
  --set loki-distributed.loki.storageConfig.aws.bucketnames=<имя_бакета_Object_Storage> \
  --set loki-distributed.serviceaccountawskeyvalue_generated.accessKeyID=<идентификатор_ключа_сервисного_аккаунта> \
  --set loki-distributed.serviceaccountawskeyvalue_generated.secretAccessKey=<секретный_ключ_сервисного_аккаунта> \
  loki ./loki/
  
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install -n logging --create-namespace grafana grafana/grafana --values values-grafana.yaml
helm install -n logging --create-namespace promtail grafana/promtail --values values-promtail.yaml
```

# Завершение

```bash

cd terraform
terraform destroy ##экономим деньги на домашние задания. их и так мало

cd s3
terraform destroy
```