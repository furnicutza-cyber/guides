Установка CrowdStrike Falcon через Group Policy Objects
Опубликовано: 23 февраля 2026 • Категория: Гайды
Введение
Развертывание сенсора CrowdStrike Falcon с помощью групповой политики (GPO) позволяет администраторам устанавливать сенсор на нескольких конечных точках Windows без ручного вмешательства. Этот метод идеально подходит для организаций, использующих Active Directory (AD) для централизованного управления устройствами.

Дано:
В настоящей инструкции установка сенсора будет назначена группе хостов Falcon Workstations в которой участвует тестовый хост win11gpo, являющийся участником домена edusiem.lab.

Deploy Falcon sensor GPO
Технические требования
Перед настройкой интеграции убедитесь, что у вас есть:
📌 Контроллер домена Active Directory (AD) с управлением групповыми политиками.
📌 Установщик сенсора CrowdStrike Falcon (FalconSensor_Windows.exe).
📌 Идентификатор клиента (CID) из консоли CrowdStrike Falcon.
📌 Права администратора на контроллере домена.

Процесс установки и настройки
1. Войдите в консоль Falcon.
Перейдите в раздел Host Setup and Management ->Sensor Downloads. Перейдите на страницу загрузки сенсоров. Загрузите сенсор для ОС Windows.
Выберите версию Windows и загрузите файл FalconSensor_Windows.exe.
Разместите установщик в сетевом ресурсе.
Скопируйте FalconSensor_Windows.exe, доступный всем компьютерам.
В примере: \\DC17\Falcon\ FalconSensor_Windows.exe
📌 Примечание. Убедитесь, что ресурс имеет разрешения на чтение (read) и выполнение (execute) для всех компьютеров, подключенных к домену.

2. Создание объектов групповой политики GPO. Откройте Управление групповыми политиками (Group Policy Management). Нажмите Win + R, введите gpmc.msc и нажмите Enter. Создайте новый объект групповой политики (GPO).
Щелкните правой кнопкой мыши Объекты групповой политики (Group Policy Objects) и выберите Создать (New).
Назовите GPO Deploy CrowdStrike Falcon.

Deploy Falcon sensor GPO
Измените GPO
Щелкните правой кнопкой мыши новый GPO и выберите Изменить (Edit).

Deploy Falcon sensor GPO
Перейдите в раздел Конфигурация компьютера-> Политики-> Параметры Windows->Сценарии (запуск/завершение работы) (Computer Configuration -> Policies->Windows Settings->Scripts (Startup/Shutdown)).

Deploy Falcon sensor GPO
Дважды щелкните Запуск (Startup) и нажмите Добавить (Add).
Добавьте сценарий запуска

Deploy Falcon sensor GPO
Нажмите Обзор (Browse), перейдите в папку \\DC17\Falcon и создайте новый файл сценария:
Имя файла: InstallFalcon.bat

Deploy Falcon sensor GPO
Содержимое файла InstallFalcon.bat (замените YOUR-CUSTOMER-ID фактическим CID из вашей консоли Falcon):

@echo off 

echo [%date% %time%] Install.bat started >> C:\GPO_Install_Log.txt
\\DC17\Falcon\FalconSensor_Windows.exe /quiet /norestart CID= YOUR-CUSTOMER-ID
echo [%date% %time%] Install.bat finished >> C:\GPO_Install_Log.txt

        
Сохраните и закройте окно скрипта. Нажмите ОК, чтобы применить скрипт запуска.

3. Применить GPO к целевым компьютерам. В разделе Управление групповыми политиками Group Policy Management щелкните правой кнопкой мыши подразделение (OU), содержащее компьютеры, на которых необходимо установить сенсор Falcon. В настоящей инструкции OU называется Falcon Workstations.

4. Щелкните Связать существующий объект групповой политики (Link an Existing GPO)

Deploy Falcon sensor GPO
и выберите Deploy CrowdStrike Falcon.

Deploy Falcon sensor GPO
Принудительное обновление групповой политики на клиентах
Откройте командную строку от имени администратора на тестовой рабочей станции Win11gpo и выполните команду:

gpupdate /force
Перезагрузите рабочую станцию Win11gpo, чтобы применить политику.

Результат:
После перезагрузки проверьте, установлен ли и запущен ли Falcon Sensor.

Вариант 1: Проверка установленных программ
Откройте Панель управления ->Программы и компоненты.
Найдите CrowdStrike Falcon Sensor в списке.

Deploy Falcon sensor GPO
Вариант 2: Проверка служб Windows
Выполните следующую команду в командной строке:

sc query csagent
Deploy Falcon sensor GPO
