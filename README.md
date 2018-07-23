# Sping - Simple ping

## 具体思想

在工作中使用ping可以探测源主机到目标主机的网络延迟和丢包率。当前已经实现单线程ping包,目前为止程序用在探测少量ip地址可以满足需求。如果在单位时间内完成10000＋ping任务,这种方式可能无法满足需求。我的设计思想是,将ping的Echo和Reply分开。Echo线程任务就是发送包,不负责阻塞接收包。而Reply线程仅负责收包不负责发包。这样可以减少阻塞,尽可能发送发包和收包的最大能力。

单线程Echo和Relay共同抢占同一个sockfd(套接字)。在多线程程序中,需要将Echo发出的sockfd放到一个hashmap中,以目标ip地址为key,将发送包对象存储该key下的hash桶内。当Relay接收包之后,通过目标IP地址从hash表内找到sequence对应的发送包,然后计算延迟(收包时间 - 发包时间,这样计算的时间偏大,这种可以忽略不计)。



## 使用

目前已经实现单线程ping。

```c
[root@host ping]# ./ping  8.8.8.8
Ping 8.8.8.8(8.8.8.8): 56 bytes data in ICMP packets.
64 bytes from 8.8.8.8:icmp_seq=0 ttl=40 rtt=54.889 ms
64 bytes from 8.8.8.8:icmp_seq=1 ttl=40 rtt=55.266 ms
64 bytes from 8.8.8.8:icmp_seq=3 ttl=40 rtt=60.174 ms
64 bytes from 8.8.8.8:icmp_seq=8 ttl=40 rtt=56.828 ms
64 bytes from 8.8.8.8:icmp_seq=13 ttl=40 rtt=70.711 ms
--- 8.8.8.8 ping statistics ---
14 packets transmitted, 6 received, 57% packet loss
```
