﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	ОткрытИзПлатежки = Параметры.Свойство("ОткрытИзПлатежки");
	
	ДоступноИспользоватьОсновным = (РольДоступна("ДобавлениеИзменениеДанныхБухгалтерии") ИЛИ РольДоступна("ПолныеПрава"));
	Если ДоступноИспользоватьОсновным Тогда
		Элементы.ФормаИспользоватьОсновным.Видимость = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.ДоговорыКонтрагентов);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	Список.Параметры.УстановитьЗначениеПараметра("ДействуетНа", ОтборДействуетНа);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Справочник.ДоговорыКонтрагентов",
		"ФормаСписка",
		НСтр("ru='Новости: Договоры'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список,, Параметр);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ЗначениеЗаполнено(СтруктураОтбора) Тогда
		
		Если СтруктураОтбора.Свойство("Организация") И ЗначениеЗаполнено(СтруктураОтбора.Организация) Тогда
			ОтборОрганизация = СтруктураОтбора.Организация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			СтруктураОтбора.Удалить("Организация");
		КонецЕсли;
		
	Иначе
		Если ОтборОрганизация <> ОсновнаяОрганизация Тогда
			ОтборОрганизация = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
		ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	Если ОтборДействуетНаИспользование Тогда
		УстановитьОтборПоСрокуДействия(Список, ОтборДействуетНа, ОтборДействуетНаИспользование);
	КонецЕсли;
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДействуетНаИспользованиеПриИзменении(Элемент)
	
	УстановитьОтборПоСрокуДействия(Список, ОтборДействуетНа, ОтборДействуетНаИспользование);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДействуетНаПриИзменении(Элемент)
	
	ОтборДействуетНаИспользование = ЗначениеЗаполнено(ОтборДействуетНа);
	Список.Параметры.УстановитьЗначениеПараметра("ДействуетНа", ОтборДействуетНа);
	
	УстановитьОтборПоСрокуДействия(Список, ОтборДействуетНа, ОтборДействуетНаИспользование);
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ДоговорыКонтрагентов", , ДанныеСтроки.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ОткрытИзПлатежки И НЕ Группа И НЕ Копирование Тогда
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура;

		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Родитель", Родитель);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
			
			Если НЕ ЭлементОтбора.Использование Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
				ЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
			КонецЕсли;
			
			Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
				ЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение[0].Значение);
			КонецЕсли;
			
		КонецЦикла;
		
		ПараметрыФормы.Вставить("ОткрытИзПлатежки");
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УправлениеФормойКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьОсновным(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.ФормаИспользоватьОсновным.Пометка Тогда
		НеИспользоватьКакОсновнойДоговор(ТекущиеДанные.Ссылка);
	Иначе
		ИспользоватьКакОсновнойДоговор(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
	УправлениеФормойКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ИспользоватьКакОсновнойДоговор(Знач Договор)
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьОсновнойДоговорКонтрагента(Договор);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура НеИспользоватьКакОсновнойДоговор(Знач Договор)

	СтруктураПараметров = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Организация, ВидДоговора, Владелец");
	МенеджерЗаписи = РегистрыСведений.ОсновныеДоговорыКонтрагента.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация = СтруктураПараметров.Организация;
	МенеджерЗаписи.ВидДоговора = СтруктураПараметров.ВидДоговора;
	МенеджерЗаписи.Контрагент  = СтруктураПараметров.Владелец;
	МенеджерЗаписи.Договор     = Договор;
	МенеджерЗаписи.Удалить();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСрокуДействия(Список, Знач ОтборДействуетНа, Знач Использование)
	
	Если НЕ Использование Тогда
		// Если отбор ранее не был установлен, то ничего делать не нужно
		ГруппаЭлементовОтбора = ОтборыСписковКлиентСервер.НайтиЭлементОтбораПоПредставлению(Список.Отбор.Элементы, "ОтборДействуетНа");
		Если ГруппаЭлементовОтбора = Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ГруппаОтбораИ = ОтборыСписковКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Список.Отбор.Элементы, "ОтборДействуетНа",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораГруппыСписка(
		ГруппаОтбораИ, "Дата", Новый ПолеКомпоновкиДанных("ДействуетНа"),
		Использование, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
		
	ГруппаОтбораИЛИ = ОтборыСписковКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ГруппаОтбораИ.Элементы, "ОтборПоСрокДействия",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИЛИ);
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораГруппыСписка(
		ГруппаОтбораИЛИ, "ДействуетНа", Новый ПолеКомпоновкиДанных("СрокДействия"),
		Использование, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
		
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораГруппыСписка(
		ГруппаОтбораИЛИ, "СрокДействия", Дата('00010101'),
		Использование, ВидСравненияКомпоновкиДанных.Равно);
		
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормойКлиент()
	
	Если Не ДоступноИспользоватьОсновным Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
		Элементы.ФормаИспользоватьОсновным.Пометка     = Ложь;
		Элементы.ФормаИспользоватьОсновным.Доступность = Ложь;
	Иначе
		Элементы.ФормаИспользоватьОсновным.Пометка     = ТекущиеДанные.Основной;
		Элементы.ФормаИспользоватьОсновным.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти