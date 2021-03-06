﻿&НаКлиенте
Перем КонтекстЭДО;

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса, 
		Элементы.Сертификат, 
		Объект.Сертификат,
		ЭтотОбъект,
		"СертификатПредставление");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения(
		"СертификатНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));

	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Объект.Сертификат, "AddressBook");

КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Объект.Сертификат = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса, 
			Элемент, 
			Объект.Сертификат,
			ЭтотОбъект,
			"СертификатПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОчистка(Элемент, СтандартнаяОбработка)
	
	Сертификат = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса, 
		Элементы.Сертификат, 
		Объект.Сертификат,
		ЭтотОбъект,
		"СертификатПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОткрытие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.Сертификат) Тогда
		КриптографияЭДКОКлиент.ПоказатьСертификат(
			Новый Структура("ЭлектроннаяПодписьВМоделиСервиса, Отпечаток", 
				ЭтоЭлектроннаяПодписьВМоделиСервиса, Объект.Сертификат));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = ЭлектроннаяПодписьВМоделиСервисаВызовСервера.ЭтоЭлектроннаяПодписьВМоделиСервиса();
	
КонецПроцедуры
