﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	ЗарплатаКадры.ПредставленияОснованийУвольненияОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ЗарплатаКадры.ПредставленияОснованийУвольненияОбработкаПолученияДанныхВыбора("ОснованияУвольнения", ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение статей ТК - оснований увольнения.
Процедура НачальноеЗаполнение() Экспорт
	
	ЗагрузитьКлассификатор();
	
КонецПроцедуры

Процедура ЗагрузитьКлассификатор() Экспорт
	
	КлассификаторТаблица = ТаблицаКлассификатора();
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		ЭлементСправочникаПоОписанию(СтрокаКлассификатора);
	КонецЦикла;
	
КонецПроцедуры

Функция ЭлементСправочникаПоОписанию(СтрокаКлассификатора)
	
	Если ЗначениеЗаполнено(СтрокаКлассификатора.ID) Тогда 
		
		СправочникСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ОснованияУвольнения." + СтрокаКлассификатора.ID);
		Если СправочникСсылка = Неопределено Тогда
			СправочникОбъект = Справочники.ОснованияУвольнения.СоздатьЭлемент();
			СправочникОбъект.ИмяПредопределенныхДанных = СтрокаКлассификатора.ID;
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;
		СправочникОбъект.Наименование = СтрокаКлассификатора.Title;
		СправочникОбъект.ТекстОснования = СтрокаКлассификатора.Reason;
		СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		СправочникОбъект.Записать();
		СправочникСсылка = СправочникОбъект.Ссылка;
		
	Иначе
		
		// Поиск существующего элемента
		СправочникСсылка = Справочники.ОснованияУвольнения.НайтиПоНаименованию(СтрокаКлассификатора.Title);
		Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
			
			// Если элемент не был найден, производится поиск по альтернативным наименованиям
			Если Не ПустаяСтрока(СтрокаКлассификатора.TitleAlternative) Тогда
				СправочникСсылка = Справочники.ОснованияУвольнения.НайтиПоНаименованию(СтрокаКлассификатора.TitleAlternative);
			КонецЕсли;
			
			// Если элемент не был найден, производится поиск по наименованиям, содержащим неточности.
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				
				НаименованиеСОшибкой = НаименованияСтатейСОшибкой().Получить(СтрокаКлассификатора.Title);
				Если НаименованиеСОшибкой <> Неопределено Тогда
					СправочникСсылка = Справочники.ОснованияУвольнения.НайтиПоНаименованию(НаименованиеСОшибкой);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
			СправочникОбъект = Справочники.ОснованияУвольнения.СоздатьЭлемент();
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;
		
		СправочникОбъект.Наименование = СтрокаКлассификатора.Title;
		СправочникОбъект.ТекстОснования = СтрокаКлассификатора.Reason;
		СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		СправочникОбъект.Записать();
		СправочникСсылка = СправочникОбъект.Ссылка;
		
	КонецЕсли;
	
	Возврат СправочникСсылка;
		
КонецФункции

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
// Используется для сопоставления элементов механизмом «Выгрузка/загрузка областей данных».
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Наименование");
	
	Возврат Результат;
	
КонецФункции

Процедура ОбновитьСправочникИзКлассификатора() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОснованияУвольнения.Наименование
		|ИЗ
		|	Справочник.ОснованияУвольнения КАК ОснованияУвольнения";
		
	ТаблицаЭлементов = Запрос.Выполнить().Выгрузить();
	
	КлассификаторТаблица = ТаблицаКлассификатора();
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		
		Если ТаблицаЭлементов.Найти(СтрокаКлассификатора.Title, "Наименование") = Неопределено Тогда
			ЭлементСправочникаПоОписанию(СтрокаКлассификатора);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТаблицаКлассификатора()
	
	КлассификаторXML = Справочники.ОснованияУвольнения.ПолучитьМакет("ОснованияУвольненияПоТКРФ").ПолучитьТекст();
	Возврат ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
КонецФункции

Функция НаименованияСтатейСОшибкой()
	
	НаименованияСтатей = Новый Соответствие;
	
	НаименованияСтатей.Вставить("п. 1 ч. 1 ст. 327.6", "п. 1 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 2 ч. 1 ст. 327.6", "п. 2 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 3 ч. 1 ст. 327.6", "п. 3 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 4 ч. 1 ст. 327.6", "п. 4 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 5 ч. 1 ст. 327.6", "п. 5 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 6 ч. 1 ст. 327.6", "п. 6 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 7 ч. 1 ст. 327.6", "п. 7 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 8 ч. 1 ст. 327.6", "п. 8 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 9 ч. 1 ст. 327.6", "п. 9 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 10 ч. 1 ст. 327.6", "п. 10 ч.1 ст. 327.6");
	НаименованияСтатей.Вставить("п. 11 ч. 1 ст. 327.6", "п. 11 ч.1 ст. 327.6");
	
	Возврат НаименованияСтатей;
	
КонецФункции

#КонецОбласти

#КонецЕсли