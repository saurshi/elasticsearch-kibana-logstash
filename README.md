# elasticsearch-kibana-logstash-winlogbeat

* По заданию на вакансию в ИСА (ООО "Информационные системы и аутсорсинг")

**ELASTIC (ELK) STACK**

## Getting Started

Познакомившись с описанием платформы на [официальном сайте](https://www.elastic.co/products/elastic-stack) и, 

развернув ELK в облаке, решил установить эту связку на локальной машине.

В моей системе Archlinux были доступны все пакеты для установки из репозитория, поэтому развернул быстро.

### Prerequisites

1. Установил elasticsearch, logstash & kibana. (Доп.: filebeat, heartbeat, journalbeat, metricbeat, packetbeat, 
для полной ясности о возможностях ELK)

2. В процессе экспериментов выяснилось, что ELK плохо дружит с новейшей версией OpenJDK Java
   - поставил Oracle Java Runtime Environment из AUR.

3. Настройка хорошо задокументирована на [официальном сайте](https://www.elastic.co/guide/index.html).

### Creating

1. systemctl enable filebeat heartbeat journalbeat metricbeat packetbeat logstash elasticsearch kibana

2. syestemctl start filebeat heartbeat journalbeat metricbeat packetbeat logstash elasticsearch kibana

3. В web-интерфейсе Kibana настраиваем мониторинг нужных модулей и вуаля!

4. В контейнере с windows 7 пробросил порты в хост, установил Winlogbeat, предварительно настроив output в winlogbeat.yml -
   отсылаем все на lagstash, а он уже на elasticsearch. В logstash, конечно нужно еще добавить обработчик-парсер перед
   отправкой в elasticsearch для удобства имхо.

5. Конечно это очень упрощенная настройка, подключения и не использовалась предусмотренная возможность паролей и сертификатов.

### Conclusion 

В целом интересная система мониторинга, но пригодна имхо только для анализа. 

Не предусмотрено алертов и оперативного оповещения без сторонних модулей. Еще хочется отметить прожорливость Java на ресурсы процессора и памяти, хотя работает все бодро, правда и нагрузки нет.

### Modification

Нужно сделать так, чтобы Logstash парсил лог через фильтр.

1. Для этого подключаем grok filter plugin например так:

    input {
      file {
        path => "/var/log/logstash/input/*.log"
      }
    }
    filter {
      grok {
        match => { "message" => "%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}" }
      }
    }
* see etc/logstash/vnet-example.conf

2. Беда в том, что у меня не получилось на хосте запустить ELK и Logstash на одной версии JAVA VM!

Logstash крашился на Java/latest, а ELK не запускался на jre8.u222-2, на котором работал первый.:-(

Пришлось Logstash запускать в контейнере docker.elastic.co/logstash и вязать с ELK на хосте.

Еще тот гемор, т.к. контейнер неразборный. В итоге не получилось протестировать реальный вывод после парсинга grok`ом.

На docker-compose у меня пока не дошли руки из-за нехватки времени и technical limitations of the host (ssd60Gb).

3. Но я принципиально это сделаю позже.

## Built With

* [ArchWiki](https://wiki.archlinux.org/)

## Authors

* **Sergey Shitenkov**

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
