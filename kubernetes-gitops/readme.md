# Подготовка к выполнению домашнего задания
## Развертывание кластера k8s в yc 
Домашнее задание требует развертывания managed k8s в Yandexcloud. Будем использовать терраформ

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
## Маркировка нод
```bash
kubectl taint nodes <node1> node-role=infra:NoSchedule
kubectl get node -o wide --show-labels
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints
```

# Выполнение домашнего задания 
Создаем в соответствии с заданием манифесты
## Установка ArgoCD
### Установка:  
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install argo-cd -n argocd --create-namespace argo/argo-cd --version 7.3.9 --values values.yaml

##домен создавать нет смысла. будем пользоваться проксированием в сервис
```
На выходе мы получим оператора плюс нормальную CRD (именно ее и применяем в кластер)
Подключаемся к арго и создаем проект Otus  
В качестве репозитория выбираем git@github.com:Kuber-2024-02OTUS/t1mon-ggg.git
### Создание манифестов argo для приложений
networks.yaml  
templating.yaml  

# Завершение

```bash
cd terraform
terraform destroy ##экономим деньги на домашние задания. их и так мало
```

PS. С оператором стоит почитать доп литературу. Было не совсем понятно