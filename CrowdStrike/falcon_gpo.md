# Установка CrowdStrike Falcon через Group Policy Objects
Опубликовано: 23 февраля 2026 • Категория: Гайды
## Введение
Развертывание сенсора CrowdStrike Falcon с помощью групповой политики (GPO) позволяет администраторам устанавливать сенсор на нескольких конечных точках Windows без ручного вмешательства. Этот метод идеально подходит для организаций, использующих Active Directory (AD) для централизованного управления устройствами.
<br>
## Дано:
В настоящей инструкции установка сенсора будет назначена группе хостов **Falcon Workstations** в которой участвует тестовый хост **win11gpo**, являющийся участником домена edusiem.lab.
<img width="461" height="169" alt="001" src="https://github.com/user-attachments/assets/cf8d465e-3356-425d-965d-9d042c658623" />


## Технические требования
Перед настройкой интеграции убедитесь, что у вас есть:


📌 Контроллер домена Active Directory (AD) с управлением групповыми политиками.


📌 Установщик сенсора CrowdStrike Falcon (**FalconSensor_Windows.exe**).


📌 Идентификатор клиента (**CID**) из консоли CrowdStrike Falcon.


📌 Права администратора на контроллере домена.


## Процесс установки и настройки
1. Войдите в консоль Falcon.


Перейдите в раздел **Host Setup and Management ->Sensor Downloads**. Перейдите на страницу загрузки сенсоров. Загрузите сенсор для ОС Windows.


Выберите версию Windows и загрузите файл **FalconSensor_Windows.exe**.


Разместите установщик в сетевом ресурсе.


Скопируйте **FalconSensor_Windows.exe**, доступный всем компьютерам.


В примере: **\\DC17\Falcon\ FalconSensor_Windows.exe**


📌 Примечание. Убедитесь, что ресурс имеет разрешения на чтение (read) и выполнение (execute) для всех компьютеров, подключенных к домену.


2. Создание объектов групповой политики GPO. Откройте **Управление групповыми политиками (Group Policy Management)**. Нажмите **Win + R**, введите **gpmc.msc** и нажмите Enter. Создайте новый объект групповой политики (GPO).


Щелкните правой кнопкой мыши **Объекты групповой политики (Group Policy Objects)** и выберите **Создать (New)**.


Назовите **GPO Deploy CrowdStrike Falcon**.

<img width="380" height="177" alt="002" src="https://github.com/user-attachments/assets/83579634-0ed8-4c4e-9155-0888648901e3" />



Измените GPO


Щелкните правой кнопкой мыши новый GPO и выберите **Изменить (Edit)**.

<img width="781" height="555" alt="003" src="https://github.com/user-attachments/assets/71586c38-70f5-4e60-a1dc-0acd0280beb5" />


Перейдите в раздел **Конфигурация компьютера-> Политики-> Параметры Windows->Сценарии (запуск/завершение работы) (Computer Configuration -> Policies->Windows Settings->Scripts (Startup/Shutdown))**.


<img width="777" height="558" alt="004" src="https://github.com/user-attachments/assets/b738be84-f221-476e-b00b-24515d1f90e0" />


Дважды щелкните **Запуск (Startup)** и нажмите **Добавить (Add)**.


Добавьте сценарий запуска


<img width="370" height="186" alt="005" src="https://github.com/user-attachments/assets/284e961e-39fa-423e-af47-094acb43752b" />


Нажмите **Обзор (Browse)**, перейдите в папку **\\DC17\Falcon** и создайте новый файл сценария:


Имя файла: **InstallFalcon.bat**


<img width="391" height="448" alt="006" src="https://github.com/user-attachments/assets/3e56cfd5-954a-449e-9dc4-2c49940f050e" />


Содержимое файла **InstallFalcon.bat** (замените YOUR-CUSTOMER-ID фактическим CID из вашей консоли Falcon):


```
@echo off 

echo [%date% %time%] Install.bat started >> C:\GPO_Install_Log.txt
\\DC17\Falcon\FalconSensor_Windows.exe /quiet /norestart CID= YOUR-CUSTOMER-ID
echo [%date% %time%] Install.bat finished >> C:\GPO_Install_Log.txt
```
        
Сохраните и закройте окно скрипта. Нажмите **ОК**, чтобы применить скрипт запуска.


3. Применить GPO к целевым компьютерам. В разделе **Управление групповыми политиками Group Policy Management** щелкните правой кнопкой мыши подразделение (OU), содержащее компьютеры, на которых необходимо установить сенсор Falcon. В настоящей инструкции OU называется **Falcon Workstations**.


4. Щелкните **Связать существующий объект групповой политики (Link an Existing GPO)**


<img width="325" height="296" alt="007" src="https://github.com/user-attachments/assets/2c1a24a8-606b-4f1c-bd18-b3ef96e1da08" />


и выберите **Deploy CrowdStrike Falcon**.


<img width="440" height="406" alt="008" src="https://github.com/user-attachments/assets/5f3842ec-da6a-4af6-b173-b8ac95220e24" />


5. Принудительное обновление групповой политики на клиентах

   
Откройте командную строку от имени администратора на тестовой рабочей станции **Win11gpo** и выполните команду:

```
gpupdate /force
```
Перезагрузите рабочую станцию **Win11gpo**, чтобы применить политику.



## Результат:
После перезагрузки проверьте, установлен ли и запущен ли Falcon Sensor.

***Вариант 1:*** Проверка установленных программ
Откройте **Панель управления ->Программы и компоненты**.
Найдите CrowdStrike Falcon Sensor в списке.

<img width="835" height="346" alt="009" src="https://github.com/user-attachments/assets/40564a5f-23e8-48e7-a274-25d1a04a89a4" />


***Вариант 2:*** Проверка служб Windows
Выполните следующую команду в командной строке:
```
sc query csagent
```
<img width="739" height="214" alt="010" src="https://github.com/user-attachments/assets/eb5bad4d-51d8-40e6-ac73-c1f31565b787" />
