﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		СтрокаНабора.ЭтоРасчетыПоНачислениюУплатеВзносовВФСС = СтрокаНабора.ВидОбязательногоСтрахованияСотрудников = Перечисления.ВидыОбязательногоСтрахованияСотрудников.ФСС И СтрокаНабора.РасчетыПоПособиям = Перечисления.ВидыРасчетовПоСредствамФСС.ПустаяСсылка();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли