﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Создает (обновляет) элемент справочника, соответствующий виду объекта ЕГАИС.
//
// Параметры:
//  Имя                     - Строка - имя объекта ЕГАИС,
//  ПространствоИмен        - Строка - пространство имен объекта ЕГАИС,
//  ПрефиксПространстваИмен - Строка - префикс пространства имен объекта ЕГАИС,
//  ПутьНаСервере           - Строка - путь в ТМ ЕГАИС к объекту,
//  Родитель                - Строка - имя родителя объекта ЕГАИС.
//
Процедура ЗаполнитьПредопределенныйЭлемент(Имя, ПространствоИмен, ПрефиксПространстваИмен, ПутьНаСервере, Родитель = "") Экспорт

	ВидОбъекта = ИнтеграцияЕГАИСВызовСервера.ПредопределенныйЭлемент("Справочник.ВидыОбъектовЕГАИС." + Имя);
	
	Если ВидОбъекта = Неопределено Тогда
		ВидОбъекта = Справочники.ВидыОбъектовЕГАИС.СоздатьЭлемент();
		ВидОбъекта.ИмяПредопределенныхДанных = Имя;
	Иначе
		ВидОбъекта = ВидОбъекта.ПолучитьОбъект();
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Родитель) Тогда
		ВидОбъекта.Родитель = ИнтеграцияЕГАИСВызовСервера.ПредопределенныйЭлемент("Справочник.ВидыОбъектовЕГАИС." + Родитель);
	КонецЕсли;
	
	ВидОбъекта.Наименование = ИнтеграцияЕГАИСКлиентСервер.Синоним(Имя);
	ВидОбъекта.ПространствоИмен = ПространствоИмен;
	ВидОбъекта.ПрефиксПространстваИмен = ПрефиксПространстваИмен;
	ВидОбъекта.ПутьНаСервере = ПутьНаСервере;
	ВидОбъекта.Записать();

КонецПроцедуры // ЗаполнитьПредопределенныйЭлемент()

#КонецОбласти

#КонецЕсли