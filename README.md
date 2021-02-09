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

Очень мощная система мониторинга. 

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
* see etc/logstash/example.conf

2. Запускаем из консоли logstash -t (Validation OK!), logstash -r (для оперативного вмешательства).

3. Для парсинга логов - filtre Grok. Самая сложная задача - правильно написать.

4. Все прекрасно парсит, работает очень быстро.

5. В консоли работать одно удовольствие, чего не скажешь о Kibana! (Может привычка.)

## Built With

* [ArchWiki](https://wiki.archlinux.org/)

## Authors

* **Sergey Shitenkov**

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
