# Интеграция CrowStrike с решениями SIEM
Опубликовано: 13 мая 2026 • Категория: Гайды
## Введение
Интеграция CrowdStrike Falcon с решением для управления информацией и событиями безопасности (SIEM) позволяет организациям централизовать данные об угрозах, улучшить прозрачность безопасности и повысить эффективность реагирования на инциденты. CrowdStrike Falcon обеспечивает обнаружение угроз в режиме реального времени и ведёт журналы активности конечных точек, которые можно пересылать на платформы SIEM, такие как Splunk, QRadar, ArcSight и Microsoft Sentinel.
В этой инструкции объясняется, как интегрировать CrowdStrike Falcon с решением SIEM с помощью коннектора Falcon SIEM.
<br>
## Схема подключения
Коннектор Falcon SIEM можно разместить за прокси-сервером, и он будет подключаться к
конечной точке Falcon Streaming для авторизации и поиска доступных каналов.
<img width="1515" height="659" alt="image" src="https://github.com/user-attachments/assets/5e2b49e1-47a1-4d91-9292-cc9a5d6256dc" />
Коннектор выполняет следующие действия:<br>
📌 Преобразование и запись событий в системный журнал (syslog). Системный журнал (syslog) будет использоваться инструментом анализа журналов.<br>
📌 Преобразование и запись событий в прослушиватель системного журнала с полезной нагрузкой, не зависящей от инструмента.
## Технические требования
Перед настройкой интеграции убедитесь, что у вас есть:
<br>
1. Доступ администратора к консоли CrowdStrike Falcon. Сетевой доступ, разрешающий трафик от сети инфраструктуры, где размещен SIEM коннектор до доменных имен соответствующего тенанта:

| Cloud tenant | Доменное имя|
|------|------|
| US-1 | api.crowdstrike.com <br>   firehose.crowdstrike.com | 
| US-2 | api.us-2.crowdstrike.com <br> firehose.us-2.crowdstrike.com | 
| EU-1 | api.eu-1.crowdstrike.com <br> firehose.eu-1.crowdstrike.com | 
2. Установлена и настроена платформа SIEM (например, Splunk, QRadar, ArcSight, Sentinel и др).
3. Сервер или виртуальная машина для размещения Falcon SIEM Connector. Для каждого CID (идентификатор клиента) требования для отдельной виртуальной машины 8 Гб ОЗУ, 2CPU 12 Гб дискового пространства.
## Процесс установки и настройки
1. Войдите в консоль Falcon.
Перейдите в раздел **Support and resources --> Tools downloads**
<img width="1636" height="859" alt="image" src="https://github.com/user-attachments/assets/5bf0e57c-94cf-4638-a2fe-a74b1663ab9b" />
Скачайте **Falcon SIEM Connector** для вашей ОС (Linux).<br>
2. Установите SIEM Connector на подготовленной виртуальной машине.<br>
Введите следующую команду для Ubuntu:

```
sudo dpkg -i [ИмяУстановочногоПакета]
```
Введите следующую команду для CentOS:
```
sudo rpm -Uvh [ИмяУстановочногоПакета]
```
Пакет немедленно установит SIEM-коннектор.
<img width="1042" height="139" alt="image" src="https://github.com/user-attachments/assets/809bf6cf-716d-4489-af70-7756e9009174" />
3. Генерация ключа API CrowdStrike Falcon<br>
При включении потоковых API можете сгенерировать ключ API CrowdStrike Falcon:<br>
Войти в CrowdStrike Falcon.<br>
Перейдите **Support and resources--> API clients and keys**.<br>
Нажмите **Create API client**.<br>
В поле **Client name** введите имя _SIEM Connector_<br>
Включить **Read** для потоков событий **Event streams**.<br>
<img width="705" height="624" alt="image" src="https://github.com/user-attachments/assets/1403a2f6-0425-467a-a2c5-aab6c4fe1451" />
<br>Нажмите **Create**.<br>
<img width="696" height="430" alt="image" src="https://github.com/user-attachments/assets/f4408376-f575-4e65-a646-b8275b0b1c02" />
<br>Скопируйте идентификатор клиента **Client ID** и секретный код **Secret**. Они понадобятся позже. Нажмите **Done**.<br>
4. Настройка SIEM connector<br>
Тип выходных данных определяется образцом файла конфигурации. Образцы файлов конфигурации хранятся в каталоге **/opt/crowdstrike/etc/**. Можно выбрать один из следующих форматов вывода:<br>
📌 JSON (по умолчанию). Выходной файл записывается в каталог _/var/log/crowdstrike/falconhoseclient/output_ <br>
📌 Syslog. Нужно подредактировать файл:
```
/opt/crowdstrike/etc/cs.falconhoseclient.cfg.
```
Измените значение параметра output_format на следующее: _output_format=syslog_ <br>
📌 Common Event Format (CEF). В каталоге _/opt/crowdstrike/etc/_ нужно переименовать конфигурационный файл-образец (для CEF формата) выполнив команду:
```
sudo mv /opt/crowdstrike/etc/cs.falconhoseclient.cef.cfg
/opt/crowdstrike/etc/cs.falconhoseclient.cfg
```
📌 Log Event Extended Format (LEEF). В каталоге _/opt/crowdstrike/etc/_ нужно переименовать конфигурационный файл-образец (для LEEF формата) выполнив команду:
```
sudo mv /opt/crowdstrike/etc/cs.falconhoseclient.leef.cfg
/opt/crowdstrike/etc/cs.falconhoseclient.cfg
```
Откройте файл конфигурации SIEM-коннектора  _opt/crowdstrike/etc/cs.falconhoseclient.cfg_ <br>
Внесите следующие изменения в файл:<br>
**client_id** = [скопированный ранее идентификатор клиента]<br>
**client_secret** = [скопированный ранее секретный ключ API]
<br>
Также может потребоваться изменить **api_url** и **request_token_url** в зависимости от того, где находится ваш экземпляр CrowdStrike. В примере ниже, тенант располагается в облаке US-2. Поскольку запись событий будет осуществляться в syslog формате, параметр _output_format=syslog_ <br>
<img width="971" height="852" alt="image" src="https://github.com/user-attachments/assets/250b4702-2de2-4d54-b00f-f3f0ab16a1fd" />
Сохраните конфигурационный файл. Перезапустите коннектор с помощью следующей команды для Ubuntu 14.x:
```
sudo start cs.falconhoseclientd
```
Перезапустите коннектор с помощью следующей команды для Ubuntu 16.x:
```
sudo systemctl restart cs.falconhoseclientd.service
```
<img width="1432" height="210" alt="image" src="https://github.com/user-attachments/assets/fd081591-1976-4150-b523-2592fddbb79c" />

Перезапустите коннектор с помощью следующей команды для CentOS:
```
sudo service cs.falconhoseclientd start
```
Проверить поступление журналов в SIEM коннектор можно в файле: **/var/log/crowdstrike/falconhoseclient/output**.<br>
```
tail -f /var/log/crowdstrike/falconhoseclient/output
```
Сбор, парсинг и отправка событий в SIEM, зависит от используемого решения. В случае с Wazuh, сбор логов из файла output осуществляется агентом Wazuh 4.9.2, установленном на том же хосте, где развернут SIEM коннектор от CrowdStrike.
## Результат:
Сырые логи от тенанта CrowdStrike Falcon поступают в индексер wazuh-archives и доступны для просмотра в консоли Wazuh Discover.
<img width="1902" height="886" alt="image" src="https://github.com/user-attachments/assets/038d9160-fb77-42fe-8fb9-89b0940c12e1" />


