﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка= Ложь;
		Возврат;
	КонецЕсли;

	// Если передали явный список лент новостей, то использовать его.
	// В противном случае рассчитать только видимые пользователю ленты новостей
	Если Параметры.ПропуститьЗаполнениеНовостями = Истина Тогда

		лкТаблицаКонтекстныхНовостей = ЭтаФорма.ТаблицаНовостей.Выгрузить();

	Иначе

		Если Параметры.СписокЛентНовостей.Количество() > 0 Тогда
			лкСписокЛентНовостей = Параметры.СписокЛентНовостей;
		Иначе
			МассивДоступныхЛентНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
				"ДоступныеЛентыНовостей", // КлючОбъекта
				""); // КлючНастроек, пока не обрабатывается
			лкСписокЛентНовостей = Новый СписокЗначений;
			лкСписокЛентНовостей.ЗагрузитьЗначения(МассивДоступныхЛентНовостей);
		КонецЕсли;

		лкТаблицаКонтекстныхНовостей = ОбработкаНовостей.ПолучитьТаблицуКонтекстныхНовостей(
			лкСписокЛентНовостей,
			?(ПустаяСтрока(Параметры.ИмяМетаданных), Неопределено, Параметры.ИмяМетаданных),
			?(ПустаяСтрока(Параметры.ИмяФормы), Неопределено, Параметры.ИмяФормы),
			?(ПустаяСтрока(Параметры.ИмяСобытия), Неопределено, Параметры.ИмяСобытия),
			"Для формы контекстных новостей"
		); // Вариант запроса для контекстных новостей

	КонецЕсли;

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьТаблицуКонтекстныхНовостей(
		?(ПустаяСтрока(Параметры.ИмяМетаданных), Неопределено, Параметры.ИмяМетаданных),
		?(ПустаяСтрока(Параметры.ИмяФормы), Неопределено, Параметры.ИмяФормы),
		?(ПустаяСтрока(Параметры.ИмяСобытия), Неопределено, Параметры.ИмяСобытия),
		лкТаблицаКонтекстныхНовостей
	);

	ЭтаФорма.ТаблицаНовостей.Загрузить(лкТаблицаКонтекстныхНовостей);

	Если Параметры.СкрыватьКолонкуПодзаголовок = Истина Тогда
		Элементы.ТаблицаНовостейПодзаголовок.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.СкрыватьКолонкуДатаПубликации = Истина Тогда
		Элементы.ТаблицаНовостейДатаПубликации.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.СкрыватьКолонкуЛентаНовостей = Истина Тогда
		Элементы.ТаблицаНовостейЛентаНовостей.Видимость = Ложь;
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (
				РольДоступна(Метаданные.Роли.АдминистраторСистемы)
				ИЛИ РольДоступна(Метаданные.Роли.ПолныеПрава)
				ИЛИ РольДоступна(Метаданные.Роли.ЧтениеНовостей)) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	Если НЕ ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		ЭтаФорма.Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;

	Если ВРег(СокрЛП(Параметры.РежимОткрытияОкна)) = ВРег("Независимый") Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	ИначеЕсли ВРег(СокрЛП(Параметры.РежимОткрытияОкна)) = ВРег("Блокировать весь интерфейс") Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	Иначе // Блокировать окно владельца
		//
	КонецЕсли;

	УстановитьУсловноеОформление();

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуКонтекстныхНовостейПриСозданииНаСервере(
		ЭтаФорма,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтаФорма.ТаблицаНовостей.Количество() <= 0 Тогда
		Отказ = Истина;
		// Вывести сообщение, что нет контекстных новостей
		ТекстСообщения     = НСтр("ru='Для этой формы нет контекстных новостей.'");
		ПояснениеСообщения = НСтр("ru='Нажмите здесь для просмотра всех новостей.'");
		ОбработкаНовостейКлиентПереопределяемый.ПереопределитьНадписиСообщенияПриОтсутствииКонтекстныхНовостей(
			ЭтаФорма,
			ТекстСообщения,
			ПояснениеСообщения,
			Отказ);
		Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
			ПоказатьОповещениеПользователя(
				ТекстСообщения, // Текст,
				ОбработкаНовостейКлиентСервер.ПолучитьНавигационнуюСсылкуСпискаНовостей(), // НавигационнаяСсылка
				ПояснениеСообщения, // Пояснение,
				БиблиотекаКартинок.Новости // Картинка
			);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Новость прочтена" Тогда
		// Если новостей > 20, то это может привести к неявному вызову сервера
		НайденныеСтроки = ЭтаФорма.ТаблицаНовостей.НайтиСтроки(Новый Структура("Новость", Источник)); // Источник = Новость
		Для каждого ТекущаяСтрока Из НайденныеСтроки Цикл
			ТекущаяСтрока.Прочтена = Параметр; // Параметр = Прочтена
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТаблицаНовостей

&НаКлиенте
Процедура ТаблицаНовостейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ВыбраннаяСтрока <> Неопределено Тогда
		НайденнаяНовость = ЭтаФорма.ТаблицаНовостей.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если НайденнаяНовость <> Неопределено Тогда
		ФормаНовости = ОбработкаНовостейКлиент.ПоказатьНовость(
			НайденнаяНовость.Новость,
			Новый Структура("РежимОткрытияОкна",
				"БлокироватьОкноВладельца"), // Параметры
			ЭтаФорма,
			Истина); // Без уникальности
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОткрытьНовость(Команда)

	Если Элементы.ТаблицаНовостей.ТекущиеДанные <> Неопределено Тогда
		ФормаНовости = ОбработкаНовостейКлиент.ПоказатьНовость(
			Элементы.ТаблицаНовостей.ТекущиеДанные.Новость,
			Новый Структура("РежимОткрытияОкна",
				"БлокироватьОкноВладельца"), // Параметры
			ЭтаФорма,
			Истина); // Без уникальности
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Непрочтенные новости (ДатаПубликации, Наименование и Подзаголовок) - жирным.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейНаименование.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейПодзаголовок.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейДатаПубликации.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейЛентаНовостей.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНовостей.Прочтена");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ШрифтНовостей, , , Истина)); // Жирный

		// Использование
		Элемент.Использование = Истина;

	// Другие произвольные настройки условного оформления, настраиваемые для конкретной конфигурации.
	ОбработкаНовостейПереопределяемый.ДополнительноУстановитьУсловноеОформлениеФормыКонтекстныхНовостей(ЭтаФорма, УсловноеОформление);

КонецПроцедуры

#КонецОбласти
