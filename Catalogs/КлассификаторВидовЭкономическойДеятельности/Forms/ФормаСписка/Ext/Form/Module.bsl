﻿////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Назначение", ПредопределенноеЗначение("Перечисление.ВидыСвободныхСтрокФормСтатистики.ВидыДеятельности")); 
	ПараметрыФормы.Вставить("Подбор", Истина); 
		
	ОткрытьФорму("ОбщаяФорма.ДобавлениеЭлементовВКлассификатор", ПараметрыФормы, ЭтаФорма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Назначение", ПредопределенноеЗначение("Перечисление.ВидыСвободныхСтрокФормСтатистики.ВидыДеятельности")); 
		ПараметрыФормы.Вставить("Подбор", Истина); 
		ОткрытьФорму("ОбщаяФорма.ДобавлениеЭлементовВКлассификатор", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ДополнительныеПараметры);
		ОткрытьФорму("Справочник.КлассификаторВидовЭкономическойДеятельности.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список
//

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура;
	Если Копирование Тогда
		ДополнительныеПараметры.Вставить("Наименование", ТекДанные.Наименование);
		ДополнительныеПараметры.Вставить("Код", ТекДанные.Код);
		ДополнительныеПараметры.Вставить("НаименованиеПолное", ТекДанные.НаименованиеПолное);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru='Есть возможность подобрать услуги из классификатора (ОКУН).
	|Подобрать?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры



