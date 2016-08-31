﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СписокОтбора") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка", Параметры.СписокОтбора, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	ИначеЕсли Параметры.Свойство("МесяцНачисления") Или Параметры.Свойство("НалоговыйПериод") Тогда
		ВычетКДоходу = Неопределено;
		Параметры.Отбор.Свойство("ВычетКДоходу", ВычетКДоходу);
		Если ВычетКДоходу <> Истина Тогда
			МесяцНачисления = Неопределено;
			НалоговыйПериод = Неопределено;
			ГруппаВычета = Неопределено;
			Параметры.Свойство("МесяцНачисления", МесяцНачисления);
			Параметры.Свойство("НалоговыйПериод", НалоговыйПериод);
			Параметры.Отбор.Свойство("ГруппаВычета", ГруппаВычета);
			Если МесяцНачисления <> Неопределено И НалоговыйПериод = Неопределено Тогда
				НалоговыйПериод = Год(МесяцНачисления)
			КонецЕсли;
			Если НалоговыйПериод <> Неопределено Тогда
				СписокОтбора = Новый СписокЗначений; 
				ДоступныеВычеты = УчетНДФЛ.ВычетыНалогоплательщика(НалоговыйПериод, ГруппаВычета);
				ЗначенияРеквизитовВычетов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ДоступныеВычеты, "Код");
				Для каждого Вычет Из ДоступныеВычеты Цикл
					СписокОтбора.Добавить(Вычет, СокрЛП(ЗначенияРеквизитовВычетов.Получить(Вычет).Код));
				КонецЦикла;
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
					"Ссылка", СписокОтбора, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Истина);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
