﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.СписокКнопкаВыбрать.Видимость = Истина;
		Элементы.СписокКнопкаВыбрать.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.СписокКнопкаВыбрать.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ПерепискаСКонтролирующимиОрганами", , Элемент.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
		Если Параметры.Свойство("ТекущаяСтрока") Тогда
			Элементы.Список.ТекущаяСтрока = Параметры.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
