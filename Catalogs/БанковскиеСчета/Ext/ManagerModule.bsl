﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция БанковскиеСчетаОрганизации(ВладелецСчета, ВалютаСчета) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	БанковскиеСчета.Ссылка,
	|	БанковскиеСчета.Представление КАК Представление,
	|	ВЫБОР
	|		КОГДА СправочникВладелец.Ссылка ЕСТЬ НЕ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Основной
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК СправочникВладелец
	|		ПО БанковскиеСчета.Владелец = СправочникВладелец.Ссылка
	|			И БанковскиеСчета.Ссылка = СправочникВладелец.ОсновнойБанковскийСчет
	|ГДЕ
	|	БанковскиеСчета.Владелец = &ВладелецСчета
	|	И НЕ БанковскиеСчета.ПометкаУдаления
	|	И БанковскиеСчета.ВалютаДенежныхСредств = &Валюта
	|
	|УПОРЯДОЧИТЬ ПО
	|	Основной УБЫВ,
	|	Представление";
	
	Если ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Контрагенты") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.Организации", "Справочник.Контрагенты");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ВладелецСчета", ВладелецСчета);
	Запрос.УстановитьПараметр("Валюта",        ВалютаСчета);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьКоличествоПодчиненныхЭлементовПоВладельцу(Владелец) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	БанковскиеСчета.Ссылка
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Количество();
	
КонецФункции

Функция КоличествоБанковскихСчетовОрганизации(Организация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	Иначе
		Количество = 0;
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

Процедура ПроверитьУстановитьЗначениеОпцииИспользоватьНесколькоБанковскихСчетовОрганизации(Организация, ПометкаУдаления = Ложь) Экспорт
	
	ДолжныИспользоваться = ПометкаУдаления ИЛИ КоличествоБанковскихСчетовОрганизации(Организация) > 1;
	
	УстановитьПривилегированныйРежим(Истина);
	Запись = РегистрыСведений.ИспользоватьНесколькоБанковскихСчетовОрганизации.СоздатьМенеджерЗаписи();
	Запись.Организация  = Организация;
	Запись.Используется = ДолжныИспользоваться;
	Запись.Записать();
	
КонецПроцедуры

Функция ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация) Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоБанковскихСчетовОрганизации",
		Новый Структура("Организация", Организация));
	
КонецФункции

Процедура УстановитьОсновнойБанковскийСчет(Владелец, БанковскийСчет) Экспорт
	
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Организации")
		И НЕ ПравоДоступа("Изменение", Метаданные.Справочники.Организации) Тогда
		Возврат;
	КонецЕсли;
	
	КонтрагентОрганизацияОбъект = Владелец.ПолучитьОбъект();
	
	УстановитьОсновнойБанковскийСчет = Истина;
	
	Попытка
		КонтрагентОрганизацияОбъект.Заблокировать();
	Исключение
		// в случае блокировки - не выполнять изменение объекта
		УстановитьОсновнойБанковскийСчет = Ложь;
		// записать предупреждение в журнал регистрации
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Не удалось заблокировать объект.'", Метаданные.ОсновнойЯзык.КодЯзыка),
			УровеньЖурналаРегистрации.Предупреждение,, КонтрагентОрганизацияОбъект, ОписаниеОшибки());
	КонецПопытки;
	
	Если УстановитьОсновнойБанковскийСчет Тогда
		КонтрагентОрганизацияОбъект.ОсновнойБанковскийСчет = БанковскийСчет;
		КонтрагентОрганизацияОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция ПодразделениеПоУмолчанию(Организация, БанковскийСчет) Экспорт
	
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		ПодразделениеПоУмолчанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет, "ПодразделениеОрганизации");
		Если ЗначениеЗаполнено(ПодразделениеПоУмолчанию) Тогда
			Возврат ПодразделениеПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
	ТипПодразделения = БухгалтерскийУчетКлиентСерверПереопределяемый.ТипПодразделения();
	ПодразделениеПоУмолчанию = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновноеПодразделениеОрганизации");
	Если Не ЗначениеЗаполнено(ПодразделениеПоУмолчанию) 
		Или ТипЗнч(ПодразделениеПоУмолчанию) <> ТипПодразделения Тогда
		Возврат Новый(ТипПодразделения);
	КонецЕсли;
	
	ОрганизацияПодразделения = БухгалтерскийУчетПереопределяемый.ОрганизацияПодразделения(ПодразделениеПоУмолчанию);
	Если ОрганизацияПодразделения <> Организация Тогда
		Возврат Новый(ТипПодразделения);
	КонецЕсли;
	
	Возврат ПодразделениеПоУмолчанию;
	
КонецФункции

Функция БанковскийСчетПоРеквизитам(Владелец, Банк, НомерСчета) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	БанковскиеСчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Банк = &Банк
	|	И БанковскиеСчета.НомерСчета = &НомерСчета
	|	И БанковскиеСчета.Владелец = &Владелец");
	Запрос.УстановитьПараметр("Банк", Банк);
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	ТипСтрока = ОбщегоНазначения.ОписаниеТипаСтрока(БанковскиеПравила.МаксимальнаяДлинаМеждународногоНомераСчета());
	ПриведенныйНомерСчета = ТипСтрока.ПривестиЗначение(НомерСчета);
	Запрос.УстановитьПараметр("НомерСчета", ПриведенныйНомерСчета);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.БанковскиеСчета.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Владелец") Или НЕ ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		Если НЕ Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
			
			Параметры.Отбор.Вставить("Владелец",
				БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновления

Процедура ИсправитьВладельцаСчета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеСРасчетногоСчета.Организация КАК Организация,
	|	СписаниеСРасчетногоСчета.СчетОрганизации КАК Счет
	|ПОМЕСТИТЬ ВТ_ПлатежныеДокументы
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|ГДЕ
	|	НЕ СписаниеСРасчетногоСчета.СчетОрганизации.Владелец ССЫЛКА Справочник.Организации
	|
	|СГРУППИРОВАТЬ ПО
	|	СписаниеСРасчетногоСчета.Организация,
	|	СписаниеСРасчетногоСчета.СчетОрганизации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПлатежноеПоручение.Организация,
	|	ПлатежноеПоручение.СчетОрганизации
	|ИЗ
	|	Документ.ПлатежноеПоручение КАК ПлатежноеПоручение
	|ГДЕ
	|	НЕ ПлатежноеПоручение.СчетОрганизации.Владелец ССЫЛКА Справочник.Организации
	|
	|СГРУППИРОВАТЬ ПО
	|	ПлатежноеПоручение.Организация,
	|	ПлатежноеПоручение.СчетОрганизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПлатежныеДокументы.Организация КАК Организация,
	|	ВТ_ПлатежныеДокументы.Счет КАК Счет
	|ИЗ
	|	ВТ_ПлатежныеДокументы КАК ВТ_ПлатежныеДокументы
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ПлатежныеДокументы.Организация,
	|	ВТ_ПлатежныеДокументы.Счет
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация,
	|	Счет";
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		СчетОбъект = ВыборкаЗапроса.Счет.ПолучитьОбъект();
		СчетОбъект.Владелец = ВыборкаЗапроса.Организация;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СчетОбъект);
	КонецЦикла;
	
КонецПроцедуры

// Выполняет проверки на корректность заполнения номера счета и БИК.
//
// Параметры:
//  БанковскийСчет   - ДанныеФормыСтруктура - банковский счет, который требуется проверить.
//  КодБанка         - Строка - БИК банка, проверяемого счета.
//  ЯвляетсяБанкомРФ - Булево, признак российского банка.
//  Отказ            - Булево - см. описание параметра Отказ в процедуре ОбработкаПроверкиЗаполнения.
//
Процедура ОбработкаПроверкиЗаполнения(БанковскийСчет, КодБанка, ЯвляетсяБанкомРФ,  Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(БанковскийСчет.Банк)
		И ЗначениеЗаполнено(БанковскийСчет.НомерСчета) Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение", НСтр("ru = 'Банк'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "БанковскийСчет.Банк", , Отказ);
		
	ИначеЕсли ЗначениеЗаполнено(БанковскийСчет.Банк)
		И Не ЗначениеЗаполнено(БанковскийСчет.НомерСчета) Тогда
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение", НСтр("ru = 'Номер счета'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "БанковскийСчет.НомерСчета", , Отказ);
		
	КонецЕсли;
	
	Если БанковскиеСчетаФормыКлиентСервер.НомерСчетаКорректен(БанковскийСчет.НомерСчета, КодБанка, ЯвляетсяБанкомРФ, ТекстСообщения) Тогда
		
		Если ЗначениеЗаполнено(БанковскийСчет.НомерСчета)
			И ЗначениеЗаполнено(БанковскийСчет.Банк)
			И Не ЗначениеЗаполнено(БанковскийСчет.ВалютаДенежныхСредств) Тогда
			
			Если ЯвляетсяБанкомРФ Тогда
				ТекстСообщения = Нстр("ru = 'Валюта счета неизвестна. Проверьте номер счета'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "БанковскийСчет.НомерСчета", , Отказ);
			Иначе
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение", НСтр("ru = 'Валюта счета'"));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "БанковскийСчет.ВалютаДенежныхСредств", , Отказ);
			КонецЕсли;
			
		КонецЕсли;
			
	Иначе
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
			НСтр("ru = 'Номер счета'"),,, ТекстСообщения);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "БанковскийСчет.НомерСчета", , Отказ);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

