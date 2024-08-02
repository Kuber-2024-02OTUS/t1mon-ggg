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
Создаем в соответствии с заданием манифесты
```bash
kubectl apply -f pod.yaml
```
## Получите доступ к файловой системе отлаживаемого контейнера
```bash
kubectl debug -n default nginx --image=busybox -ti --target=nginx-distroless
```
```bash
ls -la proc/1/root/etc/nginx/


total 48
drwxr-xr-x    3 root     root          4096 Oct  5  2020 .
drwxr-xr-x    1 root     root          4096 Jul 31 19:48 ..
drwxr-xr-x    2 root     root          4096 Oct  5  2020 conf.d
-rw-r--r--    1 root     root          1007 Apr 21  2020 fastcgi_params
-rw-r--r--    1 root     root          2837 Apr 21  2020 koi-utf
-rw-r--r--    1 root     root          2223 Apr 21  2020 koi-win
-rw-r--r--    1 root     root          5231 Apr 21  2020 mime.types
lrwxrwxrwx    1 root     root            22 Apr 21  2020 modules -> /usr/lib/nginx/modules
-rw-r--r--    1 root     root           643 Apr 21  2020 nginx.conf
-rw-r--r--    1 root     root           636 Apr 21  2020 scgi_params
-rw-r--r--    1 root     root           664 Apr 21  2020 uwsgi_params
-rw-r--r--    1 root     root          3610 Apr 21  2020 win-utf
```

## Запустите в отладочном контейнере команду tcpdump
```bash
kubectl debug -n default nginx --image=nicolaka/netshoot -ti --target=nginx-distroless
```
```bash
tcpdump -nn -i any -e port 80 
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
19:55:24.672614 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54318 > 127.0.0.1.80: Flags [S], seq 1577224887, win 65495, options [mss 65495,sackOK,TS val 167364805 ecr 0,nop,wscale 7], length 0
19:55:24.672633 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54318: Flags [S.], seq 2071965181, ack 1577224888, win 65483, options [mss 65495,sackOK,TS val 167364805 ecr 167364805,nop,wscale 7], length 0
19:55:24.672640 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54318 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364805 ecr 167364805], length 0
19:55:24.672699 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1869: 127.0.0.1.54318 > 127.0.0.1.80: Flags [P.], seq 1:1798, ack 1, win 512, options [nop,nop,TS val 167364805 ecr 167364805], length 1797: HTTP
19:55:24.672702 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54318: Flags [.], ack 1798, win 500, options [nop,nop,TS val 167364805 ecr 167364805], length 0
19:55:24.672792 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54318: Flags [P.], seq 1:310, ack 1798, win 500, options [nop,nop,TS val 167364805 ecr 167364805], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.672805 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54318 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364805 ecr 167364805], length 0
19:55:24.672816 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54318: Flags [F.], seq 310, ack 1798, win 500, options [nop,nop,TS val 167364805 ecr 167364805], length 0
19:55:24.673786 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54318 > 127.0.0.1.80: Flags [P.], seq 1798:1805, ack 311, win 512, options [nop,nop,TS val 167364806 ecr 167364805], length 7: HTTP
19:55:24.674018 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54318 > 127.0.0.1.80: Flags [F.], seq 1805, ack 311, win 512, options [nop,nop,TS val 167364807 ecr 167364805], length 0
19:55:24.674027 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54318: Flags [.], ack 1806, win 502, options [nop,nop,TS val 167364807 ecr 167364806], length 0
19:55:24.677583 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54326 > 127.0.0.1.80: Flags [S], seq 500189352, win 65495, options [mss 65495,sackOK,TS val 167364810 ecr 0,nop,wscale 7], length 0
19:55:24.677593 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54326: Flags [S.], seq 2004887693, ack 500189353, win 65483, options [mss 65495,sackOK,TS val 167364810 ecr 167364810,nop,wscale 7], length 0
19:55:24.677599 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54326 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364810 ecr 167364810], length 0
19:55:24.677629 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1869: 127.0.0.1.54326 > 127.0.0.1.80: Flags [P.], seq 1:1798, ack 1, win 512, options [nop,nop,TS val 167364810 ecr 167364810], length 1797: HTTP
19:55:24.677632 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54326: Flags [.], ack 1798, win 500, options [nop,nop,TS val 167364810 ecr 167364810], length 0
19:55:24.677681 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54326: Flags [P.], seq 1:310, ack 1798, win 500, options [nop,nop,TS val 167364810 ecr 167364810], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.677685 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54326 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364810 ecr 167364810], length 0
19:55:24.677901 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54326: Flags [F.], seq 310, ack 1798, win 500, options [nop,nop,TS val 167364810 ecr 167364810], length 0
19:55:24.678316 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54326 > 127.0.0.1.80: Flags [P.], seq 1798:1805, ack 311, win 512, options [nop,nop,TS val 167364811 ecr 167364810], length 7: HTTP
19:55:24.678505 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54326 > 127.0.0.1.80: Flags [F.], seq 1805, ack 311, win 512, options [nop,nop,TS val 167364811 ecr 167364810], length 0
19:55:24.678512 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54326: Flags [.], ack 1806, win 502, options [nop,nop,TS val 167364811 ecr 167364811], length 0
19:55:24.683536 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54334 > 127.0.0.1.80: Flags [S], seq 2740709073, win 65495, options [mss 65495,sackOK,TS val 167364816 ecr 0,nop,wscale 7], length 0
19:55:24.683546 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54334: Flags [S.], seq 1629983953, ack 2740709074, win 65483, options [mss 65495,sackOK,TS val 167364816 ecr 167364816,nop,wscale 7], length 0
19:55:24.683552 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54334 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364816 ecr 167364816], length 0
19:55:24.683580 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1837: 127.0.0.1.54334 > 127.0.0.1.80: Flags [P.], seq 1:1766, ack 1, win 512, options [nop,nop,TS val 167364816 ecr 167364816], length 1765: HTTP
19:55:24.683583 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54334: Flags [.], ack 1766, win 501, options [nop,nop,TS val 167364816 ecr 167364816], length 0
19:55:24.683639 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54334: Flags [P.], seq 1:310, ack 1766, win 501, options [nop,nop,TS val 167364816 ecr 167364816], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.683642 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54334 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364816 ecr 167364816], length 0
19:55:24.683648 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54334: Flags [F.], seq 310, ack 1766, win 501, options [nop,nop,TS val 167364816 ecr 167364816], length 0
19:55:24.684236 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54334 > 127.0.0.1.80: Flags [P.], seq 1766:1773, ack 311, win 512, options [nop,nop,TS val 167364817 ecr 167364816], length 7: HTTP
19:55:24.684249 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54334 > 127.0.0.1.80: Flags [F.], seq 1773, ack 311, win 512, options [nop,nop,TS val 167364817 ecr 167364816], length 0
19:55:24.684253 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54334: Flags [.], ack 1774, win 502, options [nop,nop,TS val 167364817 ecr 167364817], length 0
19:55:24.687283 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54342 > 127.0.0.1.80: Flags [S], seq 2453869524, win 65495, options [mss 65495,sackOK,TS val 167364820 ecr 0,nop,wscale 7], length 0
19:55:24.687292 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54342: Flags [S.], seq 1477496003, ack 2453869525, win 65483, options [mss 65495,sackOK,TS val 167364820 ecr 167364820,nop,wscale 7], length 0
19:55:24.687298 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54342 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364820 ecr 167364820], length 0
19:55:24.687330 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1805: 127.0.0.1.54342 > 127.0.0.1.80: Flags [P.], seq 1:1734, ack 1, win 512, options [nop,nop,TS val 167364820 ecr 167364820], length 1733: HTTP
19:55:24.687332 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54342: Flags [.], ack 1734, win 501, options [nop,nop,TS val 167364820 ecr 167364820], length 0
19:55:24.687370 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54342: Flags [P.], seq 1:310, ack 1734, win 501, options [nop,nop,TS val 167364820 ecr 167364820], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.687379 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54342 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364820 ecr 167364820], length 0
19:55:24.687387 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54342: Flags [F.], seq 310, ack 1734, win 501, options [nop,nop,TS val 167364820 ecr 167364820], length 0
19:55:24.688067 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54342 > 127.0.0.1.80: Flags [P.], seq 1734:1741, ack 311, win 512, options [nop,nop,TS val 167364821 ecr 167364820], length 7: HTTP
19:55:24.688079 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54342 > 127.0.0.1.80: Flags [F.], seq 1741, ack 311, win 512, options [nop,nop,TS val 167364821 ecr 167364820], length 0
19:55:24.688083 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54342: Flags [.], ack 1742, win 502, options [nop,nop,TS val 167364821 ecr 167364821], length 0
19:55:24.696536 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54352 > 127.0.0.1.80: Flags [S], seq 1340335140, win 65495, options [mss 65495,sackOK,TS val 167364829 ecr 0,nop,wscale 7], length 0
19:55:24.696544 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54352: Flags [S.], seq 1291185967, ack 1340335141, win 65483, options [mss 65495,sackOK,TS val 167364829 ecr 167364829,nop,wscale 7], length 0
19:55:24.696549 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54352 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.696572 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1869: 127.0.0.1.54352 > 127.0.0.1.80: Flags [P.], seq 1:1798, ack 1, win 512, options [nop,nop,TS val 167364829 ecr 167364829], length 1797: HTTP
19:55:24.696573 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54352: Flags [.], ack 1798, win 500, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.696618 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54352: Flags [P.], seq 1:310, ack 1798, win 500, options [nop,nop,TS val 167364829 ecr 167364829], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.696619 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54352 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.696623 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54352: Flags [F.], seq 310, ack 1798, win 500, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.696630 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54356 > 127.0.0.1.80: Flags [S], seq 1946279601, win 65495, options [mss 65495,sackOK,TS val 167364829 ecr 0,nop,wscale 7], length 0
19:55:24.696635 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54356: Flags [S.], seq 1875797231, ack 1946279602, win 65483, options [mss 65495,sackOK,TS val 167364829 ecr 167364829,nop,wscale 7], length 0
19:55:24.696638 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54356 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.696702 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1837: 127.0.0.1.54356 > 127.0.0.1.80: Flags [P.], seq 1:1766, ack 1, win 512, options [nop,nop,TS val 167364829 ecr 167364829], length 1765: HTTP
19:55:24.696707 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54356: Flags [.], ack 1766, win 501, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.696764 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54356: Flags [P.], seq 1:310, ack 1766, win 501, options [nop,nop,TS val 167364829 ecr 167364829], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.696771 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54356 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.696774 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54356: Flags [F.], seq 310, ack 1766, win 501, options [nop,nop,TS val 167364829 ecr 167364829], length 0
19:55:24.697056 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54352 > 127.0.0.1.80: Flags [P.], seq 1798:1805, ack 311, win 512, options [nop,nop,TS val 167364830 ecr 167364829], length 7: HTTP
19:55:24.697068 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54352 > 127.0.0.1.80: Flags [F.], seq 1805, ack 311, win 512, options [nop,nop,TS val 167364830 ecr 167364829], length 0
19:55:24.697072 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54352: Flags [.], ack 1806, win 502, options [nop,nop,TS val 167364830 ecr 167364830], length 0
19:55:24.697525 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54356 > 127.0.0.1.80: Flags [P.], seq 1766:1773, ack 311, win 512, options [nop,nop,TS val 167364830 ecr 167364829], length 7: HTTP
19:55:24.697534 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54356 > 127.0.0.1.80: Flags [F.], seq 1773, ack 311, win 512, options [nop,nop,TS val 167364830 ecr 167364829], length 0
19:55:24.697538 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54356: Flags [.], ack 1774, win 502, options [nop,nop,TS val 167364830 ecr 167364830], length 0
19:55:24.700352 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54370 > 127.0.0.1.80: Flags [S], seq 2358315634, win 65495, options [mss 65495,sackOK,TS val 167364833 ecr 0,nop,wscale 7], length 0
19:55:24.700358 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54370: Flags [S.], seq 728668619, ack 2358315635, win 65483, options [mss 65495,sackOK,TS val 167364833 ecr 167364833,nop,wscale 7], length 0
19:55:24.700362 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54370 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700395 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1869: 127.0.0.1.54370 > 127.0.0.1.80: Flags [P.], seq 1:1798, ack 1, win 512, options [nop,nop,TS val 167364833 ecr 167364833], length 1797: HTTP
19:55:24.700397 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54370: Flags [.], ack 1798, win 500, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700417 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54370: Flags [P.], seq 1:310, ack 1798, win 500, options [nop,nop,TS val 167364833 ecr 167364833], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.700421 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54370: Flags [F.], seq 310, ack 1798, win 500, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700425 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54370 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700475 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.54380 > 127.0.0.1.80: Flags [S], seq 3986275466, win 65495, options [mss 65495,sackOK,TS val 167364833 ecr 0,nop,wscale 7], length 0
19:55:24.700480 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.54380: Flags [S.], seq 745012782, ack 3986275467, win 65483, options [mss 65495,sackOK,TS val 167364833 ecr 167364833,nop,wscale 7], length 0
19:55:24.700484 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54380 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700503 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1773: 127.0.0.1.54380 > 127.0.0.1.80: Flags [P.], seq 1:1702, ack 1, win 512, options [nop,nop,TS val 167364833 ecr 167364833], length 1701: HTTP
19:55:24.700505 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54380: Flags [.], ack 1702, win 501, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700532 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.54380: Flags [P.], seq 1:310, ack 1702, win 501, options [nop,nop,TS val 167364833 ecr 167364833], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:24.700536 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54380 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700540 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54380: Flags [F.], seq 310, ack 1702, win 501, options [nop,nop,TS val 167364833 ecr 167364833], length 0
19:55:24.700943 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54380 > 127.0.0.1.80: Flags [P.], seq 1702:1709, ack 311, win 512, options [nop,nop,TS val 167364834 ecr 167364833], length 7: HTTP
19:55:24.700982 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54380 > 127.0.0.1.80: Flags [F.], seq 1709, ack 311, win 512, options [nop,nop,TS val 167364834 ecr 167364833], length 0
19:55:24.700984 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.54370 > 127.0.0.1.80: Flags [P.], seq 1798:1805, ack 311, win 512, options [nop,nop,TS val 167364834 ecr 167364833], length 7: HTTP
19:55:24.700988 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54380: Flags [.], ack 1710, win 507, options [nop,nop,TS val 167364834 ecr 167364834], length 0
19:55:24.701060 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.54370 > 127.0.0.1.80: Flags [F.], seq 1805, ack 311, win 512, options [nop,nop,TS val 167364834 ecr 167364833], length 0
19:55:24.701064 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.54370: Flags [.], ack 1806, win 507, options [nop,nop,TS val 167364834 ecr 167364834], length 0
19:55:34.717321 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.39650 > 127.0.0.1.80: Flags [S], seq 907504047, win 65495, options [mss 65495,sackOK,TS val 167374850 ecr 0,nop,wscale 7], length 0
19:55:34.717331 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.39650: Flags [S.], seq 3154189652, ack 907504048, win 65483, options [mss 65495,sackOK,TS val 167374850 ecr 167374850,nop,wscale 7], length 0
19:55:34.717339 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39650 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167374850 ecr 167374850], length 0
19:55:34.718486 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 756: 127.0.0.1.39650 > 127.0.0.1.80: Flags [P.], seq 1:685, ack 1, win 512, options [nop,nop,TS val 167374851 ecr 167374850], length 684: HTTP: GET / HTTP/1.1
19:55:34.718491 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.39650: Flags [.], ack 685, win 507, options [nop,nop,TS val 167374851 ecr 167374851], length 0
19:55:34.718590 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 310: 127.0.0.1.80 > 127.0.0.1.39650: Flags [P.], seq 1:239, ack 685, win 512, options [nop,nop,TS val 167374851 ecr 167374851], length 238: HTTP: HTTP/1.1 200 OK
19:55:34.718595 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39650 > 127.0.0.1.80: Flags [.], ack 239, win 511, options [nop,nop,TS val 167374851 ecr 167374851], length 0
19:55:34.718603 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 684: 127.0.0.1.80 > 127.0.0.1.39650: Flags [P.], seq 239:851, ack 685, win 512, options [nop,nop,TS val 167374851 ecr 167374851], length 612: HTTP
19:55:34.718604 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39650 > 127.0.0.1.80: Flags [.], ack 851, win 507, options [nop,nop,TS val 167374851 ecr 167374851], length 0
19:55:34.742633 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.39652 > 127.0.0.1.80: Flags [S], seq 2045691592, win 65495, options [mss 65495,sackOK,TS val 167374875 ecr 0,nop,wscale 7], length 0
19:55:34.742645 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.39652: Flags [S.], seq 1058777361, ack 2045691593, win 65483, options [mss 65495,sackOK,TS val 167374875 ecr 167374875,nop,wscale 7], length 0
19:55:34.742654 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39652 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167374875 ecr 167374875], length 0
19:55:34.742917 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1869: 127.0.0.1.39652 > 127.0.0.1.80: Flags [P.], seq 1:1798, ack 1, win 512, options [nop,nop,TS val 167374875 ecr 167374875], length 1797: HTTP
19:55:34.742938 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.39652: Flags [.], ack 1798, win 500, options [nop,nop,TS val 167374875 ecr 167374875], length 0
19:55:34.742980 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.39652: Flags [P.], seq 1:310, ack 1798, win 500, options [nop,nop,TS val 167374876 ecr 167374875], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:34.742989 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39652 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167374876 ecr 167374876], length 0
19:55:34.742996 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.39652: Flags [F.], seq 310, ack 1798, win 500, options [nop,nop,TS val 167374876 ecr 167374876], length 0
19:55:34.743398 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.39662 > 127.0.0.1.80: Flags [S], seq 1371547085, win 65495, options [mss 65495,sackOK,TS val 167374876 ecr 0,nop,wscale 7], length 0
19:55:34.743403 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.39662: Flags [S.], seq 2875313377, ack 1371547086, win 65483, options [mss 65495,sackOK,TS val 167374876 ecr 167374876,nop,wscale 7], length 0
19:55:34.743407 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39662 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167374876 ecr 167374876], length 0
19:55:34.743742 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.39652 > 127.0.0.1.80: Flags [P.], seq 1798:1805, ack 311, win 512, options [nop,nop,TS val 167374876 ecr 167374876], length 7: HTTP
19:55:34.744290 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39652 > 127.0.0.1.80: Flags [F.], seq 1805, ack 311, win 512, options [nop,nop,TS val 167374877 ecr 167374876], length 0
19:55:34.744301 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.39652: Flags [.], ack 1806, win 507, options [nop,nop,TS val 167374877 ecr 167374876], length 0
19:55:34.747793 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.39678 > 127.0.0.1.80: Flags [S], seq 653426322, win 65495, options [mss 65495,sackOK,TS val 167374880 ecr 0,nop,wscale 7], length 0
19:55:34.747801 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 80: 127.0.0.1.80 > 127.0.0.1.39678: Flags [S.], seq 173768062, ack 653426323, win 65483, options [mss 65495,sackOK,TS val 167374880 ecr 167374880,nop,wscale 7], length 0
19:55:34.747807 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39678 > 127.0.0.1.80: Flags [.], ack 1, win 512, options [nop,nop,TS val 167374880 ecr 167374880], length 0
19:55:34.747862 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 1869: 127.0.0.1.39678 > 127.0.0.1.80: Flags [P.], seq 1:1798, ack 1, win 512, options [nop,nop,TS val 167374880 ecr 167374880], length 1797: HTTP
19:55:34.747864 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.39678: Flags [.], ack 1798, win 500, options [nop,nop,TS val 167374880 ecr 167374880], length 0
19:55:34.747886 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 381: 127.0.0.1.80 > 127.0.0.1.39678: Flags [P.], seq 1:310, ack 1798, win 500, options [nop,nop,TS val 167374880 ecr 167374880], length 309: HTTP: HTTP/1.1 400 Bad Request
19:55:34.747889 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.39678: Flags [F.], seq 310, ack 1798, win 500, options [nop,nop,TS val 167374880 ecr 167374880], length 0
19:55:34.747894 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39678 > 127.0.0.1.80: Flags [.], ack 310, win 510, options [nop,nop,TS val 167374880 ecr 167374880], length 0
19:55:34.748786 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 79: 127.0.0.1.39678 > 127.0.0.1.80: Flags [P.], seq 1798:1805, ack 311, win 512, options [nop,nop,TS val 167374881 ecr 167374880], length 7: HTTP
19:55:34.748805 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39678 > 127.0.0.1.80: Flags [F.], seq 1805, ack 311, win 512, options [nop,nop,TS val 167374881 ecr 167374880], length 0
19:55:34.748811 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.80 > 127.0.0.1.39678: Flags [.], ack 1806, win 507, options [nop,nop,TS val 167374881 ecr 167374881], length 0
19:55:34.755998 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 683: 127.0.0.1.39650 > 127.0.0.1.80: Flags [P.], seq 685:1296, ack 851, win 512, options [nop,nop,TS val 167374889 ecr 167374851], length 611: HTTP: GET /favicon.ico HTTP/1.1
19:55:34.756112 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 782: 127.0.0.1.80 > 127.0.0.1.39650: Flags [P.], seq 851:1561, ack 1296, win 512, options [nop,nop,TS val 167374889 ecr 167374889], length 710: HTTP: HTTP/1.1 404 Not Found
19:55:34.796972 lo    In  ifindex 1 00:00:00:00:00:00 ethertype IPv4 (0x0800), length 72: 127.0.0.1.39650 > 127.0.0.1.80: Flags [.], ack 1561, win 512, options [nop,nop,TS val 167374930 ecr 167374889], length 0
```
## создайте отладочный под для ноды
```bash
kubectl  debug node/minikube -it --image=busybox

cat /host/var/log/pods/default_node-debugger-minikube-9kr5g_595e9a30-e9ab-40ee-a072-6ce0fbf843ff/debugger/0.log
```

## Выполните команду strace
```bash
kubectl debug -n default nginx --image=nicolaka/netshoot -ti --target=nginx-distroless

ps aux

>PID   USER     TIME  COMMAND
>    1 root      0:00 nginx: master process nginx -g daemon off;
>    6 bird      0:00 nginx: worker process
>  102 root      0:00 zsh
>  188 root      0:00 ps aux

strace -p 1 -c
>strace: Process 1 attached
```
у меня миникуб на максималках в отдельной ВМ с полным игнорированием норм ИБ  
а вообще должна быть ошибка ```Operation not permitted```  
для ее решения нужно добавить в под
```yaml
    securityContext:
      capabilities:
        add:
        - SYS_PTRACE
```
# Завершение

```bash
minikube stop
```