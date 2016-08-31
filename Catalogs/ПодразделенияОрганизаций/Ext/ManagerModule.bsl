﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ

Процедура ЗаполнитьКонстантуВестиУчетЗатратПоПодразделениям() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ВестиУчетЗатратПоПодразделениям.Установить(Истина);
	
КонецПроцедуры

Процедура ИсправитьУчетЗатратПоПодразделениям() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если БухгалтерскийУчетПереопределяемый.ВестиУчетПоПодразделениям() Тогда
		
		// Если учет по подразделениям ведется (в версии КОРП), то и учет затрат по подразделениям должен вестись
		
		Если Не Константы.ВестиУчетЗатратПоПодразделениям.Получить() Тогда
			Константы.ВестиУчетЗатратПоПодразделениям.Установить(Истина);
		КонецЕсли;
		
	ИначеЕсли Не Константы.ВестиУчетЗатратПоПодразделениям.Получить() Тогда
		
		// Возможно, что настройками плана счетов включен учет по подразделениям на счетах затрат 
		// и пользователь уже ввел данные по подразделениям.
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СчетаЗатрат", БухгалтерскийУчетПереопределяемый.СчетаУчетаЗатратПоПодразделениям());
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Хозрасчетный.ПодразделениеДт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	НЕ Хозрасчетный.ПодразделениеДт В (ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка), НЕОПРЕДЕЛЕНО)
		|	И Хозрасчетный.СчетДт В(&СчетаЗатрат)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Хозрасчетный.ПодразделениеКт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	НЕ Хозрасчетный.ПодразделениеКт В (ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка), НЕОПРЕДЕЛЕНО)
		|	И Хозрасчетный.СчетКт В(&СчетаЗатрат)";
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ВестиУчетЗатратПоПодразделениям.Установить(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	// Приведем свойства плана счетов в соответствие глобальной настройке
	ПланыСчетов.Хозрасчетный.УстановитьУчетЗатратПоПодразделениям( // При ошибке транзакция отменяется и выдается исключение
		Константы.ВестиУчетЗатратПоПодразделениям.Получить(),
		ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации()); 
		
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#Область СведенияОбОрганизации

Процедура СведенияОПодразделенияхНаДаты(ПодразделенияНаДаты, МенеджерВременныхТаблиц) Экспорт
	
	// Таблица ПодразделенияНаДаты содержит 2 колонки - "Подразделение" и "ДатаСведений".
	// Колонки должны быть типизированными: Подразделение = СправочникСсылка.ПодразделенияОрганизаций, ДатаСведений = Дата
	// В менеджере временных таблиц создается временная таблица СведенияОПодразделенияхНаДаты,
	// проиндексированная по колонкам "Подразделение" и "ДатаСведений".
	// Временная таблица содержит на каждую строку входящей таблицы одну строку с данными
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Параметры.Вставить("ПодразделенияНаДаты", ПодразделенияНаДаты);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодразделенияНаДаты.Подразделение КАК Подразделение,
	|	ПодразделенияНаДаты.ДатаСведений КАК ДатаСведений
	|ПОМЕСТИТЬ ПодразделенияНаДаты
	|ИЗ
	|	&ПодразделенияНаДаты КАК ПодразделенияНаДаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодразделенияНаДаты.Подразделение КАК Подразделение,
	|	ПодразделенияНаДаты.ДатаСведений,
	|	МАКСИМУМ(ИсторияРегистрацийВНалоговомОргане.Период) КАК Период
	|ПОМЕСТИТЬ ДатыСведенийОПодразделениях
	|ИЗ
	|	ПодразделенияНаДаты КАК ПодразделенияНаДаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
	|		ПО ПодразделенияНаДаты.Подразделение = ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница
	|			И ПодразделенияНаДаты.ДатаСведений >= ИсторияРегистрацийВНалоговомОргане.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодразделенияНаДаты.Подразделение,
	|	ПодразделенияНаДаты.ДатаСведений
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыСведенийОПодразделениях.Подразделение,
	|	ДатыСведенийОПодразделениях.ДатаСведений,
	|	Подразделения.НаименованиеПолное,
	|	ЕСТЬNULL(ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане.КПП, """") КАК КПП
	|ПОМЕСТИТЬ СведенияОПодразделенияхНаДаты
	|ИЗ
	|	ДатыСведенийОПодразделениях КАК ДатыСведенийОПодразделениях
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК Подразделения
	|		ПО ДатыСведенийОПодразделениях.Подразделение = Подразделения.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
	|		ПО ДатыСведенийОПодразделениях.Подразделение = ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница
	|			И ДатыСведенийОПодразделениях.Период = ИсторияРегистрацийВНалоговомОргане.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ОрганизацииНаДаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДатыСведенийОбОрганизациях";
	
	Результат = Запрос.Выполнить();
	
КонецПроцедуры

Функция КППНаДату(Подразделение, ДатаСведений) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Подразделение)
		ИЛИ ТипЗнч(Подразделение) <> Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаСведений) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Подразделение, "КПП");
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Подразделение", Подразделение);
	Запрос.Параметры.Вставить("ДатаСведений", ДатаСведений);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ИсторияРегистраций.Период) КАК Период,
	|	ИсторияРегистраций.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ДатаРегистрации
	|ИЗ
	|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистраций
	|ГДЕ
	|	ИсторияРегистраций.СтруктурнаяЕдиница = &Подразделение
	|	И ИсторияРегистраций.Период <= &ДатаСведений
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияРегистраций.СтруктурнаяЕдиница
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СтруктурнаяЕдиница,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсторияРегистраций.РегистрацияВНалоговомОргане.КПП КАК КПП
	|ИЗ
	|	ДатаРегистрации КАК ДатаРегистрации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистраций
	|		ПО ДатаРегистрации.СтруктурнаяЕдиница = ИсторияРегистраций.СтруктурнаяЕдиница
	|			И ДатаРегистрации.Период = ИсторияРегистраций.Период";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КПП;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ОбновитьОбособленныеПодразделения() Экспорт
	
	// Если у организации есть обособленные подразделения, не выделенные на отдельный баланс,
	// то у нее должен быть установлен признак ЕстьОбособленныеПодразделения.
	// Если признак не установлен - устанавливаем его принудительно.
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПодразделенияОрганизаций.Владелец КАК Организация
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	ПодразделенияОрганизаций.ОбособленноеПодразделение
	|	И НЕ ПодразделенияОрганизаций.Владелец.ЕстьОбособленныеПодразделения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОрганизацияОбъект = Выборка.Организация.ПолучитьОбъект();
		ОрганизацияОбъект.ЕстьОбособленныеПодразделения = Истина;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОрганизацияОбъект);
		
	КонецЦикла;
	
	ЗарплатаКадры.УстановитьРеквизитыВПодчиненныхПодразделениях(Неопределено);
	
КонецПроцедуры

#КонецОбласти


// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

// Возвращает головную структурную единицу и массив подчиненных подразделений, для которых требуется тиражирование значения из головной структурной единицы
//
// Параметры:
//		СтруктурнаяЕдиница - Организация или подразделение для которых требуется получить подчиненные подразделения до первого обособленного
//
// Возвращаемое значение:
//		Структура
//			ГоловнаяСтруктурнаяЕдиница - Организация или подразделение - Вышестоящая структурная единица, из которой будет тиражироваться значение
//			ПодчиненныеСтруктурныеЕдиницы - Массив - Подчиненные подразделения, для которых будет установлено значение из вышестоящей структурной единицы
//
Функция ПодчиненныеСтруктурныеЕдиницы(СтруктурнаяЕдиница) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодразделенияОрганизаций.Ссылка,
	|	ВЫБОР
	|		КОГДА ПодразделенияОрганизаций.Родитель = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	|			ТОГДА ПодразделенияОрганизаций.Владелец
	|		ИНАЧЕ ПодразделенияОрганизаций.Родитель
	|	КОНЕЦ КАК Родитель
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	(&СтруктурнаяЕдиница = НЕОПРЕДЕЛЕНО
	|			ИЛИ ПодразделенияОрганизаций.Ссылка В ИЕРАРХИИ (&СтруктурнаяЕдиница))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Организации.Ссылка,
	|	ВЫБОР
	|		КОГДА Организации.ГоловнаяОрганизация = Организации.Ссылка
	|			ТОГДА Организации.Ссылка
	|		ИНАЧЕ Организации.ГоловнаяОрганизация
	|	КОНЕЦ
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	(&СтруктурнаяЕдиница = НЕОПРЕДЕЛЕНО
	|			ИЛИ Организации.Ссылка = &СтруктурнаяЕдиница)";
	
	Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Организации.Ссылка = &СтруктурнаяЕдиница", "(ИСТИНА)");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПодразделенияОрганизаций.Ссылка В ИЕРАРХИИ (&СтруктурнаяЕдиница)", "ПодразделенияОрганизаций.Владелец = &СтруктурнаяЕдиница");
	КонецЕсли;
	
	ТаблицаПодчиненности = Новый ТаблицаЗначений;
	ТаблицаПодчиненности.Колонки.Добавить("Элемент", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации"));
	ТаблицаПодчиненности.Колонки.Добавить("Родитель", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации"));
	ТаблицаПодчиненности.Колонки.Добавить("Уровень", Новый ОписаниеТипов("Число"));
	
	СоответствиеПодчиненности = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеПодчиненности.Вставить(Выборка.Ссылка, Выборка.Родитель);
	КонецЦикла;
	Если СтруктурнаяЕдиница <> Неопределено Тогда
		ДополнитьРодителямиСтруктурнойЕдиницы(СоответствиеПодчиненности, СтруктурнаяЕдиница);
	КонецЕсли;
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		Родитель = СоответствиеПодчиненности[Выборка.Ссылка];
		Уровень = 1;
		Пока Истина Цикл
			НоваяСтрока = ТаблицаПодчиненности.Добавить();
			НоваяСтрока.Элемент = Выборка.Ссылка;
			НоваяСтрока.Родитель = Родитель;
			НоваяСтрока.Уровень = Уровень;
			Если Выборка.Ссылка = Родитель Тогда
				НоваяСтрока.Уровень = 0;
				Прервать;
			КонецЕсли;
			ПредыдущийРодитель = Родитель;
			Родитель = СоответствиеПодчиненности[Родитель];
			Если Родитель = Неопределено И ПредыдущийРодитель <> Неопределено Тогда
				Если ТипЗнч(ПредыдущийРодитель) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредыдущийРодитель, "Владелец");
				Иначе
					Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредыдущийРодитель, "ГоловнаяОрганизация");
				КонецЕсли;
			КонецЕсли;
			Уровень = Уровень + 1;
			Если ПредыдущийРодитель = Родитель Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаПодчиненности", ТаблицаПодчиненности);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПодчиненности.Элемент КАК ПодчиненнаяСтруктурнаяЕдиница,
	|	ТаблицаПодчиненности.Родитель КАК СтруктурнаяЕдиница,
	|	ТаблицаПодчиненности.Уровень
	|ПОМЕСТИТЬ ВТСтруктурныеЕдиницы
	|ИЗ
	|	&ТаблицаПодчиненности КАК ТаблицаПодчиненности
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодчиненнаяСтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница,
	|	СтруктурныеЕдиницы.Уровень КАК Уровень
	|ПОМЕСТИТЬ ВТПодчиненныеПодразделенияИОрганизации
	|ИЗ
	|	ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ВладельцыПодразделений
	|			ПО ПодразделенияОрганизаций.Владелец = ВладельцыПодразделений.Ссылка
	|		ПО (ПодразделенияОрганизаций.ОбособленноеПодразделение)
	|			И (ВладельцыПодразделений.ЕстьОбособленныеПодразделения)
	|			И СтруктурныеЕдиницы.СтруктурнаяЕдиница = ПодразделенияОрганизаций.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница,
	|	СтруктурныеЕдиницы.Уровень
	|ИЗ
	|	ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО СтруктурныеЕдиницы.СтруктурнаяЕдиница = Организации.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница,
	|	ЕСТЬNULL(ВЫБОР
	|			КОГДА ВладельцыПодразделений.ЕстьОбособленныеПодразделения
	|				ТОГДА Подразделения.ОбособленноеПодразделение
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ, Организации.ОбособленноеПодразделение) КАК ОбособленноеПодразделение,
	|	МИНИМУМ(ПодчиненныеПодразделенияИОрганизации.Уровень) КАК Уровень,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ВЫБОР
	|						КОГДА ВладельцыПодразделений.ЕстьОбособленныеПодразделения
	|							ТОГДА Подразделения.ОбособленноеПодразделение
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ, Организации.ОбособленноеПодразделение)
	|				ИЛИ ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница ССЫЛКА Справочник.Организации
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПодразделениеОбособленноеИлиОрганизация
	|ПОМЕСТИТЬ ВТПодчиненныеСтруктурныеЕдиницы
	|ИЗ
	|	ВТПодчиненныеПодразделенияИОрганизации КАК ПодчиненныеПодразделенияИОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК Подразделения
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ВладельцыПодразделений
	|			ПО Подразделения.Владелец = ВладельцыПодразделений.Ссылка
	|		ПО ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница = Подразделения.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница = Организации.Ссылка
	|ГДЕ
	|	(Подразделения.Ссылка ЕСТЬ НЕ NULL 
	|			ИЛИ Организации.Ссылка ЕСТЬ НЕ NULL )
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница,
	|	ЕСТЬNULL(Подразделения.ОбособленноеПодразделение, Организации.ОбособленноеПодразделение),
	|	Подразделения.ОбособленноеПодразделение,
	|	Организации.ОбособленноеПодразделение,
	|	ВладельцыПодразделений.ЕстьОбособленныеПодразделения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТГоловнаяСтруктурнаяЕдиница
	|ИЗ
	|	ВТПодчиненныеСтруктурныеЕдиницы КАК ПодчиненныеСтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ПО (&СтруктурнаяЕдиница = НЕОПРЕДЕЛЕНО
	|				ИЛИ ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = &СтруктурнаяЕдиница)
	|			И (ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|					И ПодчиненныеСтруктурныеЕдиницы.ПодразделениеОбособленноеИлиОрганизация
	|				ИЛИ НЕ ПодчиненныеСтруктурныеЕдиницы.ОбособленноеПодразделение
	|					И ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница
	|					И ПодчиненныеСтруктурныеЕдиницы.Уровень = СтруктурныеЕдиницы.Уровень)
	|
	|СГРУППИРОВАТЬ ПО
	|	СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница
	|ИЗ
	|	ВТПодчиненныеСтруктурныеЕдиницы КАК ПодчиненныеСтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТГоловнаяСтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница
	|			ПО СтруктурныеЕдиницы.СтруктурнаяЕдиница = ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница
	|		ПО ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница
	|			И ПодчиненныеСтруктурныеЕдиницы.Уровень = СтруктурныеЕдиницы.Уровень
	|			И (НЕ ПодчиненныеСтруктурныеЕдиницы.ОбособленноеПодразделение)
	|			И (СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница ССЫЛКА Справочник.ПодразделенияОрганизаций)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГоловнаяСтруктурнаяЕдиница,
	|	СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница
	|ИЗ
	|	ВТГоловнаяСтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница";
	
	ПодчиненныеСтруктурныеЕдиницы = Новый Соответствие;
	
	РезультатЗапросов = Запрос.ВыполнитьПакет();
	Подчиненные = РезультатЗапросов[РезультатЗапросов.Количество() - 2].Выгрузить();
	Выборка = РезультатЗапросов[РезультатЗапросов.Количество() - 1].Выбрать();
	Пока Выборка.Следующий() Цикл
		ОтборПоГоловнойСтруктурнойЕдинице = Новый Структура("ГоловнаяСтруктурнаяЕдиница", Выборка.ГоловнаяСтруктурнаяЕдиница);
		НайденныеСтроки = Подчиненные.НайтиСтроки(ОтборПоГоловнойСтруктурнойЕдинице);
		МассивПодчиненныхСтруктурныхЕдиниц = Подчиненные.Скопировать(НайденныеСтроки).ВыгрузитьКолонку("СтруктурнаяЕдиница");
		ПодчиненныеСтруктурныеЕдиницы.Вставить(Выборка.ГоловнаяСтруктурнаяЕдиница, МассивПодчиненныхСтруктурныхЕдиниц);
	КонецЦикла;;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПодчиненныеСтруктурныеЕдиницы;
	
КонецФункции

// Возвращает головную структурную единицу и массив подчиненных подразделений, для которых требуется тиражирование значения из головной структурной единицы
//
// Параметры:
//		СтруктурнаяЕдиница - Организация или подразделение для которых требуется получить подчиненные подразделения до первого обособленного
//
// Возвращаемое значение:
//		Структура
//			ГоловнаяСтруктурнаяЕдиница - Организация или подразделение - Вышестоящая структурная единица, из которой будет тиражироваться значение
//			ПодчиненныеСтруктурныеЕдиницы - Массив - Подчиненные подразделения, для которых будет установлено значение из вышестоящей структурной единицы
//
Функция ПодчиненныеПодразделения(СтруктурнаяЕдиница) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодразделенияОрганизаций.Ссылка,
	|	ВЫБОР
	|		КОГДА ПодразделенияОрганизаций.Родитель = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	|			ТОГДА ПодразделенияОрганизаций.Владелец
	|		ИНАЧЕ ПодразделенияОрганизаций.Родитель
	|	КОНЕЦ КАК Родитель
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Организации.Ссылка,
	|	ВЫБОР
	|		КОГДА Организации.ГоловнаяОрганизация = Организации.Ссылка
	|			ТОГДА Организации.Ссылка
	|		ИНАЧЕ Организации.ГоловнаяОрганизация
	|	КОНЕЦ
	|ИЗ
	|	Справочник.Организации КАК Организации";
	
	ТаблицаПодчиненности = Новый ТаблицаЗначений;
	ТаблицаПодчиненности.Колонки.Добавить("Элемент", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации"));
	ТаблицаПодчиненности.Колонки.Добавить("Родитель", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций, СправочникСсылка.Организации"));
	ТаблицаПодчиненности.Колонки.Добавить("Уровень", Новый ОписаниеТипов("Число"));
	
	СоответствиеПодчиненности = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоответствиеПодчиненности.Вставить(Выборка.Ссылка, Выборка.Родитель);
	КонецЦикла;
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		Родитель = СоответствиеПодчиненности[Выборка.Ссылка];
		Уровень = 1;
		Пока Истина Цикл
			НоваяСтрока = ТаблицаПодчиненности.Добавить();
			НоваяСтрока.Элемент = Выборка.Ссылка;
			НоваяСтрока.Родитель = Родитель;
			НоваяСтрока.Уровень = Уровень;
			Если Выборка.Ссылка = Родитель Тогда
				НоваяСтрока.Уровень = 0;
				Прервать;
			КонецЕсли;
			ПредыдущийРодитель = Родитель;
			Родитель = СоответствиеПодчиненности[Родитель];
			Уровень = Уровень + 1;
			Если ПредыдущийРодитель = Родитель Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаПодчиненности", ТаблицаПодчиненности);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПодчиненности.Элемент КАК ПодчиненнаяСтруктурнаяЕдиница,
	|	ТаблицаПодчиненности.Родитель КАК СтруктурнаяЕдиница,
	|	ТаблицаПодчиненности.Уровень
	|ПОМЕСТИТЬ ВТСтруктурныеЕдиницы
	|ИЗ
	|	&ТаблицаПодчиненности КАК ТаблицаПодчиненности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница,
	|	СтруктурныеЕдиницы.Уровень КАК Уровень
	|ПОМЕСТИТЬ ВТПодчиненныеПодразделенияИОрганизации
	|ИЗ
	|	ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|		ПО (ПодразделенияОрганизаций.ОбособленноеПодразделение)
	|			И СтруктурныеЕдиницы.СтруктурнаяЕдиница = ПодразделенияОрганизаций.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница,
	|	СтруктурныеЕдиницы.Уровень
	|ИЗ
	|	ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО СтруктурныеЕдиницы.СтруктурнаяЕдиница = Организации.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница,
	|	ЕСТЬNULL(Подразделения.ОбособленноеПодразделение, Организации.ОбособленноеПодразделение) КАК ОбособленноеПодразделение,
	|	МИНИМУМ(ПодчиненныеПодразделенияИОрганизации.Уровень) КАК Уровень
	|ПОМЕСТИТЬ ВТПодчиненныеСтруктурныеЕдиницы
	|ИЗ
	|	ВТПодчиненныеПодразделенияИОрганизации КАК ПодчиненныеПодразделенияИОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК Подразделения
	|		ПО ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница = Подразделения.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница = Организации.Ссылка
	|ГДЕ
	|	(Подразделения.Ссылка ЕСТЬ НЕ NULL 
	|			ИЛИ Организации.Ссылка ЕСТЬ НЕ NULL )
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодчиненныеПодразделенияИОрганизации.ПодчиненнаяСтруктурнаяЕдиница,
	|	ЕСТЬNULL(Подразделения.ОбособленноеПодразделение, Организации.ОбособленноеПодразделение)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТГоловнаяСтруктурнаяЕдиница
	|ИЗ
	|	ВТПодчиненныеСтруктурныеЕдиницы КАК ПодчиненныеСтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ПО (ВЫБОР
	|				КОГДА ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|						И ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|						И (ПодчиненныеСтруктурныеЕдиницы.ОбособленноеПодразделение
	|							ИЛИ ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница ССЫЛКА Справочник.Организации)
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|						И НЕ ПодчиненныеСтруктурныеЕдиницы.ОбособленноеПодразделение
	|						И ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница
	|						И ПодчиненныеСтруктурныеЕдиницы.Уровень = СтруктурныеЕдиницы.Уровень
	|			КОНЕЦ)
	|
	|СГРУППИРОВАТЬ ПО
	|	СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница КАК СтруктурнаяЕдиница
	|ИЗ
	|	ВТПодчиненныеСтруктурныеЕдиницы КАК ПодчиненныеСтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТГоловнаяСтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница
	|			ПО СтруктурныеЕдиницы.СтруктурнаяЕдиница = ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница
	|		ПО ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница
	|			И ПодчиненныеСтруктурныеЕдиницы.Уровень = СтруктурныеЕдиницы.Уровень
	|			И (НЕ ПодчиненныеСтруктурныеЕдиницы.ОбособленноеПодразделение)
	|			И (СтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница ССЫЛКА Справочник.ПодразделенияОрганизаций)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтруктурныеЕдиницы КАК СтруктурныеЕдиницы2
	|		ПО ПодчиненныеСтруктурныеЕдиницы.ПодчиненнаяСтруктурнаяЕдиница = СтруктурныеЕдиницы2.ПодчиненнаяСтруктурнаяЕдиница
	|			И (СтруктурныеЕдиницы2.СтруктурнаяЕдиница = &СтруктурнаяЕдиница)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГоловнаяСтруктурнаяЕдиница.СтруктурнаяЕдиница
	|ИЗ
	|	ВТГоловнаяСтруктурнаяЕдиница КАК ГоловнаяСтруктурнаяЕдиница";
	
	ПодчиненныеСтруктурныеЕдиницы = Новый Структура();
	ПодчиненныеСтруктурныеЕдиницы.Вставить("ГоловнаяСтруктурнаяЕдиница", Неопределено);
	ПодчиненныеСтруктурныеЕдиницы.Вставить("ПодчиненныеСтруктурныеЕдиницы", Неопределено);
	
	РезультатЗапросов = Запрос.ВыполнитьПакет();
	Выборка = РезультатЗапросов[РезультатЗапросов.Количество() - 1].Выбрать();
	Если Выборка.Следующий() Тогда
		Подчиненные = РезультатЗапросов[РезультатЗапросов.Количество() - 2].Выгрузить();
		ПодчиненныеСтруктурныеЕдиницы.Вставить("ГоловнаяСтруктурнаяЕдиница", Выборка.СтруктурнаяЕдиница);
		ПодчиненныеСтруктурныеЕдиницы.Вставить("ПодчиненныеСтруктурныеЕдиницы", Подчиненные.ВыгрузитьКолонку("СтруктурнаяЕдиница"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПодчиненныеСтруктурныеЕдиницы;
	
КонецФункции

Процедура ДополнитьРодителямиСтруктурнойЕдиницы(СоответствиеПодчиненности, СтруктурнаяЕдиница)
	
	Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Организации") Тогда
		ИмяРеквизитаРодитель = "ГоловнаяОрганизация";
	ИначеЕсли ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		ИмяРеквизитаРодитель = "Родитель";
	Иначе
		ИмяРеквизитаРодитель = "Ссылка";
	КонецЕсли;
	РодительСтруктурнойЕдиницы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница, ИмяРеквизитаРодитель);
	Если РодительСтруктурнойЕдиницы = СтруктурнаяЕдиница Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РодительСтруктурнойЕдиницы) Тогда
		СоответствиеПодчиненности.Вставить(СтруктурнаяЕдиница, РодительСтруктурнойЕдиницы);
		ДополнитьРодителямиСтруктурнойЕдиницы(СоответствиеПодчиненности, РодительСтруктурнойЕдиницы);
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстЗапросаСравненияНаборовСтруктурныхЕдиниц(ИмяРегистра, ИмяРеквизита) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НаборРегистраСведений.Период,
	|	НаборРегистраСведений.СтруктурнаяЕдиница,
	|	НаборРегистраСведений.ИмяРеквизита
	|ПОМЕСТИТЬ ВТНаборПроверки
	|ИЗ
	|	#ТаблицаРегистра КАК НаборРегистраСведений
	|ГДЕ
	|	НаборРегистраСведений.СтруктурнаяЕдиница В(&ПодчиненныеСтруктурныеЕдиницы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НаборРегистраСведений.Период,
	|	НаборРегистраСведений.СтруктурнаяЕдиница,
	|	НаборРегистраСведений.ИмяРеквизита
	|ПОМЕСТИТЬ ВТОсновнойНабор
	|ИЗ
	|	#ТаблицаРегистра КАК НаборРегистраСведений
	|ГДЕ
	|	НаборРегистраСведений.СтруктурнаяЕдиница = &ГоловнаяСтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НаборПроверки.Период,
	|	НаборПроверки.СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТНаборИзменений
	|ИЗ
	|	ВТОсновнойНабор КАК ОсновнойНабор
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТНаборПроверки КАК НаборПроверки
	|		ПО ОсновнойНабор.Период = НаборПроверки.Период
	|			И ОсновнойНабор.ИмяРеквизита = НаборПроверки.ИмяРеквизита
	|ГДЕ
	|	ОсновнойНабор.СтруктурнаяЕдиница ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НаборПроверки.Период,
	|	НаборПроверки.СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТНаборСовпадений
	|ИЗ
	|	ВТОсновнойНабор КАК ОсновнойНабор
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТНаборПроверки КАК НаборПроверки
	|		ПО ОсновнойНабор.Период = НаборПроверки.Период
	|			И ОсновнойНабор.ИмяРеквизита = НаборПроверки.ИмяРеквизита
	|ГДЕ
	|	ОсновнойНабор.СтруктурнаяЕдиница ЕСТЬ НЕ NULL 
	|	И НаборПроверки.СтруктурнаяЕдиница ЕСТЬ НЕ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновнойНабор.Период,
	|	Организации.Ссылка КАК СтруктурнаяЕдиница
	|ПОМЕСТИТЬ ВТВсеСтруктурныеЕдиницы
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОсновнойНабор КАК ОсновнойНабор
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Организации.Ссылка В(&ПодчиненныеСтруктурныеЕдиницы)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОсновнойНабор.Период,
	|	ПодразделенияОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОсновнойНабор КАК ОсновнойНабор
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ПодразделенияОрганизаций.Ссылка В(&ПодчиненныеСтруктурныеЕдиницы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВсеСтруктурныеЕдиницы.СтруктурнаяЕдиница
	|ИЗ
	|	ВТВсеСтруктурныеЕдиницы КАК ВсеСтруктурныеЕдиницы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНаборСовпадений КАК НаборСовпадений
	|		ПО ВсеСтруктурныеЕдиницы.СтруктурнаяЕдиница = НаборСовпадений.СтруктурнаяЕдиница
	|			И ВсеСтруктурныеЕдиницы.Период = НаборСовпадений.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНаборИзменений КАК НаборИзменений
	|		ПО ВсеСтруктурныеЕдиницы.СтруктурнаяЕдиница = НаборИзменений.СтруктурнаяЕдиница
	|			И ВсеСтруктурныеЕдиницы.Период = НаборИзменений.Период
	|ГДЕ
	|	(НаборИзменений.СтруктурнаяЕдиница ЕСТЬ НЕ NULL 
	|			ИЛИ НаборСовпадений.СтруктурнаяЕдиница ЕСТЬ NULL 
	|				И НаборИзменений.СтруктурнаяЕдиница ЕСТЬ NULL )
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОсновнойНабор.Период,
	|	ОсновнойНабор.СтруктурнаяЕдиница,
	|	ОсновнойНабор.ИмяРеквизита
	|ИЗ
	|	ВТОсновнойНабор КАК ОсновнойНабор";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ТаблицаРегистра", "РегистрСведений." + ИмяРегистра);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяРеквизита", ИмяРеквизита);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("Владелец") Или Не ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		Если Не Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
			
			Параметры.Отбор.Вставить("Владелец",
				БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
