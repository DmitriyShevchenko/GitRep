﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборПоВладельцу = Ложь;
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
			ОтборПоВладельцу = Истина;
			Услуга           = Параметры.Отбор.Владелец.Услуга;
			Владелец         = Параметры.Отбор.Владелец;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОтборПоВладельцу Тогда
		Если Услуга Тогда
			Сообщение = НСтр("ru='Для номенклатуры %Владелец% не применяются назначения использования!'");
			Сообщение = СтрЗаменить(Сообщение, "%Владелец%", Владелец); 
			ПоказатьПредупреждение( , Сообщение);
			Отказ = Истина;
		КонецЕсли;
	Иначе
		Сообщение = НСтр("ru='Не выбрана номенклатура или не записан редактируемый элемент номенклатуры!'");
		ПоказатьПредупреждение( , Сообщение);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
