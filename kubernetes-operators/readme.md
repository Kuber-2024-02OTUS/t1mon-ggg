# Подготовка к выполнению домашнего задания
## Развертывание кластера k8s в minikube 
Домашнее задание не требует развертывание большого облака потому используем миникуб

```bash
minikube start
 ```
## Установка основных компонентов
кластер подготовлен заранее, но для удобстава добавляем аддоны ingress, metrics-server
```bash
minikube addons enable ingress
minikube addons enable metrics-server
```

# Выполнение домашнего задания 
## Установка kubebuilder
Нам потребуется установить kubebuilder. Для этого нам потребуется удовлетворить следующие зависимости:  
> go version v1.20.0+  
> docker version 17.03+.  
> kubectl version v1.11.3+.  
> Access to a Kubernetes v1.11.3+ cluster.  

Установка:  
```bash
curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)"
chmod +x kubebuilder && mv kubebuilder /usr/local/bin/
##выполнять необязательно, но очень удобно
kubebuilder completion bash > /etc/bash_completion.d/kubebuilder
```

Выполнение
```bash
mkdir builder
kubebuilder init --domain otus.homework --repo otus.homework/operator
kubebuilder create api --version v1 --kind MySQL
##редактируем в VSCode файл ./builder/api/v1/mysql_types.go
cd builder
make manifests
make install
```
# Завершение

```bash
minikube stop
```