﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа И ДатаРождения > ТекущаяДатаСеанса() Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Дата рождения не может быть больше текущей'"),
			,
			"ФизическоеЛицо.ДатаРождения",
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		НаименованиеСлужебное = ФизическиеЛицаЗарплатаКадры.НаименованиеСлужебное(Наименование);
	КонецЕсли; 
	
КонецПроцедуры

#КонецЕсли

