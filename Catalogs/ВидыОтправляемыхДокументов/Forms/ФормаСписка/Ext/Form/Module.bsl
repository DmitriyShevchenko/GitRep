﻿
&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект.Ссылка;
		
КонецПроцедуры // ОбработкаЗаписиНового()

&НаКлиенте
Процедура СписокОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Элементы.Список.ТекущаяСтрока = НовыйОбъект;
		
КонецПроцедуры // СписокОбработкаЗаписиНового()

&НаКлиенте
Процедура ДействияФормыВосстановитьПредопределенные(Команда)
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ДействияФормыВосстановитьПредопределенныеЗавершение", ЭтотОбъект), 
		"Будут восстановлены исходные реквизиты всех предопределенных элементов справочника." + Символы.ПС + "Продолжить?", РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ДействияФормыВосстановитьПредопределенныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ВосстановитьПредопределенные_НаСервере();
    
    Элементы.Дерево.Обновить();
    Элементы.Список.Обновить();

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВосстановитьПредопределенные_НаСервере()
	
	Справочники.ВидыОтправляемыхДокументов.ЗаполнитьПредопределенныеВидыОтправляемыхДокументов(Истина);
		
КонецПроцедуры