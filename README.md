# KudaGo
Клиент для [KudaGo](https://kudago.com/spb/)

# Требования к проекту #

Обязательно:

- Использовать Core Data для хранения моделей данных
- Использовать KeyChain/UserDefaults для пользовательских настроек
- Использование Swift styleguides (Google styleguides)
- Не использовать сторонние библиотеки (кроме snapshot-тестов)
- Использовать сеть
- Отображение медиа (аудио, видео, изображения) из сети
- Минимальное количество экранов: 3
- Обязательно использовать UINavigationController/TabBarController
- Deployment Target: iOS 13
- Покрытие модульными тестами 10% и более [не выполнено]
- Хотя бы один UI-тест через page object
- Хотя бы один snapshot тест для iPhone SE (разрешается использовать внешнюю библиотеку)
- Использование Архитектурных подходов и шаблонов проектирования
- Верстка UI в коде
- Обязательно использовать UITableView/UICollectionView 

Дополнительно:

- Кастомные анимации
- Swiftlint
- Системы аналитики и анализа крэшей  ( с использованием сторонних зависимостей ) [не выполнено]

# Описание проекта и детали реализации #

Приложение используется для ознакомлением с актуальными событиями в выбранном городе. </br>
Кроме того, есть возможность персонализации подборки по категориям событий. </br>
Поддерживается offline-режим для добавленных в избранное событий. </br>
Поддерживается автоматическое выделение ссылок в тексте и переход по ним внутри приложения при помощи SafariServices. </br>

Deployment Target: iOS 13
Архитектура: MVC
Верстка: код, без xib, storyboards
Стиль написания кода: Sberbank SwiftLint configuration
Внешние библиотеки: SwiftLint, ShapShotTest. Добавлены при помощи cocoapods.

## UI, экраны ##

Кроме представленных ниже экранов существует онбординг, который используется при первом запуске приложения пользователем. </br> 
Онбординг структурно идентичен экранам настроек(т.к. ими он и является), отличия в визуальной составляющей.

#### Лента событий ####
![](https://github.com/lKrausz/KudaGo/blob/main/KudaGo/ReadMeData/events.jpg)

#### Избранное ####
![](https://github.com/lKrausz/KudaGo/blob/main/KudaGo/ReadMeData/bookmarks.jpg)

#### Экран детализации события ####
![](https://github.com/lKrausz/KudaGo/blob/main/KudaGo/ReadMeData/event.jpg)

#### Экраны настроек приложения ####
![](https://github.com/lKrausz/KudaGo/blob/main/KudaGo/ReadMeData/settings.jpg)

#### Кастомные анимации ####

Анимация нажатия на кнопку сохранения в закладки на ячейке события. </br>
Анимация(?), связанная с центрированием изображений на экране детализации события и изменением скорости прокрутки.

## Сервисы ##

### Core Data ###
В коде реализована в группе Core Data, обращение через DataBaseManager. </br>
Используется для сохранения данных события для offline-доступа во вкладке "Избранное".

### UserDefaults ###
В коде реализована в группе UserDefaults, обращение через DataManager. </br>
Используется для сохранения настроек пользователя, таких как локация и список категорий для подборки событий. </br> 
Также здесь сохраняется параметр "isNewUser", который отвечает за отображение онбординга для новых пользователей.

### Network Manager ###
В коде реализована в группе Network, обращение через NetworkManager. </br>
Используется для работы с KudaGo API, а также загрузки изображений из сети.

### NSCache ###
В коде реализована в группе NSCache, обращение через NSCacheManager. </br>
Используется для оптимизации работы с картинками, а также offline-режима.

### Note ###
У сервисов разные модели, поэтому для удобной работы UI взаимодействует с единой EventModel, в которую переводятся остальные. 
## Тестирование ##

Написаны UI-тесты для проверки существования элементов, например, картинок на странице детализации события.
При помощи библиотеки SnapShotTesting были сделаны ShapShot тесты для IPhone SE 2. 

### Note ###
Известна проблема с удалением событий с экрана событий из Core Data, пока не очень понятно как чинить. </br>
Возможно, отказом от NSFetchedResultsController.
