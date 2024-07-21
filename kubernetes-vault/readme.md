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
## Установка hashicorp consul
```bash
wget https://github.com/hashicorp/consul-k8s/archive/refs/heads/main.zip -O consul.zip
unzip consul.zip
cd consul-k8s-main/charts/consul/
helm install -n consul --create-namespace consul ./ --values ../../../consul-values.yaml 
cd ../../../
```
## Установка hashicorp vault
```bash
wget https://github.com/hashicorp/vault-helm/archive/refs/heads/main.zip -O vault.zip
unzip vault.zip
cd vault-helm-main/
helm install -n vault --create-namespace vault ./ --values ../vault-values.yaml 
kubectl exec -it -n vault vault-0 sh ##пробрасываем консоль для инициализации vault
vault operator init
```
### Выполнение заданий
Применяем манифест sa.yaml
```bash
kubectl apply -f sa.yaml
```
Проксируем интерфейс. Входим через рут токен. Создаем KV и секрет по заданию.  
Подключаем авторизацию k8s в интерфейсе. Все операции проводим через интрефейст vault
Создаем политику ```otus-policy``` для секретов ```/otus/cred``` с ```capabilities = [“read”, “list”]```.  
Создаем роль ```auth/kubernetes/role/otus```
```
Key                                         Value
---                                         -----
alias_name_source                           serviceaccount_uid
bound_service_account_names                 [vault-auth]
bound_service_account_namespace_selector    n/a
bound_service_account_namespaces            [vault]
token_bound_cidrs                           []
token_explicit_max_ttl                      0s
token_max_ttl                               0s
token_no_default_policy                     false
token_num_uses                              0
token_period                                0s
token_policies                              [otus-policy]
token_ttl                                   72h
token_type                                  default
```
### Установка External Secrets Operator
```bash
helm repo add external-secrets https://charts.external-secrets.io
helm install -n vault external-secrets external-secrets/external-secrets
kubectl apply -f secret-store.yaml 
kubectl apply -f external-secret.yaml
```


# Завершение

```bash
cd terraform
terraform destroy ##экономим деньги на домашние задания. их и так мало
```