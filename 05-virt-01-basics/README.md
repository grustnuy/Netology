
# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."


## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

- Полная (аппаратная) виртуализация - работает на аппаратном уровне. Гипервизор являеться хостовой ОС.
- Паравиртуализация - имеет прослойку в виде ОС на которой работате гипервизор. Гостевая ОС использует только выделенные ей ресурсы. Гипервизор модифицирует ядро гостевой ВМ для разделения доступа к аппаратным средствам физического сервера. C появлением аппаратной поддержки виртуализации, такой как Intel VT и AMD-V, стало возможным выполнение любых ОС без модификации ядра.
- Виртуализация на основе ОС - нельзя выброть ядро отличное от хостовой. Использует все ресурсы хостовой ОС. 

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

|Условия использования|Организация серверов|
|--------|----------|
| Высоконагруженная база данных, чувствительная к отказу. | Физические сервера |
| Различные web-приложения. | Виртуализация уровня ОС|
| Windows системы для использования бухгалтерским отделом. | Паравиртуализация|
| Системы, выполняющие высокопроизводительные расчеты на GPU.| Физические сервера |


## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

|Сценарий использования|Организация серверов|
|--------|----------|
|100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.|Hyper-V.Windows based инфраструктура. Полное соответствие требованиям. Низкий порог входа по сравнению с решением от VMware|
|Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.|KVM, ProxMox, XEN. Open source, производительны.|
|Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.| Hyper-V Server.Бесплатное и наиболее производительное для Windows|
|Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.|Любой open source продукт|
## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно)
 и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

 Проблемы и недостатки гетерогенной среды:
 
 - содержание нескольких команд администрирования и сопровождения для разных систем виртуализации; 
 - масштабируемость, придется масштабировать 2(или более) системы; 
 - увеличенные финансовые затраты при использовании проприетарных продуктов, так как необходимо содержать несколько систем одновременно;
 - проблемы миграции между разными системами;
	   
 Для минимизации рисков необходимо держать квалифицированный персонал, способный администрировать и сопровождать все системы виртуализации. 
 
 
Создание гетерогенной среды виртуализации зависит от предстоящих задач. Например в компаниях которые не занимаються разработкой ИТ-продуктов и предоставлением ИТ-услуг используеться единое решение виртуализации.
В ИТ компаниях, особенно крупных, без гетерогенной среды не обойтись.
      
