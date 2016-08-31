﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапросПустогоОКОФ = Новый Запрос;
	ЗапросПустогоОКОФ.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОКОФ.Ссылка
		|ИЗ
		|	Справочник.ОбщероссийскийКлассификаторОсновныхФондов КАК ОКОФ";
		
		
	Если ЗапросПустогоОКОФ.Выполнить().Пустой() Тогда
		Элементы.ПеренестиВСправочник.Доступность = Ложь;
		АмортизационныеГруппы.Параметры.УстановитьЗначениеПараметра("ОКОФ", Справочники.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка());
	КонецЕсли;
	
	Элементы.ИерархияОКОФ.ТекущаяСтрока = Параметры.КодПоОКОФ;
	Элементы.ИерархияОКОФ.ТекущийЭлемент = Параметры.АмортизационнаяГруппа;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИерархияОКОФ

&НаКлиенте
Процедура ИерархияОКОФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не Элемент.ТекущиеДанные.ЭтоГруппа Тогда 
		ЗакрытьСВыбраннымРезультатом();
		СтандартнаяОбработка = Ложь; 
	Иначе
		СтандартнаяОбработка = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИерархияОКОФПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ИерархияОКОФ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		АмортизационныеГруппы.Параметры.УстановитьЗначениеПараметра("ОКОФ", ТекущиеДанные.Ссылка);
		
	Иначе
		
		АмортизационныеГруппы.Параметры.УстановитьЗначениеПараметра(
			"ОКОФ",	ПредопределенноеЗначение("Справочник.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАмортизационныеГруппы

&НаКлиенте
Процедура АмортизационныеГруппыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗакрытьСВыбраннымРезультатом();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиОКОФиАмортизационнуюГруппу(Команда)

	ЗакрытьСВыбраннымРезультатом();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьСВыбраннымРезультатом()
	
	ТекущийКодПоОКОФ = Элементы.ИерархияОКОФ.ТекущиеДанные;
	Если ТекущийКодПоОКОФ <> Неопределено Тогда
		ОКОФ = ТекущийКодПоОКОФ.Ссылка;
		ОКОФЭтоГруппа = ТекущийКодПоОКОФ.ЭтоГруппа;
	Иначе
		ОКОФ = ПредопределенноеЗначение("Справочник.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка");
		ОКОФЭтоГруппа = Ложь;
	КонецЕсли;
	
	ТекущаяАмортизационнаяГруппа = Элементы.АмортизационныеГруппы.ТекущиеДанные;
	Если ТекущаяАмортизационнаяГруппа <> Неопределено Тогда
		АмортизационнаяГруппа = ТекущаяАмортизационнаяГруппа.АмортизационнаяГруппа;
	Иначе
		АмортизационнаяГруппа = ПредопределенноеЗначение("Перечисление.АмортизационныеГруппы.ПустаяСсылка");
	КонецЕсли;
	
	ПараметрЗакрытия = Новый Структура("ОКОФ, ОКОФЭтоГруппа, АмортизационнаяГруппа", ОКОФ, ОКОФЭтоГруппа, АмортизационнаяГруппа);
										
	Оповестить("ВыборАмортизационнойГруппыОС", ПараметрЗакрытия, ВладелецФормы.УникальныйИдентификатор);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
