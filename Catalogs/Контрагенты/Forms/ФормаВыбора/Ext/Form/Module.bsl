﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПредставлениеОбособленногоПодразделения", НСтр("ru='Обособленное подразделение'"));
		
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокКонтрагентов(Список);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ОткрытИзПлатежки = Параметры.Свойство("ОткрытИзПлатежки");
	
	УстановитьУсловноеОформление();
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Справочник.Контрагенты",
		"ФормаВыбора",
		НСтр("ru='Новости: Контрагент'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если ОткрытИзПлатежки И Элемент.ТекущиеДанные.Вид <> "" Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
		ПараметрыФормы.Вставить("ОткрытИзПлатежки"); 
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ОткрытИзПлатежки И НЕ Группа Тогда
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура("ОткрытИзПлатежки");
		
		ЗначенияЗаполнения = Новый Структура("Родитель", Родитель);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		Если Копирование И ЗначениеЗаполнено(Элемент.ТекущаяСтрока) Тогда
			ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// ИНН некорректный

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИНН");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ИННВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);


	// ИНН дублируется

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИНН");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ИННВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ЕстьДубли", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);


	// КПП некорректный

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КПП");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КППВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);


	// КПП дублируется

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КПП");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КППВведенКорректно", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ЕстьДубли", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой);


	// Контрагента нет в реестре

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ИНН");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "КПП");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.Состояние", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветКонтрагентаОтсутствущегоВРеестре);


	// Контрагент прекратил деятельность

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Список");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.КонтрагентНеСуществует", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.Состояние", ВидСравненияКомпоновкиДанных.Равно, Перечисления.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветКонтрагентаПрекратившегоДеятельность);

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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры

#КонецОбласти