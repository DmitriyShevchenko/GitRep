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
Процедура КомандаСписокВыбрать(Команда)
	
	ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		СтандартнаяОбработка = Ложь;
		ОповеститьОВыборе(ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры
