# Инструкция по установке сервера управления Trellix ePolicy Orchestrator  (on-Prem) Версия 5.10
Опубликовано: 15 сентября 2026 • Категория: Гайды
## Перед установкой:

Чтобы убедиться, что у вас есть вся необходимая информация перед установкой Trellix ePO - On-prem, сверьтесь с  контрольным списком.<br>
-	Лицензионный ключ  (не требуется для оценочных версий);
-	Для аутентификации Microsoft SQL требуются одни из следующих учетных данных:
- Учетные данные аутентификации Windows — доменные **учетные данные**, имеющие **права владельца базы данных (dbo) на SQL Server**;
- Учетные данные аутентификации SQL  Server;
-	Установленный SQL Server — (в зависимости от вашей конфигурации) укажите эти данные на странице сведений о базе данных:
- **Имя SQL Server** или имя SQL Server с именем экземпляра
- Динамический **номер порта**, используемый вашим SQL Server (в случае, если статический порт 1433)
## Системные требования:
Проверьте указанные ниже требования к системе перед установкой ПО Trellix ePO 
<br>
|Компонент	|Требования и рекомендации|
|------|-----|
|Сервер	|Выделенный сервер для управления более чем 250 систем Windows Server 2019, 2022|
|Сервер MS SQL	| MS SQL2019 Параметр **SQL Server Nested Triggers** должен быть включен. (см.  **Настройка TCP/IP доступа к серверу Microsoft SQL Server**)|
|Домен	|Рекомендуется чтобы сервер установил доверительные отношения с контроллером домена в сети|
|Файловая система	|NTFS|
|IP адрес	         |Статический|
|Память	             |16 Гб ОЗУ|
|Сетевой интерфейс	|100 Мбит минимум|
|Порты	|Уведомите команду сетевых инженеров об используемых портах для связи сервера Trellix ePO on-Prem и установленными на хостах Trellix Agent  (см.  **Сетевые порты для обеспечения коммуникации между компонентами Trellix**)|
|Процессор	|64 бит минимум 8 ядер|
|Обновления Microsoft	|Рекомендуется установить последние обновления Windows и приложений Microsoft|

## Сетевые порты для обеспечения коммуникации между компонентами Trellix


|Порт |	Значение по умолчанию	| Описание	|Направление трафика|
|-----|------|------|------|
|Порт связи агента с сервером|	80	|TCP-порт, открытый службой Trellix ePO (on-prem) для приема запросов от агентов.	|Входящее/исходящее соединение с Trellix ePO и агентами.|
|Агент, взаимодействующий через SSL (только для агентов версии 4.5 и более поздних версий)	|443	|По умолчанию агенты должны взаимодействовать по безопасному протоколу SSL (по умолчанию 443).	|Входящее/исходящее соединение с сервером Trellix ePO и агентами.|
|Порт связи пробуждения агента|	8081	|TCP-порт, открываемый агентами для получения запросов на пробуждение агентов от сервера Trellix ePO.|	Исходящее соединение от сервера Trellix ePO до управляемых агентами хостов.|
|Порт широковещательной связи агента|	8082|	Порт UDP, открытый  для пересылки сообщений сервера Trellix ePO| 	Исходящее соединение от SuperAgents.|
|Порт связи консоли с сервером приложений|	8443|	Порт HTTPS, открытый службой Trellix ePO Application Server, для обеспечения доступа к пользовательскому интерфейсу веб-браузера.|	Входящее подключение к серверу Trellix ePO.|
|Порт связи датчика инородных систем (RSD)|	8444|	HTTPS-порт, открытый службой Trellix ePO Application Server для получения RSD-подключений. Также зуется Agent Handler для связи с сервером Trellix ePO - для получения необходимой информации (например, серверов LDAP).|	Входящее подключение к серверу Trellix ePO. Исходящее подключение от удаленных обработчиков агентов.|
|TCP порт сервера базы данных SQL server|	1433 или динамический|	TCP-порт, зуемый для связи с SQL-сервером. Этот порт указывается или определяется автоматически в процессе настройки.	Исходящее соединение от сервера|  Trellix ePO /обработчиков агентов.|
|UDP порт сервера базы данных SQL server	|1434|	Порт UDP, зуемый для запроса порта TCP, который зует экземпляр SQL, на котором размещена локальная база данных Trellix ePO.|	Исходящее соединение от сервера  Trellix ePO /обработчиков агентов.|
|Порт LDAP-сервера по умолчанию|	389	|Подключение LDAP для поиска компьютеров, пользователей, групп и организационных подразделений для политик на основе пользователей.|	Исходящее соединение из Trellix ePO — локальный сервер/обработчик агентов.|
|Порт сервера SSL LDAP по умолчанию|	636|	Политики на основе пользователей зуют соединение LDAP для поиска пользователей, групп и организационных подразделений.|	Исходящее соединение из сервераTrellix ePO /обработчиков агентов.|

## Настройка TCP/IP доступа к серверу Microsoft SQL Server
Перед установкой Trellix ePO убедитесь, что на SQL-сервере, на котором будет размещена база данных Trellix ePO, включен протокол TCP/IP. Для этого на сервере, где расположена база данных, в  SQL Server Configuration  Manager в разделе  SQL Server Network Configuration->Protocols for SQLSERVER  необходимо чтобы значение параметра TCP/IP = Enabled.
<br>
<img width="680" height="222" alt="01" src="https://github.com/user-attachments/assets/026e3361-d831-4609-85b3-40cea8a29913" />
<br>
Если значение **TCP/IP**  не равно **Enabled** нужно установить и перезапустить службу   **SQL Server Services**. 
После рестарта службы SQL Server, для определения динамического порта, зуемого сервером Microsoft SQL Server, в **SQL Server Configuration  Manager**  в окне свойств **TCP/IP Properties** на вкладе **IP Address** в разделе  **IPAII**  проверить значение параметра **TCP Dynamic Ports**. 
<br>
> [!WARNING]
> **Значение порта может отличаться от того что на скриншоте ниже!**

<br><img width="414" height="486" alt="02" src="https://github.com/user-attachments/assets/a64de8f2-c512-40da-9e42-e632a3a5e352" />
<br>
Параметр **TCP Dynamic Ports** понадобиться на этапе установки сервера управления Trellix ePolicy Orchestrator.
<br><font color="red">
_Необходимо заранее создать сервисную учетную запись для связи сервера приложения с базой данных. **Server roles** для учетной записи должны быть **public**, **dbcreator**.  В процессе установки сервера Trellix ePolicy Orchestrator, для этой учетной записи еще добавиться роль права **db_owner**  на созданную в процессе инсталяции базу данных. ._
<br>
> [!WARNING]
> **После установки роль dbcreator можно отозвать.**

## KB5143 Наименование файлов в формате 8.3
Во избежание проблем в будущем, активируйте формат именования файлов 8.3 на сервере **перед установкой Trellix ePO**:
1.	**Start --> Run--> regedit**. В реестре найти следующую ветку:
**HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem**
2.	Для параметра **NtfsDisable8dot3NameCreation**, выбрать свойства **Properties** и выставить значение в **0**.
<img width="646" height="434" alt="03" src="https://github.com/user-attachments/assets/50b9875e-964e-4179-90f7-7dc830a48649" />

3.	Перезапустите сервер.
4.	Проверить формат именования файлов 8.3 можно с помощью командной строки:
```
dir /x
```
Папки теперь имеют столбец для коротких имен, например, **Progra~1** для **Program Files**.
## KB91477 Служба SQL Server Browser Service должна быть запущена
1.	Зайти на уровне ОС на сервер где установлен SQL Server.
2.	Нажать Windows+R. 
3.	Написать **services.msc** и нажать **OK**.
4.	Найти службу **SQL Server Browser**, удостовериться что служба запущена и выполняется. Если нет, правой кнопкой на службе **SQL Server Browser** и нажать **Start**.
<img width="556" height="30" alt="04" src="https://github.com/user-attachments/assets/43f8b9c8-28fc-451a-9db2-8ca99ce18b00" />

## KB91823 Поддержка  шифрования TLS 1.1 / 1.2
1.	Загрузить инструмент IIS Crypto ([IISCrypto](https://www.nartac.com/Products/IISCrypto/)).
2.	Разместить исполняемый файл (**IISCrypto.exe**) на сервере где установлено ПО SQL Server ( если БД устанавливается на том же сервере что и сервер Trellix ePO тогда файл скопировать на тот же сервер).
3.	Проверить что выбрано** TLS 1.1 **или **TLS 1.2** в настройках **Server Protocols**.<br>
    📌	Запуск **IISCrypto.exe**.<br>
  	📌 	Выбрать  вкладку **Secure Channel (Channel)**.<br>
    📌 Проверить  Server Protocols.<br>
    📌  Выбрать по необходимости **TLS 1.1** или **TLS 1.2**.<br>
    📌	После изменения, нажать **Apply**.<br>
    📌	Перезагрузить ОС сервера, где установлен SQL Server.
4.	Разместить исполняемый файл **IISCrypto.exe** на сервере, где будет устанавливаться   Trellix ePO.
5.	В настройках Client Protocols проверить что выбрано **TLS 1.1** или **TLS 1.2**:<br>
  📌	Запуск **IISCrypto.exe**.<br>
  📌	Выбрать  вкладку **Secure Channel (Channel)**.<br>
  📌	Проверить Client Protocols.<br>
  📌	Выбрать по необходимости **TLS 1.1** или **TLS 1.2**.<br>
  📌	После изменения, нажать **Apply**.<br>
  📌	Перезагрузить ОС сервера, для Trellix ePO.
<img width="880" height="731" alt="06" src="https://github.com/user-attachments/assets/f5c61659-74b3-46a2-a99d-ea62504e57c4" />

## Процесс установки:
> [!WARNING]
> **_Архив дистрибутива сервера управления должен быть распакован!!_**
> 
1. На сервере, где размещен распакованный установочный пакет для развертывания консоли управления  запустить **setup.exe** с правами локального администратора.
<img  alt="07" src="https://github.com/user-attachments/assets/057dc22c-e4dc-445b-8794-115ae89b7709" />

Запустится мастер установки Trellix ePolicy Orchestrator.
При Установке нового сервера  нажать **Next**.

<img  alt="08" src="https://github.com/user-attachments/assets/c48def43-6cba-469d-ae38-d6437f0cc425" />

Ознакомиться с пакетом дополнительного ПО для установки и нажать **Next**.

<img alt="09" src="https://github.com/user-attachments/assets/41085950-f36e-4657-af25-4358d1fb4fab" />

Указать каталог в который будет проводиться установка Trellix ePolicy Orchestrator, нажать **Next**.

<img  alt="10" src="https://github.com/user-attachments/assets/0babdcf0-ee09-434e-8bb3-3e3f9e048fe7" />

На этапе подключения к базе данных установить параметры и нажать **Next**.
<br>
**Database Server** - имя хоста, где расположен сервер базы данных **server-name\SQLSERVER**
<br>
**Database Name** – имя базы данных, ePO_<server_name>,  **Учетные данные, зуемые для подключения к базе**.
<br>
> [!WARNING]
> **_Использовать заранее созданую сервисную учетную запись!_**
> 
<br>

**TCP порт, используемый для соединения с сервером базы данных** — динамический порт,  значение параметра **TCP Dynamic Ports**  в случае Express Edition. Для коммерческих версий Microsoft SQL Server порт по умолчанию TCP 1433.

<img  alt="11" src="https://github.com/user-attachments/assets/8b940550-53de-4150-807e-9be9259c94b2" />

Утилита Pre-Installation Auditor  должна перед запуском провести проверку соответствия, если все проверки успешно пройдены жмем **Finish** и возвращаемся к установке.


<img  alt="12" src="https://github.com/user-attachments/assets/04f5a2ef-71e5-4598-b2df-3e2aaba5e89c" />

Ознакомиться с сетевыми портами, используемыми для коммуникации между компонентами Trellix и нажать **Next**

<img  alt="13" src="https://github.com/user-attachments/assets/51a83648-4046-4cc4-87e1-f3ca735171c5" />.

Ввести пароль для основной административной учетной записи сервера управления Trellix ePolicy Orchestrator – **admin**, ввести **passphrase** используемую для шифрования снапшотов и нажать **Next**.

<img width="495" height="373" alt="14" src="https://github.com/user-attachments/assets/dd1fd048-9c93-4a75-bb2c-bb2e55b5eeb3" />

Ввести лицензионный ключ и нажать **Next**, 

<img width="327" height="251" alt="15" src="https://github.com/user-attachments/assets/c25f8f6d-0deb-4ef4-8c05-ce330a716fe4" />

> [!WARNING]
> **Галочку Включить автоматическую установку продукта не активируем!!**
> 
в случае оценочной версии выбрать параметр **Evaluation** и нажать **Next**.

<img width="497" height="376" alt="16" src="https://github.com/user-attachments/assets/42b0509c-6f73-4021-a879-2cc0e8bf5c7f" />

Выбрать значение **All countries not explicitly listed above** и принять лицензионное соглашение, нажать **Next**.

<img width="497" height="428" alt="17" src="https://github.com/user-attachments/assets/bd2fbefd-92dc-4973-8e7b-68a464c8b9d6" />

Приступить к установке, нажать  **Install**.

<img width="497" height="376" alt="18" src="https://github.com/user-attachments/assets/60c51f2c-5d4b-48d6-aea6-79412132d457" />

Процесс установки занимает примерно 10 - 20 минут.

<img  alt="19" src="https://github.com/user-attachments/assets/d298c7e5-3030-4794-968c-de0e0d46ff20" />

По окончании установки выбрать **Yes, I want to launch Trellix ePolicy Orchestrator**.. и  нажать **Finish**.

<img alt="20" src="https://github.com/user-attachments/assets/5d0fb73c-97a5-4db0-8610-da1fb928839d" />

После окончания установке в браузере перейти по адресу **https://server-name:8433**, где <server-name> имя сервера,  на котором установлен Trellix ePolicy Orchestrator.

<img  alt="21" src="https://github.com/user-attachments/assets/a702ea25-7776-44f3-9ec1-d1cd41ac826c" />
Welcome to ePolicy Orchestrator. Далее можно переходить к инструкциям, после установки сервера Trellix.

## Обновление до SP Update 6 1895
Перед обновлением удалить несовместимый extension, если такой будет выявлен.

<img  alt="22" src="https://github.com/user-attachments/assets/f6b346cd-c6fe-4497-aa38-da2af9c5aba2" />

1. Отрыть SQL Management Studio и выставить параметры **AutoClose=False** для 2 баз данных

<img  alt="23" src="https://github.com/user-attachments/assets/a935fbac-179b-4244-bd5f-167106787bb3" />

2. Перезагрузить сервера Trellix ePO.

3. Остановите все нижеперечисленные службы и сможете возобновить работу после завершения обновления.<br>

📌 Windows Management instrumentation (Инструментарий управления Windows)<br>
📌 WMI Performance Adapter   (Анализатор производительности WMI)<br>
📌 Performance Counter DLL Host (Хост библитотеки счетчика производительности)<br>
📌 Performance Logs & Alerts  (Журналы и оповещения производительности)<br>
📌 Trellix ePolicy Orchestrator Application Server (Сервер приложений ePolicy Orchestrator)<br>
📌 Trellix ePolicy Orchestrator Event Parser (Анализатор событий Trellix ePolicy Orchestrator )<br>
📌 Trellix ePolicy Orchestrator Server (Сервер ePolicy Orchestrator)<br>

5. Запустить **ePOUpdater.exe**.

<img  alt="24" src="https://github.com/user-attachments/assets/a9622ec8-0390-4289-9e7e-d258fb6aa03b" />

5. Ввести учетные записи для подключения к серверу базы данных. Нажать **Next (Продолжить)**.

<img  alt="25" src="https://github.com/user-attachments/assets/79502128-3145-4a69-a102-6711af3d33a8" />

> [!WARNING]
> **!!!Для сервер Trellix ePO должен быть доступен ресурс в Интернете:**
>

https://epo.trellix.com/ProductCompatibilityList.xml
<br>
http://update.nai.com/Products/CommonUpdater

6. Ознакомиться с предложенными пакетами обновления. Нажать **Next (Продолжить)**.
7. Применить обновления нажав **Ok**.

<img width="670" height="783" alt="26" src="https://github.com/user-attachments/assets/f67cbd8f-2426-47bf-b42a-9ff3690658df" />

8. Процесс установки обновлений займет 7-10 минут.

<img width="872" height="704" alt="27" src="https://github.com/user-attachments/assets/5732ec6b-f66f-41b8-a775-6306414bda01" />

9. После успешного запуска служб нажмите **Finish (Готово)** для закрытия ПО установщика.

<img width="883" height="706" alt="28" src="https://github.com/user-attachments/assets/819ffe57-7501-44e3-aa2f-c0cf74696533" />

































